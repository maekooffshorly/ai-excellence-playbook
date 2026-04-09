---
name: context-seed
description: Build a shared understanding of a codebase area before starting complex work. Use this skill whenever the user says "before we start, read the architecture", "familiarize yourself with the codebase", "I need to understand how this works first", "context first then we'll implement", or "what should I know before touching this". Also trigger when the user says "onboard me on this module", "map out how this feature works", "help me understand the codebase before we dive in", "read the relevant files first", or "orient yourself before we start". Also trigger when the user is about to implement something complex and explicitly asks for a read-first pass before any code is written.
---

You read and summarize. You never modify code.

## Stopping Rules

Stop immediately if you are about to:
- Write, edit, or fix any code file
- Implement anything
- Make suggestions about what to build — your job here is to understand, not to design

Your output is a context summary: what the relevant code does, how it's structured, what patterns it follows, and what to know before making changes. Design and implementation decisions come after, in a separate conversation turn.

---

## Context Loading Strategy

Read the user's prompt and decide how wide to cast:

| Prompt signals | What to read |
|----------------|--------------|
| Specific module or feature named | Start there; follow imports to immediate dependencies; stop at well-understood boundaries |
| "The whole codebase" / "before we start a new feature" | Read `CLAUDE.md` + `README.md` + top-level directory structure first; then drill into the relevant area |
| Ticket reference given | Fetch the ticket first — the acceptance criteria define which areas of the codebase are relevant |
| "How does X connect to Y" | Read both X and Y; map the connection points |
| Framework or library unfamiliar | Use Context7 MCP to fetch current documentation for any unfamiliar framework before summarizing its usage in the project |

Prioritize depth over breadth. Understanding one module well is more useful than a shallow scan of the whole project.

---

## Workflow

### Phase 1 — Map the Territory

1. **Identify the entry point.** Where does the relevant code start? Route handlers, service classes, CLI commands — find the outermost boundary of the area being asked about.
2. **Read inward.** Follow the call chain from entry point into the core logic. Read the files that do the actual work, not just the wrappers.
3. **Map dependencies.** What does this code depend on? What depends on it? Note any shared utilities, base classes, or external services — these are the things that constrain what changes are safe.
4. **Extract patterns.** Naming conventions, error handling approach, testing patterns, data access patterns. These are the rules a new change must follow to be consistent.
5. **Surface gotchas.** Anything non-obvious: why something is structured the way it is, known limitations, places where the code is fragile or under-documented, things that look wrong but are intentional.

Stop reading when you have enough to give a useful orientation — not when you've read everything. Breadth without depth is noise.

### Phase 2 — Present Context Summary

Follow `references/context-summary-template.md` exactly. The goal is that the developer can read this and feel ready to start — not that every file has been enumerated.

**Stop here. Wait for the developer to validate the summary before proceeding to design or implementation.**

The developer may correct your understanding, point to files you missed, or refine the scope. Get the mental model right before any work starts — this is the entire point of context seeding.

### Phase 3 — Confirm and Proceed

Once the developer confirms the summary is accurate, the context is established for the session. Implementation or design work can start — in the same conversation, with this context already loaded.

You do not write a file unless the developer explicitly asks to save the context summary for future sessions.

---

## What Good Context Seeding Covers (Quick Reference)

| Area | What to extract |
|------|----------------|
| **Purpose** | What this code does and why it exists — one sentence |
| **Architecture map** | Key files and their roles; how they connect |
| **Entry points** | Where changes would start (routes, commands, event handlers) |
| **Patterns** | Naming, error handling, data access, testing conventions in this area |
| **Dependencies** | What this area calls; what calls it; shared utilities |
| **Constraints** | What you can't change without ripple effects; shared interfaces; contracts |
| **Gotchas** | Non-obvious decisions, fragile areas, known limitations |
| **Where to start** | The specific file or function to open first when making changes |

---

## Reference Files

| File | When to read |
|------|--------------|
| `references/context-summary-template.md` | Always — follow this format when presenting the context summary |
