---
name: manage-experience
description: "스킬별 경험 문서를 초기화(seed)하고, 실행 중 얻은 패턴을 누적(log)·정제(promote)하는 운영 스킬. 경험치를 개인/팀 자산으로 축적해 다음 실행 품질을 높인다."
---

# Manage Experience

## 목적
스킬 실행 중 얻은 경험을 문서 자산으로 관리해, 같은 시행착오를 반복하지 않도록 한다.

## 적용 원칙
- Core: `docs/skill-ops/principles.md`의 `Core (공통 강제)` 적용
- Modules: `M-EXPERIENCE-LIFECYCLE`

핵심 원칙:
- 초반 샘플은 AI가 `seeded`로 제공한다.
- 실전에서 검증된 경험만 `validated`로 승격한다.
- 오래된 패턴은 `deprecated`로 내린다.
- 실행 직전에는 필요한 항목만 짧게 참고한다.

## 입력
- 대상 스킬명(기본: Active 스킬 전체)
- 현재 실행 컨텍스트(문제/루프/US)

## 출력물
- `.codex/skills/<skill-name>/references/experience.md`

템플릿:
- `templates/experience-entry.md`

스크립트:
- `scripts/seed_experience_docs.sh`

참고 문서:
- `references/experience.md`
  - 운영 중 기록 품질/승격 기준을 점검할 때

## 실행 모드

### 1) seed
초기 경험 샘플을 생성한다.

실행:
```bash
bash .codex/skills/manage-experience/scripts/seed_experience_docs.sh
```

강제 재시드(기존 파일 덮어쓰기):
```bash
FORCE=1 bash .codex/skills/manage-experience/scripts/seed_experience_docs.sh
```

규칙:
- 대상: Active 스킬 전체
- 각 문서당 샘플 3개 생성
- 상태는 모두 `seeded`
- 기본은 기존 `experience.md`를 보존하고, 파일이 없을 때만 생성

### 2) log
사용자 실전 경험을 새 항목으로 추가한다.

절차:
1. 대상 스킬의 `references/experience.md` 열기
2. `Validated Entries` 섹션에 `templates/experience-entry.md` 형식으로 항목 추가
3. `status: validated`로 기록

### 3) promote
반복 검증된 패턴을 상단 요약으로 승격한다.

승격 기준:
- 동일 패턴이 2회 이상 재현됨
- 적용 조건이 명확함
- 부작용/한계가 기록됨

## 사용 규칙
- `seeded`는 참고용 초안이며 결정의 1차 근거로 사용하지 않는다.
- 의사결정에는 `validated`를 우선 참조한다.
- `deprecated`는 삭제하지 않고 이유를 남긴다.

## 안티패턴
- 모든 경험을 장문으로 기록해 탐색 비용을 키움
- 결과만 쓰고 적용 조건을 쓰지 않음
- 실패 사례를 숨겨 재현 방지를 못함

## 완료 조건
- 대상 스킬의 `references/experience.md`가 존재한다.
- 항목 상태(`seeded/validated/deprecated`)가 구분된다.
- 최신 실전 경험이 `validated` 섹션에 반영된다.
