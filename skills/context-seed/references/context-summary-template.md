# Context Seed — Output Template

Use this format when presenting a context summary. The goal is orientation, not documentation — the developer should feel ready to start making changes after reading this, not overwhelmed by it.

---

## Context Summary: {Module / Feature / Area}

### What This Does

{1–2 sentences. Plain language. What this area of the codebase is responsible for and why it exists. Write this so a developer who has never touched this code knows immediately what it is.}

---

### Architecture Map

{A brief map of the key files and how they connect. Prefer a short description over a file tree — explain roles, not just paths.}

| File | Role |
|------|------|
| [filename](path) | {What this file does — one line} |
| [filename](path) | {What this file does — one line} |

{If there's a meaningful call chain or data flow, describe it in 2–3 sentences after the table. Don't reproduce the full code — describe the shape.}

---

### Entry Points

{Where does work start in this area? Routes, CLI commands, event handlers, public service methods — the places a new change would begin. Be specific enough that the developer knows which file to open first.}

- **{Entry point name}** — [filename:line](path#Lline): {What triggers it and what it kicks off}

---

### Patterns to Follow

{The conventions this area uses that a change must match to stay consistent. Only include things that aren't obvious — naming, error handling style, data access patterns, testing approach.}

- **{Pattern name}**: {Description and why it exists or what it looks like}
- **{Pattern name}**: {Description}

---

### Dependencies

**Calls into:** {What this area depends on — services, utilities, external systems. These constrain what's safe to change.}

**Called by:** {What depends on this area. Changes here have ripple effects on these callers.}

---

### Constraints

{What can't be changed without broader impact? Shared interfaces, public contracts, things other teams or systems depend on. If nothing is constrained, omit this section.}

- {Constraint and why it exists}

---

### Gotchas

{Non-obvious things to know before making changes. Why something is structured the way it is even though it looks wrong. Known fragile areas. Things that will break in non-obvious ways if changed carelessly.}

- {Gotcha and context}

*Omit this section if there's nothing genuinely non-obvious.*

---

### Where to Start

{The specific file or function to open first when making changes in this area. Give the developer a clear starting point.}

**File:** [filename](path)
**Function / section:** `{function_name}` — {why this is the right starting point}

---

**Does this match your understanding? Correct anything before we proceed.**

---

## Style Rules

- **Orientation, not documentation.** The goal is a working mental model — not a complete reference. If reading the summary takes longer than reading the code, it has failed.
- **One sentence per file in the architecture map.** Resist the urge to describe every method. Role is enough.
- **Patterns must be observable.** Only include conventions that appear consistently in the code — don't invent or infer patterns that aren't there.
- **Gotchas must be non-obvious.** If a developer would notice it by reading the code carefully, it's not a gotcha worth including.
- **"Where to Start" is mandatory.** The summary should always end with a specific, actionable starting point. "It depends" is not an answer.
- **Omit empty sections.** If there are no constraints, omit Constraints. If nothing is non-obvious, omit Gotchas. Only show sections that add information.
- **Validate before proceeding.** The stop gate is non-negotiable — get confirmation that the mental model is accurate before any implementation starts.
