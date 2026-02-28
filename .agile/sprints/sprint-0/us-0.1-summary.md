# US-0.1 Summary: Kafka 기본 메시징 개념 학습

📅 완료일: 2026-02-28

---

## 산출물

| 파일 | 역할 |
|---|---|
| `docs/concepts/producer-consumer.md` | Producer 비동기 전송, acks, poll/commit, AckMode, 멱등성 연결 정리 |
| `docs/concepts/topic-partition.md` | 파티션/보관정책/세그먼트/리더 선출/네이밍 컨벤션 정리 |
| `docs/concepts/consumer-group.md` | Group 격리성, 리밸런싱, assignor, `__consumer_offsets`, 운영 관측 정리 |
| `docs/how-diagram.md` | PoC 시나리오를 알림/배송 Fan-out 중심으로 정합화 |
| `.agile/sprints/sprint-0/plan.md` | Step-0.1.1 ~ Step-0.1.3 완료 체크 반영 |

---

## 주요 의사결정

### 1. PoC 시나리오를 "주문 완료 후 Fan-out"으로 정리

- 주문의 강정합성 코어와 후속 처리(알림/배송)를 분리해, PoC 목표를 "즉시 응답 + 장애 격리 + 독립 소비" 검증으로 명확화했다.
- 근거: 결제/강결합까지 단순 이벤트로 처리하면 현실성과 학습 목표가 흐려지므로, Fan-out 검증 범위를 분명히 하는 것이 적합했다.

### 2. Consumer 처리/커밋 전략은 `enable.auto.commit=false` + AckMode 중심으로 정리

- `BATCH`와 `MANUAL` 차이를 처리 완료 시점 제어 관점으로 문서화하고, At Least Once 연결고리를 보강했다.
- 근거: 실제 장애/중복 상황에서 커밋 타이밍이 유실/중복을 좌우하므로, 설정 이유를 명확히 남길 필요가 있었다.

### 3. 네이밍/운영 가독성을 문서 전반에 통일

- Topic은 `{domain}.{event}.v{n}`, Group ID는 `{env}.{domain}.{service}.{purpose}.v{n}`로 통일했다.
- 근거: 예시가 문서마다 다르면 학습 난이도가 상승하고 Phase 2 구현 시 혼선이 커지므로, 컨벤션 일관성이 필요했다.

---

## 다음 단계

- US-0.2(At Least Once + 멱등성, DLQ, Partition Key)로 이어서 신뢰성/장애 대응 개념을 완성한다.
- US-0.1에서 정리한 Fan-out 시나리오와 Group/Topic 컨벤션을 Phase 2 설계/구현의 기본 기준으로 사용한다.
