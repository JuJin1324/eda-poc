---
name: design-test
description: "구현 설계/구현 실행 결과를 바탕으로 테스트 구현 설계를 수행하는 메인 스킬. 테스트 전략, 엣지 케이스, 우선순위, 데이터/환경을 정의한다."
---

# Design Test

## 목적
구현 결과를 검증하기 위한 테스트 설계를 US 단위로 작성한다.

## 적용 원칙
- Core: `docs/skill-ops/principles.md`의 `Core (공통 강제)` 적용
- Modules: `M-PIPELINE-CONTRACT`, `M-WIP-ONE-US`, `M-REUSE-FIRST`

핵심 원칙:
- 테스트는 사후 확인이 아니라 별도 설계 대상이다.
- 기본 실행 단위는 US 1개이며, 동일 US의 구현 결과를 즉시 검증하도록 설계한다.
- 엣지 케이스는 여기에서 정의한다.
- 우선순위(P0/P1/P2)로 범위를 통제한다.
- 테스트 도구/유틸은 `기존 테스트 스택 -> 검증된 라이브러리 -> 직접 구현` 순서로 선택한다.
- 단계 게이트/라우팅/산출 디렉터리 계약은 `docs/skill-ops/framework.md`를 우선 준수한다.
- 브랜치 생성/전환은 `define-2w` 책임이며, 본 스킬은 스프린트-브랜치 정합성만 검증한다.
- 설계 완료 후 테스트 구현(`execute-test`) 착수 전 개인 숙고(예: 짧은 산책/메모 정리) 또는 동료 설계 검토 시간을 가진다.

## 이 스킬이 메인으로 담당하는 것
- 테스트 대상/범위 정의
- 기능/실패/엣지 케이스 설계
- 테스트 유형별 전략(단위/통합/E2E) 정의
- 테스트 데이터/환경/도구 정의
- 테스트 실행 스킬로 전달 가능한 설계 산출물 생성

## 입력
- `.agile/sprints/sprint-N/2-delivery/design-implementation.md`
- `.agile/sprints/sprint-N/2-delivery/execute-implementation-us-N.M-step-*.md` (권장, 스텝 리뷰 문서)
- `.agile/sprints/sprint-N/2-delivery/execute-implementation-us-N.M.md` (호환용 legacy 문서, 존재 시만)
- `.agile/context/tech-stack.md` (테스트 스택/방법론 우선 참조)
- `.agile/sprints/sprint-N/2-delivery/sprint-status.md` (있으면 진행 상태 우선 참조)

## 출력물
- `.agile/sprints/sprint-N/2-delivery/design-test-us-N.M.md`

템플릿:
- `templates/design-test-us.md`

참고 문서:
- `docs/skill-ops/framework.md`
  - 본 스킬의 단계 진입/전환 조건과 산출 디렉터리 계약을 확인할 때
- `references/test-strategy-guidelines.md`
- `references/experience.md`
  - 정상/실패/엣지 케이스 누락 방지와 우선순위 설계 패턴을 확인할 때

## 작동 방식

### 1단계. 대상 US/기능 확인
- 현재 브랜치가 대상 `sprint-N`과 불일치하면 `HOLD`로 중단하고 `define-2w` 브랜치 게이트로 회귀한다.
- 테스트 대상 US 1개 선택
- 구현 완료된 기능 목록 확인
- `tech-stack.md`의 테스트 스택/방법론 확인

### 2단계. 테스트 경계 정의
- In Scope / Out of Scope 확정
- 테스트 제외 항목 명시

### 3단계. 케이스 설계
- 정상 시나리오
- 실패 시나리오
- 엣지 케이스
- 방법론 규칙 적용:
  - BDD면 Given-When-Then 형식 사용
  - TDD/ATDD면 팀 규칙 형식 사용

### 4단계. 우선순위 분류
- P0: 핵심 비즈니스 규칙/치명 실패
- P1: 중요 플로우/주요 경계값
- P2: 보조 시나리오/회귀 보강

### 5단계. 테스트 전략/환경 정의
- 단위/통합/E2E 중 적용 범위 결정
- 테스트 데이터/픽스처 정의
- 실행 환경(로컬/CI) 정의
- 재사용 우선 검토:
  - 1순위: 현재 프로젝트/테스트 스택에서 이미 제공하는 기능(테스트 프레임워크, assertion, fixture 유틸)
  - 2순위: 공식 생태계의 검증된 테스트 라이브러리
  - 3순위: 직접 구현(예외)
- 직접 구현은 재사용 대안 부재 또는 핵심 요구 미충족이 증적으로 확인될 때만 허용하고 사유를 문서에 기록한다.

### 6단계. 실행 전달 정보 확정
- 테스트 실행 순서
- 통과 기준
- 실패 시 트리아지 규칙
- 다음 단계 라우팅:
  - 기본: 동일 US로 `/execute-test` 이동
  - 예외: 구현 증적 부족 시 동일 US `/execute-implementation`으로 피드백

### 7단계. 설계 숙성 게이트
- `execute-test`로 넘어가기 전에 아래 중 최소 1개를 수행한다:
  - 개인 숙고: 짧은 산책/메모 정리로 케이스 누락/우선순위/가정 점검
  - 동료 검토: 동료와 테스트 전략/결함 검출력/트리아지 기준 점검
- 숙성 게이트 결과(`GO/HOLD`, 핵심 코멘트 1~3개)를 설계 문서 또는 연계 문서에 기록한다.

## 안티패턴
- 엣지 케이스를 구현 설계 단계로 밀어넣음
- 우선순위 없이 테스트를 나열
- 환경/데이터 없이 케이스만 작성
- 기존 테스트 스택으로 가능한 검증을 커스텀 테스트 유틸/프레임워크로 먼저 대체하는 방식
- 브랜치 불일치 상태를 무시하고 테스트 설계를 진행함
- 설계 직후 숙성 게이트 없이 `execute-test`로 즉시 전환함

## 완료 조건
- `.agile/sprints/sprint-N/2-delivery/design-test-us-N.M.md` 작성 완료
- 정상/실패/엣지 케이스 포함
- P0/P1/P2 우선순위 포함
- 테스트 데이터/환경/통과 기준 포함
- 재사용 우선 검토 결과(채택/제외/직접 구현 예외 사유) 기록 완료
- 동일 US 기준 다음 단계(`/execute-test`) 착수 정보 기록 완료
- 스프린트-브랜치 정합성 확인 완료 (불일치 시 `HOLD` 기록)
- 설계 숙성 게이트 수행 및 결과(`GO/HOLD`) 기록 완료

## 다음 단계
- `execute-test` 착수 전 설계 숙성 게이트를 먼저 통과한다.
- 다음 적용 스킬은 `docs/skill-ops/framework-applied-skills.md`의 `단계별 적용 순서`를 참조해 결정한다.
