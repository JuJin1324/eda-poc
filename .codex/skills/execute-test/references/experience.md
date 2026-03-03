# Experience - Execute Test

## 목적
- 이 문서는 `execute-test` 실행 전에 빠르게 참고하는 경험 자산이다.

## 사용 규칙
- `status: seeded`는 초기 샘플이다.
- 실전에서 검증된 항목만 `status: validated`로 승격한다.
- 더 이상 유효하지 않으면 `status: deprecated`로 내린다.
- 실행 전에는 `Validated Entries`를 우선 참고한다.

## Seeded Entries

### EXP-001
- status: seeded
- date: 2026-03-03
- situation: P2부터 실행해 P0 결함 발견이 늦어진 상황
- signal: 테스트는 많이 돌렸지만 치명 결함이 뒤늦게 발견됨
- choice: 항상 P0 -> P1 -> P2 순으로 고정
- result: 치명 결함의 탐지 시점이 앞당겨짐
- condition: 회귀 범위가 넓고 실행 시간이 긴 테스트 세트
- caution: 팀/프로젝트 맥락이 다르면 그대로 복제하지 말고 조정한다.
- related_artifacts:
  - N/A (seeded)

### EXP-002
- status: seeded
- date: 2026-03-03
- situation: 실패 로그를 요약만 남겨 재현이 어려웠던 상황
- signal: 동일 실패를 다시 조사하는 시간이 길어짐
- choice: 재현 절차/원인/조치 3요소를 필수 기록
- result: 결함 재현 시간이 단축
- condition: 환경 의존 테스트가 많은 경우
- caution: 지표나 증적 없이 감으로 판단하지 않는다.
- related_artifacts:
  - N/A (seeded)

### EXP-003
- status: seeded
- date: 2026-03-03
- situation: 결함을 테스트 문서에만 남기고 설계로 환류하지 않은 상황
- signal: 다음 루프에서 유사 결함이 반복됨
- choice: 원인 분류 후 design/implementation 문서로 역피드백
- result: 동일 계열 결함 재발 빈도 감소
- condition: 설계 가정이 바뀐 테스트 실패가 발생했을 때
- caution: 루프 목표를 벗어나는 확장은 별도 의사결정으로 분리한다.
- related_artifacts:
  - N/A (seeded)

## Validated Entries
- 아직 없음

## Deprecated Entries
- 아직 없음
