# Legacy Migration Report v0

## 실행 정보
- 생성 시각: 2026-03-04 10:14:59 +0900
- 모드: apply
- 프로젝트 루트: /Users/jujin/Documents/dev/workspace-pe/eda-poc
- 프로필: legacy-generic
- 대상 루프: loop-v0
- 덮어쓰기 옵션: 0

## 매핑 결과
| 항목 | 레거시 소스 | 신버전 대상 | 상태 | 메모 |
|---|---|---|---|---|
| 2W Brainstorm | `docs/2w-brainstorm.md` | `.agile/loops/loop-v0/01-define-2w.md` | skipped_destination_exists | destination exists; use --overwrite |
| Case Study | `docs/eda-kafka-case-studies.md` | `.agile/loops/loop-v0/02-define-2w-case-study.md` | skipped_destination_exists | destination exists; use --overwrite |
| How Diagram | `docs/how-diagram.md` | `.agile/loops/loop-v0/04-design-phase.md` | skipped_destination_exists | destination exists; use --overwrite |
| Sprint Plan | `.agile/sprints/sprint-0/plan.md` | `.agile/loops/loop-v0/sprint/01-sprint-plan.md` | copied | copied successfully |
| Sprint Status | `` | `.agile/loops/loop-v0/sprint/02-sprint-status.md` | missing_source | source file not found (auto-detect) |
| Sprint Retrospective | `.agile/sprints/sprint-0/sprint-retrospective.md` | `.agile/loops/loop-v0/sprint/04-sprint-retrospective.md` | copied | copied successfully |
| US Retrospective 0.1 | `.agile/sprints/sprint-0/us-0.1-retrospective.md` | `.agile/loops/loop-v0/sprint/03-us-0.1-retrospective.md` | copied | copied successfully |
| US Retrospective 0.2 | `.agile/sprints/sprint-0/us-0.2-retrospective.md` | `.agile/loops/loop-v0/sprint/03-us-0.2-retrospective.md` | copied | copied successfully |

## 요약
- copied: 4
- overwritten: 0
- skipped_destination_exists: 3
- missing_source: 1
- would_copy: 0
- would_overwrite: 0
- would_skip_destination_exists: 0

## 주의사항
- 본 마이그레이션은 파일 내용을 구조 변환하지 않고, 경로/파일명 기준으로 복사한다.
- 신버전 스킬 실행 전, 각 문서 헤더/섹션이 현재 템플릿 의도와 맞는지 수동 확인을 권장한다.
