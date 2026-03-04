# US-0.2 회고: 메시지 신뢰성 및 장애 대응 학습

📅 완료일: 2026-03-02 (목표일: 2026-03-01, +1일 지연)

---

## 산출물

| 파일 | 역할 |
|------|------|
| `docs/concepts/at-least-once-idempotency.md` | At Least Once + 멱등성 패턴 (리뷰로 대폭 수정) |
| `docs/concepts/dead-letter-queue.md` | DLQ 개념 + 오해 교정 + 안티패턴 (리뷰로 대폭 수정) |
| `docs/concepts/partition-key.md` | Partition Key + 순서 보장 한계 (리뷰로 프레임 수정) |
| `docs/concepts/kafka-logical-physical-structure.md` | 논리/물리 구조 분리 이해 (리뷰 중 파생 생성) |
| `docs/concepts/kafka-naming-convention.md` | 토픽/컨슈머 그룹 네이밍 컨벤션 (리뷰 중 파생 생성) |

---

## 배운 점

### 1. INSERT IGNORE가 try-catch + SELECT→INSERT보다 안전한 이유
- 기존 코드: `isDuplicate()` SELECT 후 `markProcessed()` INSERT — 두 단계 사이에 TOCTOU 경쟁 상태 발생 가능
- 수정 후: `tryMarkProcessed()` — INSERT IGNORE 단일 쿼리로 원자적 처리
- 배운 것: 경쟁 상태는 "검사 후 행동" 패턴 자체가 문제. 단일 쿼리로 검사+행동을 합쳐야 안전.

### 2. DLQ는 Consumer가 살아있을 때만 동작한다
- 오해: DLQ가 모든 실패를 처리해줄 것이라 생각했음
- 실제: Consumer가 다운되면 메시지는 Kafka 파티션에 그대로 남음. DLQ는 Consumer가 살아있지만 메시지 처리가 실패할 때만 동작.
- 안티패턴: Consumer 자체가 죽어서 발생하는 장애를 DLQ로 해결하려는 것 → DLQ는 논리적 격리 도구이지 인프라 장애 대응 도구가 아님

### 3. DLQ는 논리적 개념이다
- Kafka 브로커는 DLQ를 모른다. DLQ는 그냥 토픽이고, Consumer 코드에서 실패 시 다른 토픽으로 보내는 패턴.
- 이 덕분에 DLQ 소비자도 동일한 멱등성 체크(`tryMarkProcessed()`)를 적용해야 한다.

### 4. 파티션 순서 보장의 목적은 "상태 전이"가 아니라 "발행 순서 보장"
- 처음 이해: 파티션 순서 보장 = Kafka에서 상태 전이 순서 보장
- 수정 후: IoT 센서 데이터처럼 "먼저 발행된 이벤트가 먼저 처리"되는 것이 목적
- 핵심 차이: Choreography Saga의 서비스 간 협력 순서는 이벤트 인과 체인이 보장하는 것이지, 파티션 키가 보장하는 게 아님

### 5. DLQ 격리는 누적 상태 계산에서 순서 역전을 일으킨다
- Choreography Saga에서는 이 문제가 없음 (다음 이벤트 자체가 이전 단계 성공의 산물)
- 단일 Producer가 같은 토픽에 누적 상태 이벤트를 발행할 때 문제 발생
- 핵심: 비즈니스 로직이 있어도 재처리 시점의 상태가 바뀌어 있어서 다른 결론이 나옴

### 6. Consumer 두 가지 패턴
- Leaf Consumer: 이벤트 수신 → 처리 → 체인 종료 (알림, 감사 로그)
- Prosumer: 이벤트 수신 → 처리 → 다음 이벤트 발행 (Choreography Saga 참여자)
- Prosumer는 Transactional Outbox가 필요함 — 처리 + 발행의 원자성을 보장해야 하기 때문

---

## 의사결정

### AckMode: manual_immediate → manual
- **선택:** `manual`
- **이유:** `manual_immediate`는 각 메시지 처리 직후 즉시 커밋 → 브로커 부하 증가. `manual`은 poll 루프 단위로 일괄 커밋 → 일반적으로 충분하고 효율적.

### 멱등성 코드 패턴: tryMarkProcessed() 통일
- **선택:** `isDuplicate()` + `markProcessed()` 분리 → `tryMarkProcessed()` 단일 메서드
- **이유:** 두 단계 분리 시 TOCTOU 경쟁 상태 가능. 단일 INSERT IGNORE로 원자적 처리.

### DLQ 토픽 네이밍: 동적 생성 → 명시적 지정
- **선택:** `record.topic() + ".dlq"` 동적 → `"order.notification.dlq.v1"` 명시적
- **이유:** 네이밍 컨벤션(`{domain}.{service}.dlq.v{n}`)과 일치해야 하고, 동적 생성은 컨벤션 준수 보장 불가.

---

## 아쉬운 점 / 개선할 점

- 학습 문서를 처음 작성할 때 코드 예제의 일관성(isDuplicate vs tryMarkProcessed, manual vs manual_immediate)을 더 꼼꼼히 검토했으면 리뷰 시간을 줄일 수 있었음
- 파티션 순서 보장의 프레임("상태 전이" vs "발행 순서")을 처음부터 명확히 이해했다면 배민 예제 수정이 필요 없었을 것
- **학습 자료를 구현 도메인(주문/배민)에 맞추려다 개념의 본질이 흐려진 경우가 있었음.** 파티션 순서 보장 예제(OrderCreated → OrderShipped)가 상태 전이처럼 보이는 Choreography Saga 시나리오로 작성되어, 사용자 개입이 없었다면 잘못된 이해가 문서에 그대로 남았을 것. 개념 문서는 가장 본질을 잘 드러내는 도메인(은행 계좌, IoT 등)을 우선 고려할 것.
- **AI가 처음부터 끝까지 문서를 작성할 때는 문맥 완성도가 높지만, 사용자 개입으로 부분 수정이 반복되면 문맥이 어색해지는 경우가 생겼음.** 이는 LLM의 구조적 한계(부분 수정 시 전체 흐름 재검토 부재)로 보임. 개선 방향: 부분 수정 후 해당 섹션 전체를 한 번 더 읽어 문맥 교정을 선제적으로 제안할 것.

---

## 다음 단계 연결

- **Phase 2 구현 시 직접 연결되는 결정들:**
  - `tryMarkProcessed()` 패턴 → 멱등성 Consumer 구현에 그대로 적용
  - `manual` AckMode → Spring Kafka Consumer 설정에 반영
  - DLQ 토픽 네이밍 컨벤션 → `kafka-naming-convention.md`에 명세된 대로 토픽 생성
- **Phase 3 테스트 포인트 도출 완료:**
  - 중복 메시지 처리 시 멱등성 보장 여부
  - DLQ 격리 후 재처리 시 비즈니스 로직 정상 동작 여부
  - Partition Key 적용 시 동일 orderId 이벤트 순서 보장 여부
