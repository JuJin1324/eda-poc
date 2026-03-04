# Experience - Migrate Legacy Artifacts

## 목적
- 이 문서는 `migrate-legacy-artifacts` 실행 전에 빠르게 참고하는 경험 자산이다.

## 사용 규칙
- `status: seeded`는 초기 샘플이다.
- 실전에서 검증된 항목만 `status: validated`로 승격한다.
- 더 이상 유효하지 않으면 `status: deprecated`로 내린다.
- 실행 전에는 `Validated Entries`를 우선 참고한다.

## Seeded Entries

### EXP-001
- status: seeded
- date: 2026-03-04
- situation: 바로 apply를 실행해 기존 신버전 산출물을 덮어쓸 위험이 있었던 상황
- signal: 대상 경로에 이미 파일이 있는데 최신성 비교가 끝나지 않음
- choice: dry-run을 기본으로 먼저 실행해 충돌 상태를 확인
- result: 덮어쓰기 여부를 근거 기반으로 결정
- condition: 기존 loop 산출물이 일부 존재하는 프로젝트
- caution: dry-run 결과만 보고 자동 덮어쓰기를 기본값으로 바꾸지 않는다.
- related_artifacts:
  - N/A (seeded)

### EXP-002
- status: seeded
- date: 2026-03-04
- situation: 자동 루프 감지가 의도와 다른 loop를 선택할 수 있는 상황
- signal: 최신 loop는 실험 중인데 과거 레거시 문서는 다른 loop 맥락임
- choice: 중요한 마이그레이션은 `--loop N`을 명시
- result: 문서가 잘못된 loop에 섞이는 사고를 방지
- condition: 여러 loop를 병행 운영하는 프로젝트
- caution: loop를 명시했더라도 대상 경로와 목적을 1회 더 검증한다.
- related_artifacts:
  - N/A (seeded)

### EXP-003
- status: seeded
- date: 2026-03-04
- situation: 레거시 파일명은 맞지만 문서 내부 섹션 구조가 신버전과 다른 상황
- signal: 스킬 입력은 통과했지만 실행 중 수동 보정이 반복됨
- choice: 마이그레이션 후 즉시 문서 구조 점검 체크를 수행
- result: 후속 스킬 실행 중단 없이 연속 진행 가능
- condition: 오래된 템플릿에서 생성된 문서를 재사용할 때
- caution: 파일명 정렬만으로 내용 정합성이 보장된다고 가정하지 않는다.
- related_artifacts:
  - N/A (seeded)

## Validated Entries
- 아직 없음

## Deprecated Entries
- 아직 없음
