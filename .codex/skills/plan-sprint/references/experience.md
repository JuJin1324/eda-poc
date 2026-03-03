# Experience - Plan Sprint

## 목적
- 이 문서는 `plan-sprint` 실행 전에 빠르게 참고하는 경험 자산이다.

## 사용 규칙
- `status: seeded`는 초기 샘플이다.
- 실전에서 검증된 항목만 `status: validated`로 승격한다.
- 더 이상 유효하지 않으면 `status: deprecated`로 내린다.
- 실행 전에는 `Validated Entries`를 우선 참고한다.

## Seeded Entries

### EXP-001
- status: seeded
- date: 2026-03-03
- situation: 계획과 회고를 다른 문맥에서 관리해 학습 루프가 끊긴 상황
- signal: 같은 실패가 다음 스프린트에서 반복됨
- choice: plan/status/us-retro/sprint-retro를 같은 루프 경로로 관리
- result: 다음 loop-vN+1 진입 판단이 빨라짐
- condition: 스프린트 종료 후 즉시 다음 라운드를 설계할 때
- caution: 팀/프로젝트 맥락이 다르면 그대로 복제하지 말고 조정한다.
- related_artifacts:
  - N/A (seeded)

### EXP-002
- status: seeded
- date: 2026-03-03
- situation: US별 Step을 과도하게 세분화해 문서 유지비가 커진 상황
- signal: 진행보다 문서 업데이트 시간이 길어짐
- choice: 실행 필수 Step만 유지하고 나머지는 진행 중 보강
- result: 계획 변경 비용이 감소
- condition: 요구사항 변동성이 큰 스프린트
- caution: 지표나 증적 없이 감으로 판단하지 않는다.
- related_artifacts:
  - N/A (seeded)

### EXP-003
- status: seeded
- date: 2026-03-03
- situation: 회고에서 원인보다 결과만 기록한 상황
- signal: Drop 대상 전략이 다음에도 다시 등장
- choice: False 가정에 원인/증적을 필수 기입
- result: 폐기 전략이 재등장하는 빈도가 줄어듦
- condition: 유사 실패가 2회 이상 반복될 때
- caution: 루프 목표를 벗어나는 확장은 별도 의사결정으로 분리한다.
- related_artifacts:
  - N/A (seeded)

## Validated Entries
- 아직 없음

## Deprecated Entries
- 아직 없음
