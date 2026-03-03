# Experience - Design Test

## 목적
- 이 문서는 `design-test` 실행 전에 빠르게 참고하는 경험 자산이다.

## 사용 규칙
- `status: seeded`는 초기 샘플이다.
- 실전에서 검증된 항목만 `status: validated`로 승격한다.
- 더 이상 유효하지 않으면 `status: deprecated`로 내린다.
- 실행 전에는 `Validated Entries`를 우선 참고한다.

## Seeded Entries

### EXP-001
- status: seeded
- date: 2026-03-03
- situation: 정상 시나리오 위주로만 설계해 운영 결함을 놓친 상황
- signal: 실패/엣지 입력에서 즉시 장애가 재현됨
- choice: 정상/실패/엣지 케이스를 분리해 모두 명시
- result: 결함 탐지율이 초기 단계에서 상승
- condition: 입력 경계값/예외 처리가 많은 기능
- caution: 팀/프로젝트 맥락이 다르면 그대로 복제하지 말고 조정한다.
- related_artifacts:
  - N/A (seeded)

### EXP-002
- status: seeded
- date: 2026-03-03
- situation: 우선순위 없이 케이스를 나열해 실행 순서가 혼란스러운 상황
- signal: 중요도 낮은 테스트에 시간이 먼저 소모됨
- choice: P0/P1/P2로 분류 후 P0 우선 실행 계획 고정
- result: 핵심 리스크를 먼저 차단
- condition: 테스트 시간이 제한된 스프린트
- caution: 지표나 증적 없이 감으로 판단하지 않는다.
- related_artifacts:
  - N/A (seeded)

### EXP-003
- status: seeded
- date: 2026-03-03
- situation: 테스트 스택과 방법론을 따로 관리해 일관성이 깨진 상황
- signal: 케이스 형식이 팀원마다 달라짐
- choice: tech-stack의 테스트 방법론을 설계 단계에 반영
- result: 문서/코드 테스트 형식이 통일
- condition: BDD/TDD를 혼용하는 팀
- caution: 루프 목표를 벗어나는 확장은 별도 의사결정으로 분리한다.
- related_artifacts:
  - N/A (seeded)

## Validated Entries
- 아직 없음

## Deprecated Entries
- 아직 없음
