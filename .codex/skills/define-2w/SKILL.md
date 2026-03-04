---
name: define-2w
description: "2W(무엇/왜)를 통해 문제를 명확히 정의하고, 최소 질문 게이트로 라운드(vN) 단위 실행 방향을 정하는 메인 스킬. 질문 과잉을 막고 스프린트 학습을 반영해 2W를 업데이트한다."
---

# Define 2W

## 목적
무엇/왜 우선 원칙을 지키면서 질문 수를 줄여 **문제 정의를 먼저 확정**하고, 그 결과물로 **실행 가능한 2W vN**을 빠르게 만든다.

핵심 원칙:
- 2W의 코어 목적은 `문제 정의`이고, What/Why는 그 정의를 문서화한 결과다
- `완벽한 2W`가 아니라 `실행 가능한 2W vN`
- 질문은 최소화하고, 모호성은 스프린트 학습으로 줄인다
- 사용자가 말한 방법(How)에서 무엇/왜를 역으로 도출한다
- MVP 범위 명확화는 `design-phase`에서 수행하고, 2W는 문제 정의까지 책임진다
- 이전 design-phase 문서(`02-design-phase.md`, legacy: `04-design-phase.md`)가 있으면 다음 Phase 연속성 게이트를 먼저 통과한다
- 방법(How) 상세는 여기서 하지 않고 `/design-phase`로 넘긴다

## 문서 작성 원칙 (가독성)
- 본문은 읽는 사람 기준의 흐름으로 쓴다: `배경 -> 입력 신호 -> What/Why -> 결정/다음 액션`
- 운영 기록(게이트 선택, 근거 문서, 시각, 코멘트)은 본문 끝 `부록`으로 분리한다
- 본문에는 결론/판단을 먼저 쓰고, 운영 상세는 최소한으로 남긴다
- 표/구분선을 활용해 정보 밀도를 낮추고 스캔 가능하게 유지한다

## 이 스킬이 메인으로 담당하는 것
- 사용자 자유 발화 수집
- How -> What/Why 역추출 및 재서술
- 문제 정의 1문장 합의 (무엇을 왜 지금 푸는지)
- 2W 정의 (무엇/왜)
- 이전 Phase 연속 진행 여부 판단
- 상위 프로젝트 제약/가정/미확정 리스크 확인
- 다음 단계 결정 (진행/보류/중단)

## 출력물
- `.agile/loops/loop-vN/01-01-define-2w-phase-briefing.md` (선택: 이전 `02-design-phase.md` 존재 시 필수)
- `.agile/loops/loop-vN/01-02-define-2w.md`
- `.agile/loops/loop-vN/01-03-define-2w-case-study.md` (선택: 사례 연구 실행 시 필수)
- `.agile/loops/loop-vN/01-04-define-2w-patterns.md` (선택: 패턴 연구 실행 시 필수)

템플릿:
- `templates/define-2w-phase-briefing-vN.md`
- `templates/define-2w-vN.md`
- `templates/define-2w-case-study-vN.md`
- `templates/define-2w-patterns-vN.md`

참고 문서:
- `references/philosophy.md`
  - 2W를 스프린트 단위로 줄이는 이유가 헷갈릴 때
  - 사례 연구/패턴 연구를 언제 켜고 끌지 판단 근거가 필요할 때
- `references/experience.md`
  - 유사한 2W 문제에서 어떤 역추출/게이트 판단이 유효했는지 빠르게 참고할 때

## 작동 방식

### 1단계. 준비
- `references/philosophy.md` 핵심 원칙 확인
- `.agile/loops/loop-vN/` 디렉터리 확인/생성
- 직전 루프의 design-phase 문서 존재 여부 확인 (`02-design-phase.md`, legacy: `04-design-phase.md`)
- 직전 루프의 sprint 진행 문서(`sprint/02-sprint-status.md`, `sprint/04-sprint-retrospective.md`) 존재 여부 확인

확인 경로(예):
- `.agile/loops/loop-vN-1/02-design-phase.md`
- 또는 가장 최신 루프의 `02-design-phase.md`
- (legacy) `.agile/loops/loop-vN-1/04-design-phase.md`
- (legacy) 또는 가장 최신 루프의 `04-design-phase.md`
- `.agile/loops/loop-vN-1/sprint/02-sprint-status.md`
- `.agile/loops/loop-vN-1/sprint/04-sprint-retrospective.md`

### 2단계. Phase 연속성 게이트
직전 design-phase 문서(`02-design-phase.md`, legacy: `04-design-phase.md`)가 있으면 **사용자 선택을 받기 전에** 다음을 먼저 브리핑한다.

- 감지 대상:
  - 다음 후보 Phase(보통 `Phase-2`, `Phase-3`)
  - 해당 Phase의 목표/US
- 진행상황 요약:
  - 직전 Phase의 완료/진행/대기 상태(가능하면 sprint 문서 근거 포함)
- AI 추천:
  - `연속 진행 권장`: 다음 Phase가 유효하고 현재 목표가 이어질 때
  - `새로 시작 권장`: 방향/문제 자체가 바뀌었을 때

문서 산출 규칙:
- `templates/define-2w-phase-briefing-vN.md`로
  `.agile/loops/loop-vN/01-01-define-2w-phase-briefing.md`를 먼저 작성한다.
- 브리핑 문서도 `한눈에 결론 -> 진행 요약 -> 다음 Phase 후보 -> 선택지 비교 -> AI 권장안` 흐름을 유지한다.
- 사용자에게 핵심 요약(2~3줄)과 `AI 추천`을 전달한 뒤 선택을 요청한다.
- 브리핑 문서는 선택 근거를 남기기 위한 용도로 유지하되, 과도한 메타 기록은 생략한다.

- 사용자 선택:
  - `연속 진행` | `새로 시작`

게이트 결과:
- `연속 진행`: 이번 2W는 "다음 Phase 실행을 위한 What/Why"로 정의
- `새로 시작`: 기존 Phase 흐름을 참고만 하고, 신규 2W로 정의
- `이전 design-phase 문서 없음`: 신규 2W로 진행

### 3단계. 단일 입력 수집
2단계에서 사용자 선택이 확정되면, 입력 수집 전에 현재 판단 기준을 1~2줄로 공유한다.
- 예: 유지할 점 1개 + 바꿀 점 1개

입력 요청은 자유 발화 1회로 받는다.
- 연속 진행: 다음 Phase 맥락에서 바꾸거나 유지할 점 중심으로 입력 요청
- 새로 시작: 기존 흐름은 참고로 두고 신규 문제 정의 중심으로 입력 요청

직전 design-phase 문서가 없으면 아래 한 가지를 묻는다.
- "지금 무엇을 하고 싶은지, 떠오르는 방식/이유/불편한 점까지 자유롭게 말해달라"

### 4단계. 입력 기반 What/Why 역추출
수집된 자유 입력을 바탕으로 AI가 What/Why를 직접 도출한다.
- 도출된 What: "실제로 해결하려는 문제" 1문장
- 도출된 Why: "지금 해결해야 하는 이유" 1문장
- 최종 문제 정의: What+Why를 결합한 1문장

도출 방식:
- 방법(수단) 표현 제거
- 문제/영향/목표 상태 중심으로 재작성
- How 단서는 참고하되, 출력은 What/Why만 확정
- 사용자에게 1회 확인 질문으로 합의
- 연속 진행일 경우 다음 Phase 목표와 충돌 없는지 함께 확인

### 5단계. 사례 연구 판단 게이트
먼저 AI가 추천안을 만들고, 사용자에게 실행 여부를 확인한다.
- AI 추천: 진행 권장 | 생략 권장
- 추천 근거: 1줄
- 사용자 선택: 진행 | 생략

게이트 결과:
- `생략`: 사례 연구 생략 후 6단계로 이동
- `진행`: 사례 연구 실행
  - 최대 3개 사례만 조사
  - 각 사례는 3줄 요약
  - 결과를 `.agile/loops/loop-vN/01-03-define-2w-case-study.md`에 기록
  - 2W 문서에는 핵심 반영점만 요약

### 6단계. 안티패턴/베스트 프랙티스 연구 판단 게이트
먼저 AI가 추천안을 만들고, 사용자에게 실행 여부를 확인한다.
- AI 추천: 진행 권장 | 생략 권장
- 추천 근거: 1줄
- 사용자 선택: 진행 | 생략

게이트 결과:
- `생략`: 패턴 연구 생략 후 7단계로 이동
- `진행`: 패턴 연구 실행
  - 안티패턴 최대 3개 조사
  - 베스트 프랙티스 최대 3개 조사
  - 항목당 3줄 요약
  - 결과를 `.agile/loops/loop-vN/01-04-define-2w-patterns.md`에 기록
  - 2W 문서에는 핵심 반영점만 요약

### 7단계. 2W vN 문서화
`templates/define-2w-vN.md`로 `.agile/loops/loop-vN/01-02-define-2w.md`를 작성한다.
- 읽기용 본문:
  - 한눈에 결론(문제 정의 1문장 + 결정 + 다음 단계)
  - 배경/입력 신호/What/Why 재정의
  - 다음 액션(최대 3개)
- 운영 기록:
  - 게이트 선택/코멘트/시각은 문서 마지막 `부록`에 분리
  - 실행된 연구 문서 경로와 상위 제약/가정/미확정 항목은 부록에만 기록

### 8단계. 다음 단계 결정
- `진행(GO)`: `/design-phase`로 넘어가 MVP 범위/Phase/US를 설계
- `보류(HOLD)`: 질문 1개만 추가 후 2W 재작성
- `중단(STOP)`: 문제를 분할하고 새 vN으로 재시작

## 안티패턴
- 사용자에게 What/Why를 직접 정답처럼 요구함
- 질문지를 별도 파일로 강제해 입력 마찰을 키움
- 질문지를 길게 늘려 답변 피로를 유발함
- 사용자에게 phase 문서를 직접 확인하라고 넘김
- 선택 전 브리핑 없이 `연속 진행 | 새로 시작` 선택부터 요구함
- 브리핑 문서 없이 구두 요약만으로 선택을 유도함
- 이전 phase 문서가 있는데 브리핑 없이 바로 자유 입력을 요청함
- 사례를 장문 리서치로 확장함
- 운영 로그를 본문에 섞어 스토리 흐름을 끊음
- 2W 단계에서 구현 설계로 진입함

## 완료 조건
- Phase 연속성 게이트 기록 완료 (이전 phase 존재 시 필수)
- 이전 phase 문서 존재 시 `.agile/loops/loop-vN/01-01-define-2w-phase-briefing.md` 작성 완료
- 단일 자유 입력 수집 완료
- What 1문장, Why 1문장 도출 완료
- 문제 정의 1문장(What+Why 통합) 확정
- 사례 연구 게이트 기록 완료 (AI 추천 + 사용자 선택)
- 사례 연구를 실행했다면 `.agile/loops/loop-vN/01-03-define-2w-case-study.md` 작성 완료
- 패턴 연구 게이트 기록 완료 (AI 추천 + 사용자 선택)
- 패턴 연구를 실행했다면 `.agile/loops/loop-vN/01-04-define-2w-patterns.md` 작성 완료
- `.agile/loops/loop-vN/01-02-define-2w.md` 작성 완료
- 진행/보류/중단 결정 완료

## 다음 단계
- 진행(GO)이면 `/design-phase` 실행
