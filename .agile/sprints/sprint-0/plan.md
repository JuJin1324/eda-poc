# Sprint 0: EDA 핵심 개념 학습

**기간:** 2026-02-28 ~ 2026-03-01 (2일)
**목표:** 구현할 EDA 개념을 먼저 학습하여, 개념을 인지한 상태에서 구현을 시작
**Phase:** Phase 1 (EDA 핵심 개념 학습)

---

## Quick Guide (30초 문서 이해 가이드)
- **핵심 결론:** Sprint 0은 EDA 핵심 6개 개념을 학습하여, Phase 2(기반 구축) 진입 시 "왜 이렇게 구현하는지" 이해한 상태를 만든다.
- **확정된 결정:** 기간 `02/28~03/01(2일)`, US 2개 구성(기본 개념 → 신뢰성 개념), 학습 산출물은 `docs/concepts/`에 개념별 MD 파일로 산출.
- **확정된 결정:** US-0.1=`2026-02-28`, US-0.2=`2026-03-01` 완료 목표.
- **바로 실행할 내용:** US-0.1 착수 — Producer/Consumer, Topic/Partition, Consumer Group 학습.
- **판단 근거:** `how-diagram.md` Phase 1의 학습 범위를 그대로 반영. 구현 전 개념 학습이 잘못된 방향 사전 차단.
- **리스크:** 학습 깊이 기준 — "면접에서 설명 가능 + 구현 시 설정 선택 가능" 수준으로 통제.

---

## Sprint Goal

> Kafka/EDA 핵심 6개 개념을 "왜 필요한지 + 어떻게 동작하는지" 설명할 수 있는 수준으로 학습하여, Phase 2 구현의 기반을 만든다.

---

## 워크플로우 철학

> **AI 시대의 개발 순서: 작은 단위로 시각화 → 검토 → 구현 반복**

**핵심 원칙:**
1. US 단위로 반복 (인지 부하 최소화)
2. 빠른 피드백 루프 (Checkpoint로 검증)
3. 검증 후 구현 (잘못된 방향 사전 차단)

> **US = 가장 작은 반복 단위.** 리뷰하고 넘어가는 단위가 곧 작업 단위다.

---

## Sprint 흐름 요약

> 이 Sprint는 학습 Sprint로, 6개 EDA 개념을 "기본 메시징"과 "신뢰성/장애 대응"으로 나누어 2개 US × 3 Step씩 구성합니다.
> 각 Step은 **작성 → 리뷰** 단위로, 하나를 완료하고 넘어갑니다.

| US | Step | 개념 | 완료 목표일 |
|------|------------|--------------------------|------------|
| US-0.1 | Step-0.1.1 | Producer/Consumer | 2026-02-28 |
| US-0.1 | Step-0.1.2 | Topic/Partition | 2026-02-28 |
| US-0.1 | Step-0.1.3 | Consumer Group | 2026-02-28 |
| US-0.2 | Step-0.2.1 | At Least Once + 멱등성 | 2026-03-01 |
| US-0.2 | Step-0.2.2 | Dead Letter Queue | 2026-03-01 |
| US-0.2 | Step-0.2.3 | Partition Key | 2026-03-01 |

**이 순서인 이유:** Producer/Consumer → Topic/Partition → Consumer Group은 Kafka의 기본 동작 원리이며, At Least Once/멱등성/DLQ/Partition Key는 이 기본 위에 쌓이는 신뢰성 개념이다. 기본을 모르면 신뢰성을 이해할 수 없으므로 순서가 필수적이다.

---

## Tasks

### US-0.1: Kafka 기본 메시징 개념 학습

**Intent:** Kafka의 기본 동작 원리를 모르면 Phase 2에서 "왜 이렇게 구현하는지" 이해 없이 코드만 따라치게 된다. 개념을 먼저 잡아야 구현 시 올바른 판단이 가능하다.
**완료 목표일:** 2026-02-28

#### Step-0.1.1: Producer/Consumer
- [x] 학습 + `docs/concepts/producer-consumer.md` 작성
  - 메시지 발행 흐름, acks 설정(0/1/all)의 의미
  - Consumer의 poll 메커니즘, offset commit
- [x] 🔍 리뷰 완료

#### Step-0.1.2: Topic/Partition
- [x] 학습 + `docs/concepts/topic-partition.md` 작성
  - Topic의 논리적 구조, Partition의 물리적 분산
  - 파티션 내 순서 보장 vs 파티션 간 순서 미보장
- [x] 🔍 리뷰 완료

#### Step-0.1.3: Consumer Group
- [x] 학습 + `docs/concepts/consumer-group.md` 작성
  - Consumer Group의 파티션 할당 메커니즘
  - 리밸런싱 발생 조건과 영향 (사람인 장애 사례 참고)
- [x] 🔍 리뷰 완료

**Acceptance Criteria:**
- 각 개념을 "왜 필요한지 + 어떻게 동작하는지" 1~2문장으로 설명 가능
- Phase 2 구현 시 어떤 설정/코드와 연결되는지 매핑 가능
- 개념별 학습 문서가 `docs/concepts/`에 작성 완료

---

### US-0.2: 메시지 신뢰성 및 장애 대응 학습

**Intent:** At Least Once + 멱등성은 배민이 Exactly Once를 제거한 실제 교훈이며, DLQ는 쿠팡의 핵심 장애 격리 패턴이다. 이 개념들을 모르면 Phase 3 테스트 설계 시 "무엇을 테스트해야 하는지"조차 정의할 수 없다.
**완료 목표일:** 2026-03-01

#### Step-0.2.1: At Least Once + 멱등성
- [x] 학습 + `docs/concepts/at-least-once-idempotency.md` 작성
  - At Most Once / At Least Once / Exactly Once 비교
  - 배민이 Exactly Once를 제거한 이유 (2년간 41건 장애)
  - 멱등성 키 설계 패턴 (orderId 기반 중복 체크)
- [x] 🔍 리뷰 완료

#### Step-0.2.2: Dead Letter Queue (DLQ)
- [x] 학습 + `docs/concepts/dead-letter-queue.md` 작성
  - DLQ의 목적: 실패 메시지가 전체 파이프라인을 막지 않도록 격리
  - 재시도 정책 (횟수, backoff) → DLQ 이동 흐름
  - 쿠팡 Vitamin MQ의 DLQ 패턴 참고
- [x] 🔍 리뷰 완료

#### Step-0.2.3: Partition Key
- [x] 학습 + `docs/concepts/partition-key.md` 작성
  - Partition Key가 없으면: 라운드 로빈 → 순서 미보장
  - Partition Key 있으면: 같은 키 = 같은 파티션 = 순서 보장
  - 배민: 주문별 이벤트 순서 유지 사례
- [x] 🔍 리뷰 완료

**Acceptance Criteria:**
- 각 개념을 "왜 필요한지 + 어떻게 동작하는지" 1~2문장으로 설명 가능
- Phase 3 테스트 시 "무엇을 검증해야 하는지" 테스트 포인트 도출 가능
- "왜 Exactly Once를 안 쓰는가?" 질문에 사례 기반으로 답변 가능
- 개념별 학습 문서가 `docs/concepts/`에 작성 완료

---

## Sprint 0 Definition of Done

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
- [x] US별 완료 목표일 대비 실제 완료일 기록 (선행/지연 판단 가능)

---

## Blockers

- 없음

---

## Notes

- 학습 깊이 기준: "면접에서 설명할 수 있는 수준" + "구현 시 올바른 설정을 선택할 수 있는 수준"
- 학습 산출물 경로: `docs/concepts/` — 개념별 MD 파일 6개, Phase 2 구현 시 레퍼런스로 참조, Phase 4 심화 개념도 같은 폴더에 추가 예정
- 참고 자료: `docs/eda-kafka-case-studies.md` (사례 연구), `docs/2w-brainstorm.md` (EDA 개념 학습 범위 정리)
