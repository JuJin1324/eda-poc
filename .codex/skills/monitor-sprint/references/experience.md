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
- situation: status 문서가 없어 스프린트 진행률 집계가 불가능했던 상황
- signal: loop에 design-phase는 있지만 sprint/02-sprint-status.md가 없음
- choice: monitor-sprint가 design-phase 기반으로 status 문서를 초기 생성
- result: 스프린트 추적 시작 지점 확보
- condition: 새 loop를 시작한 직후
- caution: 지표나 증적 없이 감으로 판단하지 않는다.
- related_artifacts:
  - N/A (seeded)

### EXP-003
- status: seeded
- date: 2026-03-03
- situation: Blocker를 별도 채널에만 기록해 현황 문서와 분리된 상황
- signal: 회의 시 blocker 최신 상태를 찾는 시간이 길어짐
- choice: 02-sprint-status.md의 Risks/Blockers 섹션을 단일 소스로 사용
- result: 모니터링 결과와 대응 논의가 즉시 연결됨
- condition: 외부 의존 이슈가 잦은 스프린트
- caution: 루프 목표를 벗어나는 확장은 별도 의사결정으로 분리한다.
- related_artifacts:
  - N/A (seeded)

## Validated Entries
- 아직 없음

## Deprecated Entries
- 아직 없음
