# Context Seed — User Manual

A guide to establishing shared context before starting complex work using the `context-seed` skill.

---

## What It Does

The `context-seed` skill reads the relevant area of your codebase and produces a structured orientation summary — what the code does, how it's structured, what patterns it follows, and what to know before making changes. It establishes a shared mental model before implementation starts, so the first change is informed rather than exploratory.

It is read-only. It will never modify your code.

---

## Adding the Skill to a Project

The skill lives in the playbook repo under `skills/context-seed/`. To use it in a project, copy it into that project's Claude configuration.

### Step 1 — Copy the skill folder

**Option A — Global level** *(available in every project on your machine — recommended)*

```
~/.claude/skills/
└── context-seed/
    ├── SKILL.md
    └── references/
        └── context-summary-template.md
```

On Windows: `C:\Users\{your-username}\.claude\skills\`

**Option B — Project-level** *(available only in that specific project)*

```
your-project/
└── .claude/skills/
    └── context-seed/
        ├── SKILL.md
        └── references/
            └── context-summary-template.md
```

### Step 2 — Confirm Claude Code sees it

Open Claude Code and type `/` — you should see `context-seed` listed. If it doesn't appear, restart the Claude Code session.

---

## How to Invoke It

You don't need to type a command. Signal that you want to understand before acting and the skill auto-triggers.

**Phrases that automatically invoke the skill:**

| What you say | Triggers? |
|---|---|
| "Before we start, read the architecture" | ✅ |
| "Familiarize yourself with the codebase first" | ✅ |
| "Help me understand how the auth module works" | ✅ |
| "Context first, then we'll implement" | ✅ |
| "What should I know before touching the payments service?" | ✅ |
| "Onboard me on this module" | ✅ |
| "Map out how this feature works" | ✅ |
| "Orient yourself before we start" | ✅ |

You can also invoke explicitly with `/context-seed` if you prefer.

---

## What to Include in Your Request

| What to include | Why it helps |
|---|---|
| The specific module or feature | Focuses the read on what's actually relevant — avoids a shallow whole-repo scan |
| What you're about to do | Knowing the task shapes what context matters most |
| Ticket reference | The acceptance criteria define which areas of the codebase are in scope |
| "I've never touched this area" | Signals to go deeper on patterns and gotchas |

**Minimal prompt (works fine):**
```
Before we start, familiarize yourself with the subscriptions service.
```

**Full prompt (best results):**
```
Context first. I'm about to implement the plan upgrade flow for BILLING-88.
I've never touched the billing module. Read the relevant code and orient me
before we write anything.
```

---

## What Happens After You Invoke It

### Phase 1 — Read (automatic)

The skill identifies the relevant entry points, reads the key files in the area, follows the call chain inward, maps dependencies, and extracts patterns and gotchas.

### Phase 2 — Context Summary (requires your validation)

The skill presents:

| Section | What you'll see |
|---------|----------------|
| What this does | One sentence — what the area is responsible for |
| Architecture map | Key files and their roles; how they connect |
| Entry points | Where changes would start — specific files and functions |
| Patterns to follow | Conventions a change must match to stay consistent |
| Dependencies | What this area calls; what calls it |
| Constraints | Interfaces or contracts that limit what's safe to change |
| Gotchas | Non-obvious things to know before making changes |
| Where to start | The specific file to open first |

**The skill pauses here and waits for you.** Correct anything that's wrong — get the mental model right before implementation starts. This is the entire point.

### Phase 3 — Proceed

Once you confirm the summary is accurate, the context is established for the session. Tell the skill what you want to build next and work begins with the right foundation already in place.

---

## When to Use Context Seed

| Situation | Use? |
|-----------|------|
| Implementing a feature in a module you've never touched | Always |
| Returning to complex code after a long gap | Yes |
| Onboarding to a new codebase area | Yes |
| Handing off context to another developer | Yes — save the summary to `.claude/context/` |
| Working in a familiar area you touch regularly | Usually not needed |

---

## Saving the Summary for Later

By default, the context summary stays in the conversation session. If you want to save it for future sessions or handoffs:

```
Save this context summary to .claude/context/billing-service.md
```

The skill will write the file to the specified location.

---

## What the Skill Will Not Do

- **Scan the whole codebase by default.** It reads deeply in the relevant area, not shallowly across everything.
- **Make implementation suggestions.** The summary is orientation only — design and implementation decisions come after, in the next turn.
- **Proceed without validation.** The context summary always pauses for your confirmation before work starts.

---

## Why This Matters

The most common source of inconsistent code is starting implementation before understanding the existing patterns. Context seeding front-loads that understanding — the first change is informed, matches conventions, and avoids the rework that comes from discovering gotchas mid-implementation.
