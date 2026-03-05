# Experience - Review Sprint

## 목적
- 이 문서는 `review-sprint` 실행 전에 빠르게 참고하는 경험 자산이다.

## 사용 규칙
- `status: seeded`는 초기 샘플이다.
- 실전에서 검증된 항목만 `status: validated`로 승격한다.
- 더 이상 유효하지 않으면 `status: deprecated`로 내린다.
- 실행 전에는 `Validated Entries`를 우선 참고한다.

## Seeded Entries

### EXP-001
- status: seeded
- date: 2026-03-05
- situation: Sprint 결과는 있었지만 학습 항목이 문서화되지 않아 같은 실수를 반복한 상황
- signal: 다음 Sprint 계획 회의에서 근거 문서가 없어서 기억 의존 토론이 반복됨
- choice: True/False/Unknown + Keep/Drop 구조를 고정해 회고를 작성
- result: 다음 Sprint 시작 시 변경 포인트가 명확해짐
- condition: 결과 문서는 충분하지만 해석/학습이 누락된 Sprint 종료 시점
- caution: 팀/프로젝트 맥락이 다르면 그대로 복제하지 말고 조정한다.
- related_artifacts:
  - N/A (seeded)

### EXP-002
- status: seeded
- date: 2026-03-05
- situation: 미완료 US 원인을 명시하지 않고 넘어가 후속 Sprint에서 재지연된 상황
- signal: 동일 Blocker가 Sprint마다 반복됨
- choice: US 회고에 아쉬운 점/원인을 필수 기록하고 다음 액션을 연결
- result: 반복 지연 원인 추적이 쉬워짐
- condition: 외부 의존/대기 이슈가 많은 Sprint
- caution: 지표나 증적 없이 감으로 판단하지 않는다.
- related_artifacts:
  - N/A (seeded)

### EXP-003
- status: seeded
- date: 2026-03-05
- situation: 종료 여부를 명시하지 않아 작업이 관성적으로 계속된 상황
- signal: Sprint 종료 후에도 우선순위 기준 없이 작업이 추가됨
- choice: 회고 문서에 시작/종료 결정을 이유와 함께 명시
- result: 프레임워크 재진입 시점과 종료 시점이 명확해짐
- condition: 목표 달성 여부가 경계선에 있는 Sprint
- caution: 스프린트 목표를 벗어나는 확장은 별도 의사결정으로 분리한다.
- related_artifacts:
  - N/A (seeded)

## Validated Entries
- 아직 없음

## Deprecated Entries
- 아직 없음
