# Java DDD + Clean Architecture 코드 컨벤션 (초안)

## 1) 목적
- 백엔드 Java 구현에서 도메인 규칙을 프레임워크/DB/UI와 분리한다.
- DDD 경계(애그리거트, 리포지토리, 도메인 이벤트)를 코드 규칙으로 강제한다.
- 포맷/정적분석/아키텍처 테스트를 CI에 포함해 일관성을 자동화한다.

## 2) 적용 범위
- 언어: Java 17+ (권장)
- 프레임워크: Spring Boot 기반 백엔드
- 아키텍처: DDD + Clean Architecture + (선택) Spring Modulith

## 3) 핵심 원칙
- 의존 방향은 안쪽(도메인/유스케이스)으로만 향한다.
- 도메인 모델은 프레임워크 어노테이션/외부 구현체 세부사항에 의존하지 않는다.
- 애그리거트 경계 안에서 일관성을 보장하고, 트랜잭션은 애그리거트 경계를 넘지 않는다.
- 리포지토리는 도메인 관점의 컬렉션 인터페이스처럼 다룬다.

## 4) 패키지 규칙
옵션 A. Clean 명칭:
```text
src/main/java/com/acme/app/
├─ order/                         # 모듈(기능/도메인 경계)
│  ├─ domain/
│  │  ├─ model/                   # Aggregate, Entity, Value Object
│  │  ├─ event/                   # Domain Event
│  │  ├─ service/                 # Domain Service
│  │  └─ repository/              # 도메인 Repository 인터페이스
│  ├─ application/
│  │  ├─ port/in/                 # UseCase 입력 포트
│  │  ├─ port/out/                # 외부 의존 출력 포트
│  │  ├─ usecase/                 # UseCase 구현
│  │  └─ dto/                     # Command/Query DTO
│  ├─ adapter/
│  │  ├─ in/web/                  # REST Controller
│  │  ├─ out/persistence/         # JPA Adapter
│  │  └─ out/external/            # 외부 API/메시징 Adapter
└─ common/
   ├─ config/
   └─ support/
```

옵션 B. Layered 명칭(실제 의존 규칙은 Clean과 동일):
```text
src/main/java/com/acme/app/
├─ order/
│  ├─ domain/                     # Clean의 domain
│  ├─ service/                    # Clean의 application(use case)
│  ├─ controller/                 # Clean의 adapter.in
│  └─ infrastructure/             # Clean의 adapter.out
└─ common/
```

규칙:
- 기본 단위는 `layer-first`가 아니라 `모듈(feature/bounded context)-first`.
- `controller/infrastructure`는 `service/domain`에 의존 가능, 역방향 의존 금지.
- `service`는 `domain`에만 의존하고 `controller`/`infrastructure`에 의존하지 않는다.
- 모듈 간 호출은 공개된 `service` 인터페이스(또는 이벤트)로만 수행한다.
- 비공개 구현 패키지(`impl`, `support`, `detail` 등)는 외부 모듈 import 금지 규칙으로 관리한다.

## 5) 계층별 코딩 규칙

### Domain
- 상태 변경은 애그리거트 루트 메서드로만 수행.
- Value Object는 불변(`final` 필드, 변경 메서드 없음) + 생성 시 검증.
- 도메인 예외는 기술 예외를 숨기고 비즈니스 용어로 명명.
- 도메인 계층에 `@Entity`, `@Repository`, `@Service` 등 Spring 의존 금지.

### Service (UseCase)
- 유스케이스는 오케스트레이션 전담, 핵심 비즈니스 규칙은 Domain으로 위임.
- 입력/출력 모델은 `record` 우선 검토.
- 트랜잭션 경계는 UseCase 메서드에 명시.
- `port.out`을 통해서만 DB/외부 시스템 접근.

### Controller / Infrastructure
- Web Adapter는 DTO 검증/매핑만, 도메인 규칙 구현 금지.
- Persistence Adapter는 JPA 엔티티와 도메인 객체 매핑 책임만 가진다.
- 외부 API Adapter는 재시도/타임아웃/예외 매핑을 캡슐화한다.

## 6) 네이밍/스타일 규칙
- 클래스: 명사형 (`Order`, `OrderRepository`, `CreateOrderUseCase`)
- 메서드: 동사형 (`placeOrder`, `cancel`, `findById`)
- 불리언: `is/has/can` 접두사 사용
- 예외: 도메인 의미 중심 (`OrderAlreadyShippedException`)
- 와일드카드 import 금지, 라인 길이 100자 기준
- 포맷터는 `google-java-format` 단일 채택(개별 포맷 옵션 커스터마이징 금지)

## 7) 리포지토리/영속성 규칙
- Clean 명칭 사용 시: 리포지토리 인터페이스는 `domain` 또는 `application.port.out`, 구현체는 `adapter.out.persistence`.
- Layered 명칭 사용 시: 리포지토리 인터페이스는 `domain` 또는 `service`, 구현체는 `infrastructure.persistence`.
- 리포지토리 메서드는 도메인 언어 중심으로 정의하고, 범용 CRUD 노출 최소화.
- 동적 검색은 Specification/Query 객체로 캡슐화한다.

## 8) 도메인 이벤트 규칙
- 이벤트 발행 주체는 애그리거트 루트.
- 이벤트 클래스는 과거형 도메인 사실로 명명 (`OrderPlaced`, `PaymentFailed`).
- 이벤트 페이로드는 최소화하고 식별자 + 핵심 값만 포함.

## 9) 테스트/검증 규칙
- 테스트 우선순위: Domain 단위 테스트 -> UseCase 테스트 -> Adapter 통합 테스트.
- 아키텍처 규칙은 ArchUnit 테스트로 자동 검증:
  - `domain` -> `service/controller/infrastructure` 의존 금지
  - `service` -> `controller` 의존 금지
  - 모듈 간 비공개 구현 패키지(`impl`, `support`, `detail`) 접근 금지
- CI 정적 검증 기본 세트:
  - Checkstyle (코딩 규약)
  - SpotBugs (버그 패턴)
  - Error Prone (컴파일 단계 정적 검증, 실행 JDK 21+ 요구)

## 10) PR 체크리스트
- [ ] 애그리거트 경계와 트랜잭션 경계가 일치한다.
- [ ] 도메인 계층에 프레임워크 의존이 없다.
- [ ] UseCase는 포트를 통해서만 외부 의존을 사용한다.
- [ ] 아키텍처 테스트(ArchUnit)와 정적 분석(Checkstyle/SpotBugs/Error Prone)을 통과했다.
- [ ] 코드 포맷이 `google-java-format`으로 정렬되었다.

## 11) 도입 순서(권장)
1. 포맷 표준 고정: `google-java-format`
2. 최소 규약 도입: Checkstyle + SpotBugs
3. 아키텍처 규약 테스트 추가: ArchUnit
4. 모듈 경계 강화: Spring Modulith 검증/문서화 도입
5. 필요 시 Error Prone 확장

## 12) 근거 문서
- Google Java Style Guide: https://google.github.io/styleguide/javaguide.html
- google-java-format: https://github.com/google/google-java-format
- Clean Architecture (Robert C. Martin 글): https://blog.cleancoder.com/uncle-bob/2011/11/22/Clean-Architecture.html
- Martin Fowler - Repository: https://martinfowler.com/eaaCatalog/repository.html
- Martin Fowler - DDD Aggregate: https://martinfowler.com/bliki/DDD_Aggregate.html
- Spring Data JPA (Core Concepts): https://docs.spring.io/spring-data/jpa/reference/repositories/core-concepts.html
- Spring Data JPA (Domain Events): https://docs.spring.io/spring-data/jpa/reference/repositories/core-domain-events.html
- Spring Data JPA (Specifications): https://docs.spring.io/spring-data/jpa/reference/jpa/specifications.html
- Spring Modulith Reference: https://docs.spring.io/spring-modulith/reference/index.html
- ArchUnit User Guide: https://www.archunit.org/userguide/html/000_Index.html
- Checkstyle: https://checkstyle.sourceforge.io/
- SpotBugs: https://spotbugs.github.io/
- Error Prone: https://errorprone.info/docs/installation
