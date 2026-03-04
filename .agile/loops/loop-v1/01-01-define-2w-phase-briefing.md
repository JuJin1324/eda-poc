# Define 2W Phase Briefing v1 - EDA PoC Phase 연속성 판단

## 한눈에 결론
- 권장 선택: 연속 진행
- 이유 요약(1~2줄): `loop-v0`에서 Phase 1(EDA 핵심 개념 학습)이 완료되었고, 바로 다음 목표가 Phase 2(기반 구축 + 기본 이벤트 흐름)로 명확히 정의되어 있다.
- 사용자 최종 선택: 연속 진행

---

## 1) 지금까지의 진행
- 완료(Completed): Phase 1 학습 Sprint 완료, 6개 핵심 개념 문서화 및 스프린트 회고 완료
- 진행중(In Progress): 없음
- 대기(To Do): Phase 2~5 전체
- 근거 요약(2~3줄): `sprint/02-sprint-status.md` 기준 Sprint 0 전체 진행률 100%(12/12)이며, `sprint/04-sprint-retrospective.md`에서 Phase 2 구현 준비 완료로 명시됨. `04-design-phase.md` 로드맵은 Phase 1 완료 후 Phase 2~5를 순차 진행하도록 고정되어 있다.

## 2) 다음 Phase에서 하려는 일
- 후보 Phase: Phase 2 - 기반 구축 + 기본 이벤트 흐름
- 목표: 6개 서브 프로젝트 스캐폴딩 + Kafka 인프라 + 동기/비동기 기본 동작 확인
- 핵심 US: 프로젝트 구조/아키텍처 설계, Kafka+서비스 Docker Compose 구성, 동기 REST 블로킹 흐름 구현, 비동기 Fan-out 흐름 구현, 기본 동작 검증
- 범위 In / Out / Unknown:
  - In: Phase 2 태스크 전체(설계+기반 구현+기본 검증)
  - Out: Phase 3 이후 성능 정량 비교/장애 격리 심화 검증/포트폴리오 문서화
  - Unknown: 지연 시뮬레이션 고정값(500ms~2s 중 확정), k6 동시 요청/자원 제한 최적값

## 3) 선택지 비교
| 선택지 | 기대 효과 | 리스크 |
| --- | --- | --- |
| 연속 진행 | 기존 로드맵/학습 산출물을 즉시 활용해 구현 리드타임 최소화 | 이전 가정 중 바뀐 것이 있으면 구현 단계에서 재수정 비용 발생 |
| 새로 시작 | 문제 재정의 폭을 크게 가져가 방향 전환 가능 | 이미 완료한 Phase 1 산출물과 로드맵의 연속성이 끊겨 일정 손실 가능 |

## 4) AI 권장안
- 권장안: 연속 진행
- 권장 근거(최대 2줄): 직전 문서에서 다음 단계(Phase 2)가 구체 태스크/완료기준까지 확정돼 있어 재정의 비용보다 실행 가치가 크다. Sprint 0 회고도 "Sprint 1 시작 준비 완료"를 명시한다.
- 반대 선택 시 리스크(1줄): 새로 시작 시 기존 설계/학습 자산 재검증 비용으로 `2주` 제약의 초기 실행 속도가 떨어질 수 있다.

---

## 부록) 결정 로그
- 근거 문서:
  - `.agile/loops/loop-v0/04-design-phase.md`
  - `.agile/loops/loop-v0/sprint/02-sprint-status.md`
  - `.agile/loops/loop-v0/sprint/04-sprint-retrospective.md`
- 사용자 코멘트: "연속 진행해"
- 결정 시각: 2026-03-04 13:44:58 KST
