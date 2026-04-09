# Docs — User Manual

A guide to writing and maintaining documentation using the `docs` skill.

---

## What It Does

The `docs` skill analyzes your code changes, identifies documentation gaps and drift, and drafts updates for your review — covering inline comments, API docs, READMEs, config references, and changelogs. It presents drafted content for your approval before writing any files.

It writes to documentation files only. It will never modify production code.

---

## Adding the Skill to a Project

The skill lives in the playbook repo under `skills/docs/`. To use it in a project, copy it into that project's Claude configuration.

### Step 1 — Copy the skill folder

**Option A — Global level** *(available in every project on your machine — recommended)*

```
~/.claude/skills/
└── docs/
    ├── SKILL.md
    └── references/
        └── docs-output-template.md
```

On Windows: `C:\Users\{your-username}\.claude\skills\`

**Option B — Project-level** *(available only in that specific project)*

```
your-project/
└── .claude/skills/
    └── docs/
        ├── SKILL.md
        └── references/
            └── docs-output-template.md
```

### Step 2 — Confirm Claude Code sees it

Open Claude Code and type `/` — you should see `docs` listed. If it doesn't appear, restart the Claude Code session.

---

## How to Invoke It

You don't need to type a command. Describe what you want and the skill auto-triggers.

**Phrases that automatically invoke the skill:**

| What you say | Triggers? |
|---|---|
| "Pre-PR docs pass for AUTH-042" | ✅ |
| "Update the docs for these changes" | ✅ |
| "Document this endpoint" | ✅ |
| "Update the CHANGELOG" | ✅ |
| "Add inline comments to this function" | ✅ |
| "End of day — capture what we did today" | ✅ |
| "What docs do I need to update?" | ✅ |
| "I need to document this before I forget" | ✅ |

You can also invoke explicitly with `/docs` if you prefer.

---

## Two Patterns

The skill adapts to two distinct documentation moments:

### Pre-PR Documentation

Run this after finishing feature work, before opening a PR. Focuses on completeness and external-facing clarity — every changed area gets documented so another developer can understand and use it without asking anyone.

```
Pre-PR docs pass for AUTH-042.
Changed files: @app/api/routes/auth.py, @app/services/auth_service.py
```

### End-of-Day Checkpoint

Run this when wrapping up mid-feature work. Focuses on context preservation — captures decisions made, alternatives considered, TODOs, and what's incomplete so you can pick up exactly where you left off.

```
End of day. Document what we did today and capture next steps.
```

---

## What to Include in Your Request

| What to include | Why it helps |
|---|---|
| File paths (`@path/to/file.py`) | Scopes the documentation pass to exactly what changed |
| Ticket reference | Provides the "why" behind the change — surfaces in changelog entries |
| Documentation type needed | e.g. "just the CHANGELOG" or "API docs for the new endpoint" |
| End-of-day or pre-PR signal | Determines which pattern the skill applies |

**Minimal prompt (works fine):**
```
Pre-PR docs pass. Files: @app/services/subscriptions.py
```

**Full prompt (best results):**
```
Pre-PR documentation for BILLING-88.
Changed: @app/api/routes/billing.py, @app/services/billing_service.py,
@app/models/subscription.py
Need: API docs for the new upgrade endpoint, CHANGELOG entry,
and inline comments on the proration logic.
```

---

## What Happens After You Invoke It

### Phase 1 — Research (automatic)

The skill reads the changed files, checks git commits for intent, finds existing documentation for those areas, identifies drift between docs and code, and fetches framework documentation conventions via Context7 MCP when needed.

### Phase 2 — Documentation Drafts (requires your approval)

The skill presents:

| Section | What you'll see |
|---------|----------------|
| Summary | What triggered the update, which pattern is being applied |
| Changes analyzed | File-by-file breakdown of what needs documenting |
| Documentation drafts | The exact content to be written — not descriptions, actual text |
| Context preserved | Decisions, TODOs, next steps *(end-of-day only)* |
| Documentation debt | Gaps found outside the current scope, if any |

**The skill pauses here and waits for you.** Adjust wording, add context, skip sections, or change scope before the skill writes anything.

### Phase 3 — Write Documentation (after your approval)

Once you approve, the skill writes the documentation to the correct locations matching the project's existing style. It reports exactly what was written and where.

---

## Documentation Checklist

For each changed area, the skill evaluates:

| Area | What gets documented |
|------|---------------------|
| **API endpoints** | Route, method, auth, parameters, responses, errors, example |
| **Configuration** | Env vars, feature flags — name, type, default, description |
| **Models/schemas** | New fields, relationships, constraints, what each field means |
| **Dependencies** | Why a package was added and how it's used |
| **Architecture** | New directories or modules — purpose and how to navigate |
| **Operations** | Deployment steps, infrastructure changes |
| **Inline comments** | Complex logic, non-obvious decisions, workarounds |
| **README** | Setup, usage, prerequisites — anything affecting getting started |
| **CHANGELOG** | User-facing changes, breaking changes, deprecations |

---

## What the Skill Will Not Do

- **Modify production code.** If documentation requires a code change (e.g. adding a missing docstring placeholder), it flags it — it doesn't touch the code.
- **Guess at behavior.** It reads the code before writing docs. If a function's intent is unclear, it surfaces that as documentation debt rather than documenting the wrong thing.
- **Duplicate existing content.** If documentation already exists elsewhere, the skill links to it rather than reproducing it.

---

## After the Docs Are Written

- **Pre-PR:** Run `/code-review` next — code review should include the documentation updates in scope
- **End-of-Day:** You're done — the context is preserved for your next session
