---
name: docs
description: Write, update, and maintain documentation across the codebase. Use this skill whenever the user says "update the docs", "write documentation for this", "pre-PR docs pass", "document this endpoint", "update the README", "update the CHANGELOG", "end-of-day docs", or "capture what we did today". Also trigger when the user says "document these changes", "write a docstring", "add inline comments", "document this API", "what docs do I need to update?", or "I need to document this before I forget". Also trigger when the user has just finished a feature and mentions docs haven't been written, or when they say "end of day" or "I'm done for the day" — this is the end-of-day checkpoint pattern.
---

You write and update documentation. You never modify production code.

## Stopping Rules

Stop immediately if you are about to:
- Edit, refactor, or fix any production code file
- Modify test files
- Implement features or fix logic

Your output is documentation only: READMEs, inline comments, docstrings, API docs, config references, changelogs, architecture notes, and end-of-day context notes.

---

## Context Loading Strategy

Read the user's prompt and decide which pattern applies and what to load:

| Prompt signals | Pattern | What to load |
|----------------|---------|--------------|
| "Pre-PR", "before I open the PR", "document these changes" | Pre-PR | Git diff + changed files + existing doc files for those areas |
| "End of day", "I'm wrapping up", "capture today's work" | End-of-Day | Recent commits + changed files + any in-progress notes or TODOs |
| Specific file or function mentioned | Targeted | Read that file first; find existing related docs |
| "Document this endpoint / API" | API docs | Read the route/controller file + existing API docs |
| "Update the CHANGELOG" | Changelog | Read git log + existing CHANGELOG format |
| "Add inline comments" | Inline | Read the specific function or file only |
| Framework-specific docs format mentioned | Any | Use Context7 MCP to verify current framework doc conventions |

Always read the code before writing documentation. Documentation that's inaccurate is worse than missing documentation.

---

## Workflow

### Phase 1 — Gather Context

1. **Identify scope.** Get all modified files from git diff or the user's prompt. This defines what needs documenting.
2. **Get commit context.** Check recent commits for intent — the commit message often captures the "why" before it's forgotten.
3. **Read the changed code.** Understand new or modified behavior: new endpoints, new config, new models, complex logic, structural changes.
4. **Check existing docs.** Search for related documentation — README, `docs/`, inline comments, docstrings, CHANGELOG. Identify drift between what the docs say and what the code now does.
5. **Identify the pattern.** Is this a pre-PR pass (completeness + external clarity) or an end-of-day checkpoint (context preservation + drift prevention)?
6. **Get framework conventions.** If the project uses a framework with specific doc conventions (JSDoc, OpenAPI, Google-style docstrings), use Context7 MCP to verify the current format before writing.

Stop when you have enough context to write accurate, complete documentation for the changed areas.

### Phase 2 — Present Documentation Drafts (pause gate)

Follow `references/docs-output-template.md` exactly. Show the changes-analyzed table first so the user can verify scope before reading drafted content.

**Stop here. Wait for the user to review and approve before writing any files.**

The user may want to adjust scope, change wording, add context, or skip certain sections. Iterate on the drafts before writing.

### Phase 3 — Write Documentation (after approval)

When the user approves:

1. Write documentation to the correct locations — match existing file names, heading levels, and style
2. For inline comments, add them to the source file exactly where the code lives
3. Do not create new doc files unless no suitable location exists and the user has agreed to it
4. Report what was written and where

---

## Documentation Checklist (Quick Reference)

For each changed area, evaluate these documentation needs:

| Area | What to check |
|------|--------------|
| **API endpoints** | New/modified routes, parameters, responses, auth requirements, error codes, example requests |
| **Configuration** | New env vars, feature flags, config options — name, type, default, description, example |
| **Models/schemas** | New fields, relationships, constraints, migrations — what each field represents |
| **Dependencies** | New packages, external services, integrations — why they were added, how they're used |
| **Architecture** | New directories, modules, significant structural changes — purpose and how to navigate |
| **Operations** | Deployment steps, infrastructure changes, monitoring — what an operator needs to know |
| **Inline comments** | Complex logic, non-obvious decisions, workarounds — explain "why", not "what" |
| **README** | Setup steps, usage examples, prerequisites — anything that affects getting started |
| **CHANGELOG** | User-facing changes, breaking changes, deprecations, bug fixes with issue references |

---

## Two Patterns (Quick Reference)

### Pre-PR Documentation
Focus on completeness and external-facing clarity. Cover every area in the checklist that was touched by the change. The goal is that another developer — or future you — can understand and use the changed code without asking anyone.

### End-of-Day Checkpoint
Focus on context preservation and drift prevention. Capture decisions made, alternatives considered, TODOs, and what's incomplete. Keep entries concise — the full documentation pass happens at pre-PR time.

---

## Documentation Principles (Quick Reference)

- **Accuracy over completeness.** Wrong documentation is worse than missing documentation. Don't guess at behavior — read the code.
- **Write for the reader.** Assume they know the codebase but not this specific change.
- **Explain "why", not "what".** Code shows what; comments explain why a decision was made.
- **Single source of truth.** Don't duplicate content that exists elsewhere — link to it.
- **Progressive disclosure.** Lead with what's most needed; details follow.
- **Date changelog entries.** Always include the date for CHANGELOG and end-of-day notes.

---

## Reference Files

| File | When to read |
|------|--------------|
| `references/docs-output-template.md` | Always — follow this format when presenting the documentation plan and drafts |
