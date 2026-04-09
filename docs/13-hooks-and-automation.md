# Hooks and Automation

This document covers Claude Code hooks — event-driven shell commands that run automatically at specific points in the Claude Code lifecycle. Hooks extend the standard workflow covered in [`docs/04-coding-techniques.md`](04-coding-techniques.md) by making quality gates and context preservation ambient rather than manually invoked.

---

## What Hooks Are

Hooks are shell commands, HTTP endpoints, or LLM prompts configured in `settings.json` that fire automatically in response to Claude Code events. They provide deterministic, automatic control over the development workflow.

The distinction from agents and skills:

| Primitive | Mental model | Invocation |
|-----------|-------------|-----------|
| **Agent (slash command)** | Multi-step workflow | User types `/command` |
| **Skill** | Model-invoked capability | Claude auto-loads when intent matches |
| **Hook** | Event-driven automation | Fires on lifecycle events — no invocation required |

Hooks are most valuable for quality gates that need to fire unconditionally — things you don't want to depend on a developer remembering to invoke.

### Hook Event Types

Claude Code exposes a broad set of lifecycle events. The hooks documented in this guide use four of them:

| Event | When it fires | Typical use |
|-------|-------------|------------|
| `PreToolUse` | Before a tool call executes — can block it | Safety guards, destructive command interception |
| `PostToolUse` | After a tool call succeeds | Auto-format, auto-lint, auto-test on file write |
| `Stop` | When Claude finishes a response | Session-end automation: checkpoints, nudges |
| `Notification` | When Claude Code needs user attention | Desktop/system notifications |

Other events exist (`SessionStart`, `PermissionRequest`, `SubagentStart/Stop`, `ConfigChange`, `FileChanged`, and more) — see the [Claude Code Hooks reference](https://code.claude.com/docs/en/hooks) for the full list.

### How Control Works

Each hook communicates with Claude Code through exit codes and optional JSON output:

| Exit code | Meaning |
|-----------|---------|
| `0` | Proceed normally. Any stdout text is passed as context to Claude |
| `2` | Block the action. Stderr content is shown to Claude as feedback |
| Other | Non-blocking error — execution continues, error appears in transcript |

For `PreToolUse` hooks, structured JSON output can also return `"allow"`, `"deny"`, or `"ask"` decisions instead of relying on exit codes alone.

---

## Recommended Hooks

These six hooks are recommended for Offshorly development workflows. They are documented here by intent and behavior — implementation scripts and ready-to-copy `settings.json` config blocks will be developed in a follow-up pass.

> **Implementation note:** Shell scripts and full `settings.json` config are not yet shipped. This section defines the intent, trigger condition, and expected behavior for each hook. When implementation artifacts are ready, they will be added here.

---

### 1. Destructive Command Guard

| Field | Detail |
|-------|--------|
| **Event** | `PreToolUse` |
| **Matcher** | `Bash` |
| **Trigger condition** | Command contains patterns: `rm -rf`, `DROP TABLE`, `--force`, `git reset --hard`, `git push --force`, `truncate`, `DELETE FROM` without a `WHERE` clause |
| **What it does** | Surfaces a warning before the command executes, requiring explicit confirmation before proceeding |
| **Expected behavior** | Command is paused; the specific destructive pattern is flagged with an explanation of what it will do; developer confirms or cancels |
| **Priority** | High — safety net for commands that cannot be undone |
| **Who benefits most** | All roles; highest value for juniors who may not recognize destructive patterns on sight |
| **Caveats** | Pattern matching must be tight enough to avoid false positives on common commands. This hook warns and confirms — it does not silently block |

---

### 2. Auto-Lint and Format on File Change

| Field | Detail |
|-------|--------|
| **Event** | `PostToolUse` |
| **Matcher** | `Edit\|Write` |
| **Trigger condition** | A source file is written (`.py`, `.ts`, `.js`, `.tsx`, `.jsx`, `.php`, etc.) |
| **What it does** | Runs the project's configured linter/formatter on the changed file automatically after each write |
| **Expected behavior** | Linter output surfaced immediately; formatting applied in-place without requiring a manual `eslint --fix` or `black` step |
| **Priority** | High — removes a manual step from every coding loop |
| **Who benefits most** | Everyone; highest visible benefit for juniors who may skip linting |
| **Caveats** | Must be project-config-aware — use `.eslintrc`, `pyproject.toml`, etc., not hardcoded rules. May be noisy on legacy codebases with many pre-existing violations |

---

### 3. Auto-Run Relevant Tests on File Change

| Field | Detail |
|-------|--------|
| **Event** | `PostToolUse` |
| **Matcher** | `Edit\|Write` |
| **Trigger condition** | A source file is written and a corresponding test file exists alongside it |
| **What it does** | Automatically runs the test file that corresponds to the changed source file |
| **Expected behavior** | Test output surfaced in the same context as the change — regressions visible immediately, not deferred to a CI run |
| **Priority** | High for backend and fullstack; lower for frontend-only or infrastructure work |
| **Who benefits most** | Backend and fullstack developers in fast iteration loops; QA on critical paths |
| **Caveats** | Should only run when a corresponding test file is detected — not a full suite run. Pairing heuristic depends on project convention: `test_*.py` alongside `*.py`, `*.spec.ts` alongside `*.ts` |

---

### 4. SonarQube Quality Scan on File Change

| Field | Detail |
|-------|--------|
| **Event** | `PostToolUse` |
| **Matcher** | `Edit\|Write` |
| **Trigger condition** | A source file is written and the SonarQube MCP is active in the session |
| **What it does** | Triggers a SonarQube scan on the changed file and surfaces findings in context |
| **Expected behavior** | Code smells, vulnerabilities, and duplication findings surface immediately after a file is written — not deferred to a separate review step |
| **Priority** | Medium — highest value for teams not in the habit of running manual SonarQube checks |
| **Who benefits most** | All roles; especially developers who rely on CI to catch quality issues |
| **Caveats** | Requires SonarQube MCP to be configured. Can be slow on large files — consider scoping to changed lines rather than whole-file scan. Noisy if the project has a high existing issue count |

---

### 5. Documentation Nudge on Session End

| Field | Detail |
|-------|--------|
| **Event** | `Stop` |
| **Trigger condition** | Claude finishes a response after a session in which source files were modified, and no documentation pass has already been run |
| **What it does** | Surfaces a non-blocking reminder to run `/docs` before closing the session |
| **Expected behavior** | Notification: "Source files were changed this session. Consider running `/docs` before closing." — informational only, does not block |
| **Priority** | Medium — highest value for teams that have historically let documentation drift |
| **Who benefits most** | All roles |
| **Caveats** | Must be non-blocking. Should not fire if `/docs` was already invoked during the session. Detecting whether docs ran may require session state tracking |

---

### 6. Auto-Checkpoint on Session End

| Field | Detail |
|-------|--------|
| **Event** | `Stop` |
| **Trigger condition** | Claude finishes a response after a session in which code files were modified |
| **What it does** | Automatically runs the equivalent of `/checkpoint` — saves current progress, decisions made, and next steps to a savepoint file |
| **Expected behavior** | A `.claude/checkpoints/YYYY-MM-DD-HH-MM.md` savepoint is created at session end without requiring the developer to invoke `/checkpoint` |
| **Priority** | Medium — highest value for multi-session feature work |
| **Who benefits most** | All roles doing multi-session work; especially juniors managing complex features across multiple days |
| **Caveats** | Should only trigger when source files were actually modified — not on every Q&A session. File write location should follow team convention |

---

## How to Configure Hooks

### File Locations

Hooks are defined in `settings.json` files. Where you add them controls their scope:

| File | Scope | Shared with team |
|------|-------|-----------------|
| `~/.claude/settings.json` | All projects on your machine | No |
| `.claude/settings.json` (project root) | That project only | Yes — committed to repo |
| `.claude/settings.local.json` (project root) | That project only | No — gitignored |

**Windows path for global hooks:** `C:\Users\{your-username}\.claude\settings.json`

For team-wide hooks (like the destructive command guard), add them to `.claude/settings.json` in the project root and commit the file. For personal preferences (like notifications), use the global `~/.claude/settings.json`.

### JSON Structure

All hooks follow the same nesting pattern:

```json
{
  "hooks": {
    "{EventName}": [
      {
        "matcher": "{tool-name-regex}",
        "hooks": [
          {
            "type": "command",
            "command": "{shell command or path to script}"
          }
        ]
      }
    ]
  }
}
```

**Matcher patterns:**

- `"Edit|Write"` — matches the Edit or Write tool (pipe = OR in regex)
- `"Bash"` — matches only the Bash tool
- `""` or omit — matches all occurrences of the event

**Hook types:**

| Type | What it does |
|------|-------------|
| `"command"` | Runs a shell command. Most common type |
| `"prompt"` | Sends a prompt to a Claude model for a yes/no decision |
| `"agent"` | Spawns a subagent with tool access to verify conditions |
| `"http"` | POSTs event data to an HTTP endpoint |

For detailed input/output schemas and advanced options, see the [Claude Code Hooks reference](https://code.claude.com/docs/en/hooks).

### Verifying Your Hooks

After editing `settings.json`, open Claude Code and type `/hooks`. This opens the hooks browser showing:

- All configured hook events
- The matcher for each
- The handler type and command
- Which settings file the hook comes from

If a newly added hook doesn't appear, the file watcher may have missed the change — restart the session.

---

## Implementation

Scripts and ready-to-use configuration are in the [`hooks/`](../hooks/) folder at the playbook root.

| Hook | Script | Status |
|------|--------|--------|
| Destructive Command Guard | [`hooks/scripts/guard-destructive.sh`](../hooks/scripts/guard-destructive.sh) | Ready |
| Auto-Lint on File Change | [`hooks/scripts/lint-on-write.sh`](../hooks/scripts/lint-on-write.sh) | Ready |
| Auto-Run Tests on File Change | [`hooks/scripts/test-on-write.sh`](../hooks/scripts/test-on-write.sh) | Ready |
| Documentation Nudge | [`hooks/scripts/docs-nudge.sh`](../hooks/scripts/docs-nudge.sh) | Ready |
| Auto-Checkpoint | [`hooks/scripts/auto-checkpoint.sh`](../hooks/scripts/auto-checkpoint.sh) | Ready |
| SonarQube Scan on File Change | — | Pending (requires SonarQube MCP config) |

For installation steps, customization, and troubleshooting → [`hooks/README.md`](../hooks/README.md)
