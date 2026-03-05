## 단계별 적용 순서
| 순서 | 파이프라인 단계 | 적용 스킬 | 산출 디렉터리 |
|---|---|---|---|
| `1` | `C1 Direction` | `define-2w` | `.agile/sprints/sprint-N/1-direction/` |
| `2` | `C1 Direction` | `design-phase` | `.agile/sprints/sprint-N/1-direction/` |
| `3` | `C2 Delivery` | `monitor-sprint` (상태 초기화/대시보드) | `.agile/sprints/sprint-N/2-delivery/` |
| `4` | `C2 Delivery` | `design-implementation` | `.agile/sprints/sprint-N/2-delivery/` |
| `5` | `C2 Delivery` | `execute-implementation` | `.agile/sprints/sprint-N/2-delivery/` |
| `6` | `C2 Delivery` | `design-test` | `.agile/sprints/sprint-N/2-delivery/` |
| `7` | `C2 Delivery` | `execute-test` | `.agile/sprints/sprint-N/2-delivery/` |
| `8` | `C2 Delivery` | `monitor-sprint` (상태 갱신/재평가) | `.agile/sprints/sprint-N/2-delivery/` |
| `9` | `C3 Learning` | `review-sprint` | `.agile/sprints/sprint-N/3-learning/` |
| `10` | `C1 Direction` | 다음 스프린트 재진입 | `.agile/sprints/sprint-N/1-direction/` |

## C2 반복 실행 규칙
1. `4~8`번 스킬은 US 단위로 순차 반복한다.
2. 기본 반복 단위는 US 1개다.
3. 표준 루프 순서는 `design-implementation -> execute-implementation -> design-test -> execute-test -> monitor-sprint`다.
4. 현재 US가 완료되기 전에는 다음 US를 착수하지 않는다.
