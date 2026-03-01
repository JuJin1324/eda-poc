# At Least Once + 멱등성

## 왜 필요한가

핵심은 **"중복 전달이 발생해도 결과가 한 번과 동일해야 한다"**는 것이다.

Kafka는 기본적으로 At Least Once(최소 1번 전달)를 보장한다. Consumer 재시작, Rebalancing, 처리 중 장애가 발생하면 같은 메시지를 다시 받을 수 있다. 이때 처리 로직이 멱등하지 않으면 중복 주문 처리, 중복 알림 발송 같은 부작용이 생긴다.

즉, At Least Once는 "메시지 유실 없음"을 보장하지만, 멱등성 설계 없이는 중복 처리가 발생한다.

---

## 전달 보장 수준 비교

| 수준 | 의미 | 유실 | 중복 | 구현 복잡도 |
|------|------|------|------|------------|
| **At Most Once** | 최대 1번 전달 | 가능 | 없음 | 낮음 |
| **At Least Once** | 최소 1번 전달 | 없음 | 가능 | 중간 |
| **Exactly Once** | 정확히 1번 전달 | 없음 | 없음 | 높음 |

### At Most Once

```
acks=0 or acks=1 (빠른 전송, 유실 허용)

Producer → Kafka: 발행 (확인 없이)
Kafka   → Consumer: 전달
Consumer: 처리 전 offset commit → 처리 실패 시 메시지 유실
```

로그, 클릭 이벤트처럼 일부 유실을 허용하는 경우에만 사용한다.

### At Least Once

```
acks=all + enable.auto.commit=false + 수동 ack

Producer → Kafka: 발행 확인 (모든 복제본(ISR, In-Sync Replicas)에 저장 완료 후 ack)
Kafka   → Consumer: 전달
Consumer: 처리 완료 후 offset commit → 처리 전 장애 시 재전달
```

**문제:** Consumer가 처리 후 offset commit 전에 장애가 나면, 재시작 후 같은 메시지를 다시 받는다.

```
1. Consumer가 메시지 수신
2. 처리 완료 (DB write)
3. offset commit 시도 → 여기서 장애 (JVM crash, OOM 등)
4. Consumer 재시작 → 마지막 커밋 offset부터 재소비
5. 동일 메시지 재전달 → 중복 처리 발생
```

### Exactly Once (EOS)

```
Producer: enable.idempotence=true + transactional.id 설정
Consumer: isolation.level=read_committed
```

Producer가 트랜잭션으로 발행하고, Consumer가 커밋된 메시지만 읽는다. Kafka 토픽을 읽어서 처리한 뒤 다시 Kafka 토픽으로 쓰는 파이프라인(예: Kafka Streams) 내에서는 완전한 EOS가 가능하다.

**한계:** 외부 시스템(DB, 이메일 API, 결제 PG)과의 트랜잭션은 Kafka EOS로 보장할 수 없다. Kafka 내부 트랜잭션과 외부 DB 트랜잭션을 하나의 원자적 단위로 묶을 수 없기 때문이다.

---

## 배민이 Exactly Once를 제거한 이유

> 출처: WOOWACON 2024 — 배달의민족 주문 플랫폼

### 장애 현황

```
2년간 41건 장애 발생
  ├── 외부 장애: 70% (외부 API, 네트워크)
  └── 내부 장애: 30% (Kafka 설정, 트랜잭션 코디네이터)

치명적 장애: 3건 → 아키텍처 개선 결단
```

### 제거 결정의 근거

Kafka Exactly Once는 **트랜잭션 코디네이터**(Kafka 브로커 내부에서 트랜잭션 상태를 관리하는 컴포넌트)를 통해 동작한다. 이 코디네이터 자체가 SPOF(Single Point of Failure)가 될 수 있고, 트랜잭션 상태 관리 오버헤드가 장애의 원인이 됐다.

```
Exactly Once 내부 동작:
  1. Producer가 트랜잭션 코디네이터에 BEGIN 요청
  2. 메시지 발행
  3. 트랜잭션 코디네이터에 COMMIT 요청
  4. Consumer는 read_committed로 커밋된 메시지만 읽음

→ 트랜잭션 코디네이터 응답 지연/장애 시 전체 파이프라인 중단
→ 네트워크 파티션 상황에서 복잡한 롤백 처리 필요
```

### 결론

```
Exactly Once 제거
    ↓
At Least Once + 멱등성으로 전환
    ↓
- 트랜잭션 코디네이터 제거 → 장애 포인트 감소
- 파이프라인 단순화 → 디버깅/운영 용이
- 멱등성을 애플리케이션 레벨에서 명시적으로 처리
```

> 핵심 교훈: Exactly Once는 복잡도를 시스템 내부로 숨길 뿐이고, 그 복잡도가 오히려 장애 원인이 됐다. 명시적인 멱등성 설계가 더 안정적이다.

---

## 멱등성 (Idempotency)

**같은 연산을 여러 번 실행해도 결과가 동일한 성질.**

```
멱등한 예:
  알림 발송 테이블에 INSERT (messageId 기준 중복 체크)
  → 두 번 처리해도 알림은 1건만 발송

멱등하지 않은 예:
  주문 수량 += 1
  → 두 번 처리하면 수량이 2 증가
```

---

## 멱등성 키 설계 패턴

### 원칙: 이벤트 식별자 = 멱등성 키

```
orderId + eventType 조합으로 중복 체크
예: "ORDER-12345" + "OrderCompleted" → 처리 여부 확인
```

### 패턴 1: DB Unique Constraint

```sql
CREATE TABLE processed_events (
    event_id     VARCHAR(255) NOT NULL,
    event_type   VARCHAR(100) NOT NULL,
    processed_at TIMESTAMP    NOT NULL,
    CONSTRAINT uk_processed_events UNIQUE (event_id, event_type)
);
```

Unique Constraint가 `(event_id, event_type)` 조합에 걸려 있으므로 두 Consumer가 동시에 INSERT를 시도해도 DB가 원자적으로 하나만 허용한다. `INSERT IGNORE`는 중복 시 예외 없이 조용히 스킵하고 영향받은 행 수를 반환하므로, 예외를 정상 흐름 제어에 사용하지 않아도 된다.

```java
// Repository: INSERT IGNORE로 원자적 처리
public boolean tryMarkProcessed(String eventId, String eventType) {
    int rows = jdbcTemplate.update(
        "INSERT IGNORE INTO processed_events (event_id, event_type, processed_at)" +
        " VALUES (?, ?, NOW())",
        eventId, eventType
    );
    return rows > 0; // true = 신규, false = 중복 (예외 없음)
}
```

```java
// Consumer: 예외 없이 의도가 명확한 흐름
@KafkaListener(topics = "order.order-completed.v1")
public void handleOrderCompleted(
        @Payload OrderCompletedEvent event,
        Acknowledgment ack) {

    boolean isNew = processedEventRepository.tryMarkProcessed(
        event.getEventId(), "OrderCompleted"
    );

    if (!isNew) {
        log.warn("Duplicate event ignored: {}", event.getEventId());
        ack.acknowledge();
        return;
    }

    notificationService.send(event);
    ack.acknowledge();
}
```

PostgreSQL에서는 문법이 다르다:
```sql
INSERT INTO processed_events (event_id, event_type, processed_at)
VALUES (?, ?, NOW())
ON CONFLICT (event_id, event_type) DO NOTHING;
```

**장점:** 별도 인프라 불필요, 원자적 중복 체크, 예외를 정상 흐름 제어에 사용하지 않음
**단점:** DB 부하, 오래된 이벤트 ID 정리 정책 필요, DB 벤더별 문법 차이

### 패턴 2: Outbox + 상태 플래그

비즈니스 테이블에 `order_event_id`를 UNIQUE 컬럼으로 추가한다. 비즈니스 레코드 INSERT 자체가 멱등성 체크를 겸하므로 별도 processed_events 테이블이 필요 없다. 구현 방식은 패턴 1과 동일하며, INSERT 대상 테이블만 다르다.

```sql
ALTER TABLE notifications
    ADD COLUMN order_event_id VARCHAR(255);

ALTER TABLE notifications
    ADD CONSTRAINT uk_notifications_order_event_id UNIQUE (order_event_id);
```

`order_event_id`는 멱등성과 추적(어떤 이벤트로 이 알림이 생성됐는가) 두 가지 역할을 겸한다.

**장점:** 별도 processed_events 테이블 불필요, 비즈니스 레코드가 처리 증거를 겸함, 추적 용도 겸비
**단점:** 테이블 설계 변경 필요, Consumer가 항상 비즈니스 레코드를 생성하는 경우에만 적용 가능 (외부 API 호출만 하는 Consumer에는 사용 불가)

---

### 패턴 1 vs 패턴 2 본질적 차이

두 패턴은 "이벤트 처리 증거를 어디에 남기는가"의 차이다.

| | 패턴 1 (processed_events) | 패턴 2 (Outbox + 상태 플래그) |
|---|---|---|
| 이벤트 관심사 | 별도 테이블에 순수하게 분리 | 비즈니스 테이블에 함께 관리 |
| 처리 증거 | "이 이벤트를 처리했는가?" | "이 이벤트로 무엇이 생성됐는가?" |
| 적용 조건 | 항상 가능 | 처리 결과로 비즈니스 레코드가 생기는 경우만 |

**패턴 선택 기준:**

```
이벤트 처리 결과로 비즈니스 레코드(notifications, shipping 등)가 DB에 생성되는가?
  Yes → 패턴 2: 비즈니스 레코드 존재 자체가 처리 증거를 겸함
  No  → 패턴 1 필수: 외부 API만 호출하거나 자체 DB가 없는 경우 별도 증거가 필요
```

### 패턴 3: Redis SET NX (분산 환경)

```java
// 60초 TTL로 중복 처리 방지
Boolean isNew = redisTemplate.opsForValue()
    .setIfAbsent("processed:" + event.getEventId(), "1", Duration.ofSeconds(60));

if (Boolean.FALSE.equals(isNew)) {
    log.warn("Duplicate event: {}", event.getEventId());
    ack.acknowledge();
    return;
}
notificationService.send(event);
ack.acknowledge();
```

**장점:** 빠른 조회, 자동 만료
**단점:** Redis 장애 시 중복 처리 가능, TTL 설정 주의 필요

### PoC 선택: DB Unique Constraint

```
단순하고 별도 인프라 불필요
트랜잭션과 함께 원자적 처리 가능
멱등성 키: orderId + eventType
```

---

## offset commit 타이밍과 중복의 관계

```
Manual AckMode (enable-auto-commit: false)일 때:

처리 성공 흐름:
  1. 메시지 수신
  2. 처리 (멱등성 체크 → 비즈니스 로직)
  3. acknowledgment.acknowledge() → offset 커밋

중복 발생 시나리오:
  1. 메시지 수신
  2. 처리 완료
  3. JVM 장애 → offset 커밋 실패
  4. Consumer 재시작 → 동일 메시지 재전달
  5. 멱등성 체크 → 중복 감지 → 스킵 + offset 커밋
```

Auto Commit은 처리 전에 offset이 커밋될 수 있어 At Most Once로 동작할 위험이 있다. 반드시 Manual AckMode를 사용한다.

---

## Phase 2 구현 매핑

```yaml
spring:
  kafka:
    consumer:
      enable-auto-commit: false   # Manual AckMode 필수
      auto-offset-reset: earliest
    listener:
      ack-mode: manual            # 처리 완료 후 다음 poll 주기에 배치 커밋 (MANUAL_IMMEDIATE는 매 메시지마다 동기 커밋 → 자원 낭비)
```

```java
// 멱등성 체크 흐름
@KafkaListener(
    topics = "order.order-completed.v1",
    groupId = "dev.order.notification.event-consumer.v1"
)
public void handle(
        @Payload OrderCompletedEvent event,
        Acknowledgment ack) {

    // 1. INSERT IGNORE로 원자적 중복 체크 + 처리 기록
    //    isDuplicate(SELECT) + markProcessed(INSERT) 분리 시 경쟁 상태 발생 위험
    boolean isNew = processedEventService.tryMarkProcessed(
        event.getOrderId(), "OrderCompleted"
    );

    if (!isNew) {
        log.warn("중복 이벤트 스킵: {}:OrderCompleted", event.getOrderId());
        ack.acknowledge();
        return;
    }

    // 2. 비즈니스 처리
    notificationService.send(event);

    // 3. offset 커밋
    ack.acknowledge();
}
```

### PoC 구성 요약

| 항목 | 설정 | 이유 |
|------|------|------|
| `enable-auto-commit` | `false` | 처리 완료 후 수동 커밋 (At Least Once) |
| `ack-mode` | `manual` | 처리 완료 후 다음 poll 주기에 배치 커밋 (At Least Once 보장에 충분) |
| 멱등성 키 | `orderId + eventType` | 이벤트 단위 중복 체크 |
| 중복 체크 방식 | INSERT IGNORE (단일 원자 연산) | 경쟁 상태 없음, 예외를 정상 흐름에 사용하지 않음 |
| Exactly Once | 미사용 | 배민 교훈 — 복잡도 대비 가치 낮음 |

---

## 참고 자료

- [Kafka Delivery Semantics](https://kafka.apache.org/documentation/#semantics)
- [Kafka Transactions](https://kafka.apache.org/documentation/#transactions)
- WOOWACON 2024 — 배달의민족 주문 플랫폼 EDA 발표
