# Experience - Sync Agent Skills

## 목적
- 이 문서는 `sync-agent-skills` 실행 전에 빠르게 참고하는 경험 자산이다.

## 사용 규칙
- `status: seeded`는 초기 샘플이다.
- 실전에서 검증된 항목만 `status: validated`로 승격한다.
- 더 이상 유효하지 않으면 `status: deprecated`로 내린다.
- 실행 전에는 `Validated Entries`를 우선 참고한다.

## Seeded Entries

### EXP-001
- status: seeded
- date: 2026-03-03
- situation: 동기화 후 frontmatter가 대상 에이전트 규칙과 불일치한 상황
- signal: 스킬 호출은 되지만 자동 인식 품질이 저하됨
- choice: 동기화 후 SKILL.md 상단 20줄을 즉시 검증
- result: 형식 오류 조기 제거
- condition: 다중 스킬을 한 번에 동기화할 때
- caution: 팀/프로젝트 맥락이 다르면 그대로 복제하지 말고 조정한다.
- related_artifacts:
  - N/A (seeded)

### EXP-002
- status: seeded
- date: 2026-03-03
- situation: 기존 로컬 변경을 확인하지 않고 덮어써 충돌한 상황
- signal: 의도하지 않은 diff가 대량 발생
- choice: 동기화 전/후 On branch main
Your branch is ahead of 'origin/main' by 14 commits.
  (use "git push" to publish your local commits)

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	.codex/skills/define-2w/references/experience.md
	.codex/skills/design-implementation/references/experience.md
	.codex/skills/design-phase/references/experience.md
	.codex/skills/design-test/references/experience.md
	.codex/skills/execute-implementation/references/experience.md
	.codex/skills/execute-test/references/experience.md
	.codex/skills/manage-experience/
	.codex/skills/monitor-sprint/references/
	.codex/skills/monitor-sprint/templates/
	.codex/skills/record-adr/references/

nothing added to commit but untracked files present (use "git add" to track)와 를 필수 점검
- result: 덮어쓰기 사고 감소
- condition: 타겟 스킬을 수동으로 수정 중인 저장소
- caution: 지표나 증적 없이 감으로 판단하지 않는다.
- related_artifacts:
  - N/A (seeded)

### EXP-003
- status: seeded
- date: 2026-03-03
- situation: 동기화 대상 이름을 넓게 잡아 불필요한 스킬까지 복사한 상황
- signal: Active/Legacy 경계가 다시 흐려짐
- choice: 필요 스킬명만 명시해 부분 동기화
- result: 운영 범위 안정화
- condition: 리팩터링 중 특정 스킬만 업데이트할 때
- caution: 루프 목표를 벗어나는 확장은 별도 의사결정으로 분리한다.
- related_artifacts:
  - N/A (seeded)

## Validated Entries
- 아직 없음

## Deprecated Entries
- 아직 없음
