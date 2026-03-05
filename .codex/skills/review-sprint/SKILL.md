---
name: review-sprint
description: "Delivery 단계 산출물을 기반으로 Sprint 회고/학습 문서를 작성하고 다음 스프린트 시작 또는 종료를 결정하는 운영 스킬."
---

# Review Sprint

## 목적
`2-delivery/` 산출물을 기반으로 Learning 단계 회고를 확정한다.

## 적용 원칙
- Core: `docs/skill-ops/principles.md`의 `Core (공통 강제)` 적용
- Modules: `M-PIPELINE-CONTRACT`

핵심 원칙:
- 회고/학습 산출물은 `3-learning/` 디렉터리에만 기록한다.
- 본 스킬은 회고/학습/다음 스프린트 결정에 집중한다.
- Sprint 상태 집계/진행률 계산은 `monitor-sprint` 책임이다.
- 단계 게이트/라우팅/산출 디렉터리 계약은 `docs/skill-ops/framework.md`를 우선 준수한다.
- 브랜치 생성/전환은 `define-2w` 책임이며, 본 스킬은 스프린트-브랜치 정합성만 검증한다.

## 이 스킬이 메인으로 담당하는 것
- US 단위 회고 문서 작성
- Sprint 회고 문서 작성
- 학습 항목(Keep/Drop, True/False/Unknown) 정리
- 다음 스프린트 시작/종료 결정 기록

## 입력
- `.agile/sprints/sprint-N/2-delivery/` (필수)
- `.agile/sprints/sprint-N/2-delivery/sprint-status.md` (권장)

## 출력물
- `.agile/sprints/sprint-N/3-learning/sprint-retrospective.md`
- `.agile/sprints/sprint-N/3-learning/us-retrospective-US-ID.md` (선택: 완료 US 기준)

템플릿:
- `templates/sprint-retrospective.md`
- `templates/us-retrospective.md`

참고 문서:
- `docs/skill-ops/framework.md`
  - Learning 단계 진입/완료 조건을 확인할 때
- `docs/skill-ops/framework-applied-skills.md`
  - 다음 스프린트 재진입 순서를 확인할 때
- `references/experience.md`
  - 회고 구조화/학습 정리 패턴을 재사용할 때

## 작동 방식

### 1단계. 최신 sprint 확인
- `.agile/sprints/`에서 최신 `sprint-N` 확인
- `2-delivery/` 디렉터리 존재 및 비어있지 않음 확인
- 현재 브랜치가 대상 `sprint-N`과 불일치하면 `HOLD`로 중단하고 `define-2w` 브랜치 게이트로 회귀한다.

### 2단계. 증적 수집
- Delivery 단계 산출물에서 아래를 우선 수집한다:
  - 완료/미완료 US
  - 검증 결과 및 결함 기록
  - 리스크/블로커 대응 결과
- 증적이 부족하면 회고 문서에 Unknown으로 명시한다.

### 3단계. US 회고 작성 (선택)
- 완료된 US가 있으면 US별 회고를 생성한다.
- 각 US 회고에는 목표/결과/잘된 점/아쉬운 점/증적/다음 액션을 포함한다.

### 4단계. Sprint 회고 작성
- Sprint 회고에는 반드시 아래 5개를 포함한다:
  1. 검증된 가정(True)
  2. 반박된 가정(False)
  3. 새로 생긴 Unknown
  4. 유지할 전략(Keep)
  5. 폐기할 전략(Drop)
- 다음 스프린트 `시작` 또는 `종료` 결정을 이유와 함께 기록한다.

### 5단계. 라우팅 확정
- 다음 스프린트를 시작하면 `C1 Direction`으로 재진입한다.
- 종료하면 현재 Sprint를 `Done`으로 표시하고 추가 실행을 중지한다.
- 최종 라우팅은 `docs/skill-ops/framework-applied-skills.md`의 순서를 따른다.

## 안티패턴
- 회고를 상태 보고로 대체해 학습 항목이 누락됨
- 실패 원인을 기록하지 않고 다음 Sprint로 이동
- 증적 없는 결론을 확정해 재현/검증이 불가능해짐
- 회고 산출물을 `2-delivery/`에 저장해 단계 경계가 흐려짐
- 브랜치 불일치 상태를 무시하고 Learning 단계를 진행함

## 완료 조건
- `3-learning/`에 Sprint 회고 문서 작성 완료
- 완료된 US가 있으면 US 회고 문서 작성 완료
- 다음 스프린트 시작/종료 결정이 회고 문서에 기록 완료
- 다음 적용 스킬/종료 경로가 `docs/skill-ops/framework-applied-skills.md` 기준으로 확정
- 스프린트-브랜치 정합성 확인 완료 (불일치 시 `HOLD` 기록)

## 다음 단계
- 다음 적용 스킬은 `docs/skill-ops/framework-applied-skills.md`의 `단계별 적용 순서`를 참조해 결정한다.
