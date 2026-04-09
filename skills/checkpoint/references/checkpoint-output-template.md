# Checkpoint — Output Template

Use this format when presenting a checkpoint. Follow it exactly — the progress summary at the top should give anyone a clear picture of where things stand in under 30 seconds.

---

## Checkpoint: {Feature / Ticket} — {YYYY-MM-DD}

**Pattern**: {End-of-Day | Mid-Feature Pause | Handoff}

### Progress Summary

{2–3 sentences on the current state of the feature. Write this so that someone picking it up cold — including future-you — can immediately understand what's done, what's in flight, and the general shape of what's left. Don't assume the reader remembers the earlier session.}

---

### Completed

- {Task or change that is fully done and working}
- {Another completed item}

*Empty if nothing is complete yet — don't list partial work here.*

---

### In Progress

- **{Task name}**: {Exact current state — what's been done on this, where it stopped, what the next step inside this task is}
- **{Task name}**: {Current state}

---

### Files Modified

| File | Status | What Changed |
|------|--------|--------------|
| [filename](path) | Modified / Added / Deleted | {One-line description of the change} |

*Derived from git diff — reflects actual changes, not intended changes.*

---

### Key Decisions

| Decision | Rationale |
|----------|-----------|
| {Technical choice made} | {Why — the reasoning that isn't obvious from the code} |

*Only include decisions where the rationale isn't self-evident. Skip if nothing significant was decided.*

---

### Blockers / Open Questions

- **{Blocker}**: {Description and what's needed to unblock}
- **{Open question}**: {What needs to be decided and by whom}

*Omit this section if there are no blockers or open questions.*

---

### Next Steps

1. {The specific first thing to do when resuming — not a category, an action}
2. {Second priority}
3. {Third priority}

---

### Handoff Notes *(Handoff pattern only — omit for End-of-Day and Mid-Feature Pause)*

**Environment setup**: {Anything non-obvious needed to run the code locally}
**Known gotchas**: {Tricky areas, things that broke during the session, anything to watch for}
**Contacts**: {Who to ask if something is unclear — ticket owner, domain expert, etc.}

---

**Waiting for your review before saving this checkpoint.**

---

## Style Rules

- **Progress summary is for humans, not machines.** It should read like a brief to a colleague, not a git log. Include enough context that someone can orient in under 30 seconds.
- **In Progress needs the exact stopping point.** "Working on auth middleware" is useless. "Auth middleware: JWT validation is written and passing manually; still need to add the refresh token rotation logic in `jwt_handler.py:refresh_token()`" is what makes resumption fast.
- **Files Modified comes from git, not memory.** Always derive this from `git status` / `git diff` — what actually changed, not what the user thinks changed.
- **Key Decisions captures the "why".** If the decision is obvious from the code, skip it. Only record choices where the rationale would be lost without this note — library choice, approach trade-offs, deliberate shortcuts.
- **Next Steps are specific actions.** "Continue feature work" fails. "Add refresh token rotation to `jwt_handler.py:refresh_token()`, then write the test" succeeds.
- **Handoff notes are for the Handoff pattern only.** Don't include environment setup or gotchas for a personal End-of-Day checkpoint — it's noise.
- **Omit empty sections.** Don't include "Blockers / Open Questions" with nothing under it. Don't include "Key Decisions" if no decisions were made. Only show sections with content.
- **Date is always explicit.** Use `YYYY-MM-DD` format in the heading — relative dates ("today", "this week") become meaningless after 24 hours.
