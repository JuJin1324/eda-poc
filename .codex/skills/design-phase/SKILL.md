---
name: design-phase
description: "2W를 기반으로 1페이즈 분량의 Phase+US/지표/완료조건을 설계하는 메인 스킬. 구현 Step은 design-implementation에서 작성한다."
---

# Design Phase

## 목적
프로젝트 전반 흐름을 `Phase + US`로 구조화하고, 이번 스프린트의 설계 기준을 확정한다.

## 적용 원칙
- Core: `docs/skill-ops/principles.md`의 `Core (공통 강제)` 적용
- Modules: `M-PIPELINE-CONTRACT`, `M-SCHEDULE-VISIBILITY`

핵심 원칙:
- 이 단계는 Phase/US/지표/완료조건까지 정의한다.
- 이번 스프린트 기간과 US 완료 목표일을 명시해 Delivery 단계 일정 추적 기준을 만든다.
- Step 상세는 `design-implementation` 단계에서 작성하고, 상태 관리는 Delivery 단계 산출물에서 수행한다.
- 1페이즈(스프린트) 범위를 강제한다.
- 지표는 최소 2개: 선행 지표(Leading) 1, 결과 지표(Outcome) 1.
- 단계 게이트/라우팅/산출 디렉터리 계약은 `docs/skill-ops/framework.md`를 우선 준수한다.
- 브랜치 생성/전환은 `define-2w` 책임이며, 본 스킬은 스프린트-브랜치 정합성만 검증한다.

## 이 스킬이 메인으로 담당하는 것
- 2W 기반 Phase 흐름 설계 (현재/다음 단계)
- Phase별 US 구조화
- Phase/US 범위 확정(In/Out/Unknown)
- 스프린트 기간/US 완료 목표일 기준 확정
- 지표/완료조건 확정 + 다음 단계 핸드오프

## 입력
- `1-direction/` 디렉터리 내 2W 본문 문서 (필수)
- `1-direction/` 디렉터리 내 사례 연구 문서 (선택)
- `1-direction/` 디렉터리 내 패턴 연구 문서 (선택)
- 파일명은 실행 주체 자율이며, 단계 디렉터리 계약은 `docs/skill-ops/framework.md`를 따른다.

## 출력물
- `1-direction/` 디렉터리 내 design-phase 문서 1개

템플릿:
- `templates/design-phase.md`

참고 문서:
- `docs/skill-ops/framework.md`
  - 본 스킬의 단계 진입/전환 조건과 산출 디렉터리 계약을 확인할 때
- `references/experience.md`
  - Phase/US 범위 조정과 지표 설정에서 재사용 가능한 패턴을 확인할 때

## 작동 방식

### 1단계. 2W 핵심 고정
2W에서 아래를 고정 입력으로 사용한다:
- 무엇/왜
- 제약 조건
- 성공 기준/경계
- 사례/패턴 연구 결과(선택)
- 현재 브랜치가 대상 `sprint-N`과 불일치하면 `HOLD`로 중단하고 `define-2w` 브랜치 게이트로 회귀한다.

### 2단계. Phase 흐름 설계
- Phase는 1~3개로 제한
- 각 Phase에 목표/완료 기준을 명시
- 현재 스프린트 대상은 `Phase-1`로 고정

### 3단계. Phase별 US 구조화
- Phase별 US를 1~3개 설정
- 이번 스프린트(Phase-1)에서 실행할 US는 1~2개로 제한
- 각 US에 사용자 가치 1줄, 완료 기준 1줄 명시
- 이번 스프린트(Phase-1) US는 `완료 목표일(YYYY-MM-DD)`을 반드시 명시

### 4단계. 범위 확정
`포함(In)/제외(Out)/미확정(Unknown)`으로 분리:
- 포함(In): 이번 스프린트(Phase-1)에서 설계/실행할 항목 1~3개
- 제외(Out): 명시적으로 제외할 것 1~3개
- 미확정(Unknown): 실행 후 판단할 것 1~2개

### 5단계. US/일정/지표 설정
- Phase-1 대상 US를 최종 확정
- 스프린트 기간(시작일/종료일) 확정
- Phase-1 대상 US 완료 목표일 확정
- 선행 지표(Leading) 1개
- 결과 지표(Outcome) 1개

### 6단계. 스프린트 전달 정보 확정
다음 실행 단계에서 바로 계획을 만들 수 있게 아래를 확정:
- 스프린트 목표(Sprint Goal)
- 스프린트 기간(시작일/종료일)
- 완료 기준(Definition of Done)
- 선행 의존사항
- 상태 문서 초기화/갱신 책임: Delivery 단계(`2-delivery`) 산출물
- 구현 Step 작성 책임: Delivery 단계(`2-delivery`) 산출물
- 회고/학습 책임: Learning 단계(`3-learning`) 산출물

## 안티패턴
- Phase 없이 US만 나열해 전체 흐름이 사라짐
- Out/Unknown을 비워 Scope가 커짐
- Phase/US 설계에서 Step까지 확정해 Sprint 설계와 중복됨
- US 완료 목표일 없이 넘겨 Delivery 단계 일정 상태 계산이 불가능해짐
- 브랜치 불일치 상태를 무시하고 설계를 계속 진행함

## 완료 조건
- `1-direction/`에 design-phase 문서 작성 완료
- Phase(1~3) + Phase별 US 구조 확정
- 이번 스프린트 기간(시작일/종료일) 확정
- 이번 스프린트 대상 US 완료 목표일 확정
- 포함/제외/미확정 확정
- 지표 2개(Leading/Outcome) 확정
- 스프린트 목표/완료 기준 명시
- 스프린트-브랜치 정합성 확인 완료 (불일치 시 `HOLD` 기록)

## 다음 단계
- 다음 적용 스킬은 `docs/skill-ops/framework-applied-skills.md`의 `단계별 적용 순서`를 참조해 결정한다.
