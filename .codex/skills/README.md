# Codex Skills

이 디렉터리는 Codex용 프로젝트 스킬 모음입니다.

## Active Skills

- `define-2w`: 4개 필수 질문으로 2W를 라운드(vN) 단위로 빠르게 정의
- `design-phase`: 2W vN 기반으로 1페이즈 분량의 Phase+US/지표/완료조건을 설계 (Step은 Sprint에서 작성)
- `plan-sprint`: Sprint 계획/진행/완료/US 완료를 통합 운영하고 다음 define-2w/design-phase 라운드로 반영
- `design-implementation`: 구현 설계 전용 스킬 (Sequence/Flowchart 중심 + C4 Container 선택)
- `execute-implementation`: 구현 실행 전용 스킬 (코드 스타일 컨벤션 + 테스트/검증)
- `design-test`: 테스트 구현 설계 전용 스킬 (케이스/우선순위/전략/환경)
- `execute-test`: 테스트 구현 실행 전용 스킬 (실행/실패분석/재검증)
- `monitor-sprint`: Sprint 진행 현황 집계
- `record-adr`: Architecture Decision Record 생성/관리
- `sync-agent-skills`: 다른 에이전트 스킬을 Codex 형식으로 동기화
- `manage-experience`: 스킬별 경험 문서 seed/log/promote 운영

## Legacy Skills

- 레거시 스킬은 `.codex/skills-legacy/`로 분리했다.
- 현재 위치:
  - `2w-brainstorm`
  - `1h-agile-phase`
  - `sprint-start`
  - `sprint-complete`
  - `us-complete`
- 매핑/전환 기준은 `docs/operations/skills-lifecycle.md`를 참고한다.

## 형식 규칙

- `SKILL.md` frontmatter는 Codex 형식을 사용합니다.
- 필수 메타 필드:
  - `name`
  - `description`
- UI 노출 정보가 필요하면 `agents/openai.yaml`을 함께 관리합니다.

## 동기화 메모

- 공통 스킬 업데이트 시 `.claude/skills`, `.gemini/skills`와 함께 동기화합니다.
- 대량 동기화는 `sync-agent-skills` 스킬의 스크립트를 사용합니다.
