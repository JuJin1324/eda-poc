---
name: payment-coding-challenge
description: "결제 도메인 코딩과제(토스페이먼츠 스타일)를 4시간 타임박스 내에 완료하는 전략 스킬. 요구사항 분석 → 기능구현 PR → 리팩토링 PR → README 순서로 진행한다."
allowed-tools: Read,Write,Edit,Glob,Grep,Bash
disable-model-invocation: false
user-invocable: true
---

# Payment Coding Challenge

## 목적

4시간 코딩과제(토스페이먼츠 스타일)를 **요구사항 이해 → 기능구현 → 리팩토링 → README** 순서로
체계적으로 완료한다.

**해결하는 문제:**
- ❌ 시간 내 요구사항 전부 구현 못 함 (범위 초과)
- ❌ 구현에 급급해 코드 품질 낮음
- ❌ README에 설계 의도 없음 → 심사자가 의도 파악 불가
- ❌ 테스트 없는 리팩토링 PR → 리팩토링 PR 의미 없음

**제공하는 가치:**
- ✅ 4시간 타임박스 분배 전략
- ✅ 기능구현 PR / 리팩토링 PR 명확한 목적 분리
- ✅ Kotlin + Spring Boot 빠른 구현 체크리스트
- ✅ README 작성 템플릿 (설계 의도 + 트레이드오프 중심)
- ✅ 테스트 우선순위 판단 기준

---

## 트리거 조건

다음 상황에서 이 스킬을 사용한다:
- 사전과제 파일/링크가 제공됨
- "코딩과제 시작", "사전과제", "payment challenge" 언급
- 4시간 제한 내 코딩과제 수행 요청

---

## Phase 0: 과제 수령 직후 (5분)

### 체크리스트
- [ ] 요구사항 문서 전체 읽기 (1회)
- [ ] 제공된 Kotlin 템플릿 구조 파악
- [ ] 제출 방법 확인 (PR URL? GitHub Fork?)
- [ ] 마감 시간 확인

### Claude 협업 프롬프트 예시
```
이 요구사항을 읽고:
1. 핵심 도메인 개념 3~5개를 추출해줘
2. 모호한 부분 2~3개를 지적해줘
3. 구현 범위에서 제외해도 되는 항목을 제안해줘
```

---

## Phase 1: 요구사항 분석 + 도메인 설계 (0~30분)

### 목표
- 요구사항 100% 이해
- 도메인 모델 설계 완료
- 테스트 케이스 목록 작성

### 체크리스트
- [ ] 요구사항 2회 이상 읽기 (두 번째에서 엣지케이스 발견)
- [ ] 핵심 도메인 개념 추출 (명사 → 도메인 객체)
- [ ] 비즈니스 규칙 목록 작성 (e.g., "잔액이 부족하면 결제 실패")
- [ ] 테스트 케이스 목록 (성공 케이스 + 실패 케이스)
- [ ] 구현 우선순위 결정 (Must Have / Nice to Have)

### 도메인 설계 가이드
```
1. 명사 추출: 요구사항에서 명사를 모두 추출
2. 관계 정의: 명사 간 관계 (1:N, N:M)
3. 상태 정의: 변화가 있는 도메인 객체의 상태 목록
4. 비즈니스 규칙: 불변식(Invariant) 정의
```

---

## Phase 2: 기능 구현 (30분~2시간30분, 2시간)

### 목표
- 모든 요구사항 충족
- 단위 테스트 통과
- 기능구현 PR 생성

### 구현 순서 (TDD)
```
1. 도메인 계층 (Entity, Value Object)
   - 도메인 로직 + 단위 테스트
2. 서비스 계층 (UseCase, Service)
   - 비즈니스 플로우 + 서비스 테스트
3. 인프라 계층 (Repository, Controller)
   - 통합 테스트 (최소한)
```

### Kotlin 빠른 구현 체크리스트

```kotlin
// ✅ data class 활용 (VO, DTO)
data class Money(val amount: BigDecimal, val currency: Currency) {
    operator fun plus(other: Money): Money { ... }
}

// ✅ sealed class 활용 (결과 타입)
sealed class PaymentResult {
    data class Success(val transactionId: String) : PaymentResult()
    data class Failure(val reason: String) : PaymentResult()
}

// ✅ companion object + factory method
class Payment private constructor(...) {
    companion object {
        fun create(...): Payment { ... }
    }
}

// ✅ extension function 활용
fun BigDecimal.isPositive(): Boolean = this > BigDecimal.ZERO

// ✅ require/check로 전제조건 표현
fun withdraw(amount: Money) {
    require(amount.isPositive()) { "출금 금액은 양수여야 합니다" }
    check(balance >= amount) { "잔액 부족" }
    ...
}
```

### 테스트 우선순위 판단 기준

| 우선순위 | 대상 | 이유 |
|---------|------|------|
| P0 (필수) | 도메인 비즈니스 규칙 | 핵심 가치 검증 |
| P0 (필수) | 실패 케이스 | 경계 조건 이해도 표시 |
| P1 (중요) | 서비스 플로우 | 요구사항 충족 확인 |
| P2 (선택) | 웹 계층 (Controller) | 4시간 내 시간 남을 경우 |

### 시간이 부족할 때 결정 기준
```
Q: 이 기능을 구현 안 하면 요구사항을 충족하지 못하는가?
  → YES: 반드시 구현
  → NO: README에 "미구현 항목 및 이유" 기록 후 스킵

Q: 이 테스트가 없으면 핵심 비즈니스 규칙이 검증되지 않는가?
  → YES: 반드시 작성
  → NO: 주석으로 테스트 케이스만 기록
```

---

## Phase 3: 리팩토링 (2시간30분~3시간30분, 1시간)

### 목표
- 기능구현 PR 대비 코드 품질 명확히 개선
- 리팩토링 전/후 차이가 리뷰어에게 보여야 함

### 리팩토링 PR 체크리스트

**명명 개선**
- [ ] 클래스/메서드/변수명이 의도를 명확히 표현하는가?
- [ ] Kotlin 컨벤션 준수 (camelCase, PascalCase)
- [ ] 약어 제거 (e.g., `amt` → `amount`)

**책임 분리 (SoC)**
- [ ] 하나의 메서드가 하나의 일만 하는가?
- [ ] 도메인 로직이 서비스/컨트롤러에 새고 있지 않은가?
- [ ] 변경 이유가 다른 코드가 같은 클래스에 있지 않은가?

**Kotlin 관용성**
- [ ] var → val 전환 가능한 곳 확인
- [ ] Java 스타일 getter/setter → Kotlin property
- [ ] null 처리: `?.let`, `?: throw`, `requireNotNull`
- [ ] 컬렉션 함수 활용 (`map`, `filter`, `groupBy`)

**리팩토링 금지 항목** (시간 낭비)
- ❌ 완전히 새로운 아키텍처로 전환
- ❌ 테스트 통과하지 않는 리팩토링
- ❌ 요구사항 변경을 수반하는 수정

---

## Phase 4: README 작성 (3시간30분~4시간, 30분)

### README 작성 템플릿

```markdown
# [과제명]

## 실행 방법

```bash
./gradlew test
./gradlew bootRun
```

## 설계 결정

### [핵심 설계 결정 1]
**선택:** [무엇을 선택했는가]
**이유:** [왜 선택했는가]
**트레이드오프:** [무엇을 포기했는가]

### [핵심 설계 결정 2]
...

## 미구현 항목 (시간 제약)

| 항목 | 이유 | 구현했다면... |
|------|------|--------------|
| [항목] | 4시간 제약 | [접근 방법 간략히] |

## 개선 아이디어

- [개선하고 싶은 항목 1]
- [개선하고 싶은 항목 2]
```

### README 작성 가이드
```
심사자는 README에서 다음을 본다:
1. "이 사람이 요구사항을 제대로 이해했는가?"
2. "설계 결정에 근거가 있는가?"
3. "트레이드오프를 인식하는가?"
4. "미구현 항목을 솔직히 밝혔는가?"

→ 실행 방법만 있는 README는 감점 요소
→ 설계 의도 + 트레이드오프가 있어야 함
```

---

## PR 작성 가이드

### 기능구현 PR

```markdown
## Summary
요구사항 [N]개 항목 모두 구현 완료

## Changes
- [도메인 객체] 구현: [핵심 비즈니스 규칙]
- [서비스] 구현: [주요 플로우]
- 테스트: [단위/통합] 테스트 [N]개 추가

## Test Coverage
- 성공 케이스: [N]개
- 실패/엣지케이스: [N]개
```

### 리팩토링 PR

```markdown
## Summary
기능구현 PR 대비 코드 품질 개선

## Changes
- [명명 개선]: `[이전]` → `[이후]` (이유: [의도 명확화])
- [책임 분리]: [분리 내용과 이유]
- [Kotlin 관용성]: [적용 내용]

## What NOT Changed
기능 동작은 변경되지 않았습니다. 테스트는 기능구현 PR과 동일하게 통과합니다.
```

---

## 비상 대응 (시간 초과 위기)

### 3시간 경과 시점에 요구사항이 50%만 구현된 경우

```
1. 현재 구현된 기능으로 기능구현 PR 생성
2. 리팩토링은 생략하거나 5~10분으로 축소
3. README에 미구현 항목 + 이유 명시 (솔직함이 강점)
4. 시간이 조금 남으면 핵심 누락 기능 하나만 추가
```

### 테스트가 계속 실패하는 경우

```
1. 15분 이상 같은 테스트 디버깅은 멈춤
2. 테스트를 `@Disabled`로 표시하고 주석으로 이유 기록
3. README에 해당 케이스 미검증 명시
4. 다른 테스트 케이스로 이동
```

---

## 관련 리소스

- **2w-brainstorm:** `problem-solving/problems/toss-payments-preassignment/2w-brainstorm.md`
- **이력서:** `career-launchpad/resume/applications/application-round3.md`
- **참고 PoC:** `concurrency-control-poc/` (MySQL/Redis 동시성 제어)
- **참고 PoC:** `eda-poc/` (Kafka 이벤트 기반 아키텍처)
