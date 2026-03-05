---
name: execute-implementation
description: "구현 설계를 바탕으로 실제 코드를 작성하고 검증하는 메인 스킬. US를 마이크로 스텝으로 분해하고 스텝마다 사용자 리뷰 대기로 진행하며 코드-요구사항 관계/의도를 문서화한다."
---

# Execute Implementation

## 목적
`.agile/sprints/sprint-N/2-delivery/design-implementation.md`를 바탕으로 코드를 구현하고 검증한다.

## 적용 원칙
- Core: `docs/skill-ops/principles.md`의 `Core (공통 강제)` 적용
- Modules: `M-PIPELINE-CONTRACT`, `M-WIP-ONE-US`, `M-STEP-REVIEW-GATE`, `M-REUSE-FIRST`

핵심 원칙:
- US 단위로 구현을 진행하고, 필요 시 Step 상세를 보강한다.
- 기본 실행 단위는 US 1개이며, 병렬 구현으로 WIP를 늘리지 않는다.
- 구현 Step은 마이크로 스텝(한 번에 한 변경축)으로 분해해 순차 진행한다.
- 구현 전 `기존 제공 기능 -> 검증된 라이브러리/프레임워크 -> 직접 구현` 순서로 검토한다.
- 마이크로 스텝 1개 구현/검증 후 반드시 사용자 리뷰를 받고 다음 스텝으로 진행한다.
- 리뷰 문서는 US 통합본이 아니라 마이크로 스텝별 개별 파일로 기록한다.
- 구현 완료 후 동일 US의 테스트 설계/실행으로 즉시 연결한다.
- 코드 스타일 컨벤션을 강제 적용한다.
- 구현 증적(테스트/결과)을 남긴다.
- 코드와 US/Step의 연결관계를 명시해 인지부하를 줄인다.
- 단계 게이트/라우팅/산출 디렉터리 계약은 `docs/skill-ops/framework.md`를 우선 준수한다.
- 브랜치 생성/전환은 `define-2w` 책임이며, 본 스킬은 스프린트-브랜치 정합성만 검증한다.

## 이 스킬이 메인으로 담당하는 것
- 구현 태스크 분해 및 우선순위 실행
- 코드 작성/리팩터링
- 테스트 및 검증
- 컨벤션 준수 점검
- 구현 결과 기록

## 입력
- `.agile/sprints/sprint-N/2-delivery/design-implementation.md`
- `.agile/sprints/sprint-N/2-delivery/sprint-status.md`

## 출력물
- 코드 변경사항
- `.agile/sprints/sprint-N/2-delivery/execute-implementation-us-N.M-step-x.x.x-a.md` (마이크로 스텝별 1개)

템플릿:
- `templates/execute-implementation-vN.md`

참고 문서:
- `docs/skill-ops/framework.md`
  - 본 스킬의 단계 진입/전환 조건과 산출 디렉터리 계약을 확인할 때
- `references/code-style-conventions.md`
- `references/ddd-java.md` (Java 구현 시)
- `references/ddd-kotlin.md` (Kotlin 구현 시)
- `references/experience.md`
  - 코드-요구사항 매핑, 테스트 순서, 컨벤션 점검에서 재사용 패턴을 참고할 때

## 작동 방식

### 1단계. 구현 범위 확인
- 현재 브랜치가 대상 `sprint-N`과 불일치하면 `HOLD`로 중단하고 `define-2w` 브랜치 게이트로 회귀한다.
- 대상 US를 1개 선택
- 필요 시 Step 상세 범위를 선택적으로 지정
- 완료 기준(DoD) 확인

### 2단계. 구현 계획 작성
- 변경 파일 목록 예측
- 테스트 방법(단위/통합) 확정
- 언어가 Java면 `references/ddd-java.md`, Kotlin이면 `references/ddd-kotlin.md`를 참조
- 재사용 가능 요소(기존 모듈/유틸/프레임워크 기능) 후보를 먼저 확인하고 채택 여부를 정한다.
- 구현 Step을 마이크로 스텝으로 쪼갠다. (예: `1.1.1-a`, `1.1.1-b`)
- 마이크로 스텝별 완료 기준(검증 명령 1개 이상)을 함께 정의한다.
- 마이크로 스텝별 리뷰 게이트 체크리스트(코드/테스트/컨벤션)를 정의한다.
- 직접 구현이 필요한 경우 예외 사유(요구 미충족/라이선스/보안/운영 제약)를 스텝 문서에 기록한다.

### 3단계. 코드 구현
- 마이크로 스텝 1개씩 구현 후 검증하고 다음 스텝으로 이동
- 각 마이크로 스텝 완료 시 사용자 리뷰 요청 상태로 전환한다.
- 사용자 승인 후 다음 마이크로 스텝으로 진행한다.
- 설계 문서와 불일치 시 이유 기록

### 4단계. 컨벤션 점검
- `references/code-style-conventions.md` 체크리스트 기반 점검

### 5단계. 테스트/검증
- 관련 테스트 실행
- 실패 시 원인/수정 기록

### 6단계. 실행 결과 문서화
- 마이크로 스텝 완료마다 `.agile/sprints/sprint-N/2-delivery/execute-implementation-us-N.M-step-x.x.x-a.md` 생성/갱신
- 간소 템플릿(`templates/execute-implementation-vN.md`)으로 이번 스텝 범위만 기록
- 코드 변경사항과 US/Step 관계를 최소 매핑으로 기록
- 검증 명령/결과, 리뷰 요청 상태(Pending/Approved/Needs changes)를 기록
- 다음 단계 라우팅을 기록:
  - 기본: 동일 US로 `/design-test` 이동
  - 예외: 구현 미완료/결함 잔존 시 동일 US 구현을 보강

## 안티패턴
- 설계 문서 없이 바로 코드 작성
- 테스트 생략
- 컨벤션 위반을 임시로 방치
- 기존 프레임워크/기존 모듈로 해결 가능한 기능을 커스텀 구현으로 먼저 작성하는 방식
- 큰 변경을 한 번에 반영
- `Gradle 설정 + Compose + 서비스 로직`을 한 스텝으로 묶어 추적성을 잃는 방식
- 사용자 리뷰 없이 여러 마이크로 스텝을 연속으로 진행하는 방식
- 브랜치 불일치 상태를 무시하고 구현을 진행하는 방식

## 완료 조건
- 대상 US 구현 완료
- 테스트/검증 결과 기록 완료
- 컨벤션 체크리스트 확인 완료
- 마이크로 스텝별 문서(`execute-implementation-us-N.M-step-*.md`) 작성 완료
- 마이크로 스텝별 리뷰 게이트(요청/승인/보완) 이력 기록 완료
- 재사용 우선 검토 결과(채택/제외/직접 구현 예외 사유) 기록 완료
- 코드-요구사항 매핑 및 구현 의도 기록 완료
- 동일 US 기준 다음 단계(`/design-test`) 착수 정보 기록 완료
- 스프린트-브랜치 정합성 확인 완료 (불일치 시 `HOLD` 기록)

## 다음 단계
- 다음 적용 스킬은 `docs/skill-ops/framework-applied-skills.md`의 `단계별 적용 순서`를 참조해 결정한다.
