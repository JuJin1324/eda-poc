# Design Implementation vN - [문제명]

## 한눈에 결론
- 설계 핵심 결론:
- 확정된 설계 결정 2~3개:
- 바로 구현할 항목:
- 핵심 리스크:

---

## 1) 구조 설계
### 1-1. 기능과 경계
- 핵심 기능:
- 포함(In Scope):
- 제외(Out of Scope):

### 1-2. 다이어그램 (Business-first, 다중 허용)
- 작성 원칙:
  - 비즈니스 흐름 다이어그램을 먼저 제시한다. (필수, 1개 이상)
  - 기술 흐름 다이어그램은 구현 리스크를 줄이기 위한 보조로 추가한다. (선택, 0개 이상)
  - 동일 타입 다이어그램도 시나리오별로 여러 개 작성할 수 있다.
  - 동일 문제 축(예: EDA 주문 팬아웃 비교)을 유지하면 `.agile/sprints/sprint-0/1-direction/design-phase.md` 기준본을 우선 재사용하고 이번 US의 변경점만 메모한다.

#### A. 비즈니스 흐름 다이어그램 (필수, 1개 이상)
##### A-1. 동기 방식 비즈니스 흐름 (Before, 기준본 재사용 권장)
```mermaid
sequenceDiagram
    participant User as 사용자
    participant OS as 주문
    participant NS as 알림
    participant SS as 배송

    User->>OS: POST /orders
    OS->>OS: 재고 차감 (DB)

    par 병렬 REST 호출 (CompletableFuture)
        OS->>NS: REST: 알림 발송 (고정 1s)
    and
        OS->>SS: REST: 배송 접수 (고정 1s)
    end
    NS-->>OS: 완료
    SS-->>OS: 완료
    OS-->>User: 주문 완료 응답 (약 1s+)

    Note over OS,SS: 문제: 병렬 REST 호출이더라도 사용자는 모든 후속 처리 완료까지 대기 (블로킹)<br/>알림/배송 중 하나라도 장애 시 주문 전체 실패
```

##### A-2. 비동기 방식 비즈니스 흐름 (After, 기준본 재사용 권장)
```mermaid
sequenceDiagram
    participant User as 사용자
    participant OA as 주문
    participant K as Kafka
    participant NA as 알림 Consumer
    participant SA as 배송 Consumer
    participant DLQ as Dead Letter Queue

    User->>OA: POST /orders
    OA->>OA: 재고 차감 (DB)
    OA->>K: OrderCompleted 이벤트 발행
    OA-->>User: 주문 완료 응답 (즉시)

    par Fan-out: 동시 처리
        K->>NA: 이벤트 전달 (Consumer Group A)
        NA->>NA: 알림 발송 (고정 1s)
    and
        K->>SA: 이벤트 전달 (Consumer Group B)
        SA->>SA: 배송 접수 (고정 1s)
    end

    alt 후속 처리 실패 시
        NA->>DLQ: 실패 메시지 격리
        Note over DLQ: 복구 후 재처리
    end

    Note over OA,User: 효과 1: 주문 응답은 재고 차감까지만 대기 (즉시 반환)<br/>효과 2: 알림/배송이 병렬 처리 -> max(1s, 1s) = 1s<br/>효과 3: 알림 장애가 배송에 영향 없음 (장애 격리)
```

##### A-3. [선택] 추가 비즈니스 흐름 (실패/복구/보상)
```mermaid
sequenceDiagram
  participant Actor as 액터
  participant Domain as 도메인 서비스

  Actor->>Domain: 비즈니스 요청
  alt 성공
    Domain-->>Actor: 완료/상태 업데이트
  else 실패
    Domain-->>Actor: 실패 사유 + 보상/재시도 정책
  end
```

#### B. 기술 흐름 다이어그램 (선택, 0개 이상)
##### B-1. C4 Container (기준본 재사용 권장)
```mermaid
flowchart TB
    subgraph sync["동기 (Before) — 사용자 블로킹"]
        order_sync["order-service-sync\n(Spring Boot :8080)\n주문 API + 재고 차감"]
        notification_sync["notification-service-sync\n(Spring Boot :8081)\n알림 발송 (고정 1s)"]
        shipping_sync["shipping-service-sync\n(Spring Boot :8082)\n배송 접수 (고정 1s)"]
        order_sync -- "REST 호출" --> notification_sync
        order_sync -- "REST 호출" --> shipping_sync
    end

    subgraph async["비동기 (After) — 즉시 응답 + Fan-out"]
        order_async["order-service-async\n(Spring Boot :8083)\n주문 API + 재고 차감 + Kafka 발행"]
        kafka[("Kafka\nMessage Broker")]
        notification_async["notification-service-async\n(Spring Boot :8084)\nConsumer Group A — 알림 발송 (고정 1s)"]
        shipping_async["shipping-service-async\n(Spring Boot :8085)\nConsumer Group B — 배송 접수 (고정 1s)"]
        order_async -- "OrderCompleted\n이벤트 발행" --> kafka
        kafka -- "Fan-out (Group A)" --> notification_async
        kafka -- "Fan-out (Group B)" --> shipping_async
    end

    subgraph infra["공통 인프라 (Docker Compose)"]
        k6["k6\nLoad Test"]
        akhq["AKHQ\nKafka UI (:18080)"]
    end

    k6 -. "부하 테스트" .-> order_sync
    k6 -. "부하 테스트" .-> order_async
    akhq -. "토픽/컨슈머 그룹 조회" .-> kafka
```

##### B-2. 구현 순서 Flowchart (US 전달용)
```mermaid
flowchart TD
  A[요청 수신] --> B{유효성 검사}
  B -->|성공| C[도메인 처리]
  B -->|실패| E[에러 반환]
  C --> D[결과 반환]
```

##### B-3. [선택] 추가 기술 흐름 (재시도/배포/관측성 등)
```mermaid
flowchart TD
  A[기술 이벤트 시작] --> B{조건 확인}
  B -->|정상| C[처리 계속]
  B -->|오류| D[재시도 또는 대체 경로]
  C --> E[종료]
  D --> E
```

## 2) 인터페이스와 ADR
### 2-1. 인터페이스 정의
- 입력:
- 출력:
- 이벤트/메시지:

### 2-2. ADR 요약
| ADR | Decision | Why | Trade-off |
| --- | --- | --- | --- |
| ADR-001 |  |  |  |

## 3) 구현 전달 정보
- 구현 우선순위:
- 대표 1개 선행 + 확장 게이트:
  - 기본 순서: `sync 대표 -> sync 확장 -> async 대표 -> async 확장`
  - Sync 대표 서비스(먼저 구현):
  - Async 대표 서비스(먼저 구현):
  - 리뷰 게이트 통과 조건:
  - 자동 확장 대상/방식:
- 테스트 포인트:
- 리스크/완화:
- 선행 의존사항:
- US 루프 순서: `execute-implementation -> design-test -> execute-test -> monitor-sprint`

## 4) 대상 범위와 목표
- 대상 US (기본 1개):
- 동시 설계 여부: 단일 US | 다중 US(예외)
- 다중 US 예외 근거(해당 시):
- 이번 설계 목표:
- 완료 기준:
- 제외 범위:

## 5) 기술 스택과 전제
- 기술 스택 문서: `.agile/context/tech-stack.md`
- 사용 방식: 기존 문서 재사용 | 일부 수정 | 신규 생성
- 설계 전제/제약:

---

## 부록) 운영 로그 (필요 시만 작성)
- C4 판단 게이트: AI 권장 | 사용자 선택 | 근거
- 설계 변경 이력:
