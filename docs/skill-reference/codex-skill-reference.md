# Codex CLI 스킬 명세 레퍼런스

> **대상 에이전트:** Codex CLI (OpenAI)
> **마지막 확인일:** 2026-02-21
> 이 문서는 Codex CLI가 생성한 스킬의 **정성 평가** 시 참고하기 위한 레퍼런스이다.
> Claude Code, Gemini CLI 레퍼런스는 별도 문서를 참고한다.

---

## 1. 스킬이란?

Codex CLI에서 스킬은 **온디맨드로 로드되는 전문 역량 단위**이다.
`SKILL.md` 파일을 포함하는 디렉토리가 곧 하나의 스킬이며, Codex에게 특정 도메인의 전문 지식이나 워크플로우를 가르친다.
스킬은 [Agent Skills](https://agentskills.io) 오픈 표준을 따른다 (Claude Code, Gemini CLI와 동일).

핵심 특징:
- `AGENTS.md`(항상 로드)와 달리 **필요할 때만 활성화**된다
- 사용자가 `$skill-name`으로 명시적 호출하거나, Codex가 description 매칭으로 암묵적 호출할 수 있다
- 슬래시(`/`)가 아닌 **달러 기호(`$`)**로 호출하는 것이 Codex의 특징이다

### 1.1 스킬 활성화의 실체

"암묵적 호출"의 동작 흐름:

1. **CLI 시작** → Codex가 모든 스킬의 `name` + `description`을 인식 (본문은 아직 안 읽음)
2. **사용자가 대화** → Codex가 description을 보고 관련 스킬이 있는지 판단
3. **매칭되면** → 자동으로 스킬을 선택하여 활성화
4. **활성화 시** → SKILL.md 본문이 컨텍스트에 로드

**호출 제어:** `agents/openai.yaml`에서 `policy.allow_implicit_invocation: false`로 설정하면 암묵적 호출을 차단하고 `$skill-name` 명시 호출만 허용할 수 있다.

**Claude Code와의 차이:** Claude Code는 frontmatter의 `disable-model-invocation`으로 제어하지만, Codex는 별도 yaml 파일의 `policy` 섹션에서 제어한다.

---

## 2. 디렉토리 구조

### 2.1 스킬 위치 (스코프)

| 스코프 | 경로 | 적용 범위 |
|--------|------|-----------|
| REPO (현재) | `.agents/skills/<스킬명>/` | 폴더별 특화 워크플로우 |
| REPO (상위) | `../.agents/skills/<스킬명>/` | 중첩 저장소 |
| REPO (루트) | `$REPO_ROOT/.agents/skills/<스킬명>/` | 팀 공통 스킬 |
| USER | `~/.agents/skills/<스킬명>/` | 개인 크로스 프로젝트 |
| ADMIN | `/etc/codex/skills/` | 시스템 전체 기본값 |
| SYSTEM | 번들 내장 | OpenAI 제공 기본 스킬 |

### 2.2 스킬 디렉토리 레이아웃

```
<skill-name>/
├── SKILL.md              # 메인 지시 파일 (필수, 유일한 필수 파일)
├── agents/
│   └── openai.yaml       # UI 메타데이터 + 호출 정책 (선택, Codex 고유)
├── scripts/              # 실행 가능한 스크립트 (선택)
├── references/           # 참조 문서 (선택)
└── assets/               # 템플릿, 리소스 (선택)
```

**핵심 규칙:**
- `SKILL.md`가 유일한 필수 파일
- `agents/openai.yaml`은 Codex 고유의 추가 설정 파일 (8장 참고)
- 보조 파일은 SKILL.md에서 명시적으로 참조해야 Codex가 인식

### 2.3 보조 파일의 역할과 사용 기준

보조 파일은 모두 선택사항이다. 용도별로 디렉토리가 구분된다:

#### scripts/ — "이건 직접 실행해"

Codex가 셸 도구로 실행하는 스크립트이다.

- **활용 예:** 빌드 스크립트, 데이터 검증, 자동화 도구

#### references/ — "이건 참고 자료야"

스킬 실행 시 Codex가 읽어서 참고하는 정적 문서이다.

- **활용 예:** API 명세, 코딩 컨벤션, 도메인 지식

#### assets/ — "이건 템플릿/리소스야"

템플릿, 이미지, 설정 파일 등 스킬이 사용하는 리소스이다.

- **활용 예:** 결과 보고서 템플릿, 아이콘, 설정 파일

#### 보조 파일 배치 전략: 프로젝트 스킬 vs 범용 스킬

| 스킬 유형 | 보조 파일 배치 |
|-----------|---------------|
| **프로젝트 스킬** (해당 프로젝트 전용) | 프로젝트에 이미 있는 파일은 경로로 참조, 복사하지 않음 |
| **범용 스킬** (여러 프로젝트에서 재사용) | 필요한 파일을 스킬 디렉토리 안에 포함 (자체 완결) |

---

## 3. SKILL.md 구조

두 부분으로 구성된다:

```yaml
---
# YAML Frontmatter (설정)
name: my-skill-name
description: 이 스킬이 언제 호출되어야 하는지 명확하게 설명
---

# Markdown Body (지시 내용)
Codex가 따라야 할 명령형 지시사항 작성...
```

### 3.1 Frontmatter 필드 상세

| 필드 | 필수 | 설명 | 기본값 |
|------|------|------|--------|
| `name` | **필수** | 스킬의 고유 식별자 | 없음 |
| `description` | **필수** | 스킬 역할과 활성화 트리거 | 없음 |

**Claude Code와의 차이:** `name`과 `description`만 공식 확인되었다. Claude Code의 `allowed-tools`, `disable-model-invocation`, `context` 같은 세밀한 제어는 별도 `agents/openai.yaml` 파일에서 담당한다 (8장 참고).

---

## 4. 변수/인자 전달

Codex CLI의 스킬 호출:

```
$skill-name 자연어 인자
```

인자는 자연어로 이어 붙이는 방식이다:
```
$kiro-skill Create a feature spec
$api-auditor Check the /users endpoint
```

SKILL.md 내부에 `{{args}}`나 `$ARGUMENTS` 같은 템플릿 변수 메커니즘은 확인되지 않았다.

**Claude Code와의 차이:** Claude Code는 스킬 본문에서 `$ARGUMENTS`, `$0`, `$1` 등으로 인자를 직접 참조할 수 있다. Codex는 자연어 이어붙이기 방식만 지원한다.

---

## 5. 사용 가능한 도구 목록

`config.toml`의 `[features]` 섹션으로 제어한다. Claude Code와 달리 스킬 단위로 도구를 제한하는 `allowed-tools` 기능은 없다.

| 도구 | 설정 키 | 기본값 |
|------|---------|--------|
| 셸 명령 실행 | `features.shell_tool` | `true` |
| 웹 검색 | `web_search` | `"cached"` |
| 단일 실행 PTY | `features.unified_exec` | beta |
| apply_patch (자유형) | `features.apply_patch_freeform` | experimental |
| 멀티 에이전트 | `features.multi_agent` | `false` |

멀티 에이전트 활성화 시 추가 도구: `spawn_agent`, `send_input`, `resume_agent`, `wait`, `close_agent`

---

## 6. 좋은 스킬의 기준 (평가 시 참고)

### 해야 하는 것 (Best Practices)

| 항목 | 설명 |
|------|------|
| **명확한 description** | 무엇을, 언제, 왜 사용하는지 구체적으로 기술. 활성화 트리거 역할 |
| **`name`과 `description` 필수** | Codex에서는 둘 다 필수 필드 |
| **명령형 어조** | SKILL.md 본문은 명령형으로 작성 |
| **보조 파일 분류** | `scripts/`, `references/`, `assets/` 용도별 디렉토리 활용 |
| **보조 파일 참조 명시** | SKILL.md에서 보조 파일의 존재와 용도 언급 |
| **단계별 구조** | 태스크형 스킬은 명확한 단계 순서 제공 |

### 하지 말아야 하는 것 (Anti-Patterns)

| 안티패턴 | 문제 |
|----------|------|
| 모호한 description | `"코드 도움"` → 매칭 정확도 저하 |
| 보조 파일 미참조 | Codex가 보조 파일 존재를 모름 |
| 기존 파일을 전체 덮어쓰기 | 부분 수정이 필요한 상황에서 내용 유실 위험 |
| SKILL.md에 과도한 내용 | 스킬 디렉토리의 보조 파일로 분리 권장 |
| `allow_implicit_invocation` 미설정 | 부작용 있는 스킬이 자동 호출될 위험 |

---

## 7. 평가 시 체크포인트

Codex CLI 모델이 생성한 스킬을 정성 평가할 때 아래 항목을 확인한다:

### 구조적 정확성

- [ ] `SKILL.md`가 올바른 위치에 있는가? (`.agents/skills/<name>/SKILL.md`)
- [ ] YAML frontmatter 문법이 올바른가? (`---`로 감싸짐)
- [ ] `name`과 `description`이 모두 있는가? (둘 다 필수)
- [ ] `description`이 활성화 트리거로 충분히 구체적인가?
- [ ] `agents/openai.yaml`이 필요한 경우 올바르게 작성되었는가?

### 디렉토리 활용

- [ ] 보조 파일이 적절히 분류되어 있는가? (`scripts/`, `references/`, `assets/`)
- [ ] SKILL.md에서 보조 파일을 참조하는가?

### 본문 품질

- [ ] 지시가 명확하고 단계별로 구성되어 있는가?
- [ ] 명령형 어조로 작성되어 있는가?
- [ ] 보조 파일이 있으면 SKILL.md에서 참조하는가?

### 도구 사용 (평가 관찰)

- [ ] 기존 파일 수정 시 적절한 도구를 선택하는가? (전체 덮어쓰기 vs 부분 수정)
- [ ] 확인이 필요한 지점에서 사용자에게 물어보는가?

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

## 8. Codex CLI 고유 기능

이 섹션은 Codex CLI에만 있고 다른 에이전트에는 없는 기능을 다룬다.

### 8.1 AGENTS.md (프로젝트 지시사항 파일)

Claude Code의 `CLAUDE.md`, Gemini CLI의 `GEMINI.md`에 해당한다.

#### 파일 탐색 우선순위

1. `~/.codex/AGENTS.override.md` (전역 오버라이드)
2. `~/.codex/AGENTS.md` (전역 기본값)
3. Git 루트 → 현재 디렉토리까지 각 레벨에서:
   - `AGENTS.override.md` 우선 확인
   - 없으면 `AGENTS.md`
   - 없으면 `project_doc_fallback_filenames`에 지정된 파일명

루트에서 현재 디렉토리 방향으로 누적 연결(concatenate). 더 깊은 파일이 앞 내용을 보완/오버라이드한다.

#### config.toml 커스터마이즈

```toml
project_doc_fallback_filenames = ["TEAM_GUIDE.md", ".agents.md"]
project_doc_max_bytes = 65536   # 기본: 32 KiB
```

**참고:** `AGENTS.md`는 OpenAI Codex 외에도 여러 AI 에이전트 도구가 읽는 공개 표준 포맷이다 (Linux Foundation 산하 Agentic AI Foundation 관리, https://agents.md/).

### 8.2 agents/openai.yaml (Codex 고유 설정 파일)

Codex만의 추가 설정 파일로, UI 메타데이터와 호출 정책을 정의한다:

```yaml
interface:
  display_name: "사용자에게 보이는 이름"
  short_description: "UI 표시용 설명"
  icon_small: "./assets/small-logo.svg"
  icon_large: "./assets/large-logo.png"
  brand_color: "#3B82F6"
  default_prompt: "선택적 기본 프롬프트"

policy:
  allow_implicit_invocation: false  # false면 $skill-name 명시 호출만 허용

dependencies:
  tools:
    - type: "mcp"
      value: "toolIdentifier"
      description: "도구 설명"
      transport: "streamable_http"
      url: "https://endpoint.url"
```

| 섹션 | 역할 |
|------|------|
| `interface` | Codex 앱 UI 표시 설정 (CLI에서는 필수 아님) |
| `policy` | 암묵적 호출 허용 여부 제어 |
| `dependencies` | MCP 도구 의존성 선언 |

### 8.3 빌트인 슬래시 명령어

사용자 정의 슬래시 명령어는 미지원. 빌트인 명령어만 제공:

| 명령어 | 기능 |
|--------|------|
| `/model` | 모델 전환 |
| `/plan` | 계획 모드 진입 |
| `/new` | 새 대화 시작 |
| `/resume` | 이전 세션 재개 |
| `/fork` | 현재 대화 복제 |
| `/agent` | 서브 에이전트 스레드 전환 |
| `/permissions` | 승인 정책 조정 |
| `/diff` | Git 변경사항 리뷰 |
| `/compact` | 대화 요약 (컨텍스트 절약) |
| `/skills` | 스킬 목록 표시 |
| `/mcp` | MCP 도구 목록 표시 |
| `/status` | 세션 설정 및 토큰 사용량 |

### 8.4 스킬 활성화/비활성화

`config.toml`에서 제어:
```toml
[[skills.config]]
path = "/path/to/my-skill"
enabled = false   # 삭제하지 않고 비활성화
```

---

## 9. 에이전트 비교: Claude Code vs Codex CLI

| 기능 | Claude Code | Codex CLI |
|------|-------------|-----------|
| 프로젝트 지시사항 파일 | `CLAUDE.md` | `AGENTS.md` |
| 스킬 시스템 | `.claude/skills/` | `.agents/skills/` |
| 스킬 호출 접두사 | `/skill-name` | `$skill-name` |
| 커스텀 슬래시 명령어 | `.claude/commands/*.md` | **미지원** |
| 인자 전달 | `$ARGUMENTS`, `$0`, `$1` | 자연어 이어붙이기 |
| 스킬 frontmatter | 10+ 필드 | 2필드 (`name`, `description`) |
| 추가 설정 파일 | 없음 (frontmatter에 통합) | `agents/openai.yaml` (별도) |
| 스킬 도구 제한 | `allowed-tools` | 미지원 |
| 자동호출 제어 | `disable-model-invocation` | `policy.allow_implicit_invocation` (yaml) |
| 오픈 표준 | Agent Skills 표준 | Agent Skills 표준 (동일) |

---

## 10. 공식 문서 URL

| 문서 | URL |
|------|-----|
| 스킬 개요 | https://developers.openai.com/codex/skills/ |
| AGENTS.md 가이드 | https://developers.openai.com/codex/guides/agents-md/ |
| 슬래시 명령어 | https://developers.openai.com/codex/cli/slash-commands/ |
| 설정 레퍼런스 | https://developers.openai.com/codex/config-reference/ |
| AGENTS.md 공개 표준 | https://agents.md/ |
