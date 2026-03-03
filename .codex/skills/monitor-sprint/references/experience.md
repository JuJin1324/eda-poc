# Experience - Monitor Sprint

## 목적
- 이 문서는 `monitor-sprint` 실행 전에 빠르게 참고하는 경험 자산이다.

## 사용 규칙
- `status: seeded`는 초기 샘플이다.
- 실전에서 검증된 항목만 `status: validated`로 승격한다.
- 더 이상 유효하지 않으면 `status: deprecated`로 내린다.
- 실행 전에는 `Validated Entries`를 우선 참고한다.

## Seeded Entries

### EXP-001
- status: seeded
- date: 2026-03-03
- situation: 진행률 숫자만 보고 일정 리스크를 놓친 상황
- signal: 완료율은 높지만 US 목표일을 넘김
- choice: 진행률과 US 일정 상태(Ahead/On-track/Delayed)를 함께 확인
- result: 지연 신호를 조기 감지
- condition: US별 완료 목표일이 정의된 스프린트
- caution: 팀/프로젝트 맥락이 다르면 그대로 복제하지 말고 조정한다.
- related_artifacts:
  - N/A (seeded)

### EXP-002
- status: seeded
- date: 2026-03-03
- situation: In Progress 표기를 팀마다 다르게 써 파싱이 흔들린 상황
- signal: 동일 태스크가 To Do/진행 중으로 번갈아 집계됨
- choice: In Progress 표기 규칙을 스프린트 시작 시 합의
- result: 상태 집계 일관성 향상
- condition: 복수 작업자가 동시에 plan 파일을 수정할 때
- caution: 지표나 증적 없이 감으로 판단하지 않는다.
- related_artifacts:
  - N/A (seeded)

### EXP-003
- status: seeded
- date: 2026-03-03
- situation: Blocker를 별도 채널에만 기록해 현황 문서와 분리된 상황
- signal: 회의 시 blocker 최신 상태를 찾는 시간이 길어짐
- choice: sprint-plan.md의 Blockers 섹션을 단일 소스로 사용
- result: 모니터링 결과와 대응 논의가 즉시 연결됨
- condition: 외부 의존 이슈가 잦은 스프린트
- caution: 루프 목표를 벗어나는 확장은 별도 의사결정으로 분리한다.
- related_artifacts:
  - N/A (seeded)

## Validated Entries
- 아직 없음

## Deprecated Entries
- 아직 없음
