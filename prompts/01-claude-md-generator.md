# Prompt: `CLAUDE.md` Generator

## What This Does

This prompt generates or updates `/CLAUDE.md` — the file that makes Claude Code context-aware for your specific project. It instructs the AI to analyze your codebase and produce a structured instruction file that Claude Code can use to become productive immediately in that repo.

Running this is **the required first step** on any new project before doing any development work with Claude Code.

---

## When to Run It

| Situation | Action |
|-----------|--------|
| Starting work on a new project or repo | Run the full prompt to generate from scratch |
| Tech stack, structure, or critical commands have changed | Re-run to update the `<project-context>` section |
| Onboarding onto an existing project that already has the file | Run with the existing file in context — it will merge intelligently |

---

## How to Use

1. Open your project in VS Code with Claude Code
2. Open the Claude Code panel
3. Copy the prompt below and paste it into Claude Code
4. Review the generated `<project-context>` section when Claude asks for confirmation
5. Approve or request corrections, then proceed with the suggested development routes

---

## What to Expect Back

After running the prompt, Claude Code will:

1. Analyze your codebase and generate the full `/CLAUDE.md` file
2. Pause and ask you to review the `<project-context>` section specifically
3. Once approved, suggest three development routes to proceed from

If the tech stack, primary runtime, or build/test commands are not discoverable from the codebase, Claude will explicitly list what's missing and ask you to confirm before proceeding.

---

## The Prompt

````
You are generating or updating `CLAUDE.md`.

Your goal is to create a **consistent, structured, and maintainable
instruction file** that helps Claude Code become productive
immediately in THIS codebase.

The output MUST follow the exact structure defined below.
Do not omit sections.
Do not rename section headers.
Do not add extra top-level sections.

---

## STRUCTURE REQUIREMENTS (MANDATORY)

The file MUST contain the following sections in this order:

1. <project-context>
2. ### Critical Rules
3. ### Context Management
4. ### Inline Patterns
5. ### Code Style Preferences
6. ### On Every Code Change
7. ### If Unsure

---

## SECTION-SPECIFIC INSTRUCTIONS

### 1. Project Context

<project-context>
This section must describe ONLY **discoverable or confirmed information**.

Include:
- Intended tech stack (languages, frameworks, major libraries)
- High-level project purpose (1–2 sentences)
- The "big picture" architecture that requires reading multiple files to
  understand — major components, service boundaries, data flows, and the
  "why" behind structural decisions
- Project-specific conventions and patterns that differ from common practices
- Integration points, external dependencies, and cross-component
  communication patterns
- Project structure (key directories and their responsibilities)
- Critical developer workflows (builds, tests, debugging) — especially
  commands that aren't obvious from file inspection alone
- Source existing AI conventions from
  **/{CLAUDE.md,.claude/CLAUDE.md,AGENT.md,AGENTS.md,
  .github/copilot-instructions.md,.cursorrules,.windsurfrules,
  .clinerules,.cursor/rules/**,.windsurf/rules/**,
  .clinerules/**,README.md}**
  (do one glob search)

If any of the following are NOT discoverable from the codebase:
- tech stack
- primary runtime
- build/test commands

THEN explicitly write:
> Missing information: (list what is missing) — ask the user to confirm.

#### Project structure guidance (use if no strong structure exists)

If the repo is small, new, or inconsistent, suggest (do not enforce)
a structure such as:
- `/config/`   – configuration and environment handling
- `/api/`      – API routes or controllers
- `/schema/` or `/models/` – data schemas and models
- `/services/` – business logic and service layer
- `/helpers/` or `/utils/` – shared helper functions

Do NOT include opinions, rules, or coding philosophy here.
</project-context>

---

### 2. Critical Rules

This section MUST be included verbatim, with no modifications:

- When working on this project, prioritize code readability and
  maintainability.
- Keep functions and components small and focused on a single
  responsibility.
- Apply KISS (Keep It Simple, Stupid) and YAGNI (You Aren't Gonna Need It)
  principles.
- Absolutely do not modify any other part of the file except the
  <project-context> section when updating project context.
- Ask clarifying questions before making significant architectural changes.
- Never change the `.env` or configuration files unless explicitly
  instructed.
- When referencing files, include line numbers for specific sections when
  applicable.

---

### 3. Context Management

Include exactly the following guidance:

- Focus suggestions on the current file and its immediate dependencies.
- Reference other files explicitly when cross-file changes are needed.

---

### 4. Inline Patterns

Include exactly the following guidance:

- Use `// TODO:` or `# TODO:` to indicate where implementations are needed
- Use `// Example:` or `# Example:` to guide expected output format
- Use `// Note:` or `# Note:` for important constraints and considerations

---

### 5. Code Style Preferences

Include exactly the following guidance:

- Use consistent naming (camelCase for JS, snake_case for DB).
- Prefer composition over inheritance.
- Add JSDoc for public APIs.
- Always apply docstring.

---

### 6. On Every Code Change

Include exactly the following guidance:

- Always use context7 and sonarqube MCPs when available.
- Update <project-context> section in the `CLAUDE.md` file to reflect any
  changes in tech stack, project structure, or critical commands.
- Ensure functions and components are grouped logically into specific
  modules, files, or folders based on their purpose.
- In each file or module, include a brief comment at the top summarizing
  its purpose and functionality.
- In each function or component, include a brief comment summarizing its
  purpose, inputs, outputs, and side effects.
- Always handle errors and edge cases gracefully, providing meaningful
  messages or fallbacks.

---

### 7. If Unsure

Include exactly the following guidance:

- If context is unclear, ask for a specific file to reference and expand
  the example with line-numbered snippets.

---

## ANALYSIS INSTRUCTIONS

- Analyze the codebase to populate ONLY the `<project-context>` section.
- Source existing AI conventions from:
  **/{CLAUDE.md,.claude/CLAUDE.md,AGENT.md,AGENTS.md,
  .github/copilot-instructions.md,.cursorrules,.windsurfrules,
  .clinerules,.cursor/rules/**,.windsurf/rules/**,
  .clinerules/**,README.md}**
  (single glob search)
- Merge intelligently if a file already exists:
  - Preserve structure
  - Update outdated facts
  - Do NOT duplicate sections

---

## OUTPUT RULES

- Write concise, actionable instructions (target ~50–100 lines)
- Use markdown
- Do NOT add generic advice
- Do NOT invent architecture or workflows
- If something is unknown, explicitly ask for confirmation

After generating the file, ask the user:
> "Please review the <project-context> section. Is there anything that
> should be corrected, added, or removed? Otherwise, we can proceed with
> the development."

Then, suggest three development routes to proceed from.
````

---

## Output Structure Reference

The generated `/CLAUDE.md` will always follow this structure:

```
<project-context>
  [codebase-specific — generated and updated per project]
</project-context>

### Critical Rules
[verbatim — never modified]

### Context Management
[verbatim — never modified]

### Inline Patterns
[verbatim — never modified]

### Code Style Preferences
[verbatim — never modified]

### On Every Code Change
[verbatim — never modified]

### If Unsure
[verbatim — never modified]
```

Only the `<project-context>` block changes between projects or updates. All other sections are fixed and should never be manually edited.
