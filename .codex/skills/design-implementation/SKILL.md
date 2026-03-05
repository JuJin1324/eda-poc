---
name: design-implementation
description: "프로젝트 진행 단계에서 구현 설계를 수행하는 메인 스킬. 비즈니스 흐름을 우선 설계하고, 기술 흐름 다이어그램 세트를 필요 수만큼 구성해 구현 리스크를 줄인다."
---

# Design Implementation

## 목적
`.agile/sprints/sprint-N/1-direction/design-phase.md`에서 정의된 US를 실제 구현 가능한 상세 설계로 변환한다.

## 적용 원칙
- Core: `docs/skill-ops/principles.md`의 `Core (공통 강제)` 적용
- Modules: `M-PIPELINE-CONTRACT`, `M-WIP-ONE-US`

핵심 원칙:
- 바퀴를 새로 만들지 않는다: 기술 스택 결정 전 웹 검색으로 재사용 가능한 라이브러리/서비스를 먼저 검토한다.
- 구현 전에 설계 증적을 남긴다.
- 비즈니스 흐름(고객 가치/업무 상태/완료 조건/실패 정책)을 기술 흐름보다 먼저 설계한다.
- 다이어그램은 타입별 1개로 제한하지 않고, 의사결정과 구현 전달에 필요한 수만큼 작성한다.
- 동일 문제 축을 유지하는 비교형 PoC는 `sprint-0`의 기준 다이어그램(C4 + 동기/비동기 흐름)을 우선 재사용하고 US별 변경점만 델타로 기록한다.
- C4 Container는 외부 의존성이 복잡할 때만 선택적으로 작성한다.
- 기능 정리와 ADR을 함께 기록한다.
- US 단위로 설계를 분리해 변경 비용을 줄인다.
- 반복 구조(예: sync 3개/async 3개)는 대표 1개 설계 후 리뷰 게이트를 통과한 뒤 나머지를 동일 패턴으로 확장한다.
- 기본 실행 단위는 US 1개로 고정하고, `설계 -> 구현 -> 테스트 -> 상태갱신` 루프를 순차 반복한다.
- US 2개 동시 설계는 상호 독립성이 높고 사용자가 명시적으로 요청한 경우에만 예외로 허용한다.
- 단계 게이트/라우팅/산출 디렉터리 계약은 `docs/skill-ops/framework.md`를 우선 준수한다.
- 브랜치 생성/전환은 `define-2w` 책임이며, 본 스킬은 스프린트-브랜치 정합성만 검증한다.

## 이 스킬이 메인으로 담당하는 것
- 구현 대상 기능 목록 정리
- US별 구현 Step 작성
- 구현 범위/경계 명확화
- 비즈니스 흐름 다이어그램 작성 (필수, 1개 이상)
- 기술 흐름 다이어그램 작성 (선택, 0개 이상: C4/Sequence/Flowchart 다중 작성 가능)
- ADR 정리
- 구현 실행 스킬로 전달 가능한 설계 산출물 생성

## 입력
- `.agile/sprints/sprint-N/1-direction/design-phase.md`
- `.agile/sprints/sprint-N/2-delivery/sprint-status.md` (있으면 진행 상태 우선 참조)
- `.agile/context/tech-stack.md` (있다면 우선 사용)

## 출력물
- `.agile/sprints/sprint-N/2-delivery/design-implementation.md`
- `.agile/context/tech-stack.md` (없으면 생성)

템플릿:
- `templates/design-implementation-vN.md`
- `templates/tech-stack.md`

참고 문서:
- `docs/skill-ops/framework.md`
  - 본 스킬의 단계 진입/전환 조건과 산출 디렉터리 계약을 확인할 때
- `references/diagram-guidelines.md`
- `references/experience.md`
  - 스택 선택, 다이어그램 게이트, 인터페이스 정리에서 유효했던 패턴을 참고할 때

## 작동 방식

### 1단계. 기술 스택 확인
- 현재 브랜치가 대상 `sprint-N`과 불일치하면 `HOLD`로 중단하고 `define-2w` 브랜치 게이트로 회귀한다.
- `.agile/context/tech-stack.md` 존재 여부 확인
- 파일이 있으면: "기존 기술 스택 문서를 그대로 사용할지" 사용자에게 확인
- 파일이 없으면: 사용자에게 기술 스택 입력을 받고 `templates/tech-stack.md` 형식으로 저장
- 저장 경로: `.agile/context/tech-stack.md`
- 확정된 스택을 `.agile/sprints/sprint-N/2-delivery/design-implementation.md`에 링크

### 2단계. 라이브러리/서비스 후보 웹 검색
- 구현 목적에 맞는 라이브러리/서비스 후보를 웹 검색으로 수집
- `tech-stack.md`를 사용하기로 했다면 해당 문서 내용을 기준으로 검색 키워드를 구성
- 수집 후보 중 재사용 가능한 옵션 우선 검토
- 신규 후보가 있으면 `tech-stack.md`에 추가할지 사용자에게 확인 후 반영

기술 스택 입력 수집 항목:
- 언어/런타임 버전
- 서버/클라이언트 프레임워크
- DB/캐시/메시징
- 인프라/배포/CI
- 테스트 스택

### 3단계. 대상 US/기능 정리
- 이번 실행에서 구현 설계할 US를 기본 1개 선택
- US 2개 동시 설계는 아래 조건을 모두 만족할 때만 선택:
  - 두 US 사이 선행 의존성이 없음
  - 실패/지연 영향이 서로 전파되지 않음
  - 사용자가 동시 설계를 명시적으로 요청함
- US별 기능 목록을 정리
- US별 설계 범위를 명시
- US별 구현 Step을 2~5개로 작성
- 반복 서비스군이 있으면 구현 Step에 아래 순서를 반드시 포함:
  - `sync 대표 서비스 1개 설계 -> 리뷰 게이트 -> sync 나머지 자동 확장`
  - `async 대표 서비스 1개 설계 -> 리뷰 게이트 -> async 나머지 자동 확장`

### 3-1단계. 순차 루프 계획 명시
- 선택한 US에 대해 아래 루프 순서를 문서에 명시:
  - `design-implementation -> execute-implementation -> design-test -> execute-test -> monitor-sprint`
- 여러 US가 있으면 루프를 US별로 순차 반복하도록 다음 액션에 기록

### 4단계. 구현 경계 정의
- In Scope / Out of Scope 확정
- 인터페이스 세부는 다이어그램 이후 별도 정리

### 5단계. 비즈니스 흐름 다이어그램 작성 (필수)
- 최소 1개 이상 작성
- 고객/운영 관점의 actor, 비즈니스 상태 전이, 완료 조건, 실패 시 처리 정책을 포함
- 동기/비동기 비교가 핵심인 US는 `Before(동기)`/`After(비동기)` 흐름을 우선 작성
- 비교형 PoC이고 `sprint-0` 기준본이 있으면 동일 맥락 구간은 재사용하고 현재 US 변경점만 주석/메모로 반영

### 6단계. 기술 흐름 다이어그램 작성 (선택, 다중 허용)
- 구현 리스크(시스템 경계/호출 순서/운영 절차)에 맞춰 C4/Sequence/Flowchart를 0개 이상 작성
- 동일 타입 다이어그램도 시나리오별로 여러 개 작성 가능
- 다이어그램마다 목적(왜 필요한지) 1줄 기록
- C4 Container는 외부 의존성이 복잡할 때 우선 고려

### 7단계. 인터페이스 정의
- 입력/출력/이벤트를 다이어그램 기준으로 정리

### 8단계. ADR 정리
- 핵심 기술/구조 결정의 선택 이유와 트레이드오프 기록
- ADR 항목을 구현 설계 문서에 요약

### 9단계. 구현 전달 정보 확정
- 구현 우선순위
- 테스트 포인트
- 리스크 및 완화 전략

## 안티패턴
- 라이브러리/서비스 탐색 없이 직접 구현부터 시작
- 코드 작성 후 다이어그램을 사후 생성
- 비즈니스 흐름 없이 기술 다이어그램만 작성
- 다이어그램 타입별로 1개만 강제해 핵심 시나리오를 누락
- 반복 서비스군을 처음부터 전체 구현 기준으로 설계해 리뷰/피드백 반영 비용을 키우는 방식
- 실패 흐름을 생략
- ADR 없이 의사결정 근거를 구두로만 남김
- 기술 스택 합의 없이 구현 설계를 진행
- 선행 의존성이 있는 US 2개를 한 번에 설계해 WIP를 키움
- 브랜치 불일치 상태를 무시하고 설계를 진행함

## 완료 조건
- `tech-stack.md` 확인/확정 완료
- 파일이 없던 경우 사용자 입력 기반으로 `tech-stack.md` 생성/저장 완료
- 웹 검색 신규 후보가 있던 경우 `tech-stack.md` 반영 여부 확인/기록 완료
- `.agile/sprints/sprint-N/2-delivery/design-implementation.md` 작성 완료
- 대상 US 수(기본 1개)와 선택 근거 기록 완료
- US 2개 동시 설계 시 예외 조건 충족 근거 기록 완료
- 기능 목록 정리 완료
- 반복 구조가 있으면 `대표 1개 -> 리뷰 게이트 -> 확장` 순서가 구현 전달 정보에 포함되어야 함
- 비즈니스 흐름 다이어그램 1개 이상 포함
- 기술 흐름 다이어그램 작성/생략 근거 기록 완료
- C4 Container를 작성했다면 책임/경계가 명확해야 함
- 비교형 PoC에서 `sprint-0` 기준 다이어그램을 재사용했다면 출처/변경점 기록 완료
- ADR 요약 기록 완료
- US별 구현 경계와 테스트 포인트 명시
- 다음 단계 루프(`execute-implementation -> design-test -> execute-test -> monitor-sprint`)가 US 기준으로 연결되어야 함
- `execute-implementation`이 바로 착수 가능한 전달 정보 포함
- 스프린트-브랜치 정합성 확인 완료 (불일치 시 `HOLD` 기록)

## 다음 단계
- 다음 적용 스킬은 `docs/skill-ops/framework-applied-skills.md`의 `단계별 적용 순서`를 참조해 결정한다.
