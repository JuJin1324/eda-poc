# 스킬 라이프사이클

## 목적
Active 스킬과 Legacy 스킬의 경계를 고정해, 스킬 탐색/호출 혼선을 줄인다.

## 디렉터리 정책
- Active: `.codex/skills/`
- Legacy: `.codex/skills-legacy/`

## Legacy -> Active 매핑
| Legacy | Active 대체 | 상태 | 비고 |
|---|---|---|---|
| `2w-brainstorm` | `define-2w` | Deprecated | What/Why 역추출 + 사례연구 게이트로 통합 |
| `1h-agile-phase` | `design-phase` | Deprecated | Phase+US 중심으로 단순화 |
| `sprint-start` | `plan-sprint` | Deprecated | Sprint 계획/상태/회고를 단일 스킬로 통합 |
| `sprint-complete` | `plan-sprint` | Deprecated | Sprint retrospective를 plan-sprint 흐름으로 통합 |
| `us-complete` | `plan-sprint` | Deprecated | US retrospective를 동일 흐름에서 관리 |

## 문서/템플릿 상태 점검
| 파일 | 현재 판단 | 사유 |
|---|---|---|
| `templates/questions.md` | Legacy-only 유지 | Active 스킬은 사용하지 않지만, Claude/Gemini 레거시 스킬 호환성 때문에 보관 |
| `problem-solving-principles.md` | Legacy reference 유지 | Active는 `docs/skill-ops/*` + 각 스킬 `references/philosophy.md`를 사용 |

## 제거 조건
아래 조건이 모두 충족되면 Legacy와 Legacy-only 파일을 제거한다.
1. `.claude/skills`와 `.gemini/skills`에서도 동일 Active 워크플로우로 전환 완료
2. 최근 N회(팀 정책) 운영에서 Legacy 호출 0회
3. 운영 문서(`framework.md`) 기준으로 대체 가능성 검증 완료
