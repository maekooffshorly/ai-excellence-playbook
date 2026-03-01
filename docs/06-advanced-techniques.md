# Advanced Techniques

This document covers established techniques for power users working on complex, multi-repo, or large-scale development tasks.

For basic day-to-day usage, see [Basic Techniques](08-basic-techniques.md). For techniques still under evaluation, see [Experimental Techniques](09-experimental-techniques.md).

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
2. Go to **File -> Add Folder to Workspace...** and select related repositories
3. Save your workspace: **File -> Save Workspace As...** (creates `.code-workspace` file)
4. Reopen the `.code-workspace` file for future sessions

### Example Structures

**Microservices with shared contracts:**

```
my-workspace.code-workspace
|-- /api-gateway           # References contracts
|-- /auth-service          # Implements contracts
|-- /shared-contracts      # Source of truth
`-- /notification-service  # Consumes contracts
```

**Frontend/Backend split:**

```
fullstack-workspace.code-workspace
|-- /frontend-app    # Consumes API types
|-- /backend-api     # Defines API types
`-- /shared-types    # Common definitions
```

### Best Practices

- Keep workspaces focused - only include repositories you actively cross-reference
- Document workspace setup in your project README for team consistency
- Save workspace files at the same level as your repos
- Create multiple workspace profiles for different workflow scenarios (frontend-only, full-stack, backend-services)
- Large workspaces (5+ repos) can slow indexing - exclude `node_modules` in workspace settings if needed

---

## Context Seeding

Before starting complex work, seed the context by having Claude Code read and summarize key files. This improves suggestion quality for subsequent prompts by establishing a baseline understanding of patterns and architecture.

### When to Use

| Situation | Notes |
|-----------|-------|
| Starting a new feature that must follow existing patterns | Ensures Claude Code understands conventions before generating code |
| Working in an unfamiliar part of the codebase | Builds context before asking for changes |
| Complex integrations requiring knowledge of multiple systems | Establishes understanding of how components interact |

### Example

```
Read and summarize the architecture of @src/services/ and @src/api/.
I'll be adding a new payment integration that needs to follow these patterns.
```

After seeding, subsequent prompts will generate code that aligns with the established patterns.

---

## Three-Phase Refactors

For T3 refactoring work, break implementation into three distinct phases. This pattern reduces risk and ensures you always have a working codebase to fall back to.

### The Three Phases

| Phase | Goal | Output |
|-------|------|--------|
| **Phase 1 - Analysis** | Map dependencies, identify risks, document current state | Analysis document, dependency graph, risk assessment |
| **Phase 2 - Scaffolding** | Create new structure without removing old code (both exist in parallel) | New code structure alongside old code |
| **Phase 3 - Migration** | Move logic to new structure, remove old code, validate | Completed refactor with old code removed |

### Rules

- Each phase should produce a runnable state - tests pass, code builds
- Never proceed to the next phase until the current one is validated
- Phase 2 is the safety net - if Phase 3 fails, you can revert to Phase 2's parallel state
- Commit at the end of each phase for easy rollback

### Example Prompt (Phase 1)

```
/plan Refactor the authentication system from session-based to JWT.
Phase 1: Analysis only - do not write code yet.
Map all files that touch authentication, identify dependencies,
and document the current auth flow with risks of the migration.
```

---

## Plan Mode for Complex Tasks

For T3 tasks, explicitly request a plan before implementation. This ensures alignment on approach before investing time in code.

### When to Use

- Any T3 complexity task
- Tasks where multiple valid approaches exist
- Work that will span multiple days or developers
- Changes with architectural implications

### Example Prompt

```
/plan Create a new authentication system using JWT.
Requirements: (list). Constraints: (list).
Provide: architecture outline, folder structure, key interfaces,
error handling approach, and test plan.
```

Review and approve the plan before proceeding to implementation. Use the `/plan` command for dedicated planning workflows - see [Coding Techniques](04-coding-techniques.md#plan---implementation-planning) for installation instructions.

---

## Security Guardrails

For projects handling credentials, API keys, or secrets, extend your `CLAUDE.md` with security guardrails that enforce zero-tolerance for credential exposure.

See [`prompts/02-security-guardrail.md`](../prompts/02-security-guardrail.md) for the full security guardrail prompt and installation instructions.

