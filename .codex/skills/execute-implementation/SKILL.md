---
name: execute-implementation
description: "구현 설계를 바탕으로 실제 코드를 작성하고 검증하는 메인 스킬. 코드 스타일 컨벤션을 준수하며 US 단위로 구현하고 코드-요구사항 관계/의도를 문서화한다."
---

# Execute Implementation

## 목적
`.agile/loops/loop-vN/03-design-implementation.md`를 바탕으로 코드를 구현하고 검증한다.

핵심 원칙:
- US 단위로 구현을 진행하고, 필요 시 Step 상세를 보강한다.
- 코드 스타일 컨벤션을 강제 적용한다.
- 구현 증적(테스트/결과)을 남긴다.
- 코드와 US/Step의 연결관계를 명시해 인지부하를 줄인다.

## 이 스킬이 메인으로 담당하는 것
- 구현 태스크 분해 및 우선순위 실행
- 코드 작성/리팩터링
- 테스트 및 검증
- 컨벤션 준수 점검
- 구현 결과 기록

## 입력
- `.agile/loops/loop-vN/03-design-implementation.md`
- `.agile/loops/loop-vN/sprint/01-sprint-plan.md`

## 출력물
- 코드 변경사항
- `.agile/loops/loop-vN/04-execute-implementation-us-N.M.md`

템플릿:
- `templates/execute-implementation-vN.md`

참고 문서:
- `references/philosophy.md`
- `references/code-style-conventions.md`
- `references/ddd-java.md` (Java 구현 시)
- `references/ddd-kotlin.md` (Kotlin 구현 시)
- `references/experience.md`
  - 코드-요구사항 매핑, 테스트 순서, 컨벤션 점검에서 재사용 패턴을 참고할 때

## 작동 방식

### 1단계. 구현 범위 확인
- 대상 US를 1개 선택
- 필요 시 Step 상세 범위를 선택적으로 지정
- 완료 기준(DoD) 확인

### 2단계. 구현 계획 작성
- 변경 파일 목록 예측
- 테스트 방법(단위/통합) 확정
- 언어가 Java면 `references/ddd-java.md`, Kotlin이면 `references/ddd-kotlin.md`를 참조

### 3단계. 코드 구현
- 작은 단위로 구현
- 설계 문서와 불일치 시 이유 기록

### 4단계. 컨벤션 점검
- `references/code-style-conventions.md` 체크리스트 기반 점검

### 5단계. 테스트/검증
- 관련 테스트 실행
- 실패 시 원인/수정 기록

### 6단계. 실행 결과 문서화
- `.agile/loops/loop-vN/04-execute-implementation-us-N.M.md`에 결과, 증적, 남은 리스크 기록
- 코드 변경사항과 US/Step 관계를 매핑 표로 기록
- 핵심 구현 의도(왜 이렇게 구현했는지)를 설명

## 안티패턴
- 설계 문서 없이 바로 코드 작성
- 테스트 생략
- 컨벤션 위반을 임시로 방치
- 큰 변경을 한 번에 반영

## 완료 조건
- 대상 US 구현 완료
- 테스트/검증 결과 기록 완료
- 컨벤션 체크리스트 확인 완료
- `.agile/loops/loop-vN/04-execute-implementation-us-N.M.md` 작성 완료
- 코드-요구사항 매핑 및 구현 의도 설명 완료

## 다음 단계
- 필요 시 `/plan-sprint` 상태 업데이트
