# Gemini CLI 스킬 명세 레퍼런스

> **대상 에이전트:** Gemini CLI (Google)
> **마지막 확인일:** 2026-02-21
> 이 문서는 Gemini CLI가 생성한 스킬의 **정성 평가** 시 참고하기 위한 레퍼런스이다.
> Claude Code, Codex 레퍼런스는 별도 문서를 참고한다.

---

## 1. 스킬이란?

Gemini CLI에서 스킬은 **온디맨드로 로드되는 전문 역량 단위**이다.
`SKILL.md` 파일 하나를 포함하는 디렉토리가 곧 하나의 스킬이며, Gemini에게 특정 도메인의 전문 지식이나 워크플로우를 가르친다.
스킬은 [Agent Skills](https://agentskills.io) 오픈 표준을 따른다 (Claude Code, Codex와 동일).

핵심 특징:
- `GEMINI.md`(항상 로드)와 달리 **필요할 때만 활성화**된다
- Gemini가 사용자의 요청과 스킬의 `description`을 매칭하여 자동 활성화를 제안하거나, 사용자가 수동으로 활성화할 수 있다
- 활성화되면 세션 전체 동안 유지된다

### 1.1 스킬 활성화의 실체

"자동 활성화"의 동작 흐름:

1. **CLI 시작** → Gemini가 모든 스킬의 `name` + `description`만 인식 (본문은 아직 안 읽음)
2. **사용자가 대화** → Gemini가 description을 보고 관련 스킬이 있는지 판단
3. **매칭되면** → 사용자에게 "이 스킬을 활성화할까요?" 확인 프롬프트 표시
4. **사용자 승인 시** → SKILL.md 본문 전체 + 디렉토리 파일들이 컨텍스트에 로드

**Claude Code와의 차이:** Claude Code는 자동으로 로드하지만, Gemini CLI는 활성화 전에 사용자 확인을 거친다.

---

## 2. 디렉토리 구조

### 2.1 스킬 위치 (스코프)

| 스코프 | 경로 | 적용 범위 |
|--------|------|-----------|
| 워크스페이스 | `.gemini/skills/<스킬명>/` | 해당 프로젝트 (버전 관리, 팀 공유 권장) |
| 사용자 | `~/.gemini/skills/<스킬명>/` | 모든 프로젝트 (개인) |

`.agents/skills/` 경로도 별칭으로 사용 가능하다.

우선순위: 워크스페이스 > 사용자 > 익스텐션 번들

### 2.2 스킬 디렉토리 레이아웃

```
<skill-name>/
├── SKILL.md        # 메인 지시 파일 (필수, 유일한 필수 파일)
├── scripts/        # 실행 가능한 스크립트 (선택)
├── references/     # 정적 참조 문서 (선택)
└── assets/         # 템플릿, 리소스 (선택)
```

**핵심 규칙:**
- `SKILL.md`가 유일한 필수 파일
- 보조 파일은 SKILL.md에서 명시적으로 참조해야 Gemini가 인식
- 활성화 시 디렉토리 전체에 대한 파일 접근 권한이 부여됨

### 2.3 보조 파일의 역할과 사용 기준

보조 파일은 모두 선택사항이다. 용도별로 디렉토리가 구분된다:

#### scripts/ — "이건 직접 실행해"

Gemini가 `run_shell_command` 도구로 실행하는 스크립트이다.

- **활용 예:** API 감사 스크립트, 데이터 검증, 시각화 생성

#### references/ — "이건 참고 자료야"

스킬 실행 시 Gemini가 읽어서 참고하는 정적 문서이다.

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
name: api-auditor
description: API 엔드포인트 감사 및 테스트 전문. 사용자가 URL이나 API를 'check', 'test', 'audit'할 때 사용.
---

# Markdown Body (지시 내용)
Gemini가 따라야 할 지시사항...
```

### 3.1 Frontmatter 필드 상세

| 필드 | 필수 | 설명 | 기본값 |
|------|------|------|--------|
| `name` | **필수** | 스킬의 고유 식별자. 디렉토리 이름과 일치 권장 | 없음 |
| `description` | **필수** | 스킬 역할과 활성화 트리거. 모델이 이 필드만 보고 매칭 판단 | 없음 |

**Claude Code와의 차이:** Gemini CLI의 SKILL.md frontmatter는 `name`과 `description` 두 필드만 공식 확인되었다. Claude Code의 `allowed-tools`, `disable-model-invocation`, `context`, `argument-hint` 같은 세밀한 제어 필드가 없다.

### 3.2 스킬 로딩 메커니즘

1. CLI 시작 시: `name`과 `description`만 인식
2. 활성화 시: `SKILL.md` 본문 전체 + 디렉토리 파일들이 컨텍스트에 로드
3. 스킬 디렉토리에 대한 파일 접근 권한 부여
4. 세션 전체 동안 활성 상태 유지

**활성화 방법:**
1. 사용자가 description에 매칭되는 자연어 요청
2. `/skills list`로 목록 확인 후 수동 활성화
3. 모델이 작업 매칭 감지 → 사용자에게 확인 프롬프트 → 승인

---

## 4. 변수/인자 전달

Gemini CLI 스킬(SKILL.md)에는 공식적인 인자 전달 메커니즘이 확인되지 않았다. 스크립트의 `process.argv` 등 간접 방식만 언급된다.

단, **커스텀 슬래시 명령어**(별도 시스템, 8장 참고)에서는 삽입 구문을 지원한다:

| 구문 | 설명 |
|------|------|
| `{{args}}` | 사용자 인자를 해당 위치에 삽입 |
| `!{shell command}` | 셸 명령어 실행 후 결과 삽입 |
| `@{file/path}` | 파일/디렉토리 내용 삽입 |

**Claude Code와의 차이:** Claude Code는 스킬 본문에서 `$ARGUMENTS`, `$0`, `$1` 등으로 인자를 직접 참조할 수 있다. Gemini CLI 스킬에는 이에 해당하는 메커니즘이 없다.

---

## 5. 사용 가능한 도구 목록

Gemini CLI의 내장 도구이다. Claude Code와 달리 스킬 단위로 도구를 제한하는 `allowed-tools` 기능은 없다.

### 파일 시스템 도구

| 도구 ID | 설명 |
|---------|------|
| `list_directory` | 파일/서브디렉토리 목록 조회 |
| `read_file` | 파일 내용 읽기 (텍스트, 이미지, PDF 지원) |
| `write_file` | 파일 생성 또는 덮어쓰기 |
| `glob` | 패턴으로 파일 검색 |
| `search_file_content` | 파일 내 텍스트 검색 |
| `replace` | 파일 내 정밀 편집 |

### 에이전트 조정 도구

| 도구 ID | 설명 |
|---------|------|
| `ask_user` | 사용자에게 명확화 요청 |
| `save_memory` | 장기 메모리에 사실 저장 |
| `write_todos` | 서브태스크 목록 관리 |
| `activate_skill` | 전문 스킬 로드 |

### 정보 수집 도구

| 도구 ID | 설명 |
|---------|------|
| `run_shell_command` | 셸 명령어 실행 |
| `web_fetch` | URL에서 콘텐츠 가져오기 |
| `google_web_search` | Google 검색 |
| `read_many_files` | 여러 파일 일괄 읽기 |

---

## 6. 좋은 스킬의 기준 (평가 시 참고)

### 해야 하는 것 (Best Practices)

| 항목 | 설명 |
|------|------|
| **명확한 description** | 무엇을, 언제, 왜 사용하는지 구체적으로 기술. 활성화 트리거 역할 |
| **`name`과 `description` 필수** | Gemini CLI에서는 둘 다 필수 필드 |
| **보조 파일 분류** | `scripts/`, `references/`, `assets/` 용도별 디렉토리 활용 |
| **보조 파일 참조 명시** | SKILL.md에서 보조 파일의 존재와 용도 언급 |
| **단계별 구조** | 태스크형 스킬은 명확한 단계 순서 제공 |

### 하지 말아야 하는 것 (Anti-Patterns)

| 안티패턴 | 문제 |
|----------|------|
| 모호한 description | `"코드 도움"` → 매칭 정확도 저하 |
| 보조 파일 미참조 | Gemini가 보조 파일 존재를 모름 |
| `write_file`로 기존 파일 전체 덮어쓰기 | `replace`를 사용해야 할 상황에서 내용 유실 위험 |
| SKILL.md에 과도한 내용 | 스킬 디렉토리의 보조 파일로 분리 권장 |

---

## 7. 평가 시 체크포인트

Gemini CLI 모델이 생성한 스킬을 정성 평가할 때 아래 항목을 확인한다:

### 구조적 정확성

- [ ] `SKILL.md`가 올바른 위치에 있는가? (`.gemini/skills/<name>/SKILL.md`)
- [ ] YAML frontmatter 문법이 올바른가? (`---`로 감싸짐)
- [ ] `name`과 `description`이 모두 있는가? (둘 다 필수)
- [ ] `description`이 활성화 트리거로 충분히 구체적인가?

### 디렉토리 활용

- [ ] 보조 파일이 적절히 분류되어 있는가? (`scripts/`, `references/`, `assets/`)
- [ ] SKILL.md에서 보조 파일을 참조하는가?

### 본문 품질

- [ ] 지시가 명확하고 단계별로 구성되어 있는가?
- [ ] 스크립트가 필요한 경우 `scripts/`에 분리되어 있는가?
- [ ] 보조 파일이 있으면 SKILL.md에서 참조하는가?

### 도구 사용 (평가 관찰)

- [ ] `write_file` vs `replace`를 상황에 맞게 구분하는가?
- [ ] 기존 파일 수정 시 `replace`를 사용하는가? (`write_file`로 덮어쓰지 않는가?)
- [ ] `ask_user`로 확인이 필요한 지점에서 확인을 요청하는가?

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

## 8. Gemini CLI 고유 기능

이 섹션은 Gemini CLI에만 있고 다른 에이전트에는 없는 기능을 다룬다.

### 8.1 GEMINI.md (프로젝트 컨텍스트 파일)

Claude Code의 `CLAUDE.md`에 해당한다. 모든 프롬프트와 함께 모델에게 전달되는 영구 지시사항을 담는다.

#### 계층 구조 (로드 순서)

1. `~/.gemini/GEMINI.md` — 전역 (모든 프로젝트에 적용)
2. 현재 디렉토리 ~ `.git` 폴더까지의 상위 디렉토리 `GEMINI.md` — 프로젝트 범위
3. 현재 위치 하위 디렉토리의 `GEMINI.md` — 서브디렉토리 범위

모든 발견된 파일의 내용이 연결(concatenate)되어 모델에게 한 번에 전달된다.

#### 모듈화 (import 문법)

```
@./components/instructions.md
@../shared/style-guide.md
```

`@파일경로` 형식으로 다른 마크다운 파일을 임포트할 수 있다.

#### 관련 명령어

| 명령어 | 기능 |
|--------|------|
| `/memory show` | 현재 로드된 모든 GEMINI.md 내용 표시 |
| `/memory refresh` | GEMINI.md 파일 재로드 |
| `/memory add <텍스트>` | 전역 `~/.gemini/GEMINI.md`에 내용 추가 |
| `/init` | 프로젝트용 GEMINI.md 초안 자동 생성 |

### 8.2 커스텀 슬래시 명령어

스킬과 별도로 **간단한 프롬프트 단축키**를 TOML 파일로 정의할 수 있다.

#### 디렉토리 구조

```
~/.gemini/commands/          # 전역 (모든 프로젝트)
<project>/.gemini/commands/  # 프로젝트 범위
```

프로젝트 명령어가 전역보다 우선순위가 높다.

#### 파일 형식

TOML 파일 (`.toml` 확장자 필수). 파일명이 명령어명이 된다:
- `test.toml` → `/test`
- `git/commit.toml` → `/git:commit` (디렉토리가 네임스페이스로 변환)

#### TOML 필드

| 필드 | 필수 | 설명 |
|------|------|------|
| `prompt` | **필수** | 실행 시 모델에게 전달될 프롬프트 |
| `description` | 선택 | `/help` 메뉴에 표시될 설명 |

#### 예시

```toml
description = "Staged 변경사항으로 커밋 메시지 작성"
prompt = """
아래는 현재 staged된 변경사항이다:

!{git diff --staged}

이 변경사항에 대한 명확하고 간결한 커밋 메시지를 작성해줘.
"""
```

### 8.3 스킬 관리 명령어

```bash
gemini skills list
gemini skills install <git-repo | local-dir | .skill-file>
gemini skills link <local-dir>
gemini skills uninstall <name>
gemini skills enable <name>
gemini skills disable <name>
```

---

## 9. 에이전트 비교: Claude Code vs Gemini CLI

| 기능 | Claude Code | Gemini CLI |
|------|-------------|------------|
| 프로젝트 지시사항 파일 | `CLAUDE.md` | `GEMINI.md` |
| 스킬 시스템 | `.claude/skills/` (SKILL.md) | `.gemini/skills/` (SKILL.md) |
| 커스텀 슬래시 명령어 | `.claude/commands/*.md` | `.gemini/commands/*.toml` |
| 명령어 인자 전달 | `$ARGUMENTS` | `{{args}}` |
| 셸 명령어 삽입 | `` !`command` `` (스킬 전처리) | `!{command}` (명령어 내) |
| 파일 내용 삽입 | 미지원 | `@{file/path}` |
| 스킬 frontmatter | 10+ 필드 (도구 제어, 호출 제어 등) | 2필드 (`name`, `description`만) |
| 스킬 도구 제한 | `allowed-tools` 필드로 세밀 제어 | 미지원 |
| 스킬 자동호출 제어 | `disable-model-invocation` | 미지원 (활성화 전 사용자 확인으로 대체) |
| 오픈 표준 | Agent Skills 표준 | Agent Skills 표준 (동일) |

---

## 10. 공식 문서 URL

| 문서 | URL |
|------|-----|
| 공식 문서 홈 | https://geminicli.com/docs/ |
| GEMINI.md 가이드 | https://geminicli.com/docs/cli/gemini-md/ |
| 커스텀 슬래시 명령어 | https://geminicli.com/docs/cli/custom-commands/ |
| 에이전트 스킬 | https://geminicli.com/docs/cli/skills/ |
| 스킬 생성 가이드 | https://geminicli.com/docs/cli/creating-skills/ |
| 도구 목록 | https://geminicli.com/docs/tools/ |
