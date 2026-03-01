# Experimental Techniques

This document covers experimental techniques currently being tested across teams as part of the AI Excellence initiative. These build on the core workflows established in v0.1 and address common scenarios encountered during daily development work.

> These techniques are under active evaluation. Feedback from teams using them will inform whether they become standard recommendations in future versions.

---

## Multi-Repository Workspace Context

Use VS Code's "Add Folder to Workspace" feature to aggregate multiple repositories into a single workspace. This gives Copilot full context across all your codebases simultaneously, allowing it to reference types, interfaces, and patterns from any project in the workspace.

### When to Use

| Situation | Notes |
|-----------|-------|
| Working across microservices with shared contracts or interfaces | Copilot can reference contract definitions when implementing consumers |
| Frontend/Backend split requiring cross-repository context | Type definitions and API contracts visible across both repos |
| Referencing common libraries, shared types, or API definitions | Shared code is always in context without manual copy-paste |
| Any time you need Copilot to understand relationships between separate repositories | Multi-repo architectural decisions become easier to implement consistently |

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

1. Generate `copilot-instructions.md` as indicated in the setup guide
2. After generation, extend the instructions file with the security guardrail prompt from [`prompts/02-security-guardrail.md`](../prompts/02-security-guardrail.md)
3. Save changes

The security guardrail enforces:

- Never displaying, echoing, logging, or hardcoding credentials
- Always requiring environment variables or secret managers
- Stopping generation immediately if sensitive data is detected
- Pattern detection for common credential formats (API keys, connection strings, private keys, JWT tokens)

---

## Context Reference with `#` Symbol

Use the `#` (hash) symbol to explicitly reference different types of context in your prompts. Type `#` in the chat input field to see available options.

| Context Type | Usage | Example |
|--------------|-------|---------|
| `#file` or `#folder` | Reference specific files/folders | "Suggest improvements to #package.json" |
| `#selection` | Currently highlighted code | "/fix #selection using proper error handling" |
| `#codebase` | Search entire codebase | "Where is database connection used in #codebase?" |
| `#symbol` | Specific functions/classes | "Refactor #UserController to use DI" |
| `#git:staged` | Staged git changes | "/gcm #git:staged" |
| `#terminalLastCommand` | Last terminal output | "@terminal #terminalLastCommand explain error" |
| `#fetch` | Web content | "#fetch https://docs.api.com and create types" |

### Context Management Best Practices

- Open relevant files, close irrelevant ones — Copilot draws context from open tabs
- Use drag-and-drop for files onto chat prompt (faster than typing paths)
- Combine context types: "/fix #selection using patterns from #file"
- Remove past questions from chat history if not relevant to current task
- Start new chat session when switching to completely different tasks

---

## Slash Commands Reference

Slash commands are shortcuts to specific functionality within the chat. Type `/` followed by the command name.

| Command | Purpose | Example |
|---------|---------|---------|
| `/fix` | Analyze errors and suggest fixes | "/fix optimize this function for performance" |
| `/tests` | Generate tests with edge cases | "/tests for UserService using Jest" |
| `/explain` | Detailed code explanations | "/explain how this recursive function works" |
| `/doc` | Generate documentation | "/doc generate API docs for these endpoints" |
| `/new` | Set up new project structure | "/new React component library with TypeScript" |

### Chat Participants (@ Commands)

| Participant | Purpose |
|-------------|---------|
| `@workspace` | Aware of entire workspace, answers related questions |
| `@vscode` | Questions about VS Code features and APIs |
| `@terminal` | Questions about command line |

---

## Essential Keyboard Shortcuts

Master these shortcuts to maximize productivity and stay in flow.

### Inline Suggestions (Ghost Text)

| Action | Windows/Linux | Mac |
|--------|---------------|-----|
| Accept suggestion | `Tab` | `Tab` |
| Next suggestion | `Alt + ]` | `Option + ]` |
| Previous suggestion | `Alt + [` | `Option + [` |
| Accept next word | `Ctrl + Right` | `Cmd + Right` |
| Show all suggestions | `Ctrl + Enter` | `Control + Enter` |
| Trigger new suggestion | `Alt + \` | `Option + \` |
| Dismiss suggestion | `Esc` | `Esc` |

### Chat Shortcuts

| Action | Windows/Linux | Mac |
|--------|---------------|-----|
| Open main chat view | `Ctrl + Alt + I` | `Cmd + Ctrl + I` |
| Start inline chat | `Ctrl + I` | `Ctrl + I` |
| New chat session | `Ctrl + N` (in chat) | `Cmd + N` (in chat) |
| Switch to agents mode | `Ctrl + Shift + Alt + I` | `Shift + Cmd + I` |

---

## Advanced Situational Techniques

### Context Seeding

Before starting complex work, "seed" the context by having Copilot read and summarize key files. This improves suggestion quality for subsequent prompts.

**Example:**
```
Read and summarize the architecture of @src/services/ and @src/api/.
I'll be adding a new payment integration that needs to follow these patterns.
```

### Snooze Mode

For routine T1 tasks where autocompletion alone suffices, you can temporarily disable chat-based assistance to reduce cognitive overhead. Re-enable when you need planning or multi-step help.

**When to use:**
- Simple variable renames across a file
- Adding basic boilerplate you've written many times
- Quick fixes where you already know the solution

### Three-Phase Refactors

For T3 refactoring work, break implementation into three distinct phases:

1. **Phase 1 — Analysis**: Map dependencies, identify risks, document current state
2. **Phase 2 — Scaffolding**: Create new structure without removing old code (both exist in parallel)
3. **Phase 3 — Migration**: Move logic to new structure, remove old code, validate

Each phase should produce a runnable state. Never proceed to the next phase until the current one is validated.

---

## Refinements from v0.1

The table below summarizes how v0.2 techniques enhance the original v0.1 workflows:

| v0.1 Section | v0.1 Technique | v0.2 Enhancement |
|--------------|----------------|------------------|
| Tier 2 | File path references in prompts | `#` symbol context system |
| Setup | `copilot-instructions.md` | Prompt files + global prompts |
| Agents | Custom agents (manual setup) | `@agent` built-in + custom agents |
| Tier 1 | Autocompletion as default | Snooze mode for exceptions |
| Tier 3 | Plan mode + phased implementation | Three-phase refactor pattern |
| N/A | Single-repo focus | Multi-repo workspace context |
| N/A | Not covered | Keyboard shortcuts reference |
| N/A | Not covered | Slash commands reference |

### Using `@agent` (Built-in)

The built-in `@agent` is available without any setup — just type `@agent` in chat. It's designed for multi-file feature implementation with a plan → execute → review flow.

**When to use `@agent`:**
- Quick multi-file tasks where custom agent setup is overkill
- Ad-hoc feature implementation across several files
- When you need planning but don't need the structured PR workflow

**When to use custom agents (Test Writer, Code Reviewer, Documentation):**
- Structured PR workflow with consistent output formats
- Specialized tasks requiring specific MCP integrations
- Team standardization on review and documentation patterns

**Recommendation:** Use `@agent` for quick multi-file work; use custom agents for the structured PR workflow.
