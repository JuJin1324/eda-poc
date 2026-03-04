---
name: monitor-sprint
description: "Sprint 상태 문서를 생성/갱신하고, 고정 대시보드 포맷으로 진행률/리스크를 시각화하며, 종료 시 회고 문서를 생성하는 운영 스킬."
---

# Monitor Sprint

## 목적
`02-design-phase.md`를 기준으로 Sprint 상태를 운영한다.

핵심 원칙:
- 상태 문서(`02-sprint-status.md`)가 Sprint 진행의 단일 소스다.
- 상태 문서가 없으면 monitor-sprint가 자동으로 초기 생성한다.
- 구현 Step 상세는 `design-implementation` 책임이며, monitor-sprint는 상태/리스크/회고 운영에 집중한다.
- 상태 문서 생성/보정/존재 여부는 내부 처리하며, 사용자 응답에는 현재 Sprint 상태만 표시한다. (복구 불가 오류는 예외)

## 이 스킬이 메인으로 담당하는 것
- Sprint 상태 문서 초기 생성 (bootstrap)
- Sprint 상태 시각화 (US 상태 + 일정 상태)
- 리스크/블로커 추적
- US 회고 / Sprint 회고 문서 생성

## 입력
- `.agile/loops/loop-vN/02-design-phase.md`
- `.agile/loops/loop-vN/sprint/02-sprint-status.md` (선택: 없으면 생성)

## 출력물
- `.agile/loops/loop-vN/sprint/02-sprint-status.md`
- `.agile/loops/loop-vN/sprint/03-us-N.M-retrospective.md` (US 완료 시)
- `.agile/loops/loop-vN/sprint/04-sprint-retrospective.md` (Sprint 종료 시)

템플릿:
- `templates/sprint-status.md`
- `templates/us-retrospective.md`
- `templates/sprint-retrospective-vN.md`

참고 문서:
- `references/experience.md`
  - 상태 초기화/리스크 추적/회고 생성 패턴을 재사용할 때

## 작동 방식

### 1단계. 최신 loop 확인
- `.agile/loops/`에서 최신 `loop-vN` 확인
- `02-design-phase.md` 존재 확인

### 2단계. Sprint 상태 문서 bootstrap
- `sprint/02-sprint-status.md`가 없으면 자동 생성
- 생성 규칙:
  - Sprint Goal: `02-design-phase.md`의 Sprint Goal 사용
  - US 목록: `US 계획` 표에서 `이번 스프린트 포함(Y)` 항목만 추출
  - 초기 상태: 모든 US를 `Todo`로 시작
  - 진행률: `0% (완료 0/N US)`
  - Risks: design-phase의 미확정/리스크를 초기 리스크로 반영
- 이 단계의 처리 여부(없어서 생성했는지 등)는 사용자 응답에 노출하지 않는다.

### 3단계. 상태 시각화
- monitor-sprint 실행 응답은 아래 4개 섹션을 항상 포함한다:
  1. Sprint Dashboard
  2. US Board
  3. Risk Radar
  4. Skill Routing
- 사용자 응답은 상태 대시보드에 집중하며, 파일 생성/존재/갱신 같은 내부 메타데이터는 포함하지 않는다.

#### 3-1. Sprint Dashboard
- 출력 항목:
  - `loop-vN`, 기준일, Sprint Goal, 현재 상태(Ahead/On-track/Delayed), 남은 기간
  - 10칸 진행률 바 + 퍼센트 + 완료 US 수
  - US 상태 집계(`Todo / In-Progress / Done`)
- 진행률 계산:
  - 우선 `전체 진행률` 값 사용
  - 없으면 `(Done US 수 / 전체 US 수) * 100`

#### 3-2. US Board
- `US Progress` 표를 기준으로 아래 열을 표 형태로 출력한다:
  - US ID
  - 상태
  - 일정 상태
  - 다음 권장 스킬
  - 다음 액션
- 일정 상태 규칙:
  - US별 `완료 목표일`이 있으면 `Ahead/On-track/Delayed` 계산
  - 완료 목표일이 없으면 Sprint의 `현재 상태`를 기본값으로 사용

#### 3-3. Risk Radar
- `Risks / Blockers`를 리스크/블로커 개수와 함께 표시한다.
- 블로커가 1개 이상이면 최상단에 경고를 표시한다.

#### 3-4. Skill Routing (현재 스킬 체계 기준)
- 상태와 산출물 존재 여부를 기준으로 다음 스킬을 추천한다:
  - `Todo` US 존재: `/design-implementation`
  - `In-Progress` US 존재: `/execute-implementation`
  - `04-execute-implementation-us-N.M.md`는 있고 `05-design-test-us-N.M.md`가 없으면: `/design-test`
  - `05-design-test-us-N.M.md`는 있고 `06-execute-test-us-N.M.md`가 없으면: `/execute-test`
  - 모든 US `Done`: US/Sprint 회고 생성 후 `/define-2w` 또는 `/design-phase`

### 4단계. 상태 갱신 규칙
- US 착수: `Todo -> In-Progress`
- US 완료: `In-Progress -> Done`
- 리스크/블로커는 `02-sprint-status.md`의 `Risks / Blockers` 섹션에서만 관리

### 5단계. 회고 문서 생성
- US가 완료되면 `03-us-N.M-retrospective.md` 생성
- Sprint 종료 시 `04-sprint-retrospective.md` 생성
- Sprint 회고에는 반드시 아래 5개 포함:
  1. 검증된 가정(True)
  2. 반박된 가정(False)
  3. 새로 생긴 Unknown
  4. 유지할 전략(Keep)
  5. 폐기할 전략(Drop)

## 안티패턴
- 상태 문서 없이 진행 상황을 구두/채팅으로만 관리
- 대시보드 없이 한두 줄 텍스트 요약만 출력
- 내부 처리 정보(bootstrap 여부, 파일 생성 여부)를 사용자 상태 리포트에 노출
- 상태 문서와 리스크 기록을 분리해 단일 소스가 깨짐
- 회고를 생략하고 다음 루프로 바로 이동

## 완료 조건
- `02-sprint-status.md`가 존재하고 최신 상태 반영 완료
- 대시보드 4섹션(Sprint Dashboard/US Board/Risk Radar/Skill Routing) 출력 완료
- 완료된 US마다 `03-us-N.M-retrospective.md` 생성 완료
- Sprint 종료 시 `04-sprint-retrospective.md` 생성 완료
- 다음 루프 진입 경로(`define-2w` 또는 `design-phase` 또는 종료) 확정

## 다음 단계
- 구현 설계/실행 중: `/design-implementation`, `/execute-implementation`, `/design-test`, `/execute-test`
- Sprint 종료 시: `/define-2w` 또는 `/design-phase`
