# Checkpoint — User Manual

A guide to saving progress and preserving context across sessions using the `checkpoint` skill.

---

## What It Does

The `checkpoint` skill reads your current git state, identifies what's been completed and what's in progress, surfaces key decisions and blockers, and produces a structured context snapshot — so you (or another developer) can resume exactly where you left off without re-reading the entire session.

It is read-only. It will never modify your code, tests, or configuration.

---

## Adding the Skill to a Project

The skill lives in the playbook repo under `skills/checkpoint/`. To use it in a project, copy it into that project's Claude configuration.

### Step 1 — Copy the skill folder

**Option A — Global level** *(available in every project on your machine — recommended)*

```
~/.claude/skills/
└── checkpoint/
    ├── SKILL.md
    └── references/
        └── checkpoint-output-template.md
```

On Windows: `C:\Users\{your-username}\.claude\skills\`

**Option B — Project-level** *(available only in that specific project)*

```
your-project/
└── .claude/skills/
    └── checkpoint/
        ├── SKILL.md
        └── references/
            └── checkpoint-output-template.md
```

### Step 2 — Confirm Claude Code sees it

Open Claude Code and type `/` — you should see `checkpoint` listed. If it doesn't appear, restart the Claude Code session.

---

## How to Invoke It

You don't need to type a command. Describe what you want and the skill auto-triggers.

**Phrases that automatically invoke the skill:**

| What you say | Triggers? |
|---|---|
| "Save my progress on AUTH-042" | ✅ |
| "Create a checkpoint before I step away" | ✅ |
| "I'm wrapping up for the day — capture this" | ✅ |
| "I'm handing this off to the team" | ✅ |
| "Capture where I am before switching tasks" | ✅ |
| "What's the status of this feature?" | ✅ |
| "Save context before I lose it" | ✅ |
| "Let's save state and resume tomorrow" | ✅ |

You can also invoke explicitly with `/checkpoint` if you prefer.

---

## Three Patterns

The skill adapts based on why you're creating the checkpoint:

### End-of-Day
Captures everything needed to re-establish context quickly the next session. Completed items, exact state of in-progress work, and the specific first action to take when resuming.

```
Wrapping up for the day. Save progress on AUTH-042.
```

### Mid-Feature Pause
Lighter snapshot for when you're switching tasks temporarily. Focused on the stopping point and the minimum context needed to resume without re-reading everything.

```
Checkpoint — pausing AUTH-042 to jump on a hotfix. Save where I am.
```

### Handoff
Most thorough — written for another developer picking this up. Includes enough decision rationale, setup notes, and known gotchas that they can start without asking questions.

```
Checkpoint for handoff. Another dev is picking up AUTH-042. Make it thorough.
```

---

## What to Include in Your Request

| What to include | Why it helps |
|---|---|
| Ticket reference (Jira, Linear, GitHub issue) | Used as the requirements baseline — shows what's done vs what's left |
| Pattern signal ("end of day", "handoff") | Determines the depth and focus of the checkpoint |
| Specific blockers or decisions | If you know of something important, surface it explicitly — the skill may not find it from git alone |

---

## What Happens After You Invoke It

### Phase 1 — Research (automatic)

The skill checks git status and diff to see exactly what changed, skims in-progress files for stopping points and TODOs, pulls ticket requirements if referenced, and identifies decisions and blockers from the session context.

### Phase 2 — Checkpoint Draft (requires your review)

The skill presents:

| Section | What you'll see |
|---------|----------------|
| Progress summary | 2–3 sentences — clear to someone cold |
| Completed | Fully done items |
| In Progress | Partially done items with exact current state |
| Files modified | Derived from git diff — what actually changed |
| Key decisions | Technical choices and their rationale |
| Blockers / open questions | What needs resolution before work continues |
| Next steps | Prioritized — first item is the exact thing to do when resuming |
| Handoff notes | Environment setup, gotchas, contacts *(Handoff pattern only)* |

**The skill pauses here and waits for you.** Add missing context, correct the next steps, or note a blocker before saving.

### Phase 3 — Save Checkpoint (after your approval)

Once you approve, the skill saves the checkpoint to the location you specify, or suggests `.claude/checkpoints/YYYY-MM-DD-{feature-name}.md` if no location was given.

---

## Where Checkpoints Are Saved

Suggested default: `.claude/checkpoints/YYYY-MM-DD-{feature}.md`

You can also:
- Paste the content into a Jira ticket comment
- Commit it as part of a WIP commit message
- Save it anywhere else that fits your workflow

The skill presents the content first — you control where it ends up.

---

## What the Skill Will Not Do

- **Fix blockers it finds.** If a bug surfaces during research, it documents it and stops.
- **Rely on memory.** The "Files Modified" list comes from `git diff` — not what the user thinks changed.
- **Use relative dates.** Checkpoints always use `YYYY-MM-DD` so they're interpretable after the session ends.

---

## Where Checkpoint Fits in the Workflow

```
Development session → Checkpoint (pause / end-of-day / handoff)
                   → Resume next session with checkpoint as context
```

Checkpoint is a standalone tool — it can be used at any point in the pipeline, independently of other skills.
