# Kafka 논리 구조 vs 물리 구조

Kafka 학습에서 자주 혼란이 생기는 이유는 **논리 구조(사람이 이해하는 개념)** 와 **물리 구조(실제 저장 방식)** 를 구분하지 않고 학습하기 때문이다.

---

## 논리 구조 (Logical Structure)

사람이 Kafka를 사용할 때 다루는 개념이다. 코드와 설정에서 직접 다루는 단위다.

```
Topic "order.order-completed.v1"
  └── Partition 0  → Consumer Group A의 인스턴스 1이 담당
  └── Partition 1  → Consumer Group A의 인스턴스 2가 담당
  └── Partition 2  → Consumer Group A의 인스턴스 3이 담당
```

| 논리 개념 | 의미 |
|----------|------|
| **Topic** | 메시지의 논리적 카테고리 (이름표) |
| **Partition** | Topic을 나누는 논리적 단위. 순서 보장의 경계 |
| **Offset** | Partition 내 메시지 위치를 나타내는 번호 (0부터 시작, 단조 증가) |
| **Consumer Group** | 하나의 Topic을 독립적으로 구독하는 논리적 소비 단위 |
| **Producer** | Topic에 메시지를 발행하는 논리적 역할 |
| **Consumer** | Partition을 할당받아 메시지를 소비하는 논리적 역할 |

---

## 물리 구조 (Physical Structure)

Kafka 브로커 디스크에 실제로 저장되는 방식이다.

**핵심: Topic은 디스크에 존재하지 않는다. Partition이 실제 물리 저장 단위다.**

```
브로커 디스크 (/kafka-logs/)
  ├── order.order-completed.v1-0/     ← {토픽명}-{파티션번호} 디렉터리
  │     ├── 00000000000000000000.log        ← 실제 메시지 데이터
  │     ├── 00000000000000000000.index      ← offset → 파일 위치 인덱스
  │     └── 00000000000000000000.timeindex  ← timestamp → offset 인덱스
  ├── order.order-completed.v1-1/
  │     ├── 00000000000000000000.log
  │     └── ...
  └── order.order-completed.v1-2/
        ├── 00000000000000000000.log
        └── ...
```

### Segment 파일

Partition 디렉터리 안의 `.log` 파일은 **Segment** 단위로 분리된다. 파일이 무한정 커지지 않도록 일정 크기(기본 1GB) 또는 기간(기본 7일)이 되면 새 Segment를 생성한다.

```
order.order-completed.v1-0/
  ├── 00000000000000000000.log   ← Segment 1 (offset 0부터 시작)
  ├── 00000000000000000000.index
  ├── 00000000000000500000.log   ← Segment 2 (offset 500000부터 시작)
  ├── 00000000000000500000.index
  └── ...
```

### Topic은 어디에 존재하는가

Topic은 브로커 내부 메타데이터 저장소에만 존재한다:
- **KRaft 모드** (Kafka 2.8+): 내부 `__cluster_metadata` 토픽에 저장
- **ZooKeeper 모드** (구버전): ZooKeeper에 저장

```
Topic 메타데이터 내용:
  - Topic 이름
  - Partition 수
  - 각 Partition의 Leader/Follower 브로커 위치
  - Replication Factor
```

### Consumer Group Offset은 어디에 저장되는가

Consumer Group의 offset 정보도 메모리나 애플리케이션 DB가 아니라 Kafka 내부 토픽에 저장된다.

```
__consumer_offsets (Kafka 내부 토픽)
  → "Consumer Group X가 Partition 0의 offset 1234까지 처리했다"를 기록
```

Consumer가 재시작되어도 이 토픽에서 마지막 offset을 읽어 이어서 처리할 수 있다.

---

## 논리 vs 물리 매핑

| 논리 개념 | 물리적 실체 |
|----------|------------|
| Topic | 메타데이터에만 존재 (디스크 없음) |
| Partition | 브로커 디스크의 디렉터리 |
| 메시지 | Partition 디렉터리 안의 `.log` Segment 파일 |
| Offset | `.log` 파일 내 바이트 위치를 가리키는 번호 |
| Consumer Group | `__consumer_offsets` 내부 토픽에 상태 저장 |
| Replication | Partition 디렉터리가 다른 브로커에 복제됨 |

---

## 자주 혼동하는 것들

### "파티션 안에 토픽이 있다" (❌)

```
❌ 파티션 → 토픽 (파티션이 토픽을 담는다)
✅ 토픽 → 파티션 (토픽이 파티션으로 나뉜다)
```

### "토픽이 물리 저장소다" (❌)

```
❌ 토픽이 디스크에 파일로 존재한다
✅ 파티션이 디스크 디렉터리로 존재한다. 토픽은 이름표일 뿐이다.
```

### "Consumer가 토픽에서 직접 가져온다" (△)

논리적으로는 맞지만 물리적으로는 틀리다:

```
논리: Consumer → Topic에서 메시지 소비
물리: Consumer → 할당받은 Partition의 .log 파일에서 offset 기준으로 읽음
```

### "poll 시 다른 토픽 메시지로 채운다" (❌)

```
max.poll.records = 10, A 토픽에 5개만 있을 때:

❌ A에서 5개 + B에서 5개 채워서 10개 반환
✅ A에서 5개만 반환 (부족해도 다른 토픽에서 채우지 않음)
```

---

## Kafka가 파티션 중심으로 동작하는 이유

Topic이 아니라 Partition이 Kafka의 실질적 동작 단위다:

| 동작 | 단위 |
|------|------|
| 물리 저장 | Partition |
| 순서 보장 | Partition (파티션 내부만 순서 보장) |
| Consumer 할당 | Partition (Consumer Group 내 인스턴스에 파티션 분배) |
| Replication (복제) | Partition (Leader/Follower가 파티션 단위로 선출) |
| Consumer Lag 측정 | Partition (파티션별 lag 합산이 Group 전체 lag) |

Topic은 사람이 메시지를 논리적으로 분류하기 위한 이름표고, Kafka 내부는 파티션 중심으로 동작한다.
