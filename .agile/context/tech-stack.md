# Tech Stack - EDA PoC Sprint 1 (US-1.1)

## 한눈에 결론
- 최종 채택 스택 요약: Java 21 + Spring Boot 3.5 + Gradle 멀티모듈 + Kafka(KRaft) + Docker Compose + AKHQ + JUnit5/Testcontainers
- 채택 기준: 2주 PoC에서 재현 가능성, 학습 곡선, 로컬 실행 단순성을 우선
- 보류/제외 기술: Spring Cloud Gateway/Eureka, Schema Registry, Debezium, Streams 기반 고급 처리

---

## 1) 최종 스택
### 1-1. 런타임/언어
- 언어: Java
- 런타임/버전: JDK 21 (LTS)

### 1-2. 프레임워크
- 서버: Spring Boot 3.5.x (`spring-boot-starter-web`, `spring-kafka`, `spring-boot-starter-actuator`)
- 클라이언트(있다면): 없음 (백엔드 PoC)

### 1-3. 데이터/스토리지
- DB: H2 (서비스별 로컬 내장 DB, PoC 단순화 목적)
- 캐시: 없음 (Phase-2 이후 필요 시 검토)
- 메시징(있다면): Apache Kafka (KRaft 단일 브로커)

### 1-4. 인프라/도구
- 컨테이너/배포: Docker Compose v2
- CI/CD: 보류 (로컬 우선, Phase-2 이후 최소 CI 추가 검토)
- 관측성/로깅: Actuator + AKHQ, 구조화 로그(JSON) 최소 적용

## 2) 테스트 전략 연계
- 단위 테스트: JUnit5 + AssertJ
- 통합 테스트: Spring Boot Test + Testcontainers(Kafka)
- E2E 테스트: curl smoke + (Phase-2) k6 시나리오
- 목/스텁/픽스처 도구: Mockito, JSON fixture 파일
- 커버리지/리포팅 도구: JaCoCo (선택)
- 방법론: TDD-lite (핵심 로직 우선)
- 시나리오 작성 규칙: US 단위로 정상/실패/엣지 케이스 분리

## 3) 후보 비교
| 영역 | 후보 | 채택 여부 | 근거 |
| --- | --- | --- | --- |
| 언어/런타임 | Java 21, Kotlin 2.x | Java 21 채택 | Spring/Kafka 예제와 자료가 가장 풍부하고 팀 기존 학습 산출물과 정합성이 높음 |
| 빌드 | Gradle 멀티모듈, Maven 멀티모듈 | Gradle 채택 | 다중 서비스 스캐폴딩과 공통 설정 재사용에 유리 |
| 서버 프레임워크 | Spring Boot, Micronaut, Quarkus | Spring Boot 채택 | `spring-kafka` 공식 통합 레퍼런스가 가장 직접적 |
| 메시징 | Kafka, RabbitMQ, NATS | Kafka 채택 | 이번 PoC의 핵심 목표(EDA/Kafka 경험)와 직접 일치 |
| Kafka UI | AKHQ, Kafdrop, Redpanda Console | AKHQ 채택 | 토픽/컨슈머 그룹 확인에 필요한 기능을 빠르게 제공 |
| 통합 테스트 | Testcontainers, Embedded Kafka 단독 | Testcontainers 채택 | 실제 Kafka 컨테이너 기반 검증으로 로컬/CI 일관성 확보 |

## 4) 의사결정 기준
- 기능 요구:
  - 동기/비동기 주문 흐름을 나란히 구현하고 같은 시나리오로 비교
  - Kafka Fan-out 이벤트 발행/소비 구조 구현
  - Docker Compose 기반 원클릭 실행 환경 제공
- 비기능 요구:
  - 로컬에서 빠른 부트스트랩 가능
  - 서비스 간 책임 분리와 장애 영향 범위가 명확해야 함
  - 스프린트 내 문서-코드-테스트 경로가 단순해야 함
- 제약(시간/인력/예산): 2주, 1인, PoC 수준

---

## 부록) 조사 로그 (필요 시만 작성)
- 검색 기간: 2026-03-05
- 참고 링크:
  - Spring for Apache Kafka Reference: https://docs.spring.io/spring-kafka/reference/
  - Spring Boot Documentation: https://docs.spring.io/spring-boot/index.html
  - Gradle Multi-Project Builds: https://docs.gradle.org/current/userguide/multi_project_builds.html
  - Docker Compose File Reference: https://docs.docker.com/reference/compose-file/
  - Testcontainers Kafka Module: https://java.testcontainers.org/modules/kafka/
  - Grafana k6 Docs: https://grafana.com/docs/k6/latest/
  - AKHQ: https://akhq.io/
- 제외한 후보와 사유:
  - Spring Cloud Gateway/Eureka: 서비스 수(6개 PoC) 대비 운영 복잡도 과다
  - Debezium/Schema Registry: 현재 스프린트 목표(기반 구축) 범위 초과
