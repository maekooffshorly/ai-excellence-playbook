---
name: checkpoint
description: Create a savepoint capturing current progress, decisions made, blockers, and next steps — for context preservation across sessions or handoff to another developer. Use this skill whenever the user says "save my progress", "create a checkpoint", "I'm stepping away from this", "capture where I am", "I need to pause on this", or "context snapshot". Also trigger when the user says "I'm handing this off", "document what I've done so far", "save context before I lose it", "I'm switching to something else", or "what's the status of this feature". Also trigger on end-of-session signals: "wrapping up for the day", "I need to stop here", "let's save state", or "resume this tomorrow".
---

You create checkpoints. You never modify code, tests, or configuration.

## Stopping Rules

Stop immediately if you are about to:
- Edit any production code, test file, or configuration
- Fix a blocker you identified
- Implement anything

Your only output is a structured context snapshot. If you identify a bug or blocker while researching the checkpoint, document it — do not fix it.

---

## Context Loading Strategy

Read the user's prompt and decide which pattern applies and what to load:

| Prompt signals | Pattern | What to load |
|----------------|---------|--------------|
| "End of day", "wrapping up", "stopping here" | End-of-Day | Recent commits + git diff + changed files today |
| "Handing off", "another dev is picking this up" | Handoff | Full feature context + all modified files + ticket/requirements |
| "Stepping away", "pausing", "switching to something else" | Mid-Feature Pause | Current diff + in-progress files + any open questions in the session |
| Ticket or feature reference given | Any | Fetch ticket context via MCP first for the requirements baseline |

Always check git state before writing the checkpoint. The diff and recent commits tell you what actually changed — don't rely on what the user remembers.

---

## Workflow

### Phase 1 — Gather Context

1. **Check git state.** Run `git status` and `git diff` to see exactly what's changed — staged, unstaged, and untracked files. Recent commits show what was completed earlier in the session.
2. **Read in-progress files.** For any files with uncommitted changes, skim them to understand current state — especially any partial implementations, commented TODOs, or obvious stopping points.
3. **Identify the pattern.** End-of-Day, Handoff, or Mid-Feature Pause? This determines how much context depth to capture.
4. **Pull requirements.** If a ticket was referenced, fetch acceptance criteria via MCP — this becomes the progress baseline (what's done vs what's left).
5. **Surface decisions and blockers.** From the session context or code comments, identify key technical decisions made and any unresolved questions.

### Phase 2 — Present Checkpoint (pause gate)

Follow `references/checkpoint-output-template.md` exactly. Show the progress summary first — a quick read should tell anyone (including future-you) exactly where things stand.

**Stop here. Wait for the user to review before saving anywhere.**

The user may want to add context, correct the next steps list, or note a blocker you missed. Iterate on the content before writing the file.

### Phase 3 — Save Checkpoint (after approval)

When the user approves:

1. If a save location was specified, write the checkpoint file there
2. If no location was given, suggest `.claude/checkpoints/YYYY-MM-DD-{feature-name}.md` and ask to confirm
3. Do not create directories without checking they exist first

---

## Three Patterns (Quick Reference)

### End-of-Day
Goal: pick up exactly where you left off tomorrow. Capture everything needed to re-establish context quickly — what's done, what's partially done, the exact state of in-progress work, and the specific next action to take first thing.

### Mid-Feature Pause
Goal: context preservation while switching tasks. Lighter than End-of-Day — focused on the current stopping point and the minimum context needed to resume without re-reading everything.

### Handoff
Goal: another developer can pick up without asking questions. Most thorough — includes setup steps, environment notes, known gotchas, and enough decision rationale that they understand not just what to do next but why.

---

## What to Capture (Quick Reference)

| Section | What to include |
|---------|----------------|
| **Progress summary** | 2–3 sentences on overall state — would make sense to someone cold |
| **Completed** | What's fully done and working |
| **In progress** | What's partially done and its exact current state |
| **Files modified** | Each changed file with a one-line description of what changed |
| **Key decisions** | Technical choices made and their rationale — the "why" that isn't in the code |
| **Blockers / open questions** | Anything that needs resolution before work can continue |
| **Next steps** | Prioritized — the first item should be the exact thing to do when resuming |

---

## Reference Files

| File | When to read |
|------|--------------|
| `references/checkpoint-output-template.md` | Always — follow this format when presenting the checkpoint |
