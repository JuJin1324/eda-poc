# Experience - Manage Experience

## 목적
- 이 문서는 `manage-experience` 실행 전에 빠르게 참고하는 경험 자산이다.

## 사용 규칙
- `status: seeded`는 초기 샘플이다.
- 실전에서 검증된 항목만 `status: validated`로 승격한다.
- 더 이상 유효하지 않으면 `status: deprecated`로 내린다.
- 실행 전에는 `Validated Entries`를 우선 참고한다.

## Seeded Entries

### EXP-001
- status: seeded
- date: 2026-03-03
- situation: 초기 샘플 없이 시작해 기록 형식이 스킬마다 달라진 상황
- signal: 경험 문서를 읽어도 재사용 조건을 찾기 어려움
- choice: seed 단계에서 공통 포맷 + 샘플 3개를 일괄 생성
- result: 기록 시작 장벽이 낮아짐
- condition: 새 스킬 세트를 처음 운영할 때
- caution: 팀/프로젝트 맥락이 다르면 그대로 복제하지 말고 조정한다.
- related_artifacts:
  - N/A (seeded)

### EXP-002
- status: seeded
- date: 2026-03-03
- situation: seeded와 validated를 섞어 의사결정 근거가 약해진 상황
- signal: 검증되지 않은 패턴이 우선 적용됨
- choice: status를 seeded/validated/deprecated로 분리
- result: 근거 신뢰도 향상
- condition: 경험 문서를 실제 계획 판단에 사용할 때
- caution: 지표나 증적 없이 감으로 판단하지 않는다.
- related_artifacts:
  - N/A (seeded)

### EXP-003
- status: seeded
- date: 2026-03-03
- situation: 경험 문서가 길어져 실행 전 읽기 부담이 커진 상황
- signal: 팀이 문서를 참고하지 않고 건너뜀
- choice: 실행 전에는 validated 상위 3개만 확인
- result: 참조 비용을 줄이면서 재사용률 유지
- condition: 스프린트 시작 전 빠른 의사결정이 필요할 때
- caution: 루프 목표를 벗어나는 확장은 별도 의사결정으로 분리한다.
- related_artifacts:
  - N/A (seeded)

## Validated Entries
- 아직 없음

## Deprecated Entries
- 아직 없음
