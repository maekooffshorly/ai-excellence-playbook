# Skills

This document covers Claude Code skills — model-invoked capabilities that activate automatically based on intent, without requiring a slash command. Skills complement the agent-based workflow covered in [`docs/04-coding-techniques.md`](04-coding-techniques.md) and the event-driven hooks in [`docs/13-hooks-and-automation.md`](13-hooks-and-automation.md).

---

## What Skills Are

Skills are instruction files placed in `.claude/skills/` that Claude Code reads at the start of each session. When a user's message matches the skill's intent description, Claude automatically loads and applies it — no `/command` required.

The distinction from agents and hooks:

| Primitive | Mental model | Invocation |
|-----------|-------------|-----------|
| **Agent (slash command)** | Multi-step workflow | User types `/command` |
| **Skill** | Model-invoked capability | Claude auto-loads when intent matches |
| **Hook** | Event-driven automation | Fires on lifecycle events — no invocation required |

Skills are best for recurring workflows where you want the right behavior to just happen when you describe what you need, without remembering a command name. They can also be invoked explicitly with `/skill-name` if you prefer direct control.

---

## How Skills Work

Each skill's `SKILL.md` file has a `description` field in its frontmatter. Claude Code reads this description to decide when to activate the skill:

```markdown
---
name: code-review
description: Review code changes and provide structured feedback before a PR is
             created or changes are merged. Use this skill whenever the user asks
             for code review, wants feedback on their implementation, says
             "review my code", "pre-PR review", "check my changes" ...
---

You review code. You never modify it.
[... rest of the instruction ...]
```

When your message matches the description — even loosely — Claude pulls in the skill's full instruction set and applies it. The skill governs what Claude does, what it reads, what output format it uses, and where it stops for approval.

---

## The Three-File Pattern

Each skill ships as three files:

```
skills/
└── {skill-name}/
    ├── SKILL.md                        # Instruction file — what Claude does when activated
    └── references/
        └── {output-template}.md        # Output format Claude follows for responses
```

Plus a user-facing manual at:

```
skills/
└── {skill-name}-manual.md             # Installation steps, trigger phrases, usage guide
```

The `SKILL.md` is what Claude reads. The `references/` files are loaded by the skill itself when it needs a consistent output structure. The manual is for the developer setting up or using the skill.

---

## Shipped Skills

Nine skills are available in the `skills/` folder:

| Skill | What it does | Example trigger phrases | Manual |
|-------|-------------|------------------------|--------|
| `code-review` | Structured pre-PR review — findings classified by severity, acceptance criteria check, test coverage assessment | "Review my code before I open a PR", "check my changes", "is this ready to merge?" | [`skills/code-review-manual.md`](../skills/code-review-manual.md) |
| `test-writer` | Generates a test plan and unit tests; pauses for approval before writing files | "Write tests for this file", "add coverage", "TDD approach", "I need tests for..." | [`skills/test-writer-manual.md`](../skills/test-writer-manual.md) |
| `security-check` | OWASP-based security analysis; findings by severity with OWASP Top 10 assessment | "Check for vulnerabilities", "security scan", "review the auth logic for risks" | [`skills/security-check-manual.md`](../skills/security-check-manual.md) |
| `build-fix` | Diagnoses build/CI failures and proposes a fix; pauses before file writes | Paste error output, "build failed", "CI is broken", "fix this error" | [`skills/build-fix-manual.md`](../skills/build-fix-manual.md) |
| `docs` | Documentation maintenance — pre-PR pass or end-of-day context preservation | "Update the docs", "pre-PR docs pass", "end of day docs", "document this endpoint" | [`skills/docs-manual.md`](../skills/docs-manual.md) |
| `verify` | Pre-PR verification — tests, lint, build, and acceptance criteria checks | "Is this ready for a PR?", "verify my implementation", "does this meet the AC?" | [`skills/verify-manual.md`](../skills/verify-manual.md) |
| `checkpoint` | Session savepoint — documents progress, decisions, blockers, and next steps | "Stepping away", "handing this off", "save my progress", "end of day" | [`skills/checkpoint-manual.md`](../skills/checkpoint-manual.md) |
| `context-seed` | Codebase orientation before starting complex work — architecture map, entry points, patterns, gotchas | "Before we start, read the architecture", "familiarize yourself with the codebase", "context first" | [`skills/context-seed-manual.md`](../skills/context-seed-manual.md) |
| `refactor` | Behavior-preserving code cleanup; proposes a plan and diffs before touching files | "Refactor this", "clean this up", "too much duplication", "simplify the conditionals" | [`skills/refactor-manual.md`](../skills/refactor-manual.md) |

---

## Installing Skills

Skills are placed in a `skills/` directory inside Claude Code's config folder. Two levels are available:

| Location | Scope | Shared with team |
|----------|-------|-----------------|
| `~/.claude/skills/` | All projects on your machine | No |
| `.claude/skills/` (project root) | That project only | Yes — committed to repo |

**Windows path for global skills:** `C:\Users\{your-username}\.claude\skills\`

### Installation steps

1. Choose global (`~/.claude/skills/`) or project-level (`.claude/skills/`) installation
2. Copy the skill folder from the playbook — e.g. `skills/code-review/` → `~/.claude/skills/code-review/`
3. The folder must contain `SKILL.md`; include `references/` if the skill uses output templates
4. Open Claude Code and type `/` — the skill name should appear in the command list
5. If it doesn't appear, restart the Claude Code session

> The `references/` folder must travel with `SKILL.md`. The skill's instruction sheet loads reference files by relative path — they won't resolve if the folder is missing.

---

## Writing a Custom Skill

The minimum structure for a custom skill:

```markdown
---
name: your-skill-name
description: One or more sentences that describe when Claude should activate this
             skill. Be specific — list trigger phrases, intent signals, and
             the kinds of requests that should invoke it. The more precise this
             description, the more reliably Claude will auto-trigger the skill.
---

[Your instruction content here — what Claude should do, what to read,
what output to produce, where to pause for approval, what not to do.]
```

Place the file at `~/.claude/skills/your-skill-name/SKILL.md` (global) or `.claude/skills/your-skill-name/SKILL.md` (project).

**Tips for the description field:**

- List explicit trigger phrases ("use this when the user says X, Y, Z")
- Describe the intent, not just the command ("whenever the user wants to understand the codebase before starting work")
- Include negative signals if needed ("do not trigger for general code questions — only activate when the user explicitly wants a structured review")

For the full skill format with output templates and references, use an existing skill in `skills/` as the starting point.
