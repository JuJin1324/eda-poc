#!/usr/bin/env bash
set -euo pipefail

MODE="dry-run"
PROJECT_ROOT="."
LOOP=""
OVERWRITE=0
PROFILE="legacy-generic"

SOURCE_2W=""
SOURCE_CASE=""
SOURCE_HOW=""
SOURCE_2W_SET=0
SOURCE_CASE_SET=0
SOURCE_HOW_SET=0

REPORT_PATH=""

usage() {
  cat <<'EOF'
Usage:
  bash .codex/skills/migrate-legacy-artifacts/scripts/migrate_legacy_artifacts.sh [options]

Options:
  --project-root <path>        Target project root (default: .)
  --loop <N>                   Target loop number (default: auto-detect latest, fallback 0)
  --mode <dry-run|apply>       Execution mode (default: dry-run)
  --overwrite                  Allow overwriting existing destination files (apply mode)
  --profile <name>             Mapping profile (default: legacy-generic)
  --source-2w <path>           Legacy 2W source path (override auto-detect)
  --source-case-study <path>   Legacy case study source path (override auto-detect)
  --source-how <path>          Legacy how diagram source path (override auto-detect)
  --report-path <path>         Custom report path
  -h, --help                   Show this help
EOF
}

abs_path() {
  local base="$1"
  local path="$2"
  if [[ "${path}" == /* ]]; then
    printf '%s\n' "${path}"
  else
    printf '%s/%s\n' "${base}" "${path}"
  fi
}

display_path() {
  local root="$1"
  local path="$2"
  case "${path}" in
    "${root}"/*) printf '%s\n' "${path#${root}/}" ;;
    *) printf '%s\n' "${path}" ;;
  esac
}

detect_loop() {
  local project_root_abs="$1"
  local loops_dir="${project_root_abs}/.agile/loops"
  local latest

  if [[ ! -d "${loops_dir}" ]]; then
    printf '0\n'
    return
  fi

  latest="$(
    ls -1 "${loops_dir}" 2>/dev/null \
      | sed -n 's/^loop-v\([0-9][0-9]*\)$/\1/p' \
      | sort -n \
      | tail -1
  )"

  if [[ -n "${latest}" ]]; then
    printf '%s\n' "${latest}"
  else
    printf '0\n'
  fi
}

resolve_auto_source() {
  local project_root_abs="$1"
  shift
  local candidates=("$@")
  local candidate
  local resolved
  local expanded

  shopt -s nullglob
  for candidate in "${candidates[@]}"; do
    expanded=("${project_root_abs}"/${candidate})
    for resolved in "${expanded[@]}"; do
      if [[ -f "${resolved}" ]]; then
        printf '%s\n' "${resolved}"
        shopt -u nullglob
        return 0
      fi
    done
  done
  shopt -u nullglob
  printf '\n'
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-root)
      PROJECT_ROOT="${2:-}"
      shift 2
      ;;
    --loop)
      LOOP="${2:-}"
      shift 2
      ;;
    --mode)
      MODE="${2:-}"
      shift 2
      ;;
    --overwrite)
      OVERWRITE=1
      shift
      ;;
    --profile)
      PROFILE="${2:-}"
      shift 2
      ;;
    --source-2w)
      SOURCE_2W="${2:-}"
      SOURCE_2W_SET=1
      shift 2
      ;;
    --source-case-study)
      SOURCE_CASE="${2:-}"
      SOURCE_CASE_SET=1
      shift 2
      ;;
    --source-how)
      SOURCE_HOW="${2:-}"
      SOURCE_HOW_SET=1
      shift 2
      ;;
    --report-path)
      REPORT_PATH="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ "${MODE}" != "dry-run" && "${MODE}" != "apply" ]]; then
  echo "Invalid mode: ${MODE}" >&2
  exit 1
fi

case "${PROFILE}" in
  legacy-generic|eda-poc-default)
    ;;
  *)
    echo "Unsupported profile: ${PROFILE}" >&2
    exit 1
    ;;
esac

if [[ ! -d "${PROJECT_ROOT}" ]]; then
  echo "Project root not found: ${PROJECT_ROOT}" >&2
  exit 1
fi

PROJECT_ROOT_ABS="$(cd "${PROJECT_ROOT}" && pwd)"

if [[ -z "${LOOP}" ]]; then
  LOOP="$(detect_loop "${PROJECT_ROOT_ABS}")"
fi

if [[ ! "${LOOP}" =~ ^[0-9]+$ ]]; then
  echo "Invalid loop value: ${LOOP}" >&2
  exit 1
fi

TARGET_LOOP_DIR="${PROJECT_ROOT_ABS}/.agile/loops/loop-v${LOOP}"
if [[ -z "${REPORT_PATH}" ]]; then
  REPORT_PATH="${PROJECT_ROOT_ABS}/.agile/migration/legacy-migration-report-v${LOOP}.md"
else
  REPORT_PATH="$(abs_path "${PROJECT_ROOT_ABS}" "${REPORT_PATH}")"
fi

if [[ "${SOURCE_2W_SET}" -eq 1 ]]; then
  SRC_2W="$(abs_path "${PROJECT_ROOT_ABS}" "${SOURCE_2W}")"
else
  SRC_2W="$(
    resolve_auto_source "${PROJECT_ROOT_ABS}" \
      "2w-brainstorm.md" \
      "docs/planning/2w-brainstorm.md" \
      "problems/*/2w-brainstorm.md"
  )"
fi

if [[ "${SOURCE_CASE_SET}" -eq 1 ]]; then
  SRC_CASE="$(abs_path "${PROJECT_ROOT_ABS}" "${SOURCE_CASE}")"
else
  SRC_CASE="$(
    resolve_auto_source "${PROJECT_ROOT_ABS}" \
      "2w-case-study.md" \
      "2w-case-studies.md" \
      "case-study.md" \
      "case-studies.md" \
      "eda-kafka-case-studies.md" \
      "docs/planning/2w-case-study.md" \
      "docs/planning/case-studies.md" \
      "docs/planning/eda-kafka-case-studies.md" \
      "problems/*/2w-case-study.md" \
      "problems/*/case-studies.md" \
      "problems/*/eda-kafka-case-studies.md"
  )"
fi

if [[ "${SOURCE_HOW_SET}" -eq 1 ]]; then
  SRC_HOW="$(abs_path "${PROJECT_ROOT_ABS}" "${SOURCE_HOW}")"
else
  SRC_HOW="$(
    resolve_auto_source "${PROJECT_ROOT_ABS}" \
      "how-diagram.md" \
      "1h-agile-phase.md" \
      "docs/planning/how-diagram.md" \
      "docs/planning/1h-agile-phase.md" \
      "problems/*/how-diagram.md"
  )"
fi

DEST_2W="${TARGET_LOOP_DIR}/01-define-2w.md"
DEST_CASE="${TARGET_LOOP_DIR}/02-define-2w-case-study.md"
DEST_PHASE="${TARGET_LOOP_DIR}/04-design-phase.md"

labels=("2W Brainstorm" "Case Study" "How Diagram")
srcs=("${SRC_2W}" "${SRC_CASE}" "${SRC_HOW}")
dests=("${DEST_2W}" "${DEST_CASE}" "${DEST_PHASE}")

statuses=()
notes=()

count_copied=0
count_overwritten=0
count_skipped=0
count_missing=0
count_would_copy=0
count_would_overwrite=0
count_would_skip=0

for i in "${!srcs[@]}"; do
  src="${srcs[$i]}"
  dest="${dests[$i]}"

  if [[ -z "${src}" ]]; then
    statuses+=("missing_source")
    notes+=("source file not found (auto-detect)")
    count_missing=$((count_missing + 1))
    continue
  fi

  if [[ ! -f "${src}" ]]; then
    statuses+=("missing_source")
    notes+=("source file not found")
    count_missing=$((count_missing + 1))
    continue
  fi

  if [[ "${MODE}" == "dry-run" ]]; then
    if [[ -f "${dest}" && "${OVERWRITE}" -eq 0 ]]; then
      statuses+=("would_skip_destination_exists")
      notes+=("destination exists; rerun with --overwrite")
      count_would_skip=$((count_would_skip + 1))
    elif [[ -f "${dest}" && "${OVERWRITE}" -eq 1 ]]; then
      statuses+=("would_overwrite")
      notes+=("destination exists and would be overwritten")
      count_would_overwrite=$((count_would_overwrite + 1))
    else
      statuses+=("would_copy")
      notes+=("ready to copy")
      count_would_copy=$((count_would_copy + 1))
    fi
    continue
  fi

  if [[ -f "${dest}" && "${OVERWRITE}" -eq 0 ]]; then
    statuses+=("skipped_destination_exists")
    notes+=("destination exists; use --overwrite")
    count_skipped=$((count_skipped + 1))
    continue
  fi

  mkdir -p "$(dirname "${dest}")"
  if [[ -f "${dest}" ]]; then
    cp "${src}" "${dest}"
    statuses+=("overwritten")
    notes+=("copied with overwrite")
    count_overwritten=$((count_overwritten + 1))
  else
    cp "${src}" "${dest}"
    statuses+=("copied")
    notes+=("copied successfully")
    count_copied=$((count_copied + 1))
  fi
done

mkdir -p "$(dirname "${REPORT_PATH}")"

{
  echo "# Legacy Migration Report v${LOOP}"
  echo
  echo "## 실행 정보"
  echo "- 생성 시각: $(date '+%Y-%m-%d %H:%M:%S %z')"
  echo "- 모드: ${MODE}"
  echo "- 프로젝트 루트: ${PROJECT_ROOT_ABS}"
  echo "- 프로필: ${PROFILE}"
  echo "- 대상 루프: loop-v${LOOP}"
  echo "- 덮어쓰기 옵션: ${OVERWRITE}"
  echo
  echo "## 매핑 결과"
  echo "| 항목 | 레거시 소스 | 신버전 대상 | 상태 | 메모 |"
  echo "|---|---|---|---|---|"
  for i in "${!srcs[@]}"; do
    src_display="$(display_path "${PROJECT_ROOT_ABS}" "${srcs[$i]}")"
    dest_display="$(display_path "${PROJECT_ROOT_ABS}" "${dests[$i]}")"
    echo "| ${labels[$i]} | \`${src_display}\` | \`${dest_display}\` | ${statuses[$i]} | ${notes[$i]} |"
  done
  echo
  echo "## 요약"
  echo "- copied: ${count_copied}"
  echo "- overwritten: ${count_overwritten}"
  echo "- skipped_destination_exists: ${count_skipped}"
  echo "- missing_source: ${count_missing}"
  echo "- would_copy: ${count_would_copy}"
  echo "- would_overwrite: ${count_would_overwrite}"
  echo "- would_skip_destination_exists: ${count_would_skip}"
  echo
  echo "## 주의사항"
  echo "- 본 마이그레이션은 파일 내용을 구조 변환하지 않고, 경로/파일명 기준으로 복사한다."
  echo "- 신버전 스킬 실행 전, 각 문서 헤더/섹션이 현재 템플릿 의도와 맞는지 수동 확인을 권장한다."
} > "${REPORT_PATH}"

echo "Migration completed."
echo "Mode: ${MODE}"
echo "Project: ${PROJECT_ROOT_ABS}"
echo "Loop: loop-v${LOOP}"
echo "Report: ${REPORT_PATH}"
