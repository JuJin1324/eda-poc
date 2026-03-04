#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
SKILLS_DIR="${ROOT_DIR}/.codex/skills"
FORCE="${FORCE:-0}"
CREATED=0
SKIPPED=0

SKILLS=(
  "define-2w"
  "design-phase"
  "design-implementation"
  "execute-implementation"
  "design-test"
  "execute-test"
  "monitor-sprint"
  "record-adr"
  "sync-agent-skills"
  "manage-experience"
  "migrate-legacy-artifacts"
)

for skill in "${SKILLS[@]}"; do
  out_dir="${SKILLS_DIR}/${skill}/references"
  out_file="${out_dir}/experience.md"
  mkdir -p "${out_dir}"

  if [[ -f "${out_file}" && "${FORCE}" != "1" ]]; then
    echo "Skip existing: ${out_file}"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  case "${skill}" in
    define-2w)
      title="Define 2W"
      e1_situation="사용자가 해결책(How)만 길게 설명하고 목적은 비어 있던 상황"
      e1_signal="요구사항은 많지만 성공 기준이 계속 바뀜"
      e1_choice="How 표현을 걷어내고 What/Why를 1문장씩 재서술해 합의"
      e1_result="질문 수를 줄이고도 다음 단계 진입 결정이 빨라짐"
      e1_condition="문제 정의보다 구현 아이디어가 먼저 쏟아지는 대화"
      e2_situation="사례 연구를 매번 켜서 초기 단계 토큰 비용이 과도했던 상황"
      e2_signal="2W 문서보다 사례 메모가 더 길어짐"
      e2_choice="사례 연구 게이트를 두고, 권장/생략 근거 1줄로 먼저 제시"
      e2_result="필요한 경우에만 조사해도 결정 품질 유지"
      e2_condition="레퍼런스가 성공 기준에 직접 영향이 있을 때만 조사"
      e3_situation="성공 기준이 여러 개라 우선순위 합의가 어려웠던 상황"
      e3_signal="진행/보류 판단이 회의마다 달라짐"
      e3_choice="성공 기준 1개 + 경계 1개만 확정"
      e3_result="GO/HOLD 판단 기준이 명확해짐"
      e3_condition="초기 루프에서 빠른 실행/학습이 필요한 경우"
      ;;
    design-phase)
      title="Design Phase"
      e1_situation="US를 많이 적어 계획은 커졌지만 실행 우선순위가 흐려진 상황"
      e1_signal="스프린트 시작 전부터 대기 작업이 많아짐"
      e1_choice="Phase는 1~3개, 이번 스프린트 US는 1~2개로 제한"
      e1_result="핸드오프 문서가 실행 중심으로 단순화됨"
      e1_condition="MVP 범위를 작게 유지해야 하는 초기 단계"
      e2_situation="In/Out/Unknown 구분 없이 요구사항을 나열한 상황"
      e2_signal="스코프 확장 논쟁이 반복됨"
      e2_choice="항목을 In/Out/Unknown으로 강제 분리"
      e2_result="스프린트 외 항목이 자동으로 차단됨"
      e2_condition="요구사항 출처가 여러 팀/이해관계자로 분산된 경우"
      e3_situation="지표를 결과 지표만 두어 중간 점검이 어려웠던 상황"
      e3_signal="종료 시점 전에는 진행 이상을 감지하지 못함"
      e3_choice="Leading 1개 + Outcome 1개를 동시에 정의"
      e3_result="중간 점검과 종료 평가가 분리되어 안정됨"
      e3_condition="실행 중 피벗 가능성을 열어둬야 하는 프로젝트"
      ;;
    design-implementation)
      title="Design Implementation"
      e1_situation="기술 스택 합의 전에 설계부터 시작해 구현 중 충돌한 상황"
      e1_signal="라이브러리 선택 변경으로 다이어그램을 다시 그림"
      e1_choice="tech-stack 확인/합의를 1단계로 고정"
      e1_result="설계 재작업 횟수 감소"
      e1_condition="외부 라이브러리 의존도가 높은 기능"
      e2_situation="C4 Container를 항상 작성해 비용이 커진 상황"
      e2_signal="외부 의존성이 단순한데도 문서가 과도하게 길어짐"
      e2_choice="C4 작성 게이트를 두고 생성/생략 판단"
      e2_result="필수 다이어그램(Sequence/Flowchart)에 집중 가능"
      e2_condition="단일 서비스 내부 변경 중심의 구현"
      e3_situation="인터페이스를 먼저 쓰고 다이어그램을 나중에 맞춘 상황"
      e3_signal="설명 문서와 흐름도가 서로 불일치"
      e3_choice="경계 정의 후 다이어그램 먼저, 인터페이스는 그 다음"
      e3_result="문서 읽기 순서가 자연스러워짐"
      e3_condition="여러 구현자에게 설계를 전달해야 할 때"
      ;;
    execute-implementation)
      title="Execute Implementation"
      e1_situation="코드 완료 후 US/Step 매핑을 나중에 작성해 누락이 생긴 상황"
      e1_signal="완료 보고 시 어떤 요구를 충족했는지 즉시 답하기 어려움"
      e1_choice="구현과 동시에 매핑 표를 갱신"
      e1_result="리뷰 시 추적성이 크게 개선"
      e1_condition="US 범위가 큰 기능을 분할 구현할 때"
      e2_situation="테스트를 마지막에 몰아 실행해 결함 수정이 지연된 상황"
      e2_signal="통합 단계에서 실패가 한 번에 터짐"
      e2_choice="작은 단위 구현마다 관련 테스트를 즉시 실행"
      e2_result="결함 원인 구간이 좁아져 수정 속도 향상"
      e2_condition="도메인 규칙이 많은 백엔드 구현"
      e3_situation="컨벤션 점검을 생략해 리팩터링 비용이 증가한 상황"
      e3_signal="PR 리뷰가 스타일 이슈 중심으로 길어짐"
      e3_choice="코드 변경 직후 컨벤션 체크리스트 확인"
      e3_result="리뷰 피드백이 설계/로직 중심으로 이동"
      e3_condition="협업 PR 비중이 높은 프로젝트"
      ;;
    design-test)
      title="Design Test"
      e1_situation="정상 시나리오 위주로만 설계해 운영 결함을 놓친 상황"
      e1_signal="실패/엣지 입력에서 즉시 장애가 재현됨"
      e1_choice="정상/실패/엣지 케이스를 분리해 모두 명시"
      e1_result="결함 탐지율이 초기 단계에서 상승"
      e1_condition="입력 경계값/예외 처리가 많은 기능"
      e2_situation="우선순위 없이 케이스를 나열해 실행 순서가 혼란스러운 상황"
      e2_signal="중요도 낮은 테스트에 시간이 먼저 소모됨"
      e2_choice="P0/P1/P2로 분류 후 P0 우선 실행 계획 고정"
      e2_result="핵심 리스크를 먼저 차단"
      e2_condition="테스트 시간이 제한된 스프린트"
      e3_situation="테스트 스택과 방법론을 따로 관리해 일관성이 깨진 상황"
      e3_signal="케이스 형식이 팀원마다 달라짐"
      e3_choice="tech-stack의 테스트 방법론을 설계 단계에 반영"
      e3_result="문서/코드 테스트 형식이 통일"
      e3_condition="BDD/TDD를 혼용하는 팀"
      ;;
    execute-test)
      title="Execute Test"
      e1_situation="P2부터 실행해 P0 결함 발견이 늦어진 상황"
      e1_signal="테스트는 많이 돌렸지만 치명 결함이 뒤늦게 발견됨"
      e1_choice="항상 P0 -> P1 -> P2 순으로 고정"
      e1_result="치명 결함의 탐지 시점이 앞당겨짐"
      e1_condition="회귀 범위가 넓고 실행 시간이 긴 테스트 세트"
      e2_situation="실패 로그를 요약만 남겨 재현이 어려웠던 상황"
      e2_signal="동일 실패를 다시 조사하는 시간이 길어짐"
      e2_choice="재현 절차/원인/조치 3요소를 필수 기록"
      e2_result="결함 재현 시간이 단축"
      e2_condition="환경 의존 테스트가 많은 경우"
      e3_situation="결함을 테스트 문서에만 남기고 설계로 환류하지 않은 상황"
      e3_signal="다음 루프에서 유사 결함이 반복됨"
      e3_choice="원인 분류 후 design/implementation 문서로 역피드백"
      e3_result="동일 계열 결함 재발 빈도 감소"
      e3_condition="설계 가정이 바뀐 테스트 실패가 발생했을 때"
      ;;
    monitor-sprint)
      title="Monitor Sprint"
      e1_situation="상태 문서가 없어 스프린트 진행률 집계가 불가능했던 상황"
      e1_signal="loop에 design-phase는 있지만 sprint/02-sprint-status.md가 없음"
      e1_choice="monitor-sprint가 design-phase를 기반으로 status 문서를 0% 초기값으로 자동 생성"
      e1_result="별도 운영 스킬 없이도 스프린트 추적 시작점 확보"
      e1_condition="새 loop를 시작한 직후"
      e2_situation="진행률 숫자만 보고 일정 리스크를 놓친 상황"
      e2_signal="완료율은 높지만 US 목표일을 넘김"
      e2_choice="진행률과 US 일정 상태(Ahead/On-track/Delayed)를 함께 확인"
      e2_result="지연 신호를 조기 감지"
      e2_condition="US별 완료 목표일이 정의된 스프린트"
      e3_situation="Blocker를 별도 채널에만 기록해 현황 문서와 분리된 상황"
      e3_signal="회의 시 blocker 최신 상태를 찾는 시간이 길어짐"
      e3_choice="02-sprint-status.md의 Risks/Blockers 섹션을 단일 소스로 사용"
      e3_result="모니터링 결과와 대응 논의가 즉시 연결됨"
      e3_condition="외부 의존 이슈가 잦은 스프린트"
      ;;
    record-adr)
      title="Record ADR"
      e1_situation="기술 선택 근거를 채팅에만 남겨 추적이 끊긴 상황"
      e1_signal="한 달 뒤 동일 논쟁이 반복됨"
      e1_choice="결정 즉시 ADR로 context/decision/why 기록"
      e1_result="재논의 비용 감소"
      e1_condition="대안 2개 이상이 경합하는 선택"
      e2_situation="결정은 했지만 영향/부작용을 기록하지 않은 상황"
      e2_signal="후속 변경 시 예상치 못한 파급이 발생"
      e2_choice="Consequences(장점/비용) 섹션을 필수로 작성"
      e2_result="변경 영향 예측 정확도 개선"
      e2_condition="기반 라이브러리나 아키텍처 레벨 결정"
      e3_situation="예전 ADR이 더 이상 유효하지 않은데 상태 갱신이 없던 상황"
      e3_signal="구현과 ADR 내용이 불일치"
      e3_choice="Deprecated 또는 Superseded 상태로 즉시 갱신"
      e3_result="문서 신뢰도 유지"
      e3_condition="새 결정이 기존 결정을 대체했을 때"
      ;;
    sync-agent-skills)
      title="Sync Agent Skills"
      e1_situation="동기화 후 frontmatter가 대상 에이전트 규칙과 불일치한 상황"
      e1_signal="스킬 호출은 되지만 자동 인식 품질이 저하됨"
      e1_choice="동기화 후 SKILL.md 상단 20줄을 즉시 검증"
      e1_result="형식 오류 조기 제거"
      e1_condition="다중 스킬을 한 번에 동기화할 때"
      e2_situation="기존 로컬 변경을 확인하지 않고 덮어써 충돌한 상황"
      e2_signal="의도하지 않은 diff가 대량 발생"
      e2_choice="동기화 전/후 `git status`와 `git diff`를 필수 점검"
      e2_result="덮어쓰기 사고 감소"
      e2_condition="타겟 스킬을 수동으로 수정 중인 저장소"
      e3_situation="동기화 대상 이름을 넓게 잡아 불필요한 스킬까지 복사한 상황"
      e3_signal="Active/Legacy 경계가 다시 흐려짐"
      e3_choice="필요 스킬명만 명시해 부분 동기화"
      e3_result="운영 범위 안정화"
      e3_condition="리팩터링 중 특정 스킬만 업데이트할 때"
      ;;
    manage-experience)
      title="Manage Experience"
      e1_situation="초기 샘플 없이 시작해 기록 형식이 스킬마다 달라진 상황"
      e1_signal="경험 문서를 읽어도 재사용 조건을 찾기 어려움"
      e1_choice="seed 단계에서 공통 포맷 + 샘플 3개를 일괄 생성"
      e1_result="기록 시작 장벽이 낮아짐"
      e1_condition="새 스킬 세트를 처음 운영할 때"
      e2_situation="seeded와 validated를 섞어 의사결정 근거가 약해진 상황"
      e2_signal="검증되지 않은 패턴이 우선 적용됨"
      e2_choice="status를 seeded/validated/deprecated로 분리"
      e2_result="근거 신뢰도 향상"
      e2_condition="경험 문서를 실제 계획 판단에 사용할 때"
      e3_situation="경험 문서가 길어져 실행 전 읽기 부담이 커진 상황"
      e3_signal="팀이 문서를 참고하지 않고 건너뜀"
      e3_choice="실행 전에는 validated 상위 3개만 확인"
      e3_result="참조 비용을 줄이면서 재사용률 유지"
      e3_condition="스프린트 시작 전 빠른 의사결정이 필요할 때"
      ;;
    migrate-legacy-artifacts)
      title="Migrate Legacy Artifacts"
      e1_situation="dry-run 없이 apply를 실행해 기존 신버전 산출물 덮어쓰기 위험이 있었던 상황"
      e1_signal="대상 파일이 이미 존재하는데 최신성 검토가 안 됨"
      e1_choice="항상 dry-run 결과를 먼저 보고 apply 여부를 결정"
      e1_result="덮어쓰기 사고를 사전에 차단"
      e1_condition="기존 루프 산출물이 일부 존재하는 프로젝트"
      e2_situation="자동 루프 감지가 의도와 다른 loop를 선택한 상황"
      e2_signal="문서가 진행 중 루프에 섞여 히스토리 추적이 어려워짐"
      e2_choice="중요 마이그레이션은 --loop 값을 명시"
      e2_result="루프 경계가 유지되어 후속 스킬 입력 안정화"
      e2_condition="복수 루프를 병행 운영하는 프로젝트"
      e3_situation="파일명만 맞추고 문서 내부 구조 점검을 생략한 상황"
      e3_signal="후속 스킬 실행 중 섹션 누락으로 수동 보정 반복"
      e3_choice="마이그레이션 직후 템플릿 기준으로 구조 점검 수행"
      e3_result="후속 define/design 단계 재작업 감소"
      e3_condition="오래된 레거시 템플릿 문서를 재활용할 때"
      ;;
    *)
      echo "Unknown skill: ${skill}" >&2
      exit 1
      ;;
  esac

  cat >"${out_file}" <<EOF
# Experience - ${title}

## 목적
- 이 문서는 \`${skill}\` 실행 전에 빠르게 참고하는 경험 자산이다.

## 사용 규칙
- \`status: seeded\`는 초기 샘플이다.
- 실전에서 검증된 항목만 \`status: validated\`로 승격한다.
- 더 이상 유효하지 않으면 \`status: deprecated\`로 내린다.
- 실행 전에는 \`Validated Entries\`를 우선 참고한다.

## Seeded Entries

### EXP-001
- status: seeded
- date: 2026-03-03
- situation: ${e1_situation}
- signal: ${e1_signal}
- choice: ${e1_choice}
- result: ${e1_result}
- condition: ${e1_condition}
- caution: 팀/프로젝트 맥락이 다르면 그대로 복제하지 말고 조정한다.
- related_artifacts:
  - N/A (seeded)

### EXP-002
- status: seeded
- date: 2026-03-03
- situation: ${e2_situation}
- signal: ${e2_signal}
- choice: ${e2_choice}
- result: ${e2_result}
- condition: ${e2_condition}
- caution: 지표나 증적 없이 감으로 판단하지 않는다.
- related_artifacts:
  - N/A (seeded)

### EXP-003
- status: seeded
- date: 2026-03-03
- situation: ${e3_situation}
- signal: ${e3_signal}
- choice: ${e3_choice}
- result: ${e3_result}
- condition: ${e3_condition}
- caution: 루프 목표를 벗어나는 확장은 별도 의사결정으로 분리한다.
- related_artifacts:
  - N/A (seeded)

## Validated Entries
- 아직 없음

## Deprecated Entries
- 아직 없음
EOF
  CREATED=$((CREATED + 1))
done

echo "Seed complete: created=${CREATED}, skipped=${SKIPPED}, total=${#SKILLS[@]}"
