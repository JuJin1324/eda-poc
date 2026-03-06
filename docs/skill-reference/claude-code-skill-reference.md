# Claude Code 스킬 명세 레퍼런스

> **대상 에이전트:** Claude Code (Anthropic)
> **마지막 확인일:** 2026-02-21
> 이 문서는 Claude Code가 생성한 스킬의 **정성 평가** 시 참고하기 위한 레퍼런스이다.
> 평가자가 모델의 스킬 산출물을 보며 "올바르게 만들었는가?"를 판단할 때 사용한다.
> Gemini CLI, Codex 레퍼런스는 별도 문서를 참고한다.

---

## 1. 스킬이란?

스킬은 Claude Code의 기능을 확장하는 **지시 + 워크플로우 단위**이다.
`SKILL.md` 파일 하나로 구성되며, Claude에게 특정 작업의 수행 방식을 가르친다.
스킬은 [Agent Skills](https://agentskills.io) 오픈 표준을 따른다.

기술적으로 모든 스킬은 동일한 SKILL.md 구조이지만, **본문에 무엇을 쓰느냐**에 따라 용도가 나뉜다:

- **레퍼런스 스킬**: 코딩 컨벤션, API 패턴 등 **규칙/지식**을 본문에 담는다
- **태스크 스킬**: 배포, 리뷰, 평가 등 **단계별 절차**를 본문에 담는다

### 1.1 스킬 활성화의 실체

"자동 적용"은 마법이 아니라 Claude의 **판단에 의한 로드**이다. 동작 흐름:

1. **세션 시작** → Claude가 모든 스킬의 `name` + `description`을 컨텍스트에 로드 (본문은 아직 안 읽음)
2. **사용자가 대화** → Claude가 description을 보고 "이 대화에 맞는 스킬이 있나?" 판단
3. **description이 매칭되면** → 해당 스킬의 SKILL.md 본문 전체를 로드
4. **본문의 규칙을 따라** 응답에 반영

즉, 사용자가 `/명령어`를 치는 대신 **Claude가 알아서 호출하는 것**이다. description의 품질이 곧 자동 적용의 정확도를 결정한다.

### 1.2 두 유형의 차이 정리

| | 레퍼런스 스킬 | 태스크 스킬 |
|---|---|---|
| **본문 성격** | 규칙, 컨벤션, 지식 | 단계별 워크플로우 |
| **누가 호출** | Claude가 description 보고 자동 판단 | 사용자가 `/명령어`로 직접 |
| **결과** | 응답에 규칙이 녹아들어감 | 단계를 순서대로 실행 |
| **frontmatter 차이** | 기본값 그대로 | 보통 `disable-model-invocation: true` |

**예시 — 레퍼런스 스킬:**
```yaml
---
name: api-conventions
description: API 엔드포인트 작성 시 따라야 할 컨벤션. API 코드를 작성하거나 수정할 때 사용.
---

API 엔드포인트 작성 시:
- RESTful 네이밍 사용
- 에러 응답 형식 통일
```
→ 사용자가 "로그인 API 만들어줘"라고 하면 Claude가 description 매칭 → 본문 로드 → 컨벤션 반영
→ "README 수정해줘"라고 하면 API와 무관하므로 무시

---

## 2. 디렉토리 구조

### 2.1 스킬 위치 (스코프)

| 스코프 | 경로 | 적용 범위 |
|--------|------|-----------|
| 개인 | `~/.claude/skills/<스킬명>/SKILL.md` | 모든 프로젝트 |
| 프로젝트 | `.claude/skills/<스킬명>/SKILL.md` | 해당 프로젝트만 |

우선순위: 기업 설정 > 개인 > 프로젝트

### 2.2 스킬 디렉토리 레이아웃

```
my-skill/
├── SKILL.md           # 메인 지시 파일 (필수, 유일한 필수 파일)
├── template.md        # Claude가 채울 템플릿 (선택)
├── examples/          # 예제 (선택)
│   └── sample.md
└── scripts/           # 실행 스크립트 (선택)
    └── validate.sh
```

**핵심 규칙:**
- `SKILL.md`는 500줄 이하로 유지
- 상세 자료는 별도 파일로 분리하고 SKILL.md에서 참조
- 보조 파일은 자동 로드되지 않음 → SKILL.md에서 명시적 언급 필요

### 2.3 보조 파일의 역할과 사용 기준

보조 파일은 모두 선택사항이다. SKILL.md를 가볍게 유지하면서 **필요할 때만 Claude가 Read로 로드**하는 것이 목적이다.

#### template.md — "이 양식대로 채워"

Claude가 구조화된 결과물을 생성할 때 사용하는 틀이다.
SKILL.md에 양식을 장황하게 쓰는 대신 템플릿 파일로 분리한다.

- **활용 예:** PR 작성 양식, 평가 결과 양식, 변경 로그 양식
- **SKILL.md에서 참조:** `결과 파일 작성 시 [template.md](template.md)를 읽어서 양식을 따른다.`

#### examples/sample.md — "이런 느낌으로 만들어"

완성된 산출물의 예시를 보여주는 파일이다.
추상적 지시보다 구체적 예시가 Claude의 출력 품질을 높인다.

- **활용 예:** 잘 작성된 이전 결과물, 기대하는 톤/분량/포맷의 샘플
- **효과:** 톤, 분량, 포맷팅 컨벤션을 말로 설명하기 어려울 때 패턴 매칭 유도

#### scripts/ — "이건 직접 실행해"

Claude가 Bash 도구로 실행하는 스크립트이다.
LLM이 직접 하기 어려운 작업(데이터 가공, 시각화, 검증)을 위임한다.

- **활용 예:** HTML 시각화 생성, 데이터 집계, 출력물 검증
- **실행 제한:** `allowed-tools: Bash(python *)` 같이 범위를 제한할 수 있다

#### 보조 파일 배치 전략: 프로젝트 스킬 vs 범용 스킬

| 스킬 유형 | 보조 파일 배치 |
|-----------|---------------|
| **프로젝트 스킬** (해당 프로젝트 전용) | 프로젝트에 이미 있는 파일은 경로로 참조, 복사하지 않음 |
| **범용 스킬** (여러 프로젝트에서 재사용) | 필요한 파일을 스킬 디렉토리 안에 포함 (자체 완결) |

```
# 프로젝트 스킬 — 외부 파일을 경로로 참조
.claude/skills/run-eval/
└── SKILL.md              # evaluation/result-template.md 경로 참조

# 범용 스킬 — 필요한 파일을 모두 내장
problem-solving-skills/skills/agile-process/
├── SKILL.md
├── template.md           # 자체 포함
└── reference/
    └── principles.md     # 자체 포함
```

---

## 3. SKILL.md 구조

두 부분으로 구성된다:

```yaml
---
# YAML Frontmatter (설정)
name: my-skill
description: 스킬이 하는 일과 사용 시점
---

# Markdown Body (지시 내용)
Claude가 따라야 할 지시사항...
```

### 3.1 Frontmatter 필드 상세

| 필드 | 필수 | 설명 | 기본값 |
|------|------|------|--------|
| `name` | 아니오 | 슬래시 커맨드명. 소문자+숫자+하이픈, 최대 64자. 생략 시 디렉토리명 사용 | 디렉토리명 |
| `description` | **권장** | 스킬의 용도 설명. Claude가 자동 호출 판단에 사용 | 본문 첫 단락 |
| `argument-hint` | 아니오 | 자동완성 시 표시되는 인자 힌트. 예: `[issue-number]` | 없음 |
| `allowed-tools` | 아니오 | 스킬 활성 시 권한 확인 없이 사용할 도구 목록 | 없음 |
| `disable-model-invocation` | 아니오 | `true`면 Claude 자동 호출 차단 (수동 전용) | `false` |
| `user-invocable` | 아니오 | `false`면 `/` 메뉴에서 숨김 (배경 지식용) | `true` |
| `model` | 아니오 | 사용할 모델 (`sonnet`, `opus`, `haiku` 또는 전체 ID) | 세션 기본값 |
| `context` | 아니오 | `fork`으로 설정 시 격리된 서브에이전트에서 실행 | 메인 컨텍스트 |
| `agent` | 아니오 | `context: fork` 시 사용할 서브에이전트 타입 (`Explore`, `Plan`, `general-purpose`) | `general-purpose` |

### 3.2 호출 제어 매트릭스

| 설정 | 사용자 호출 | Claude 자동 호출 | 컨텍스트 비용 |
|------|------------|-----------------|---------------|
| 기본값 | O | O | description만 상시 로드 |
| `disable-model-invocation: true` | O | X | 0 (호출 전까지 없음) |
| `user-invocable: false` | X | O | description만 상시 로드 |

---

## 4. 변수/인자 전달

스킬 본문에서 사용할 수 있는 변수:

| 변수 | 설명 |
|------|------|
| `$ARGUMENTS` | 호출 시 전달된 모든 인자 |
| `$ARGUMENTS[N]` / `$N` | N번째 인자 (0부터 시작) |
| `${CLAUDE_SESSION_ID}` | 현재 세션 ID |
| `` !`command` `` | 셸 전처리: 스킬 로드 전에 실행, 결과로 치환 |

**예시:** `/fix-issue 123` 실행 시 본문의 `$ARGUMENTS`는 `123`으로 치환된다.

`$ARGUMENTS`가 본문에 없으면 끝에 `ARGUMENTS: <값>` 자동 추가.

---

## 5. 사용 가능한 도구 목록

`allowed-tools`에 지정할 수 있는 도구:

| 도구 | 설명 |
|------|------|
| `Read` | 파일 읽기 |
| `Write` | 파일 생성/덮어쓰기 |
| `Edit` | 기존 파일 수정 |
| `Bash` | 셸 명령 실행 |
| `Bash(패턴)` | 특정 명령만 허용. 예: `Bash(gh *)`, `Bash(python *)` |
| `Glob` | 파일 패턴 검색 |
| `Grep` | 파일 내용 정규식 검색 |
| `WebFetch` | URL 내용 가져오기 |
| `WebSearch` | 웹 검색 |
| `Task` | 서브에이전트 생성/관리 |
| `AskUserQuestion` | 사용자에게 선택형 질문 |
| `TaskOutput` | 백그라운드 태스크 출력 조회 |
| MCP 도구 | MCP 서버가 제공하는 도구 |

---

## 6. 좋은 스킬의 기준 (평가 시 참고)

### 해야 하는 것 (Best Practices)

| 항목 | 설명 |
|------|------|
| **명확한 description** | 무엇을, 언제, 왜 사용하는지 구체적으로 기술 |
| **적절한 도구 스코프** | 필요한 도구만 `allowed-tools`에 지정 |
| **부작용 스킬에 수동 전용 설정** | 배포, 전송 등은 `disable-model-invocation: true` |
| **500줄 이하** | 상세 자료는 보조 파일로 분리 |
| **보조 파일 참조 명시** | SKILL.md에서 보조 파일의 존재와 용도 언급 |
| **단계별 구조** | 태스크 스킬은 명확한 단계 순서 제공 |

### 하지 말아야 하는 것 (Anti-Patterns)

| 안티패턴 | 문제 |
|----------|------|
| SKILL.md에 수백 줄의 레퍼런스 | 컨텍스트 낭비, 가독성 저하 |
| 부작용 스킬에 자동 호출 허용 | Claude가 예기치 않게 배포/전송 실행 |
| 모호한 description | `"코드 도움"` → 거의 모든 상황에서 호출되거나 아예 안 됨 |
| `context: fork` + 태스크 없는 본문 | 서브에이전트가 할 일 없이 반환 |
| 보조 파일 미참조 | Claude가 보조 파일 존재를 모름 |
| `user-invocable: false`를 보안 수단으로 사용 | 메뉴에서만 숨길 뿐, Claude는 여전히 호출 가능 |

---

## 7. 평가 시 체크포인트

모델이 생성한 스킬을 정성 평가할 때 아래 항목을 확인한다:

### 구조적 정확성

- [ ] `SKILL.md` 파일이 올바른 위치에 있는가? (`.claude/skills/<name>/SKILL.md`)
- [ ] YAML frontmatter 문법이 올바른가? (`---`로 감싸짐)
- [ ] `name` 필드가 소문자+숫자+하이픈 규칙을 따르는가?
- [ ] `description`이 구체적이고 용도를 명확히 설명하는가?

### 디렉토리 활용

- [ ] 보조 파일이 적절히 분류되어 있는가?
- [ ] SKILL.md에서 보조 파일을 참조하는가?

### 도구 설정

- [ ] `allowed-tools`가 필요한 도구만 포함하는가? (과도하지 않은가)
- [ ] 부작용이 있는 스킬에 `disable-model-invocation: true`가 있는가?
- [ ] `Bash` 사용 시 패턴 제한이 적절한가? (필요한 경우)

### 본문 품질

- [ ] 지시가 명확하고 단계별로 구성되어 있는가?
- [ ] `$ARGUMENTS`를 적절히 활용하는가?
- [ ] 500줄 이하인가? (초과 시 보조 파일 분리 여부)
- [ ] 보조 파일이 있으면 SKILL.md에서 참조하는가?

### 워크플로우 적합성

- [ ] 프로젝트의 기존 패턴/철학과 일관성이 있는가?
- [ ] 실제 사용 시나리오에 맞는 흐름인가?
- [ ] 사용자 확인이 필요한 지점에서 확인을 요청하는가?
- [ ] 에러/예외 상황을 고려하는가?

### 시각화 (해당 시)

- [ ] Mermaid 다이어그램이 문법적으로 올바른가?
- [ ] 다이어그램이 워크플로우를 정확히 표현하는가?
- [ ] 렌더링 가능한가? (문법 오류 없음)

---

## 8. Claude Code 고유 기능

이 섹션은 Claude Code에만 있고 다른 에이전트에는 없는 기능을 다룬다.

### 8.1 서브에이전트 (Forked Context)

```yaml
context: fork
agent: Explore
```

- 격리된 컨텍스트에서 실행 (대화 히스토리 접근 불가)
- 결과를 요약해서 메인 대화에 반환
- **주의:** 태스크 지시 없이 레퍼런스만 있으면 의미 있는 출력 없음
- 서브에이전트는 다른 서브에이전트를 생성할 수 없음 (중첩 불가)

### 8.2 스킬 단위 도구 제한 (allowed-tools)

Claude Code만 frontmatter에서 스킬별로 사용 가능한 도구를 제한할 수 있다:

```yaml
allowed-tools: Read, Grep, Bash(gh *)
```

패턴 제한도 가능하다 (`Bash(python *)` → python 명령만 허용).
다른 에이전트(Gemini CLI, Codex)에는 이 기능이 없다.

### 8.3 세밀한 호출 제어

Claude Code는 frontmatter만으로 호출 제어가 가능하다:
- `disable-model-invocation: true` → 자동 호출 차단
- `user-invocable: false` → `/` 메뉴에서 숨김

다른 에이전트는 별도 파일(Codex의 `openai.yaml`)이 필요하거나, 해당 기능 자체가 없다(Gemini CLI).

---

## 9. 공식 문서 URL

| 문서 | URL |
|------|-----|
| 스킬 공식 문서 | https://code.claude.com/docs/en/skills.md |
| Agent Skills 오픈 표준 | https://agentskills.io |
