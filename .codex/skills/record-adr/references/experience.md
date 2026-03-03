# Experience - Record ADR

## 목적
- 이 문서는 `record-adr` 실행 전에 빠르게 참고하는 경험 자산이다.

## 사용 규칙
- `status: seeded`는 초기 샘플이다.
- 실전에서 검증된 항목만 `status: validated`로 승격한다.
- 더 이상 유효하지 않으면 `status: deprecated`로 내린다.
- 실행 전에는 `Validated Entries`를 우선 참고한다.

## Seeded Entries

### EXP-001
- status: seeded
- date: 2026-03-03
- situation: 기술 선택 근거를 채팅에만 남겨 추적이 끊긴 상황
- signal: 한 달 뒤 동일 논쟁이 반복됨
- choice: 결정 즉시 ADR로 context/decision/why 기록
- result: 재논의 비용 감소
- condition: 대안 2개 이상이 경합하는 선택
- caution: 팀/프로젝트 맥락이 다르면 그대로 복제하지 말고 조정한다.
- related_artifacts:
  - N/A (seeded)

### EXP-002
- status: seeded
- date: 2026-03-03
- situation: 결정은 했지만 영향/부작용을 기록하지 않은 상황
- signal: 후속 변경 시 예상치 못한 파급이 발생
- choice: Consequences(장점/비용) 섹션을 필수로 작성
- result: 변경 영향 예측 정확도 개선
- condition: 기반 라이브러리나 아키텍처 레벨 결정
- caution: 지표나 증적 없이 감으로 판단하지 않는다.
- related_artifacts:
  - N/A (seeded)

### EXP-003
- status: seeded
- date: 2026-03-03
- situation: 예전 ADR이 더 이상 유효하지 않은데 상태 갱신이 없던 상황
- signal: 구현과 ADR 내용이 불일치
- choice: Deprecated 또는 Superseded 상태로 즉시 갱신
- result: 문서 신뢰도 유지
- condition: 새 결정이 기존 결정을 대체했을 때
- caution: 루프 목표를 벗어나는 확장은 별도 의사결정으로 분리한다.
- related_artifacts:
  - N/A (seeded)

## Validated Entries
- 아직 없음

## Deprecated Entries
- 아직 없음
