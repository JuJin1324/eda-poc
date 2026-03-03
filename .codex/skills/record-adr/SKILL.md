---
name: record-adr
description: "Architecture Decision Record(ADR) 생성 스킬. 다음 두 가지 방식으로 동작한다: (1) 사용자가 /record-adr을 명시적으로 호출, (2) 대화 중 기술 선택/설계 변경/범위 결정이 내려지는 순간을 자동 감지하여 ADR 작성을 제안. docs/adr/ 디렉터리에 ADR-{N:03d}-{slug}.md 파일로 생성한다."
---

# ADR 생성 스킬

## 참고 문서

- `references/experience.md`
  - 어떤 결정에서 ADR을 남겨야 효과적이었는지, 상태 갱신 패턴이 어땠는지 참고할 때

## 자동 감지 (Auto-detection)

대화 중 아래 신호가 감지되면 즉시 개입하여 ADR 작성을 제안한다.

### 감지 시나리오

| 시나리오 | 감지 신호 예시 |
|---------|-------------|
| **기술 선택** | "A 대신 B 쓰기로", "~를 제외하기로", "~를 채택", "A vs B 결론" |
| **설계 변경** | "~로 재정의", "~방식으로 변경", "기존 설계를 ~로 수정" |
| **범위 결정** | "Out of Scope로", "이번엔 안 하기로", "나중에 하기로", "In Scope 확정" |

### 자동 감지 시 개입 방식

```
⚠️ ADR 감지: [결정 내용 한 줄 요약]

이 결정을 ADR로 남기겠습니다. (ADR-{N}: {제목 제안})
→ 바로 생성할까요, 아니면 내용을 먼저 확인하시겠습니까?
```

사용자가 거부하면 스킵하고, 승인하면 생성 워크플로우를 실행한다.

---

## 생성 워크플로우

### 1. 다음 ADR 번호 결정

```
docs/adr/ 디렉터리의 기존 파일 목록을 확인하여 다음 번호 결정
→ 파일 없으면 ADR-001부터 시작
→ 있으면 마지막 번호 + 1
```

### 2. 대화에서 내용 추출

| ADR 필드 | 추출 방법 |
|---------|---------|
| **Context** | 결정이 필요했던 배경/문제 상황 |
| **Decision** | 최종 결정 내용 (명확하고 구체적으로) |
| **Why** | 결정 근거 (사례, 트레이드오프, 실험 결과 등) |
| **Consequences** | 장점 + 비용/단점 |

추출이 불명확하면 사용자에게 확인 후 진행한다.

### 3. 파일 생성

```
경로: docs/adr/ADR-{N:03d}-{slug}.md
slug: 제목을 소문자 kebab-case로 변환 (예: "at-least-once-idempotency")
템플릿: templates/adr-template.md 참고
```

### 4. 생성 완료 알림

```
✅ ADR-{N} 생성 완료: docs/adr/ADR-{N:03d}-{slug}.md
→ how-diagram.md 또는 관련 문서에 참조를 추가하시겠습니까?
```

---

## 파일 네이밍 규칙

```
docs/adr/
  ADR-001-at-least-once-vs-exactly-once.md
  ADR-002-kafka-naming-convention.md
  ADR-003-spring-cloud-exclusion.md
```

- 번호: 3자리 zero-padding (`001`, `002`)
- slug: 결정의 핵심 키워드를 kebab-case로
- 번호는 생성 순서 기준 (중요도 순 아님)

---

## ADR 상태

| 상태 | 의미 |
|------|------|
| `Proposed` | 논의 중, 아직 확정 전 |
| `Accepted` | 확정된 결정 |
| `Deprecated` | 더 이상 유효하지 않음 |
| `Superseded by ADR-{N}` | 다른 ADR로 대체됨 |

기본값은 `Accepted`로 생성한다. (대화에서 결정이 이미 내려진 시점에 생성하므로)
