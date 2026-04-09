# Hooks — Implementation Guide

This folder contains ready-to-use hook scripts for Offshorly engineering projects. The scripts implement the 6 hooks recommended in [`docs/12-hooks-and-automation.md`](../docs/12-hooks-and-automation.md).

Hooks in this folder are the **source files** — copy them into your project's `.claude/hooks/` directory to use them.

---

## What's in This Folder

| File | Purpose |
|------|---------|
| `README.md` | This guide |
| `settings-template.json` | Copy-paste `settings.json` config for all hooks |
| `scripts/guard-destructive.sh` | PreToolUse: block destructive Bash commands |
| `scripts/lint-on-write.sh` | PostToolUse: auto-lint after every file write |
| `scripts/test-on-write.sh` | PostToolUse: auto-run paired test file after source file write |
| `scripts/docs-nudge.sh` | Stop: remind to run /docs if source files were changed |
| `scripts/auto-checkpoint.sh` | Stop: write a minimal savepoint file at session end |

---

## Hooks at a Glance

| Hook | Event | Trigger | Effect | Default |
|------|-------|---------|--------|---------|
| Destructive Command Guard | `PreToolUse` | `Bash` tool | Blocks `rm -rf`, force-push, DROP commands | Include always |
| Auto-Lint on File Write | `PostToolUse` | `Edit\|Write` | Runs project linter on changed file | Include if linter is configured |
| Auto-Run Tests on File Write | `PostToolUse` | `Edit\|Write` | Runs paired test file if it exists | Include if tests exist |
| Documentation Nudge | `Stop` | Always | Reminds to run `/docs` if source files changed | Include — non-blocking |
| Auto-Checkpoint | `Stop` | Always | Writes a git-status savepoint to `.claude/checkpoints/` | Optional — creates files |

> **SonarQube Scan** (also documented in `docs/12-hooks-and-automation.md`) is not included here — it requires SonarQube MCP to be active and project-specific config. Implement it separately once SonarQube is configured.

---

## Prerequisites

### `jq` — required for all scripts

All scripts parse hook input with `jq`. Install it before using any hook:

| Platform | Command |
|----------|---------|
| macOS | `brew install jq` |
| Ubuntu/Debian | `sudo apt-get install jq` |
| Windows (winget) | `winget install jqlang.jq` |
| Windows (Chocolatey) | `choco install jq` |

Verify: `jq --version`

### `git` — required for `docs-nudge.sh` and `auto-checkpoint.sh`

These two scripts read `git status` to check for modified files. Git is typically already installed in all project environments.

---

## Installation

Do this once for each project where you want to use hooks.

### Step 1 — Copy scripts to the project

```
your-project/
└── .claude/
    └── hooks/
        └── scripts/
            ├── guard-destructive.sh
            ├── lint-on-write.sh
            ├── test-on-write.sh
            ├── docs-nudge.sh
            └── auto-checkpoint.sh
```

Copy the scripts from the playbook's `hooks/scripts/` into your project's `.claude/hooks/scripts/`.

### Step 2 — Make scripts executable (macOS / Linux / Git Bash)

```bash
chmod +x .claude/hooks/scripts/*.sh
```

> **Windows note:** If you're running Claude Code in Git Bash on Windows, `chmod` sets the executable bit in Git's index. Scripts run correctly through Git Bash. If Claude Code runs them via `cmd.exe` or PowerShell, you may need to prefix the command with `bash` — see `settings-template.json` for the Windows-compatible command format.

### Step 3 — Add hooks to your project settings

Copy the contents of `settings-template.json` into your project's `.claude/settings.json`. If the file already has a `hooks` key, merge the entries rather than replacing the whole file.

To use only a subset of hooks, remove the entries you don't need.

### Step 4 — Verify the hooks are registered

Open Claude Code and type `/hooks`. You should see each configured hook listed under its event. Select any hook to see its matcher, type, source file, and command.

If a hook doesn't appear after editing `settings.json`, restart the Claude Code session.

---

## The Hooks

### Destructive Command Guard

**File:** `scripts/guard-destructive.sh`
**Event:** `PreToolUse` | **Matcher:** `Bash`

Scans every Bash command before execution against a list of destructive patterns. If a match is found, the command is blocked with exit 2 — Claude receives the reason and will ask the user to confirm before retrying.

**Patterns flagged:**

| Pattern | Risk |
|---------|------|
| `rm -rf` | Recursive force delete |
| `rm -r /` | Delete from root |
| `git reset --hard` | Discard all local changes |
| `git push --force` / `-f` | Force push — overwrites remote history |
| `git clean -f` / `-fd` | Remove untracked files |
| `DROP TABLE` | Irreversible database table deletion |
| `DROP DATABASE` | Full database deletion |
| `TRUNCATE TABLE` | Empties a database table |
| `DELETE FROM` | SQL delete (flagged even with WHERE — high risk) |

**Customizing:** Edit `scripts/guard-destructive.sh` and update the `PATTERNS` array to add or remove patterns for your project.

**When it fires:** Before every Bash command. Low overhead — pattern matching is fast and the hook exits immediately on no match.

---

### Auto-Lint on File Write

**File:** `scripts/lint-on-write.sh`
**Event:** `PostToolUse` | **Matcher:** `Edit|Write`

After Claude writes or edits a file, this hook runs the project's configured linter on that file. Output is surfaced in context so Claude can fix lint issues without a separate step.

**Supported linters by file type:**

| Extension | Linter checked (in order) |
|-----------|--------------------------|
| `.js`, `.jsx`, `.ts`, `.tsx`, `.vue` | ESLint via `npx eslint` |
| `.py` | ruff, then flake8 |
| `.php` | phpcs |

If none of the checked linters are installed for a given file type, the hook exits silently.

**Customizing:** Edit the `case` block in `scripts/lint-on-write.sh` to add linters or change the command flags. For example, to run `eslint --fix` (auto-fix) instead of reporting only, change the eslint line accordingly.

**Note:** This hook runs synchronously — Claude waits for lint output before continuing. This is intentional so Claude can address lint errors in the same turn. If you find it too slow for large files, set `"async": true` in `settings.json` (output becomes informational only).

---

### Auto-Run Tests on File Write

**File:** `scripts/test-on-write.sh`
**Event:** `PostToolUse` | **Matcher:** `Edit|Write`

After Claude writes a source file, this hook looks for a corresponding test file. If found, it runs that test file and surfaces the output. If not found, exits silently — it does not run the full test suite.

**Test file lookup order (for a source file `src/auth.ts`):**

1. `src/auth.test.ts`
2. `src/auth.spec.ts`
3. `src/__tests__/auth.test.ts`
4. `src/__tests__/auth.spec.ts`
5. `tests/test_auth.ts`
6. `src/tests/test_auth.ts`

Python equivalents follow the same pattern (`test_auth.py`, `auth_test.py`).

Test files are never re-triggered when Claude edits a test file directly.

**Supported test runners:**

| Extension | Runner |
|-----------|--------|
| `.py` | `python -m pytest` |
| `.js`, `.jsx`, `.ts`, `.tsx` | `npx jest` |

**Customizing:** Edit `scripts/test-on-write.sh` to add runners for other languages or adjust the candidate test file paths to match your project's conventions.

**Note:** This hook runs async by default (`"async": true` in the template). Test output appears after the fact — Claude may not see it immediately. Change to sync if you need Claude to react to test failures in the same turn.

---

### Documentation Nudge

**File:** `scripts/docs-nudge.sh`
**Event:** `Stop`

At the end of every Claude response, this hook checks whether any source files were modified in the current session (using `git status`). If modified files are found, it surfaces a one-line reminder to run `/docs`.

**Non-blocking.** This hook always exits 0 — it never prevents Claude from stopping. The reminder is informational.

**Source file types checked:** `.py`, `.js`, `.ts`, `.jsx`, `.tsx`, `.php`, `.go`, `.rs`, `.rb`, `.java`

Excludes `.claude/` files, documentation files, and config files to reduce noise.

**Customizing:** Edit the `grep -E` pattern in `scripts/docs-nudge.sh` to add or remove file extensions for your project's stack.

---

### Auto-Checkpoint

**File:** `scripts/auto-checkpoint.sh`
**Event:** `Stop`

At session end, writes a minimal savepoint to `.claude/checkpoints/YYYY-MM-DD-HH-MM-auto.md` containing:
- List of modified files (from `git status`)
- Full git status output
- Recent commit history (last 5 commits)

**Note:** This creates a structural checkpoint from git state, not an AI-analyzed context summary. For a full checkpoint with decisions made, blockers, and next steps, use the `/checkpoint` skill or slash command. The auto-checkpoint is a fallback for sessions where `/checkpoint` wasn't run manually.

**Runs async** — does not block Claude from finishing.

**Output location:** `.claude/checkpoints/` in the project root. This directory should be gitignored unless the team wants to share checkpoints.

---

## Enable and Disable

### Disable all hooks temporarily

Add to `.claude/settings.local.json` (gitignored, personal):

```json
{
  "disableAllHooks": true
}
```

### Disable an individual hook

Remove its entry from `.claude/settings.json`, or override with an empty hooks array in `.claude/settings.local.json`.

Alternatively, comment out (remove) the specific hook block from `settings.json`.

### Global vs project-level config

| File | Scope | Committed to repo |
|------|-------|------------------|
| `~/.claude/settings.json` | All your projects | No |
| `.claude/settings.json` | This project only | Yes — team shared |
| `.claude/settings.local.json` | This project only | No — personal |

**Recommendation:** Add the Destructive Command Guard to your global `~/.claude/settings.json` so it applies everywhere. Add project-specific hooks (lint, tests) to `.claude/settings.json` so the team shares them.

---

## Troubleshooting

### Hook not appearing in `/hooks`

- Confirm `settings.json` is valid JSON (no trailing commas, no comments)
- Confirm the file is in the right location (`.claude/settings.json` in the project root)
- Restart the Claude Code session if the file watcher missed the change

### `jq: command not found`

Install jq — see Prerequisites above. On Windows, confirm `jq` is on PATH in the shell Claude Code uses (Git Bash or WSL).

### Script exits with `Permission denied`

Run `chmod +x .claude/hooks/scripts/*.sh`. On Windows with Git Bash, this sets the executable bit in git's index — you may need to commit the chmod change for teammates.

### Hook fires but produces no output

- Check the script exits cleanly with `echo $?` after a test run
- Confirm the linter / test runner is installed and on PATH
- Use `claude --debug-file /tmp/claude.log` to see full hook execution logs

### Stop hook triggers a loop

If a Stop hook causes Claude to respond (e.g., the output triggers further work), and that response triggers another Stop, you'll get an infinite loop. Fix: check `stop_hook_active` in stdin:

```bash
STOP_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')
[ "$STOP_ACTIVE" = "true" ] && exit 0
```

`docs-nudge.sh` and `auto-checkpoint.sh` always exit 0 (never block Claude), so they won't trigger this. Only a hook that exits 2 (blocking) on Stop can cause a loop.
