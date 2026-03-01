# Experimental Techniques

This document covers experimental techniques currently being tested across teams as part of the AI Excellence initiative. These build on the core workflows established in v0.1 and address common scenarios encountered during daily development work.

> These techniques are under active evaluation. Feedback from teams using them will inform whether they become standard recommendations in future versions.

---

## Multi-Repository Workspace Context

Use VS Code's "Add Folder to Workspace" feature to aggregate multiple repositories into a single workspace. This gives Claude Code full context across all your codebases simultaneously, allowing it to reference types, interfaces, and patterns from any project in the workspace.

### When to Use

| Situation | Notes |
|-----------|-------|
| Working across microservices with shared contracts or interfaces | Claude Code can reference contract definitions when implementing consumers |
| Frontend/Backend split requiring cross-repository context | Type definitions and API contracts visible across both repos |
| Referencing common libraries, shared types, or API definitions | Shared code is always in context without manual copy-paste |
| Any time you need Claude Code to understand relationships between separate repositories | Multi-repo architectural decisions become easier to implement consistently |

### Setup Steps

1. Open your primary project in VS Code
2. Go to **File → Add Folder to Workspace...** and select related repositories
3. Save your workspace: **File → Save Workspace As...** (creates `.code-workspace` file)
4. Reopen the `.code-workspace` file for future sessions

### Example Structures

**Microservices with shared contracts:**

```
my-workspace.code-workspace
├── /api-gateway           # References contracts
├── /auth-service          # Implements contracts
├── /shared-contracts      # Source of truth
└── /notification-service  # Consumes contracts
```

**Frontend/Backend split:**

```
fullstack-workspace.code-workspace
├── /frontend-app    # Consumes API types
├── /backend-api     # Defines API types
└── /shared-types    # Common definitions
```

### Best Practices

- Keep workspaces focused — only include repositories you actively cross-reference
- Document workspace setup in your project README for team consistency
- Save workspace files at the same level as your repos
- Create multiple workspace profiles for different workflow scenarios (frontend-only, full-stack, backend-services)
- Large workspaces (5+ repos) can slow indexing — exclude `node_modules` in workspace settings if needed

---

## Security Guardrails

Security has always been a concern when it comes to AI-related operations, especially for handling sensitive data like passwords, keys, tokens, or credentials. To prevent potential misuse, we enforce a zero-tolerance policy for handling sensitive information. Any operations involving access to sensitive data require complete human-in-the-loop approval.

### How to Apply

1. Generate `CLAUDE.md` as indicated in the setup guide
2. After generation, extend the instructions file with the security guardrail prompt from [`prompts/02-security-guardrail.md`](../prompts/02-security-guardrail.md)
3. Save changes

The security guardrail enforces:

- Never displaying, echoing, logging, or hardcoding credentials
- Always requiring environment variables or secret managers
- Stopping generation immediately if sensitive data is detected
- Pattern detection for common credential formats (API keys, connection strings, private keys, JWT tokens)

---

## Context Reference with `@` Symbol

Use the `@` (at) symbol to explicitly reference different types of context in your prompts. Type `@` in Claude Code to see available options.

| Context Type | Usage | Example |
|--------------|-------|---------|
| `@file` | Reference specific files | "Suggest improvements to @package.json" |
| `@folder` | Reference entire directories | "Review all tests in @tests/" |
| `@codebase` | Search entire codebase | "Where is database connection used in @codebase?" |
| `@web` | Fetch web content | "@web https://docs.api.com and create types" |
| `@terminal` | Last terminal output | "@terminal explain this error" |

### Context Management Best Practices

- Open relevant files, close irrelevant ones — Claude Code draws context from open tabs
- Use drag-and-drop for files onto the Claude Code panel (faster than typing paths)
- Combine context types: "Fix this using patterns from @src/utils/"
- Start a new chat session when switching to completely different tasks
- Use `@codebase` sparingly — it can be slow on large repos

---

## Slash Commands Reference

Slash commands are shortcuts to specific functionality within Claude Code. Type `/` followed by the command name.

| Command | Purpose | Example |
|---------|---------|---------|
| `/test` | Generate tests for specified code | "/test UserService using Jest" |
| `/review` | Review code for issues | "/review this function for security issues" |
| `/doc` | Generate documentation | "/doc generate API docs for these endpoints" |
| `/fix` | Analyze errors and suggest fixes | "/fix optimize this function for performance" |
| `/explain` | Detailed code explanations | "/explain how this recursive function works" |

### Custom Slash Commands

Create custom slash commands in `.claude/commands/` directory:

```markdown
---
name: my-command
description: Description of what this command does
---

Your prompt template here.
Use @file or other context references as needed.
```

Once created, invoke with `/my-command` in Claude Code.

---

## Essential Keyboard Shortcuts

Master these shortcuts to maximize productivity and stay in flow.

### Claude Code Panel

| Action | Windows/Linux | Mac |
|--------|---------------|-----|
| Open Claude Code panel | `Ctrl + Shift + P` → "Claude Code" | `Cmd + Shift + P` → "Claude Code" |
| New chat session | `Ctrl + N` (in panel) | `Cmd + N` (in panel) |
| Submit message | `Enter` | `Enter` |
| New line in message | `Shift + Enter` | `Shift + Enter` |

### Code Actions

| Action | Windows/Linux | Mac |
|--------|---------------|-----|
| Quick fix with Claude | `Ctrl + .` (on error) | `Cmd + .` (on error) |
| Explain selection | Right-click → "Explain with Claude" | Right-click → "Explain with Claude" |
| Add to chat context | Right-click → "Add to Claude Context" | Right-click → "Add to Claude Context" |

---

## Advanced Situational Techniques

### Context Seeding

Before starting complex work, "seed" the context by having Claude Code read and summarize key files. This improves suggestion quality for subsequent prompts.

**Example:**
```
Read and summarize the architecture of @src/services/ and @src/api/.
I'll be adding a new payment integration that needs to follow these patterns.
```

### Plan Mode for Complex Tasks

For T3 tasks, explicitly request a plan before implementation:

```
/plan Create a new authentication system using JWT.
Requirements: (list). Constraints: (list).
Provide: architecture outline, folder structure, key interfaces,
error handling approach, and test plan.
```

Review and approve the plan before proceeding to implementation.

### Three-Phase Refactors

For T3 refactoring work, break implementation into three distinct phases:

1. **Phase 1 — Analysis**: Map dependencies, identify risks, document current state
2. **Phase 2 — Scaffolding**: Create new structure without removing old code (both exist in parallel)
3. **Phase 3 — Migration**: Move logic to new structure, remove old code, validate

Each phase should produce a runnable state. Never proceed to the next phase until the current one is validated.

---

## Refinements from v0.1

The table below summarizes how v0.2+ techniques enhance the original v0.1 workflows:

| v0.1 Section | v0.1 Technique | v0.2+ Enhancement |
|--------------|----------------|-------------------|
| Tier 2 | File path references in prompts | `@` symbol context system |
| Setup | `copilot-instructions.md` | `CLAUDE.md` with project context |
| Agents | Custom agents (manual setup) | Slash command agents |
| Tier 1 | Autocompletion as default | Claude Code inline suggestions |
| Tier 3 | Plan mode + phased implementation | Three-phase refactor pattern |
| N/A | Single-repo focus | Multi-repo workspace context |
| N/A | Not covered | Keyboard shortcuts reference |
| N/A | Not covered | Custom slash commands |

### Using Slash Command Agents

The playbook agents (Test Writer, Code Reviewer, Documentation) are invoked via slash commands:

| Slash Command | Agent | When to Use |
|---------------|-------|-------------|
| `/test` | Test Writer | Before PR; critical modules; PoC → MVP transitions |
| `/review` | Code Reviewer | Pre-PR structured review |
| `/doc` | Documentation | After coding sessions; end-of-day context preservation |

**When to use custom slash commands:**
- Structured PR workflow with consistent output formats
- Specialized tasks requiring specific MCP integrations
- Team standardization on review and documentation patterns

**Recommendation:** Use built-in slash commands for quick work; create custom commands for team-standardized workflows.
