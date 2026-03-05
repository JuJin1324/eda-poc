# Define 2W Phase Briefing - EDA PoC Sprint 1

## 한눈에 결론
- 권장 선택: 연속 진행
- 이유 요약(1~2줄): sprint-0의 학습 목표와 DoD가 완료되었고, 회고에서 sprint-1 시작 준비가 완료로 확인되었다. 직전 design-phase의 다음 후보가 Phase 2로 명확해 방향 전환 비용이 낮다.
- 사용자 최종 선택: 연속 진행 (기본값 적용)

---

## 1) 다음 Phase에서 하려는 일
- 후보 Phase: Phase 2 (기반 구축 + 기본 이벤트 흐름)
- 목표: 6개 서브 프로젝트 스캐폴딩 + Kafka 인프라 + 동기/비동기 기본 동작 확인
- 핵심 US:
  - US-1.1: 프로젝트/인프라 기반 구성 (멀티모듈 구조, Docker Compose, API/이벤트 스펙)
  - US-1.2: 동기/비동기 주문 흐름 최소 구현 및 기본 동작 검증
- 범위 In / Out / Unknown:
  - In: 설계 산출(C4 Component, Compose, API/이벤트), 기본 구현 및 curl 검증
  - Out: 성능 정량 비교(k6), 장애 격리 실험, DLQ/멱등성 심화 검증
  - Unknown: Phase 2 내 동시 요청 수/지연 파라미터 세부 튜닝값

## 2) 선택지 비교
| 선택지 | 기대 효과 | 리스크 |
| --- | --- | --- |
| 연속 진행 | 기존 2W/Phase 자산을 재사용해 실행 속도를 높이고 컨텍스트 손실을 줄인다. | 범위 통제 실패 시 구현 범위가 Phase 3 영역까지 확장될 수 있다. |
| 새로 시작 | 문제 재정의 자유도가 높아져 전면 전환이 가능하다. | sprint-0 학습/사례 자산의 연속성이 끊겨 재분석 비용이 커진다. |

## 3) AI 권장안
- 권장안: 연속 진행
- 권장 근거(최대 2줄): 방향 자체가 바뀌지 않았고, 직전 산출물들이 모두 "Phase 2 착수"를 가리킨다. 지금은 신규 탐색보다 실행 전환 효율이 우선이다.
- 반대 선택 시 리스크(1줄): 새로 시작을 택하면 이미 검증된 문제정의를 다시 합의하느라 Sprint 1 착수 지연 가능성이 커진다.

## 4) 지금까지의 진행
- 완료(Completed): Sprint 0 Phase 1(EDA 핵심 개념 학습) 완료, US-0.1/US-0.2 Done, 회고 작성 완료
- 진행중(In Progress): 없음
- 대기(To Do): Sprint 1 Phase 2(기반 구축 + 기본 이벤트 흐름)
- 근거 요약(2~3줄): `sprint-status.md`에서 sprint-0 진행률 100%(2/2 US) 완료가 확인된다. `sprint-retrospective.md`에 Sprint 1 시작 준비 완료가 기록되어 있다. 직전 `design-phase.md`는 다음 실행 후보를 Phase 2로 명시한다.

---

## 부록) 결정 로그
- 근거 문서:
  - 직전 실행의 `design-phase` 관련 산출 문서
    - `.agile/sprints/sprint-0/1-direction/design-phase.md`
  - 직전 실행의 상태 문서 (있으면)
    - `.agile/sprints/sprint-0/2-delivery/sprint-status.md`
  - 직전 실행의 회고 문서 (있으면)
    - `.agile/sprints/sprint-0/3-learning/sprint-retrospective.md`
- 사용자 코멘트: `$define-2w` 실행 요청(신규 문제 제시 없음)
- 결정 시각: 2026-03-05 10:40 KST
