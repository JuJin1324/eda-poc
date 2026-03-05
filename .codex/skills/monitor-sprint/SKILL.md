---
name: monitor-sprint
description: "Sprint 상태 문서를 생성/갱신하고, 고정 대시보드 포맷으로 진행률/리스크를 시각화하는 운영 스킬."
---

# Monitor Sprint

## 목적
`1-direction/` 산출물을 기준으로 Sprint 상태를 운영한다.

## 적용 원칙
- Core: `docs/skill-ops/principles.md`의 `Core (공통 강제)` 적용
- Modules: `M-PIPELINE-CONTRACT`, `M-SCHEDULE-VISIBILITY`, `M-REPLAN-TRIGGER`

핵심 원칙:
- 상태 문서(`sprint-status.md`)가 Delivery 단계 진행의 단일 소스다.
- 상태 문서가 없으면 monitor-sprint가 자동으로 초기 생성한다.
- 본 스킬은 상태/리스크/재평가에 집중하고, 회고/학습은 `review-sprint`가 담당한다.
- 상태 문서 생성/보정/존재 여부는 내부 처리하며, 사용자 응답에는 현재 Sprint 상태만 표시한다. (복구 불가 오류는 예외)
- 단계 게이트/라우팅/산출 디렉터리 계약은 `docs/skill-ops/framework.md`를 우선 준수한다.
- 브랜치 생성/전환은 `define-2w` 책임이며, 본 스킬은 스프린트-브랜치 정합성만 검증한다.

## 이 스킬이 메인으로 담당하는 것
- Sprint 상태 문서 초기 생성 (bootstrap)
- Sprint 상태 시각화 (US 상태 + 일정 상태)
- 리스크/블로커 추적
- Delivery 단계 재평가 및 다음 적용 스킬 라우팅

## 입력
- `.agile/sprints/sprint-N/1-direction/` (필수)
- `.agile/sprints/sprint-N/2-delivery/sprint-status.md` (선택: 없으면 생성)

## 출력물
- `.agile/sprints/sprint-N/2-delivery/sprint-status.md`

템플릿:
- `templates/sprint-status.md`

참고 문서:
- `docs/skill-ops/framework.md`
  - 본 스킬의 단계 진입/전환 조건과 산출 디렉터리 계약을 확인할 때
- `docs/skill-ops/framework-applied-skills.md`
  - 적용 순서 기반으로 다음 스킬을 결정할 때
- `references/experience.md`
  - 상태 초기화/리스크 추적 패턴을 재사용할 때

## 작동 방식

### 1단계. 최신 sprint 확인
- `.agile/sprints/`에서 최신 `sprint-N` 확인
- `1-direction/` 디렉터리 존재 및 비어있지 않음 확인
- 현재 브랜치가 대상 `sprint-N`과 불일치하면 `HOLD`로 중단하고 `define-2w` 브랜치 게이트로 회귀한다.

### 2단계. 상태 문서 bootstrap
- `2-delivery/sprint-status.md`가 없으면 자동 생성
- 생성 규칙:
  - Sprint Goal: `1-direction/` 산출물의 Sprint Goal 사용
  - US 목록: `1-direction/` 산출물의 US 계획에서 이번 Sprint 포함 항목 추출
  - 초기 상태: 모든 US를 `Todo`로 시작
  - 진행률: `0% (완료 0/N US)`
  - Risks: 방향 문서의 미확정/리스크를 초기 리스크로 반영
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
  - `sprint-N`, 기준일, Sprint Goal, 현재 상태(Ahead/On-track/Delayed), 남은 기간
  - 10칸 진행률 바 + 퍼센트 + 완료 US 수
  - US 상태 집계(`Todo / In-Progress / Done`)
- 진행률 계산:
  - 우선 `전체 진행률` 값 사용
  - 없으면 `(Done US 수 / 전체 US 수) * 100`

#### 3-2. US Board
- `US Progress` 표를 기준으로 아래 열을 표 형태로 출력한다:
  - US ID
  - 상태
  - 완료 목표일
  - 일정 상태
  - 다음 권장 스킬
  - 다음 액션
- 일정 상태 규칙:
  - US별 `완료 목표일`이 있으면 `Ahead/On-track/Delayed` 계산
  - 완료 목표일이 없으면 Sprint의 `현재 상태`를 기본값으로 사용

#### 3-3. Risk Radar
- `Risks / Blockers`를 리스크/블로커 개수와 함께 표시한다.
- 블로커가 1개 이상이면 최상단에 경고를 표시한다.

#### 3-4. Skill Routing (적용 순서 참조)
- 상태와 산출물 존재 여부를 기준으로 다음 적용 스킬 후보를 정리한다.
- 최종 라우팅은 `docs/skill-ops/framework-applied-skills.md`의 `단계별 적용 순서`를 참조해 결정한다.

### 4단계. 상태 갱신 규칙
- US 착수: `Todo -> In-Progress`
- US 완료: `In-Progress -> Done`
- 리스크/블로커는 `sprint-status.md`의 `Risks / Blockers` 섹션에서만 관리

### 5단계. 재평가 규칙
- `Replan Needed`가 `Yes`이면 현재 Sprint의 우선순위/범위를 재정렬한다.
- 재정렬 결과는 `2-delivery/` 산출물에 즉시 반영한다.
- 회고/학습 문서 생성은 본 스킬 범위에서 제외하며 `review-sprint`에서 수행한다.

## 안티패턴
- 상태 문서 없이 진행 상황을 구두/채팅으로만 관리
- 대시보드 없이 한두 줄 텍스트 요약만 출력
- 내부 처리 정보(bootstrap 여부, 파일 생성 여부)를 사용자 상태 리포트에 노출
- 상태 문서와 리스크 기록을 분리해 단일 소스가 깨짐
- 회고 작업을 본 스킬에서 수행해 Learning 단계 책임이 섞임
- 브랜치 불일치 상태를 무시하고 상태 갱신을 진행함

## 완료 조건
- `sprint-status.md`가 존재하고 최신 상태 반영 완료
- 대시보드 4섹션(Sprint Dashboard/US Board/Risk Radar/Skill Routing) 출력 완료
- 다음 적용 스킬/종료 경로가 `docs/skill-ops/framework-applied-skills.md` 기준으로 확정
- 스프린트-브랜치 정합성 확인 완료 (불일치 시 `HOLD` 기록)

## 다음 단계
- 다음 적용 스킬은 `docs/skill-ops/framework-applied-skills.md`의 `단계별 적용 순서`를 참조해 결정한다.
