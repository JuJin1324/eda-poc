# US-0.1 회고: Kafka 기본 메시징 개념 학습

📅 완료일: 2026-02-28

---

## 산출물

| 파일 | 역할 |
|------|------|
| `docs/concepts/producer-consumer.md` | Producer 비동기 전송, acks, poll/commit, AckMode, 멱등성 연결 정리 |
| `docs/concepts/topic-partition.md` | 파티션/보관정책/세그먼트/리더 선출/네이밍 컨벤션 정리 |
| `docs/concepts/consumer-group.md` | Group 격리성, 리밸런싱, assignor, `__consumer_offsets`, 운영 관측 정리 |
| `docs/concepts/kafka-cluster-infrastructure.md` | replication.factor 토픽별 설정, 도메인 클러스터 분리 기준, KRaft vs Zookeeper 정리 |
| `docs/how-diagram.md` | PoC 시나리오를 알림/배송 Fan-out 중심으로 정합화 |
| `.agile/sprints/sprint-0/plan.md` | Step-0.1.1 ~ Step-0.1.3 완료 체크 반영 |

---

## 배운 점

### 1. Kafka 학습 난이도는 개별 개념보다 개념 간 연결에서 급격히 올라간다
- `topic/partition/group/offset/rebalance/commit`이 서로 의존적이어서 직렬 학습만으로는 이해가 느려졌다.
- 같은 예시(`order.order-completed.v1`)를 문서 전반에 고정하니 이해 속도가 확실히 개선됐다.

### 2. 구현 전 설계 수정은 비용이 아니라 학습의 증거다
- `how-diagram.md`의 초기 설계는 피상적인 EDA 이해 + Kafka 미숙 상태에서 AI와 함께 작성됐다. 주문-재고-결제-배송-알람이 모두 이벤트로 연결된 구조였는데, 학습 이후 결제는 강결합 코어로, 알람/배송만 Fan-out 대상임을 이해하면서 설계가 크게 바뀌었다.
- 이 수정은 낭비가 아니다. 구현 이전에 개념을 바로잡은 것이므로, 잘못된 방향으로 코드를 작성했다가 되돌리는 비용에 비하면 훨씬 저렴하다. Phase 1(학습)이 Phase 2(구현) 앞에 오는 이유가 바로 이것이다.

### 3. 동기의 문제는 "직렬"이 아니라 "사용자 블로킹"이다
- CompletableFuture로 REST를 병렬화해도 사용자는 모든 후속 처리가 끝날 때까지 대기한다.
- EDA의 핵심 가치는 "병렬 처리"가 아니라 "즉시 응답" — 재고 차감 직후 응답을 반환하고, 알림/배송은 사용자와 무관하게 독립 처리된다.
- 이 인사이트로 how-diagram.md 시퀀스 다이어그램을 `par` 블록(병렬 REST)으로 변경하고 레이블을 "직렬 → 블로킹"으로 수정했다. PoC 비교 스토리 자체가 바뀐 결정이었다.

### 3. Consumer 운영 안정성의 핵심은 커밋 타이밍과 리밸런싱 제어다
- `BATCH`/`MANUAL` 차이는 단순 API 선택이 아니라, 유실/중복 리스크를 어디서 통제할지에 대한 설계 결정이었다.
- MSA 배포 주기가 짧아질수록 리밸런싱 빈도가 올라가므로 assignor/튜닝/모니터링을 같이 설계해야 함을 확인했다.

---

## 의사결정

### 1. PoC 시나리오를 "주문 완료 후 Fan-out"으로 재정의
- **선택:** 강정합성 코어와 후속 처리(알림/배송)를 분리하고, PoC 목표를 "즉시 응답 + 장애 격리 + 독립 소비" 검증에 집중했다.
- **이유:** 결제/강결합까지 단순 이벤트로 모델링하면 현실성과 학습 목표가 동시에 흐려지므로, 검증 범위를 명확히 제한하는 것이 더 적합했다.

### 2. Consumer 커밋 전략은 `enable.auto.commit=false` + AckMode 중심으로 문서화
- **선택:** `BATCH` vs `MANUAL` 차이를 처리 완료 시점 제어 관점으로 명시하고 At Least Once와 연결했다.
- **이유:** 실제 운영 리스크(유실/중복)는 커밋 타이밍에서 발생하므로, 설정 근거를 문서에 남기는 것이 필수였다.

### 4. Kafka KRaft 모드 선택 (Zookeeper 제거)
- **선택:** Docker Compose에서 Zookeeper 컨테이너를 제거하고 Kafka KRaft 단일 브로커로 구성한다.
- **이유:** Kafka 4.0에서 Zookeeper가 완전 제거됐고, 단일 브로커 PoC에서 Zookeeper는 순수 오버헤드다. 새로 시작하는 프로젝트에서 KRaft가 표준이다.

### 5. Topic/Group 네이밍 컨벤션을 문서 전반에 통일
- **선택:** Topic=`{domain}.{event}.v{n}`, Group ID=`{env}.{domain}.{service}.{purpose}.v{n}` 패턴을 채택했다.
- **이유:** 문서별 예시 불일치가 학습 난이도와 구현 혼선을 높였고, 컨벤션 통일이 Phase 2 설계 기준을 명확히 해주기 때문이다.

---

## 아쉬운 점 / 개선할 점

- 초기 문서에서 현실 도메인 경계(강정합성 코어 vs 비동기 후행 처리)를 늦게 고정해 중간 수정 비용이 발생했다.
- `how-diagram.md`와 `docs/concepts/*` 사이 정합성을 초기에 더 강하게 검증했으면 반복 수정을 줄일 수 있었다.
- **예상보다 훨씬 어려웠다.** 예전에 Kafka를 학습한 경험이 있었고 EDA도 어느 정도 안다고 생각했기 때문에, Sprint 0 전체를 하루 안에 끝낼 수 있을 것이라 예상했다. 실제로는 Kafka 학습이 너무 오래전이었고, EDA 개념도 피상적으로만 알고 있었음을 깨달았다. "안다"와 "설명할 수 있다"의 차이를 실감했다.
- **AI 학습 문서의 지식의 저주.** 학습을 목적으로 작성된 문서임에도 AI가 이미 깊이 아는 전문가 관점에서 서술해, 초심자가 맥락 없이 읽으면 이해하기 어려운 부분이 곳곳에 있었다. 다음 학습 문서 작성 시 "이 개념을 처음 접하는 사람이 읽는다"는 관점을 명시적으로 요청해야 한다.

---

## 다음 단계 연결

- US-0.2(At Least Once + 멱등성, DLQ, Partition Key) 학습 시, US-0.1에서 정리한 커밋/리밸런싱/컨벤션 기준을 그대로 확장 적용한다.
- Phase 2 구현에서는 Fan-out 시나리오(`notification/shipping`)를 기준으로 Topic/Group/AckMode 설정을 코드/인프라에 일관 반영한다.
