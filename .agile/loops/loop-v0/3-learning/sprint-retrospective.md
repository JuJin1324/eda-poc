# Sprint 0 회고 (Retrospective)

**Sprint:** Sprint 0 - EDA 핵심 개념 학습
**기간:** 2026-02-28 ~ 2026-03-01 (계획 2일) / 실제 완료: 2026-03-02 (3일, +1일 지연)
**회고 작성일:** 2026-03-02
**상태:** ✅ 완료 (Completed)

---

## 1. Sprint Goal 달성 여부

> **목표:** Kafka/EDA 핵심 6개 개념을 "왜 필요한지 + 어떻게 동작하는지" 설명할 수 있는 수준으로 학습하여, Phase 2 구현의 기반을 만든다.

### 결과: ✅ 목표 달성

6개 핵심 개념 학습 문서 완성. 학습 중 오개념 발견 및 교정까지 이루어졌고, 계획에 없던 파생 문서 2개(논리/물리 구조, 네이밍 컨벤션)가 추가로 생성되어 Phase 2 구현 기반이 더 탄탄해졌다.

---

## 2. Definition of Done 체크리스트

### US-0.1 ✅
- [x] Step-0.1.1: `docs/concepts/producer-consumer.md` 작성 + 리뷰 완료
- [x] Step-0.1.2: `docs/concepts/topic-partition.md` 작성 + 리뷰 완료
- [x] Step-0.1.3: `docs/concepts/consumer-group.md` 작성 + 리뷰 완료

### US-0.2 ✅
- [x] Step-0.2.1: `docs/concepts/at-least-once-idempotency.md` 작성 + 리뷰 완료
- [x] Step-0.2.2: `docs/concepts/dead-letter-queue.md` 작성 + 리뷰 완료
- [x] Step-0.2.3: `docs/concepts/partition-key.md` 작성 + 리뷰 완료

### 최종 검증
- [x] 6개 개념 모두 "왜 필요한지 + 어떻게 동작하는지" 설명 가능
- [x] Phase 2 구현 시 각 개념이 코드/설정의 어디에 반영되는지 매핑 완료
- [x] US별 완료 목표일 대비 실제 완료일 기록

---

## 3. 완료된 작업 (What Went Well)

### 3.1. 학습 중 설계 오류를 사전에 교정
학습 이전에 작성된 `how-diagram.md`의 초기 설계(결제/재고까지 이벤트로 연결)가 피상적 이해 상태에서 작성된 것임을 학습 과정에서 발견했다. 결제는 강결합 코어이고, 알림/배송만 Fan-out 대상임을 이해하면서 설계를 조기에 수정했다. 구현 이후 발견했다면 훨씬 비쌌을 수정이다.

### 3.2. 오개념을 리뷰 단계에서 발견하고 교정
- **DLQ 동작 조건 오해:** DLQ는 Consumer가 살아있을 때만 동작함. Consumer 다운 시 메시지는 파티션에 잔류. (문서에 안티패턴 섹션 추가)
- **파티션 순서 보장 프레임:** "상태 전이 보장"이 아니라 "발행 순서 보장"이 본질. Choreography Saga와 역할이 다름. (배민 예제 교정 + 한계 섹션 추가)
- **DLQ 예제 도메인 오류:** OrderPaid DLQ 격리 시 OrderShipped가 존재할 수 없음 (Choreography Saga에서는 이전 단계 성공이 전제). 은행 계좌 거래 예제로 교체.

### 3.3. 계획 외 파생 문서 생성
리뷰 중 파생된 개념을 별도 문서로 정리하여 Phase 2 구현 레퍼런스 강화:
- `kafka-logical-physical-structure.md` — 논리/물리 구조 혼동 해소
- `kafka-naming-convention.md` — 네이밍 컨벤션 명세

### 3.4. 코드 일관성 교정
학습 문서 전반의 코드 패턴 불일치를 리뷰에서 발견 및 수정:
- `isDuplicate()` + `markProcessed()` → `tryMarkProcessed()` 통일 (TOCTOU 해소)
- `manual_immediate` → `manual` AckMode (자원 효율)
- DLQ 토픽 동적 생성 → 명시적 네이밍 컨벤션 준수

---

## 4. 미흡했던 점 (What Didn't Go Well)

### 4.1. 예상보다 긴 학습 기간 (+1일 지연)
- **문제:** 계획 2일 → 실제 3일
- **원인:** "이미 아는 개념"이라는 과신. "아는 것"과 "설명할 수 있는 것"의 차이를 간과했다.
- **영향:** Phase 2 시작이 하루 밀림 (이미 how-diagram.md 일정에 +2일 여유를 추가했으므로 전체 일정 영향 최소)

### 4.2. 구현 도메인 예제가 개념의 본질을 흐린 경우
- **문제:** 파티션 순서 보장 예제를 PoC 도메인(주문/배민)에 맞추다 보니 Choreography Saga처럼 보이는 예제가 생성됐다.
- **원인:** AI가 구현 대상 도메인 기준으로 예제를 생성하는 경향
- **영향:** 사용자 개입이 없었다면 잘못된 예제가 문서에 잔류했을 것

### 4.3. 부분 수정 반복 시 문맥 일관성 저하
- **문제:** AI가 전체 문서를 처음부터 작성할 때는 문맥 완성도가 높지만, 부분 수정이 반복되면 문맥이 어색해지는 경우가 발생했다.
- **원인:** LLM의 구조적 한계 — 부분 수정 시 전체 흐름 재검토가 자동으로 이루어지지 않음
- **영향:** 문맥 교정을 위한 추가 요청이 필요했음

### 4.4. AI의 "지식의 저주" (US-0.1에서 발견)
- **문제:** 학습 목적 문서임에도 이미 깊이 아는 전문가 관점에서 서술되어 초심자가 맥락 없이 읽으면 이해하기 어려운 부분이 있었다.

---

## 5. 배운 점 (Lessons Learned)

### 5.1. Phase 1(학습)이 Phase 2(구현) 앞에 오는 이유가 실증됐다
학습 중 설계 오류(Fan-out 재정의, 블로킹 재프레이밍)를 발견하고 구현 전에 수정했다. 구현 후 발견했다면 비용이 훨씬 컸을 것이다. "학습 → 설계 수정 → 구현"의 순서가 유효함을 직접 경험했다.

### 5.2. 개념 문서의 예제는 구현 도메인보다 본질을 먼저 고려해야 한다
복잡한 비즈니스 도메인 예제(주문/배달)는 개념의 본질보다 도메인 지식에 더 많은 인지 부하를 줄 수 있다. 은행 계좌, IoT처럼 단순하고 직관적인 도메인이 개념 설명에 더 효과적인 경우가 많다.

### 5.3. Leaf Consumer vs Prosumer 패턴
EDA Consumer는 두 가지 역할로 구분된다. Leaf는 파이프라인 종료, Prosumer는 파이프라인 지속. Prosumer는 Transactional Outbox가 필요하고, Kafka Streams는 Kafka-to-Kafka 원자성만 해결한다 (외부 DB + Kafka 원자성은 여전히 Outbox 필요).

### 5.4. DLQ 순서 역전 문제의 정확한 발생 조건
DLQ로 인한 순서 역전은 단일 Producer가 누적 상태 이벤트(잔액, 재고)를 발행하는 경우에 발생한다. Choreography Saga에서는 다음 이벤트가 이전 단계 성공의 산물이므로 이 문제가 발생하지 않는다.

---

## 6. 개선 사항 (Action Items for Next Sprint)

### 6.1. 개념 문서 작성 방식
- [ ] 예제 도메인 선택 시 "구현 도메인 일치"보다 "개념 본질 노출"을 우선 고려
- [ ] 학습 목적 문서 작성 시 "이 개념을 처음 접하는 사람 관점" 명시적으로 요청

### 6.2. AI 협업 방식
- [ ] 부분 수정 후 AI가 해당 섹션 전체 문맥을 재검토하여 어색함을 선제적으로 교정하도록 요청
- [ ] 문서 초안 완성 후 리뷰 전에 "전체 문맥 일관성 검토" 단계를 명시적으로 추가

### 6.3. 일정 추정
- [ ] 학습 Sprint에서 "이미 아는 개념"이라도 "설명 가능한 수준"으로 끌어올리는 시간을 더 보수적으로 추정

---

## 7. 메트릭 (Metrics)

### 태스크 완료율
- 전체 Tasks: 12개
- 완료: 12개
- 완료율: **100%**

### DoD 달성률
- 전체 DoD 항목: 9개
- 달성: 9개
- 달성률: **100%**

### 산출물
| 문서 | 상태 |
|------|------|
| `docs/concepts/producer-consumer.md` | ✅ 완료 |
| `docs/concepts/topic-partition.md` | ✅ 완료 |
| `docs/concepts/consumer-group.md` | ✅ 완료 |
| `docs/concepts/at-least-once-idempotency.md` | ✅ 완료 |
| `docs/concepts/dead-letter-queue.md` | ✅ 완료 |
| `docs/concepts/partition-key.md` | ✅ 완료 |
| `docs/concepts/kafka-logical-physical-structure.md` | ✅ 완료 (파생) |
| `docs/concepts/kafka-naming-convention.md` | ✅ 완료 (파생) |

### 시간
- 계획: 2일 (02/28 ~ 03/01)
- 실제: 3일 (02/28 ~ 03/02)
- 지연: +1일

---

## 8. 종합 평가

### Sprint 0 성공 요인
1. Phase 1(학습)을 Phase 2(구현) 앞에 배치한 설계 — 학습 중 설계 오류를 구현 전에 수정할 수 있었음
2. US 단위 리뷰 — 리뷰 없이 넘어갔다면 잘못된 예제와 코드 불일치가 누적됐을 것

### Sprint 0 완성도
- **계획 대비 달성률:** 100%
- **개념 이해 수준:** 상 (리뷰에서 오개념까지 발견)
- **Phase 2 준비도:** 상 (코드 패턴, 설정 기준, 네이밍 컨벤션 모두 확정)

### Next Sprint 준비 완료 여부
✅ **준비 완료**

Phase 2 구현에 필요한 6개 핵심 개념 학습 완료. 코드 예제의 멱등성 패턴(`tryMarkProcessed`), AckMode(`manual`), 네이밍 컨벤션, DLQ 토픽 명세가 모두 문서화되어 있어 Phase 2 구현 시 레퍼런스로 바로 사용 가능하다.

---

## 9. 다음 Sprint 준비사항

### Sprint 1 목표 (예상)
- Phase 2: Kafka 기반 EDA 기반 구축 (Docker Compose + Producer/Consumer 기본 구조)

### Sprint 1 시작 전 확인 사항
- [ ] `how-diagram.md` Phase 2 범위 및 목표 일정 확인
- [ ] Action Items(개념 문서 작성 방식, AI 협업 방식) Sprint 1에 반영

---

## 결론

Sprint 0은 "알고 있다"와 "설명할 수 있다"의 차이를 실감한 Sprint였다. 학습 중 오개념을 발견하고 구현 전에 설계를 수정한 경험이 Phase 1(학습) 선행의 가치를 직접 증명했다. +1일 지연은 있었지만, 리뷰를 통해 문서 품질이 높아진 것과 Phase 2 구현 기반이 탄탄해진 것으로 충분히 상쇄된다.

**Sprint 1 시작 준비 완료 ✅**
