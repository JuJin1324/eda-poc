# Codex Skills

이 디렉터리는 Codex용 프로젝트 스킬 모음입니다.

## Active Skills

- `define-2w`: 4개 필수 질문으로 2W를 라운드(vN) 단위로 빠르게 정의
- `design-phase`: 2W vN 기반으로 1페이즈 분량의 Phase+US/지표/완료조건을 설계 (사례/패턴 연구 산출물 선택 반영, 구현 Step은 design-implementation에서 작성)
- `design-implementation`: 구현 설계 전용 스킬 (Sequence/Flowchart 중심 + C4 Container 선택)
- `execute-implementation`: 구현 실행 전용 스킬 (코드 스타일 컨벤션 + 테스트/검증)
- `design-test`: 테스트 구현 설계 전용 스킬 (케이스/우선순위/전략/환경)
- `execute-test`: 테스트 구현 실행 전용 스킬 (실행/실패분석/재검증, 필요 시 monitor-sprint 상태 갱신)
- `monitor-sprint`: Sprint 상태 문서 생성/업데이트 + 진행 현황 집계/재평가
- `review-sprint`: Sprint 회고/학습 정리 + 다음 스프린트 시작/종료 결정
- `record-adr`: Architecture Decision Record 생성/관리 (`design-phase.md`, `design-implementation.md` 등과 연계)
- `sync-agent-skills`: 다른 에이전트 스킬을 Codex 형식으로 동기화
- `manage-experience`: 스킬별 경험 문서 seed/log/promote 운영
- `migrate-legacy-artifacts`: 다양한 프로젝트의 구버전 산출물을 자동 탐색해 신버전 파이프라인 입력 경로로 마이그레이션

## 권장 워크플로우 (현재)

1. `define-2w`: 2W 확정 + 필요 시 사례/패턴 연구 산출물 생성
2. `design-phase`: `1-direction/` 산출물로 Phase/US/지표 설계
3. `monitor-sprint`: `2-delivery/` 상태 문서 초기화(없으면 bootstrap) 및 대시보드 확인
4. `design-implementation` -> `execute-implementation`
5. `design-test` -> `execute-test`
6. `monitor-sprint`: 상태/리스크 갱신 및 재평가
7. `review-sprint`: `3-learning/`에 회고/학습 정리
8. Sprint 종료 후 `define-2w` 또는 `design-phase`로 다음 스프린트 진입

## Legacy Skills

- 레거시 스킬은 `.codex/skills-legacy/`로 분리했다.
- 현재 위치:
  - `2w-brainstorm`
  - `1h-agile-phase`
  - `sprint-start`
  - `sprint-complete`
  - `us-complete`
- 매핑/전환 기준은 `docs/skill-ops/skills-lifecycle.md`를 참고한다.

## 형식 규칙

- `SKILL.md` frontmatter는 Codex 형식을 사용합니다.
- 필수 메타 필드:
  - `name`
  - `description`
- UI 노출 정보가 필요하면 `agents/openai.yaml`을 함께 관리합니다.

## 동기화 메모

- 공통 스킬 업데이트 시 `.claude/skills`, `.gemini/skills`와 함께 동기화합니다.
- 대량 동기화는 `sync-agent-skills` 스킬의 스크립트를 사용합니다.
