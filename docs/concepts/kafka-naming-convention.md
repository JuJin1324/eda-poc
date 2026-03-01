# Kafka 네이밍 컨벤션

> ADR-007 (Accepted, 2026-02-28) 의 결정을 바탕으로 정리한 실무 가이드.
> Topic/Consumer Group 이름이 코드, 설정, 다이어그램에 반복 등장하므로 일관된 규칙이 필요하다.

---

## 규칙 요약

| 대상 | 패턴 | 예시 |
|------|------|------|
| **Topic** | `{domain}.{event}.v{n}` | `order.order-completed.v1` |
| **DLQ 토픽** | `{domain}.{service}.dlq.v{n}` | `order.notification.dlq.v1` |
| **Consumer Group** | `{env}.{domain}.{service}.{purpose}.v{n}` | `dev.order.notification.event-consumer.v1` |
| **DLQ Consumer Group** | `{env}.{domain}.{service}.dlq-processor.v{n}` | `dev.order.notification.dlq-processor.v1` |

---

## Topic

```
{domain}.{event}.v{n}

order   .order-completed   .v1
 ↑           ↑              ↑
도메인     이벤트 이름      버전
```

**규칙:**
- `domain`: 이벤트를 발행하는 서비스 도메인 (`order`, `payment`, `shipping`)
- `event`: 발생한 사실을 과거형으로 표현 (`order-completed`, `payment-failed`)
- `v{n}`: 스키마 변경 시 버전 증가. 구버전/신버전 병행 운영 가능

**예시:**
```
order.order-completed.v1
payment.payment-failed.v1
shipping.shipping-started.v1
```

---

## DLQ 토픽

```
{domain}.{service}.dlq.v{n}

order   .notification   .dlq   .v1
 ↑            ↑           ↑     ↑
도메인    소비하는 서비스  DLQ  버전
```

Spring Kafka의 `DeadLetterPublishingRecoverer`는 기본적으로 원본 토픽명 + `.DLT` suffix를 사용하지만, 이 프로젝트는 명시적 네이밍을 위해 직접 지정한다.

**예시:**
```
order.notification.dlq.v1   ← 알림 Consumer의 실패 메시지
order.shipping.dlq.v1       ← 배송 Consumer의 실패 메시지
```

**DLQ는 서비스별로 분리하는 이유:** 알림 실패와 배송 실패를 하나의 DLQ에 섞으면 재처리 시 어느 서비스로 보낼지 판단이 어렵다.

---

## Consumer Group

```
{env}.{domain}.{service}.{purpose}.v{n}

dev   .order   .notification   .event-consumer   .v1
 ↑       ↑           ↑               ↑             ↑
환경   도메인      서비스명          역할          버전
```

**규칙:**
- `env`: 실행 환경 (`dev`, `staging`, `prod`). 환경별 offset이 독립적으로 관리됨
- `domain`: 소비하는 이벤트의 도메인
- `service`: 소비하는 서비스 이름
- `purpose`: 역할 식별 (`event-consumer`, `dlq-processor`)
- `v{n}`: Consumer 로직 변경으로 offset을 초기화해야 할 때 버전 증가

**예시:**
```
dev.order.notification.event-consumer.v1   ← 알림 Consumer (정상)
dev.order.shipping.event-consumer.v1       ← 배송 Consumer (정상)
dev.order.notification.dlq-processor.v1   ← 알림 DLQ 재처리
dev.order.shipping.dlq-processor.v1        ← 배송 DLQ 재처리
```

---

## 이 프로젝트 전체 네이밍 목록

```
[Topic]
order.order-completed.v1             ← 주문 완료 이벤트
order.notification.dlq.v1           ← 알림 Consumer DLQ
order.shipping.dlq.v1               ← 배송 Consumer DLQ

[Consumer Group]
dev.order.notification.event-consumer.v1    ← 알림 정상 처리
dev.order.shipping.event-consumer.v1        ← 배송 정상 처리
dev.order.notification.dlq-processor.v1    ← 알림 DLQ 재처리
dev.order.shipping.dlq-processor.v1         ← 배송 DLQ 재처리
```

---

## 규칙: 동적 값 금지

타임스탬프, 인스턴스 ID, UUID 등 동적 값은 Topic/Group ID에 포함하지 않는다.

```
❌ order.order-completed.v1.1709123456   ← 타임스탬프 포함
❌ dev.order.notification.event-consumer.instance-3  ← 인스턴스 ID 포함

✅ order.order-completed.v1
✅ dev.order.notification.event-consumer.v1
```

동적 값이 포함되면 모니터링 필터링, Consumer Lag 집계, 로그 검색이 불가능해진다.

---

## 버전 증가 시점

| 대상 | 버전 올리는 경우 |
|------|----------------|
| **Topic** | 이벤트 스키마가 하위 호환이 불가능하게 변경될 때 |
| **Consumer Group** | Consumer 처리 로직이 변경되어 기존 offset부터 재처리가 필요할 때 |

버전을 올리면 구버전과 신버전을 **병행 운영**할 수 있다. 구버전 Consumer가 v1을 소비하는 동안 신버전 Consumer가 v2를 소비하는 방식으로 무중단 마이그레이션이 가능하다.
