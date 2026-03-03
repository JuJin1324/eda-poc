# Experience - Define 2W

## 목적
- 이 문서는 `define-2w` 실행 전에 빠르게 참고하는 경험 자산이다.

## 사용 규칙
- `status: seeded`는 초기 샘플이다.
- 실전에서 검증된 항목만 `status: validated`로 승격한다.
- 더 이상 유효하지 않으면 `status: deprecated`로 내린다.
- 실행 전에는 `Validated Entries`를 우선 참고한다.

## Seeded Entries

### EXP-001
- status: seeded
- date: 2026-03-03
- situation: 사용자가 해결책(How)만 길게 설명하고 목적은 비어 있던 상황
- signal: 요구사항은 많지만 성공 기준이 계속 바뀜
- choice: How 표현을 걷어내고 What/Why를 1문장씩 재서술해 합의
- result: 질문 수를 줄이고도 다음 단계 진입 결정이 빨라짐
- condition: 문제 정의보다 구현 아이디어가 먼저 쏟아지는 대화
- caution: 팀/프로젝트 맥락이 다르면 그대로 복제하지 말고 조정한다.
- related_artifacts:
  - N/A (seeded)

### EXP-002
- status: seeded
- date: 2026-03-03
- situation: 사례 연구를 매번 켜서 초기 단계 토큰 비용이 과도했던 상황
- signal: 2W 문서보다 사례 메모가 더 길어짐
- choice: 사례 연구 게이트를 두고, 권장/생략 근거 1줄로 먼저 제시
- result: 필요한 경우에만 조사해도 결정 품질 유지
- condition: 레퍼런스가 성공 기준에 직접 영향이 있을 때만 조사
- caution: 지표나 증적 없이 감으로 판단하지 않는다.
- related_artifacts:
  - N/A (seeded)

### EXP-003
- status: seeded
- date: 2026-03-03
- situation: 성공 기준이 여러 개라 우선순위 합의가 어려웠던 상황
- signal: 진행/보류 판단이 회의마다 달라짐
- choice: 성공 기준 1개 + 경계 1개만 확정
- result: GO/HOLD 판단 기준이 명확해짐
- condition: 초기 루프에서 빠른 실행/학습이 필요한 경우
- caution: 루프 목표를 벗어나는 확장은 별도 의사결정으로 분리한다.
- related_artifacts:
  - N/A (seeded)

## Validated Entries
- 아직 없음

## Deprecated Entries
- 아직 없음
