# Experience - Design Implementation

## 목적
- 이 문서는 `design-implementation` 실행 전에 빠르게 참고하는 경험 자산이다.

## 사용 규칙
- `status: seeded`는 초기 샘플이다.
- 실전에서 검증된 항목만 `status: validated`로 승격한다.
- 더 이상 유효하지 않으면 `status: deprecated`로 내린다.
- 실행 전에는 `Validated Entries`를 우선 참고한다.

## Seeded Entries

### EXP-001
- status: seeded
- date: 2026-03-03
- situation: 기술 스택 합의 전에 설계부터 시작해 구현 중 충돌한 상황
- signal: 라이브러리 선택 변경으로 다이어그램을 다시 그림
- choice: tech-stack 확인/합의를 1단계로 고정
- result: 설계 재작업 횟수 감소
- condition: 외부 라이브러리 의존도가 높은 기능
- caution: 팀/프로젝트 맥락이 다르면 그대로 복제하지 말고 조정한다.
- related_artifacts:
  - N/A (seeded)

### EXP-002
- status: seeded
- date: 2026-03-03
- situation: C4 Container를 항상 작성해 비용이 커진 상황
- signal: 외부 의존성이 단순한데도 문서가 과도하게 길어짐
- choice: C4 작성 게이트를 두고 생성/생략 판단
- result: 필수 다이어그램(Sequence/Flowchart)에 집중 가능
- condition: 단일 서비스 내부 변경 중심의 구현
- caution: 지표나 증적 없이 감으로 판단하지 않는다.
- related_artifacts:
  - N/A (seeded)

### EXP-003
- status: seeded
- date: 2026-03-03
- situation: 인터페이스를 먼저 쓰고 다이어그램을 나중에 맞춘 상황
- signal: 설명 문서와 흐름도가 서로 불일치
- choice: 경계 정의 후 다이어그램 먼저, 인터페이스는 그 다음
- result: 문서 읽기 순서가 자연스러워짐
- condition: 여러 구현자에게 설계를 전달해야 할 때
- caution: 루프 목표를 벗어나는 확장은 별도 의사결정으로 분리한다.
- related_artifacts:
  - N/A (seeded)

### EXP-004
- status: seeded
- date: 2026-03-05
- situation: US 2개를 한 번에 설계해 구현/테스트 큐가 커진 상황
- signal: execute/test 단계가 병목되며 monitor-sprint에서 In-Progress가 오래 유지됨
- choice: 기본을 US 1개 순차 루프로 고정하고, 2개 동시 설계는 예외 조건으로 제한
- result: WIP가 줄고 단계별 완료 신호가 빨라짐
- condition: 선행 의존성이 있는 US가 연속 배치된 스프린트
- caution: 동시 설계는 반드시 독립성/영향 분리를 먼저 검증한다.
- related_artifacts:
  - `.codex/skills/design-implementation/SKILL.md`

## Validated Entries
- 아직 없음

## Deprecated Entries
- 아직 없음
