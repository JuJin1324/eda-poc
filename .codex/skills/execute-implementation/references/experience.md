# Experience - Execute Implementation

## 목적
- 이 문서는 `execute-implementation` 실행 전에 빠르게 참고하는 경험 자산이다.

## 사용 규칙
- `status: seeded`는 초기 샘플이다.
- 실전에서 검증된 항목만 `status: validated`로 승격한다.
- 더 이상 유효하지 않으면 `status: deprecated`로 내린다.
- 실행 전에는 `Validated Entries`를 우선 참고한다.

## Seeded Entries

### EXP-001
- status: seeded
- date: 2026-03-03
- situation: 코드 완료 후 US/Step 매핑을 나중에 작성해 누락이 생긴 상황
- signal: 완료 보고 시 어떤 요구를 충족했는지 즉시 답하기 어려움
- choice: 구현과 동시에 매핑 표를 갱신
- result: 리뷰 시 추적성이 크게 개선
- condition: US 범위가 큰 기능을 분할 구현할 때
- caution: 팀/프로젝트 맥락이 다르면 그대로 복제하지 말고 조정한다.
- related_artifacts:
  - N/A (seeded)

### EXP-002
- status: seeded
- date: 2026-03-03
- situation: 테스트를 마지막에 몰아 실행해 결함 수정이 지연된 상황
- signal: 통합 단계에서 실패가 한 번에 터짐
- choice: 작은 단위 구현마다 관련 테스트를 즉시 실행
- result: 결함 원인 구간이 좁아져 수정 속도 향상
- condition: 도메인 규칙이 많은 백엔드 구현
- caution: 지표나 증적 없이 감으로 판단하지 않는다.
- related_artifacts:
  - N/A (seeded)

### EXP-003
- status: seeded
- date: 2026-03-03
- situation: 컨벤션 점검을 생략해 리팩터링 비용이 증가한 상황
- signal: PR 리뷰가 스타일 이슈 중심으로 길어짐
- choice: 코드 변경 직후 컨벤션 체크리스트 확인
- result: 리뷰 피드백이 설계/로직 중심으로 이동
- condition: 협업 PR 비중이 높은 프로젝트
- caution: 루프 목표를 벗어나는 확장은 별도 의사결정으로 분리한다.
- related_artifacts:
  - N/A (seeded)

## Validated Entries
- 아직 없음

## Deprecated Entries
- 아직 없음
