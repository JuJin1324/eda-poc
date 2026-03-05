---
name: execute-test
description: "테스트 설계를 바탕으로 테스트 코드를 구현하고 실행/검증하는 메인 스킬. 실패 원인과 결함을 기록해 구현/설계로 피드백한다."
---

# Execute Test

## 목적
`.agile/sprints/sprint-N/2-delivery/design-test-us-N.M.md`를 기반으로 테스트를 구현/실행하고 결과를 검증한다.

## 적용 원칙
- Core: `docs/skill-ops/principles.md`의 `Core (공통 강제)` 적용
- Modules: `M-PIPELINE-CONTRACT`, `M-WIP-ONE-US`

핵심 원칙:
- P0부터 실행해 리스크를 먼저 낮춘다.
- 실패는 증거와 함께 기록한다.
- 결함은 구현/설계 문서로 되돌려 닫힌 루프를 만든다.
- 테스트 종료 후 동일 US 상태를 확정하고 `monitor-sprint`로 즉시 반영한다.
- 이번 US 완료 후에만 다음 US 설계로 이동한다.
- 단계 게이트/라우팅/산출 디렉터리 계약은 `docs/skill-ops/framework.md`를 우선 준수한다.

## 이 스킬이 메인으로 담당하는 것
- 테스트 코드 구현
- 테스트 실행/결과 수집
- 실패 분석/결함 기록
- 재검증 및 상태 갱신

## 입력
- `.agile/sprints/sprint-N/2-delivery/design-test-us-N.M.md`
- `.agile/sprints/sprint-N/2-delivery/execute-implementation-us-N.M-step-*.md` (권장, 스텝 리뷰 문서)
- `.agile/sprints/sprint-N/2-delivery/execute-implementation-us-N.M.md` (호환용 legacy 문서, 존재 시만)

## 출력물
- 테스트 코드 변경사항
- `.agile/sprints/sprint-N/2-delivery/execute-test-us-N.M.md`

템플릿:
- `templates/execute-test-us-vN.md`

참고 문서:
- `docs/skill-ops/framework.md`
  - 본 스킬의 단계 진입/전환 조건과 산출 디렉터리 계약을 확인할 때
- `references/experience.md`
  - P0 우선 실행, 실패 재현 기록, 결함 환류 패턴을 참고할 때

## 작동 방식

### 1단계. 실행 범위 확인
- 대상 US 확인
- P0/P1/P2 실행 순서 확정

### 2단계. 테스트 구현
- 설계된 케이스를 테스트 코드로 변환
- 테스트 데이터/픽스처 구성

### 3단계. 테스트 실행
- P0 -> P1 -> P2 순서로 실행
- 실패 로그/재현 절차 수집

### 4단계. 실패 분석/결함 기록
- 실패 원인 분류(코드/설계/환경/데이터)
- 결함 항목과 영향 범위 기록

### 5단계. 재검증 및 문서화
- 수정 후 재실행 결과 기록
- 테스트 통과율/잔여 리스크 업데이트

### 6단계. 순차 루프 라우팅 확정
- 현재 US 테스트 결과를 기준으로 상태 갱신 경로를 결정:
  - PASS(완료): `/monitor-sprint`로 상태 반영 후 다음 US의 `/design-implementation`으로 이동
  - FAIL(미완료): 동일 US의 `/execute-implementation` 또는 `/design-test`로 되돌림
- 다음 단계 판단 근거를 실행 결과 문서에 기록

## 안티패턴
- P0보다 P2를 먼저 실행
- 실패 로그 없이 “실패”만 기록
- 결함을 구현/설계로 피드백하지 않음

## 완료 조건
- `.agile/sprints/sprint-N/2-delivery/execute-test-us-N.M.md` 작성 완료
- P0 실행 결과 기록 완료
- 실패 항목 원인/재현/조치 기록 완료
- 재검증 결과 반영 완료
- 다음 단계 라우팅(`/monitor-sprint` 또는 동일 US 재진입) 기록 완료

## 다음 단계
- 다음 적용 스킬은 `docs/skill-ops/framework-applied-skills.md`의 `단계별 적용 순서`를 참조해 결정한다.
