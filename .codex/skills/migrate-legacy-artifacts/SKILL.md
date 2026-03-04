---
name: migrate-legacy-artifacts
description: "구버전 스킬 산출물(예: 2w-brainstorm.md, case-studies.md, how-diagram.md)을 신버전 loop 산출물 경로로 안전하게 변환하는 운영 스킬. 프로젝트 공통 자동 탐색 + dry-run 기본."
---

# Migrate Legacy Artifacts

## 목적
구버전 스킬 산출 문서를 신버전 스킬 입력 경로로 변환해, 기존 프로젝트를 끊김 없이 계속 진행할 수 있게 한다.

핵심 원칙:
- 기본은 `dry-run`으로 실행한다.
- 원본 레거시 파일은 수정/삭제하지 않는다.
- `apply`에서도 기본은 덮어쓰기 금지이며, `--overwrite`를 명시한 경우에만 덮어쓴다.
- 마이그레이션 결과를 리포트 파일로 남긴다.

## 기본 매핑 (legacy-generic)
- `2W 문서` 후보 자동 탐색 -> `.agile/loops/loop-vN/01-define-2w.md`
  - 우선순위 예: `2w-brainstorm.md`, `docs/planning/2w-brainstorm.md`, `problems/*/2w-brainstorm.md`
- `사례 연구 문서` 후보 자동 탐색 -> `.agile/loops/loop-vN/02-define-2w-case-study.md`
  - 우선순위 예: `2w-case-study*.md`, `case-studies.md`, `eda-kafka-case-studies.md`, `docs/planning/*`
- `How/Phase 문서` 후보 자동 탐색 -> `.agile/loops/loop-vN/04-design-phase.md`
  - 우선순위 예: `how-diagram.md`, `1h-agile-phase.md`, `docs/planning/*`, `problems/*`

## 입력
- 대상 프로젝트 루트 경로 (`--project-root`, 예: `../eda-poc`)
- 루프 번호 (`--loop`, 생략 시 자동 감지)
- 실행 모드 (`--mode dry-run|apply`)
- 덮어쓰기 여부 (`--overwrite`)
- 프로필 (`--profile`, 기본: `legacy-generic`)
- 소스 파일 경로 커스터마이징(선택):
  - `--source-2w`
  - `--source-case-study`
  - `--source-how`

## 출력물
- `<project-root>/.agile/loops/loop-vN/01-define-2w.md` (선택: 소스 존재 시)
- `<project-root>/.agile/loops/loop-vN/02-define-2w-case-study.md` (선택: 소스 존재 시)
- `<project-root>/.agile/loops/loop-vN/04-design-phase.md` (선택: 소스 존재 시)
- `<project-root>/.agile/migration/legacy-migration-report-vN.md`

템플릿:
- `templates/legacy-migration-report-vN.md`

스크립트:
- `scripts/migrate_legacy_artifacts.sh`

참고 문서:
- `references/experience.md`
  - 루프 선택/덮어쓰기/누락 파일 처리에서 검증된 패턴을 참고할 때

## 실행 절차

### Step 1. 게이트 확정
아래를 먼저 확정한다.
- 대상 프로젝트 루트
- 대상 루프 번호
- 모드(`dry-run` 또는 `apply`)
- 덮어쓰기 여부

### Step 2. Dry-run 실행 (필수 권장)
```bash
bash .codex/skills/migrate-legacy-artifacts/scripts/migrate_legacy_artifacts.sh \
  --project-root ../my-project \
  --mode dry-run
```

확인 포인트:
- 소스 파일 존재 여부
- 대상 파일 충돌 여부
- `would_copy`, `would_overwrite`, `would_skip_destination_exists` 상태

### Step 3. Apply 실행 (선택)
충돌/누락을 확인한 뒤 실제 변환을 실행한다.
```bash
bash .codex/skills/migrate-legacy-artifacts/scripts/migrate_legacy_artifacts.sh \
  --project-root ../my-project \
  --mode apply
```

덮어쓰기가 필요하면 명시적으로 실행:
```bash
bash .codex/skills/migrate-legacy-artifacts/scripts/migrate_legacy_artifacts.sh \
  --project-root ../my-project \
  --mode apply \
  --overwrite
```

### Step 4. 신버전 입력 검증
다음 경로를 확인한다.
- `.agile/loops/loop-vN/01-define-2w.md`
- `.agile/loops/loop-vN/02-define-2w-case-study.md` (생성된 경우)
- `.agile/loops/loop-vN/04-design-phase.md`

검증이 끝나면 신버전 스킬로 이어서 실행한다.
- `/define-2w` (2W 갱신이 필요한 경우)
- `/design-phase` (Phase 갱신이 필요한 경우)

## 안티패턴
- `dry-run` 없이 바로 `apply` 실행
- 레거시 원본 파일을 직접 rename/move해서 이력 유실
- `--overwrite`를 습관적으로 사용해 최신 산출물을 덮어씀
- 리포트를 남기지 않고 구두로만 이전 상태를 공유

## 완료 조건
- 대상 루트/루프/모드 게이트 확정 완료
- 마이그레이션 리포트 파일 생성 완료
- 적용 모드일 경우 대상 산출물 생성/충돌/누락 상태 확인 완료
- 후속 스킬 진입 경로(`/define-2w` 또는 `/design-phase`) 결정 완료
