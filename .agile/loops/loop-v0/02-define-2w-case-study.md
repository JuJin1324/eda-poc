# EDA/Kafka 도입 사례 조사 (Case Study Research)

**조사 일자:** 2026-02-26
**목적:** EDA PoC 설계를 위한 실제 기업 도입 사례, 트레이드오프, 평가 지표 조사
**조사 범위:** 한국 테크 기업 중심 + 글로벌 사례 보완

---

## 1. 개별 사례 연구 (Case Studies)

---

### Case 1: 우아한형제들 (배달의민족) - 딜리버리서비스팀

**출처:**
- [우리 팀은 카프카를 어떻게 사용하고 있을까 (techblog.woowahan.com)](https://techblog.woowahan.com/17386/)
- [WOOWACON 2024 - Kafka 메시지 플랫폼 아키텍처 개선](https://2024.woowacon.com/sessions/)
- [우아콘 2024 후기](https://velog.io/@hsh111366/%EC%9A%B0%EC%95%84%EC%BD%98-2024-%ED%9B%84%EA%B8%B0)

#### 도입 배경 (Before State)
- 하루 **100만 건 이상** 배민배달 생성/중계
- 일 평균 주문: 과거 10만 건 → 현재 **300만 건**
- 여러 주문서비스(배민배달, B마트, 배민스토어)의 배달을 받아 배달서비스로 분배
- 늘어나는 주문으로 **쓰기 처리량 한계** 도달

#### Why: 왜 EDA/Kafka를 선택했는가
- **고성능/고가용성**: 실시간 이벤트 처리에 적합
- **대부분의 기능이 배달과 강한 일관성 불필요** → 이벤트 기반이 자연스러움
- 전담팀의 Kafka 클러스터 관리/모니터링 지원 가능
- Kafka Streams, Kafka Connect 등 다양한 통합 도구 제공

#### 핵심 아키텍처 결정
- **Transactional Outbox Pattern**: 분산 시스템에서 DB 트랜잭션 + 메시지 큐 원자성 보장
  - Outbox 테이블에 트랜잭션 변경사항 기록
  - **Debezium** (MySQL Source Connector) → Kafka 이벤트 발행
  - 트랜잭션 롤백 시 이벤트 미발송 보장
- **이벤트 순서 보장**: Kafka 파티션 키 기반
- **순서를 보장한 재시도**: 이벤트 누락 방지

#### 결과 및 성과
- 일 300만 건 주문 처리 안정적 운영
- 서비스 간 느슨한 결합 달성
- 쓰기 부하 분산 (샤딩 + EDA 조합)

#### 트레이드오프 및 어려움 (WOOWACON 2024 발표)
- **2년간 41건 장애** 발생 (외부 장애 70%, 내부 30%)
- **3건의 치명적 장애** → 아키텍처 개선 결단
- **Kafka Exactly Once 제거** 결정 (안정성 확보 위해)
- **3배 트래픽 처리** 요청 수용 과정:
  - 파티션 수 증가만으로 불가 → 구조적 변경 필요
  - TimeLimiter 적용 (아웃라이어 제거)
  - 비동기 전환 + 배치 리스너 적용
  - 결과: 파티션 수를 **100개까지 감소** 가능
- Debezium 학습/운영 팀 비용 발생

#### 측정 지표
- 일간 주문 건수 (TPS 간접 추정)
- 장애 건수 및 치명도
- 파티션 수 최적화
- 트래픽 처리 배수 (1x → 3x)

---

### Case 2: 쿠팡 (Coupang) - Vitamin MQ

**출처:**
- [마이크로서비스 아키텍처로의 전환 (Coupang Engineering Blog)](https://medium.com/coupang-engineering/how-coupang-built-a-microservice-architecture-fd584fff7f2b)
- [Coupang Engineering - MSA Platform Services](https://medium.com/coupang-engineering/integrating-platform-services-to-a-microservice-architecture-6f19f7816e15)

#### 도입 배경 (Before State)
- **모놀리식 아키텍처** (Apache + Tomcat, 단일 Git 저장소)
- 주문 시 결제→배송 요청이 **단일 트랜잭션으로 강결합**
- 하나의 에러가 전체 프로세스 중단 (Cascading Failure)
- 전체 플랫폼 스케일링 필요 (비효율적)
- 모든 변경 시 전체 코드베이스 테스트 필요
- coupang-common 브랜치의 레거시 코드 축적

#### Why: 왜 이벤트 기반 MQ를 선택했는가
- 강결합된 트랜잭션을 느슨하게 분리하는 것이 핵심 과제
- 기존 메시지 큐로는 **안전한 트랜잭션 분해**가 어려움
- **인하우스 MQ(Vitamin MQ)** 직접 개발 결정
  - 이유: 특수한 트랜잭션 분해 요구사항에 맞는 제품 부재

#### 핵심 아키텍처 결정
- **Vitamin MQ**: 자체 개발 메시지 큐 플랫폼
  - 트랜잭션을 메시지 형태로 변환 (주문 → 결제 이벤트 + 배송 이벤트)
  - **Dead Letter Queue**: 실패 메시지 자동 전달, 서비스 복구 후 재처리
  - 도메인 팀이 코드 운영에서 벗어나 비즈니스 도메인에 집중
- **2013년 "Vitamin Project"** 시작

#### 결과 및 성과
- 모놀리스 → **수백 개의 느슨하게 결합된 서비스** 분리
- 매일 **100~200개 마이크로서비스** 신규 배포
- 매일 **2,000개 이상 인스턴스** 신규 구성
- 독립 배포/테스트 가능
- 장애 격리 달성 (하나의 서비스 장애가 전체로 전파되지 않음)

#### 트레이드오프 및 어려움
- 인하우스 MQ 개발/유지보수 비용 (전담 팀 필요)
- 2013년부터 수년간의 점진적 전환 (Big Bang 아님)
- 기존 강결합 트랜잭션을 이벤트로 분리하는 설계가 가장 어려운 과제
- Vitamin MQ 자체의 안정성 보장 필요 (MQ 장애 = 전체 장애)

#### 측정 지표
- 일간 배포 횟수 (100~200 서비스/일)
- 장애 격리 범위 (단일 서비스 vs 전체)
- 신규 인스턴스 구성 수 (2,000+/일)

---

### Case 3: LINE (LY Corporation) - IMF (Internal Message Flow)

**출처:**
- [Applying Kafka Streams for internal message delivery pipeline (LINE Engineering)](https://engineering.linecorp.com/en/blog/applying-kafka-streams-for-internal-message-delivery-pipeline/)
- [Building a company-wide data pipeline on Apache Kafka (SlideShare)](https://www.slideshare.net/linecorp/building-a-companywide-data-pipeline-on-apache-kafka-engineering-for-150-billion-messages-per-day)

#### 도입 배경 (Before State)
- **2억 명** 월간 활성 사용자 (MAU)
- 피크 시 **초당 100만 메시지** 유입 (TalkOperation 토픽)
- 전사 데이터 파이프라인: 일 **1,500억 건** 메시지 (초당 300만 건)
- talk-dispatcher: 백그라운드 작업 처리 컴포넌트 → 교체 필요
- 시스템 간 이벤트 전달 방식이 통일되지 않음

#### Why: 왜 Kafka Streams를 선택했는가
- IMF 프로젝트 목표: (1) 시스템 간 통합 이벤트 전달 파이프라인, (2) talk-dispatcher 교체
- **Apache Samza 먼저 시도** → 코어 인프라 적용 시 문제 발견
  - Samza는 "실행 프레임워크"라 서비스에 직접 통합이 어려움
- **Kafka Streams의 결정적 장점**: 프레임워크가 아닌 **라이브러리**
  - 기존 애플리케이션에 직접 통합 가능
  - 별도 실행 클러스터 불필요
  - 서비스 성능/안정성에 직접 영향을 주는 코어 인프라에 적합
- Kafka 커뮤니티의 빠른 응답 + 오픈소스 기여 용이

#### 핵심 아키텍처 결정
- **토픽 리플리케이터**: map/filter 연산을 적용하며 토픽 복제
  - 전체 메시지 중 필요한 카테고리만 파생 토픽으로 필터링
  - Consumer의 불필요한 메시지 소비 제거 → 네트워크/리소스 절감
- **High-level DSL API** 활용 (Scala 컬렉션 API와 유사)
- 전담 Kafka 엔지니어링 팀 운영:
  - 아키텍처/사용법 컨설팅
  - 클러스터 안정성 엔지니어링
  - SLO 위반 시 트러블슈팅
  - 버그 수정/성능 개선 패치

#### 결과 및 성과
- 초당 100만 메시지 안정적 처리 (코어 토픽)
- 전사 일 1,500억 메시지 파이프라인 운영
- Apache Kafka 오픈소스 기여 (KAFKA-7504, KAFKA-4614 등)
- 통합된 이벤트 전달 파이프라인 확보
- multi-IDC 배포 지원

#### 트레이드오프 및 어려움
- Samza → Kafka Streams 전환 비용 (기술 선택 실패 경험)
- 전담 Kafka 엔지니어링 팀 필요 (상시 컨설팅/운영)
- 커스텀 패치 유지보수 부담
- 이 규모에서는 Kafka 자체의 한계도 직면 (패치 필요)

#### 측정 지표
- 초당 메시지 처리량 (TPS): 100만/초 (코어), 300만/초 (전사)
- 일간 메시지 총량: 1,500억 건
- SLO 기반 성능 모니터링
- 네트워크 트래픽/리소스 사용량 (필터링 전후 비교)

---

### Case 4: 올리브영 (Olive Young) - 품절 시스템 현대화

**출처:**
- [Kafka Streams 기반 EDA 구축 사례: 올리브영 품절 시스템 현대화 프로젝트 (oliveyoung.tech)](https://oliveyoung.tech/2025-12-15/kafka-streams-for-out-of-stock/)
- [Kafka 메시지 중복 및 유실 케이스별 해결 방법 (oliveyoung.tech)](https://oliveyoung.tech/2024-10-16/oliveyoung-scm-oms-kafka/)

#### 도입 배경 (Before State)
- 품절 여부 판단: **Oracle 함수 직접 호출** (캐시 없음)
- 모든 트래픽이 DB로 직행 → 지속적 부하
- **올영세일** 같은 대규모 트래픽 시:
  - 품절 정보 조회 지연
  - **온라인몰 전체 서비스 품질 저하**
- DB 내부 로직(Oracle 함수)에 의존하는 일방향 처리 구조

#### Why: 왜 EDA/Kafka Streams를 선택했는가
- DB 부하를 근본적으로 해소해야 함
- 재고 변경 → 품절 판단까지 **실시간 처리** 필요
- 기존 배치 방식의 시간 지연/정합성 문제 해결
- Oracle GoldenGate(OGG) + AWS MSK + Kafka Streams 조합

#### 핵심 아키텍처 결정
- **CDC(Change Data Capture)** 기반: OGG → Kafka → Kafka Streams
- 상품 유형별 처리 분기:
  - 직매입: Inventory Service → Kafka Topic 발행
  - 위수탁/예약/한정: 재고 이벤트 중 "전 소진"/"재입고" 상태 전환 감지 → SoldOut 토픽 발행
- **Kafka Streams의 필터링** 기능 활용 (조인은 비즈니스 복잡도로 간소화)

#### 결과 및 성과
- **Oracle 함수 호출량 86% 감소**
  - Before: 주간 2.34G (23억 4천만 건)
  - After: 주간 237M (2억 3천7백만 건)
- 올영세일 기간 안정적 서비스 제공
- 재고 변경 → 검색 결과 반영까지 **실시간** 처리
- 배치 처리 → 이벤트 기반 전환으로 데이터 정합성 개선

#### 트레이드오프 및 어려움
- 초기 Kafka Streams 조인 기능 활용 기획 → 복잡한 비즈니스 관계로 **간소화** 결정
- Kafka Streams 내부에서 외부 API/DB I/O 호출 시 **지연 증가 + 스트림 효율 저하**
  - 해결: 외부 연동은 별도 비동기 처리로 분리
- OGG + MSK + Kafka Streams 3개 기술 스택 학습/운영 부담
- OMS 프로젝트에서 기존 40건의 EAI/Batch를 Kafka로 전환하는 대규모 마이그레이션

#### 측정 지표
- **Oracle 함수 호출량** (Before/After 비교): 23.4억 → 2.37억 (86% 감소)
- 세일 기간 서비스 안정성
- 재고 변경 → 반영 지연 시간 (배치 vs 실시간)

---

### Case 5: 사람인 (Saramin) - 메일 시스템 Kafka 도입

**출처:**
- [Kafka 설정을 사용한 문제해결 (saramin.github.io)](https://saramin.github.io/2019-09-17-kafka/)

#### 도입 배경 (Before State)
- MSA 구조 개선 프로젝트 중 메일 시스템 구조개선
- 메일 발송 처리를 비동기로 전환 필요

#### Why: 왜 Kafka를 선택했는가
- MSA 전환의 일환으로 서비스 간 비동기 통신 필요
- 대량 메일 발송의 안정적 처리

#### 트레이드오프 및 어려움 (핵심: 디버깅 사례)
- **Consumer Rebalance 중복 처리 문제** 발생:
  - DB 쿼리가 레코드당 **1분 30초~2분** 소요
  - 500개 레코드 처리 시 약 500분 소요
  - `max.poll.interval.ms` 기본값(5분) 초과
  - 브로커가 Consumer 이상 판단 → Consumer Group에서 제외
  - **리밸런스 발생 → 메시지 중복 처리**
- **교훈**: "기능만 가져다 쓰기보단 흐름과 제어 설정에 대한 이해 필요"
  - Kafka 설정의 의미를 이해해야 문제 원인을 빠르게 찾을 수 있음

#### 측정 지표
- Consumer lag
- 리밸런스 발생 빈도
- 메시지 중복 처리율

---

### 보조 사례: 카카오 / 네이버파이낸셜

**카카오** ([tech.kakao.com/2023/09/22/techmeet-kafka/](https://tech.kakao.com/2023/09/22/techmeet-kafka/)):
- 광고 스트림 데이터 수집/분석에 Kafka 활용
- 스마트 메시지 서비스 Kafka 적용
- Exactly Once / At Least Once / At Most Once 전달 보장 수준별 적용
- KEMI (전사 모니터링 시스템)에서 Kafka 활용

**네이버파이낸셜** ([medium.com/naverfinancial/k8s에서-카프카-리밸런싱-방지하기](https://medium.com/naverfinancial/k8s%EC%97%90%EC%84%9C-%EC%B9%B4%ED%94%84%EC%B9%B4-%EB%A6%AC%EB%B0%B8%EB%9F%B0%EC%8B%B1-%EB%B0%A9%EC%A7%80%ED%95%98%EA%B8%B0-c9452a239c28)):
- Kubernetes 환경에서 Kafka 리밸런싱 방지 전략
- Static Membership 적용
- `session.timeout.ms` 튜닝

---

## 2. 공통 도입 패턴 (Common Adoption Patterns)

### 2-1. 도입 동기 유형

| 패턴 | 해당 기업 | 설명 |
|------|-----------|------|
| **모놀리스 → MSA 전환** | 쿠팡, 올리브영 | 강결합 해소가 핵심 동기 |
| **DB 부하 해소** | 올리브영 | DB 직접 호출 → 이벤트 기반 실시간 처리 |
| **대규모 트래픽 처리** | 배민, LINE | 이미 MSA 상태에서 이벤트 처리량 증가 대응 |
| **통합 데이터 파이프라인** | LINE | 시스템 간 이벤트 전달 통합 |
| **비동기 처리 전환** | 사람인 | 동기 처리의 한계 극복 |

### 2-2. 기술 선택 패턴

| 결정 | 기업 | 이유 |
|------|------|------|
| **Kafka (매니지드/자체 운영)** | 배민, LINE, 올리브영, 카카오 | 대규모 처리량, 내구성, 생태계 |
| **인하우스 MQ** | 쿠팡 (Vitamin MQ) | 특수한 트랜잭션 분해 요구사항 |
| **Kafka Streams** | LINE, 올리브영 | 라이브러리 방식 (별도 클러스터 불필요) |
| **Transactional Outbox + Debezium** | 배민 | DB 트랜잭션-이벤트 원자성 보장 |
| **CDC (OGG/Debezium)** | 올리브영, 배민 | DB 변경 감지 → 이벤트 발행 |

### 2-3. 공통적인 점진적 접근

모든 사례에서 **Big Bang 전환이 아닌 점진적 전환** 패턴을 확인:
1. 핵심 도메인 한두 개부터 시작
2. 운영 경험 축적 후 확대
3. 전담 팀(또는 전담 인력) 확보

---

## 3. 공통 트레이드오프 (Common Trade-offs)

### 3-1. 기술적 트레이드오프

| 트레이드오프 | 실제 사례 | 영향도 |
|-------------|-----------|--------|
| **디버깅 복잡도 증가** | 사람인 (리밸런스 중복처리), 배민 (2년간 41건 장애) | 높음 |
| **최종적 일관성(Eventual Consistency)** | 모든 기업 공통 | 높음 - 비즈니스 설계 변경 필요 |
| **메시지 중복/유실 처리** | 사람인, 올리브영, 배민 | 높음 - 멱등성 설계 필수 |
| **Kafka 설정 복잡도** | 사람인, 네이버파이낸셜 | 중간 - 학습 비용 |
| **리밸런싱 성능 저하** | 사람인, 네이버파이낸셜 | 중간 - K8s 환경에서 더 빈번 |
| **스키마 진화 관리** | 글로벌 금융 사례 ($2.9M 정합성 비용) | 높음 |

### 3-2. 조직적 트레이드오프

| 트레이드오프 | 실제 사례 | 대응 |
|-------------|-----------|------|
| **전문 인력 필요** | LINE (전담 Kafka 팀), 배민 (전담팀 지원) | Kafka 전담 팀/담당자 필수 |
| **학습 비용** | 사람인, 올리브영 (OGG+MSK+Streams 3개 기술) | 점진적 도입 + 학습 기간 확보 |
| **운영 비용 증가** | 글로벌 사례 (40% 증가), 밀당영어 (MSK 비용) | 매니지드 서비스 vs 자체 운영 비교 |
| **Zookeeper 이중 관리** | 일반적 Kafka 운영 | KRaft 모드 전환 고려 |
| **오버 엔지니어링 위험** | 글로벌 사례 ($300K 투자 → 디버깅 3배) | Bounded Context EDA 적용 |

### 3-3. 핵심 경고: "The Hidden Cost of Event-Driven Everything"

**출처:** [DEV Community - Hidden Cost of EDA](https://dev.to/carlosinfantes/the-hidden-cost-of-event-driven-architecture-why-decoupling-can-triple-your-debugging-time-58m)

> "50+ 프로젝트 경험에서, EDA 전환 후 디버깅 복잡도는 기하급수적으로 증가했다."
> "$300,000 투자 → 6개월 후 디버깅 시간 3배, 운영 비용 40% 증가"

**EDA를 쓰면 안 되는 경우:**
- 30% 이상의 핵심 경로가 **즉각적 일관성** 필요 시
- 낮은 처리량 (moderate throughput) 시스템
- 도메인 분할이 명확하지 않은 경우

**권장 점진적 접근:**
1. Modular Monolith (도메인 경계 명확화)
2. Synchronous Services (스케일링 압박 있는 곳만 분리)
3. Targeted Asynchrony (특정 고가치 유즈케이스에만 메시징 도입)
4. Full Event-Driven Ecosystem (크로스 도메인 워크플로 정당화 시에만)

---

## 4. 평가/측정 인사이트 (Evaluation & Measurement)

### 4-1. 사례에서 확인된 실제 측정 지표

| 기업 | 측정한 지표 | 수치 |
|------|-----------|------|
| **배민** | 일간 주문 건수 | 10만 → 300만 건/일 |
| **배민** | 장애 건수 (2년간) | 41건 (치명적 3건) |
| **배민** | 트래픽 처리 배수 | 1x → 3x |
| **쿠팡** | 일간 배포 횟수 | 100~200 서비스/일 |
| **쿠팡** | 일간 인스턴스 구성 | 2,000+/일 |
| **LINE** | 초당 메시지 처리량 (코어) | 100만 msg/sec |
| **LINE** | 일간 메시지 총량 | 1,500억 건 |
| **올리브영** | Oracle 함수 호출 감소율 | 86% 감소 (23.4억 → 2.37억/주) |

### 4-2. EDA 평가 프레임워크

**출처:**
- [EDA Performance Optimization (Medium)](https://solutionsarchitecture.medium.com/event-driven-performance-optimization-balancing-throughput-latency-and-reliability-22e33e372243)
- [Next-Gen EDA Architectures (arxiv)](https://arxiv.org/html/2510.04404)
- [Datadog - Monitoring EDA Best Practices](https://www.datadoghq.com/blog/monitor-event-driven-architectures/)
- [SLO Monitoring of EDA (Medium)](https://medium.com/@debyroth340/slo-monitoring-of-event-driven-architectures-b35d2a2d8043)

#### 필수 측정 지표 (Core Metrics)

| 카테고리 | KPI | 설명 | PoC 적용 가능성 |
|---------|-----|------|----------------|
| **처리량 (Throughput)** | Events/sec (TPS) | 초당 이벤트 처리 건수 | ✅ 필수 |
| **지연 시간 (Latency)** | p50, p90, p95, p99 | End-to-end 이벤트 전달 시간 | ✅ 필수 |
| **신뢰성 (Reliability)** | 성공률 (%), 에러율 | 메시지 손실/중복 비율 | ✅ 필수 |
| **Consumer 건강** | Kafka Lag | Consumer Offset 지연 정도 | ✅ 측정 용이 |
| **결합도 (Coupling)** | 서비스 의존성 수 | 독립 배포 가능 여부 | ⚠️ 정성 평가 |
| **SLO 준수** | 처리 시간 vs SLA 목표 | Error Budget 소진율 | ⚠️ PoC에서는 간단히 |

#### Throughput vs Latency 트레이드오프

> "처리량을 높이면 배치 처리/병렬화가 필요해 지연이 늘 수 있고,
> 지연을 줄이면 재시도/에러 핸들링이 줄어 신뢰성이 저하될 수 있다."

이 균형을 어떻게 맞추는가가 핵심 아키텍처 결정.

#### 벤치마크 참고 수치 (업계 기준)

| 플랫폼 | 처리량 | 지연 (p95) | 비고 |
|--------|--------|-----------|------|
| Kafka (이상적 조건) | 200만 msg/sec | - | 1KB 메시지, 무제한 배치 |
| NATS JetStream | 80만 msg/sec | 15ms | 경량 대안 |
| RabbitMQ | 20~50만 msg/sec | - | 적절한 클러스터 구성 시 |
| Kafka (실전, Apache 기준) | 120만 msg/sec | 18ms (p95) | 2.3 FTE 운영 인력 필요 |

#### Kafka 운영 복잡도 통계

- **78%의 조직**이 최적 구성을 위한 전문성 부족 보고
- 평균 **23개의 설정 파라미터** 워크로드별 튜닝 필요
- 최소 **2.3 FTE** 운영 인력 필요 (Apache Kafka 기준)

### 4-3. 모니터링 도구 스택

| 도구 | 역할 |
|------|------|
| **Prometheus + Grafana** | Consumer lag, 브로커 지연, 처리량 시각화 |
| **OpenTelemetry / Jaeger** | 분산 추적 (Correlation ID 기반) |
| **Datadog / New Relic** | Kafka/Pulsar 네이티브 통합, 처리량/lag/Consumer 건강 |
| **Kafka Exporter** | Prometheus용 Kafka 메트릭 수집 |

---

## 5. PoC 권장사항 (Based on Case Studies)

### 5-1. PoC가 증명해야 할 EDA 핵심 가치

사례들에서 도출된 EDA의 핵심 가치 3가지:

| # | 핵심 가치 | 사례 근거 | PoC 검증 방법 |
|---|----------|-----------|--------------|
| 1 | **느슨한 결합 (Decoupling)** | 쿠팡: 주문-결제-배송 분리, 배민: 서비스 간 독립 | Producer/Consumer 독립 배포/장애 격리 시연 |
| 2 | **비동기 처리 성능 향상** | 올리브영: DB 호출 86% 감소, 배민: 3배 트래픽 | 동기 vs 비동기 처리 시간/TPS 정량 비교 |
| 3 | **장애 격리 (Fault Isolation)** | 쿠팡: Vitamin MQ DLQ, 배민: 장애 도메인 분리 | Consumer 중단 시 Producer 영향 없음 시연 |

### 5-2. 최소 PoC 시나리오 설계

**사례 기반 추천: "주문 → 재고 차감" 이벤트 흐름**

배민, 쿠팡, 올리브영 모두 주문/재고 도메인에서 EDA를 핵심적으로 활용.
이 도메인이 PoC에 적합한 이유:
- 이해하기 쉬운 비즈니스 로직
- 동기/비동기 비교가 명확
- 장애 격리 시연이 자연스러움

```
[최소 PoC 구성]

Producer (주문 서비스) → Kafka Topic → Consumer (재고 서비스)
    |                                       |
    v                                       v
  주문 DB                               재고 DB
```

### 5-3. PoC 검증 체크리스트

사례에서 도출된 핵심 검증 항목:

| # | 검증 항목 | 성공 기준 | 사례 근거 |
|---|----------|----------|-----------|
| 1 | **이벤트 발행/소비** | OrderCreated → 재고 차감 정상 동작 | 모든 사례의 기본 |
| 2 | **동기 vs 비동기 성능 비교** | 비동기가 N% 이상 빠름 (TPS 기준) | 올리브영: 86% DB 호출 감소 |
| 3 | **장애 격리** | Consumer 중단 시 Producer 정상 + 복구 후 재처리 | 쿠팡: DLQ 기반 |
| 4 | **메시지 순서 보장** | 같은 주문의 이벤트 순서 유지 | 배민: 파티션 키 기반 |
| 5 | **멱등성 처리** | 중복 메시지 수신 시 중복 처리 방지 | 사람인: 리밸런스 교훈 |
| 6 | **정량 지표 대시보드** | TPS, Latency(p50/p95), Consumer Lag 시각화 | LINE: SLO 기반 |

### 5-4. PoC에서 하지 않을 것 (Over-engineering 방지)

사례에서 배운 "과도한 범위" 경고:

| 하지 않을 것 | 이유 | 대안 |
|-------------|------|------|
| Exactly Once Semantics | 배민이 오히려 **제거**함, 복잡도 대비 가치 낮음 | At Least Once + 멱등성 |
| 이벤트 소싱 (Event Sourcing) | 올리브영도 Streams 조인을 간소화함 | 단순 이벤트 발행/소비 |
| CQRS | PoC 범위 초과 | 단일 DB 모델 |
| Saga Pattern | 2주 제약 내 구현 어려움 | 단일 트랜잭션 + 이벤트 알림 |
| 스키마 레지스트리 | 초기 PoC에서는 불필요 | JSON 직렬화 |
| Kafka Connect / Debezium | 학습 비용 높음 (배민도 팀 비용 고려) | 애플리케이션 레벨 이벤트 발행 |

### 5-5. PoC 성공 기준 (KPI)

사례 기반 정량 지표 3~5개:

| KPI | 측정 방법 | 목표 |
|-----|----------|------|
| **처리 시간 비교** | 동기 API vs Kafka 비동기, 동일 시나리오 | 비동기가 측정 가능하게 빠름 |
| **TPS (처리량)** | 동시 요청 수 증가 시 처리량 비교 | 비동기 TPS > 동기 TPS |
| **장애 격리** | Consumer 중단 → Producer 정상 여부 | Producer 100% 정상 동작 |
| **Consumer Lag** | Kafka 모니터링 | 부하 시 lag 증가 → 감소 패턴 확인 |
| **메시지 유실율** | 발행 건수 vs 소비 건수 비교 | 0% 유실 |

---

## 6. 핵심 요약 (Executive Summary)

### 한 줄 요약
> **EDA/Kafka는 "대규모 트래픽 + 서비스 간 결합 해소"가 명확한 문제일 때 강력하지만,
> 디버깅 복잡도와 운영 비용이라는 대가를 반드시 지불한다.**

### 사례에서 배운 5가지 원칙

1. **점진적으로 도입하라** - 모든 기업이 한두 개 도메인부터 시작 (Big Bang 없음)
2. **Exactly Once보다 At Least Once + 멱등성** - 배민이 Exactly Once를 오히려 제거
3. **Kafka 설정의 깊은 이해가 필수** - 사람인 사례: 설정 무지 → 중복 처리 장애
4. **전담 인력 또는 매니지드 서비스 필수** - LINE: 전담 팀, 밀당: MSK 선택
5. **Bounded Context EDA** - 전체가 아닌 비동기가 자연스러운 도메인에만 적용

### PoC 적용 시사점

이 사례 조사 결과를 기존 `2w-brainstorm.md`의 PoC 설계에 반영:

- **도메인 선택**: 주문 → 재고 (사례 5개 중 4개가 이 도메인 활용)
- **핵심 검증**: 동기 vs 비동기 성능 비교 + 장애 격리 (가장 높은 증명 가치)
- **범위 제한**: At Least Once + 멱등성 (Exactly Once는 제외)
- **측정 지표**: TPS, Latency(p50/p95), Consumer Lag, 메시지 유실율
- **과도한 범위 경고**: Event Sourcing, CQRS, Saga는 PoC 범위 밖
