# Experience - Design Phase

## 목적
- 이 문서는 `design-phase` 실행 전에 빠르게 참고하는 경험 자산이다.

## 사용 규칙
- `status: seeded`는 초기 샘플이다.
- 실전에서 검증된 항목만 `status: validated`로 승격한다.
- 더 이상 유효하지 않으면 `status: deprecated`로 내린다.
- 실행 전에는 `Validated Entries`를 우선 참고한다.

## Seeded Entries

### EXP-001
- status: seeded
- date: 2026-03-03
- situation: US를 많이 적어 계획은 커졌지만 실행 우선순위가 흐려진 상황
- signal: 스프린트 시작 전부터 대기 작업이 많아짐
- choice: Phase는 1~3개, 이번 스프린트 US는 1~2개로 제한
- result: 핸드오프 문서가 실행 중심으로 단순화됨
- condition: MVP 범위를 작게 유지해야 하는 초기 단계
- caution: 팀/프로젝트 맥락이 다르면 그대로 복제하지 말고 조정한다.
- related_artifacts:
  - N/A (seeded)

### EXP-002
- status: seeded
- date: 2026-03-03
- situation: In/Out/Unknown 구분 없이 요구사항을 나열한 상황
- signal: 스코프 확장 논쟁이 반복됨
- choice: 항목을 In/Out/Unknown으로 강제 분리
- result: 스프린트 외 항목이 자동으로 차단됨
- condition: 요구사항 출처가 여러 팀/이해관계자로 분산된 경우
- caution: 지표나 증적 없이 감으로 판단하지 않는다.
- related_artifacts:
  - N/A (seeded)

### EXP-003
- status: seeded
- date: 2026-03-03
- situation: 지표를 결과 지표만 두어 중간 점검이 어려웠던 상황
- signal: 종료 시점 전에는 진행 이상을 감지하지 못함
- choice: Leading 1개 + Outcome 1개를 동시에 정의
- result: 중간 점검과 종료 평가가 분리되어 안정됨
- condition: 실행 중 피벗 가능성을 열어둬야 하는 프로젝트
- caution: 루프 목표를 벗어나는 확장은 별도 의사결정으로 분리한다.
- related_artifacts:
  - N/A (seeded)

### EXP-004
- status: seeded
- date: 2026-03-05
- situation: US는 정의됐지만 완료 목표일이 없어 Delivery 일정 상태를 계산하지 못한 상황
- signal: monitor-sprint에서 일정 상태를 전부 기본값(On-track)으로만 표시
- choice: design-phase에서 스프린트 기간 + Phase-1 US 완료 목표일을 의무로 확정
- result: Ahead/On-track/Delayed를 기준일 대비 자동 계산 가능
- condition: 1페이즈 내 US가 2개 이상이고 선행관계가 있는 스프린트
- caution: 목표일은 \"개발 완료일\"이 아니라 \"완료 기준 증적 확인일\"로 정의한다.
- related_artifacts:
  - `.agile/sprints/sprint-1/1-direction/design-phase.md`
  - `.agile/sprints/sprint-1/2-delivery/sprint-status.md`

## Validated Entries
- 아직 없음

## Deprecated Entries
- 아직 없음
