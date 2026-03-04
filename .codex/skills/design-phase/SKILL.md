---
name: design-phase
description: "2W vN을 기반으로 1페이즈 분량의 Phase+US/지표/완료조건을 설계하는 메인 스킬. Step은 sprint 단계에서 작성한다."
---

# Design Phase

## 목적
프로젝트 전반 흐름을 `Phase + US`로 구조화하고, 이번 스프린트의 설계 기준을 확정한다.

핵심 원칙:
- 이 단계는 Phase/US/지표/완료조건까지 정의한다.
- Step은 `/plan-sprint` Plan 단계에서만 작성한다.
- 1페이즈(스프린트) 범위를 강제한다.
- 지표는 최소 2개: 선행 지표(Leading) 1, 결과 지표(Outcome) 1.

## 이 스킬이 메인으로 담당하는 것
- 2W 기반 Phase 흐름 설계 (현재/다음 단계)
- Phase별 US 구조화
- Phase/US 범위 확정(In/Out/Unknown)
- 지표/완료조건 확정 + Sprint 핸드오프

## 입력
- `.agile/loops/loop-vN/01-define-2w.md`
- `.agile/loops/loop-vN/02-define-2w-case-study.md` (선택)

## 출력물
- `.agile/loops/loop-vN/04-design-phase.md`

템플릿:
- `templates/design-phase-vN.md`

참고 문서:
- `references/philosophy.md`
  - 왜 design-phase를 Phase 중심으로 설계하는지 확인할 때
  - Step 책임 분리(design-phase vs Sprint)가 헷갈릴 때
- `references/experience.md`
  - Phase/US 범위 조정과 지표 설정에서 재사용 가능한 패턴을 확인할 때

## 작동 방식

### 1단계. 2W 핵심 고정
2W에서 아래를 고정 입력으로 사용한다:
- 무엇/왜
- 제약 조건
- 성공 기준/경계

### 2단계. Phase 흐름 설계
- Phase는 1~3개로 제한
- 각 Phase에 목표/완료 기준을 명시
- 현재 스프린트 대상은 `Phase-1`로 고정

### 3단계. Phase별 US 구조화
- Phase별 US를 1~3개 설정
- 이번 스프린트(Phase-1)에서 실행할 US는 1~2개로 제한
- 각 US에 사용자 가치 1줄, 완료 기준 1줄 명시

### 4단계. 범위 확정
`포함(In)/제외(Out)/미확정(Unknown)`으로 분리:
- 포함(In): 이번 스프린트(Phase-1)에서 설계/실행할 항목 1~3개
- 제외(Out): 명시적으로 제외할 것 1~3개
- 미확정(Unknown): 실행 후 판단할 것 1~2개

### 5단계. US/지표 설정
- Phase-1 대상 US를 최종 확정
- 선행 지표(Leading) 1개
- 결과 지표(Outcome) 1개

### 6단계. 스프린트 전달 정보 확정
다음 실행 단계에서 바로 계획을 만들 수 있게 아래를 확정:
- 스프린트 목표(Sprint Goal)
- 완료 기준(Definition of Done)
- 선행 의존사항
- Step 작성 책임: `/plan-sprint` Plan 단계

## 안티패턴
- Phase 없이 US만 나열해 전체 흐름이 사라짐
- Out/Unknown을 비워 Scope가 커짐
- Phase/US 설계에서 Step까지 확정해 Sprint 설계와 중복됨

## 완료 조건
- `.agile/loops/loop-vN/04-design-phase.md` 작성 완료
- Phase(1~3) + Phase별 US 구조 확정
- 포함/제외/미확정 확정
- 지표 2개(Leading/Outcome) 확정
- 스프린트 목표/완료 기준 명시

## 다음 단계
- `/plan-sprint` 실행
