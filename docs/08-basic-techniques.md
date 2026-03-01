# Basic Techniques

This document covers day-to-day Claude Code usage patterns that teams use constantly across T1-T3 work. These are lightweight techniques for context selection, panel usage, and quick command flow.

For full setup and installation, see the [Setup Guide](05-setup-guide.md). For larger workflows, see [Advanced Techniques](06-advanced-techniques.md).

---

## Context with `@` Symbol

Use the `@` (at) symbol to explicitly reference different types of context in your prompts. Type `@` in Claude Code to see available options.

| Context Type | Usage | Example |
|--------------|-------|---------|
| `@file` | Reference specific files | "Suggest improvements to @package.json" |
| `@folder` | Reference entire directories | "Review all tests in @tests/" |
| `@codebase` | Search entire codebase | "Where is database connection used in @codebase?" |
| `@web` | Fetch web content | "@web https://docs.api.com and create types" |
| `@terminal` | Last terminal output | "@terminal explain this error" |

### Context Management Tips

- Open relevant files, close irrelevant ones - Claude Code draws context from open tabs
- Use drag-and-drop for files onto the Claude Code panel (faster than typing paths)
- Combine context types: "Fix this using patterns from @src/utils/"
- Start a new chat session when switching to completely different tasks
- Use `@codebase` sparingly - it can be slow on large repos

---

## Keyboard Shortcuts

### Claude Code Panel

| Action | Windows/Linux | Mac |
|--------|---------------|-----|
| Open Claude Code panel | `Ctrl + Shift + P` -> "Claude Code" | `Cmd + Shift + P` -> "Claude Code" |
| New chat session | `Ctrl + N` (in panel) | `Cmd + N` (in panel) |
| Submit message | `Enter` | `Enter` |
| New line in message | `Shift + Enter` | `Shift + Enter` |

### Code Actions

| Action | Windows/Linux | Mac |
|--------|---------------|-----|
| Quick fix with Claude | `Ctrl + .` (on error) | `Cmd + .` (on error) |
| Explain selection | Right-click -> "Explain with Claude" | Right-click -> "Explain with Claude" |
| Add to chat context | Right-click -> "Add to Claude Context" | Right-click -> "Add to Claude Context" |

---

## Basic Command Flow

These commands are useful as a lightweight baseline before moving to heavier workflows:

| Command | Purpose | Typical Use |
|---------|---------|-------------|
| `/plan` | Plan before coding | T2/T3 tasks with multiple files or dependencies |
| `/test` | Generate or improve tests | Add coverage before PR |
| `/review` | Pre-PR code review | Catch correctness and edge-case issues |
| `/doc` | Documentation updates | Keep implementation and docs aligned |

For the full command catalog and advanced command templates, see [Coding Techniques](04-coding-techniques.md).

