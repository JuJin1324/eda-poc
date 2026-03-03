---
name: plan-sprint
description: "Sprint 계획/진행/완료를 한 흐름으로 운영하는 메인 스킬. 실행-검증-학습 루프로 Sprint 결과를 define-2w/design-phase 다음 버전에 반영한다."
---

# Plan Sprint

## 목적
Sprint를 계획하고 실행/점검/완료까지 운영한 뒤, 결과를 다음 `loop-vN+1`의 `define-2w/design-phase`에 반영하는 **학습 루프**를 강제한다.

핵심 원칙:
- 계획은 실행을 위한 가설
- Sprint 결과는 다음 계획의 입력
- 회고 없는 반복은 금지

## 이 스킬이 메인으로 담당하는 것
- Sprint 계획 수립 (Plan)
- Sprint 진행 점검 (Status)
- US 회고 기록 (US Retrospective)
- Sprint 회고 작성 (Sprint Retrospective)
- 증적 기반 회고(가정 검증/반박)
- 다음 라운드 진입 판단

## 입력
- `.agile/loops/loop-vN/design-phase.md`

## 출력물
- `.agile/loops/loop-vN/sprint/sprint-plan.md`
- `.agile/loops/loop-vN/sprint/sprint-status.md`
- `.agile/loops/loop-vN/sprint/us-N.M-retrospective.md`
- `.agile/loops/loop-vN/sprint/sprint-retrospective.md` (스프린트 회고 본문)

템플릿:
- `templates/sprint-retrospective-vN.md`
- `templates/sprint-plan.md`
- `templates/sprint-status.md`
- `templates/us-retrospective.md`

참고 문서:
- `references/philosophy.md`
  - 왜 매 스프린트 종료 후 define-2w/design-phase 재진입이 필요한지 확인할 때
  - 실행-학습 루프 운영 원칙을 팀에 설명할 때
- `references/experience.md`
  - Step 밀도, 회고 품질, 다음 라운드 판단에서 재사용 패턴을 참고할 때

## 권장 실행 순서
1. Plan: `.agile/loops/loop-vN/design-phase.md` 기반으로 `sprint-plan.md` 생성/확정 (US별 Step 작성 포함)
2. Design Implementation: `/design-implementation` 실행
3. Execute Implementation: `/execute-implementation` 실행
4. Design Test: `/design-test` 실행
5. Execute Test: `/execute-test` 실행
6. Status: 진행률과 일정 리스크를 `sprint-status.md`에 기록
7. US Retrospective: 각 US 완료 후 `us-N.M-retrospective.md` 작성
8. Sprint Retrospective: `sprint-retrospective.md` 작성
9. 다음 라운드 결정

## 루프 리뷰 규칙
`.agile/loops/loop-vN/sprint/sprint-retrospective.md`는 스프린트 회고 문서이며, 아래 5개를 반드시 작성:
1. 검증된 가정 (True)
2. 반박된 가정 (False)
3. 새로 생긴 Unknown
4. 유지할 전략
5. 폐기할 전략

## 다음 라운드 결정 규칙
- 2W 자체가 바뀜: `/define-2w`로 재진입 (`define-2w.md (다음 loop-vN+1 디렉터리)`)
- 2W는 유지, 설계(Phase)만 수정: `/design-phase`로 재진입 (`design-phase.md (다음 loop-vN+1 디렉터리)`)
- 목표 달성: 루프 종료

## 안티패턴
- 회고를 생략하고 다음 Sprint를 시작
- 실패한 가정을 문서에서 제거만 하고 원인 기록 없음
- 일정 지연을 숨기고 계획을 고정값처럼 취급

## 완료 조건 (Done)
- `sprint-plan.md`, `sprint-status.md` 작성 완료
- 완료된 US마다 `us-N.M-retrospective.md` 작성 완료
- `.agile/loops/loop-vN/sprint/sprint-retrospective.md`(스프린트 회고) 작성 완료
- 다음 라운드 진입 경로 확정

## 다음 단계
- 결정에 따라 `/define-2w` 또는 `/design-phase`
