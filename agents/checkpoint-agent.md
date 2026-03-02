# Agent: Checkpoint

## What This Does

The Checkpoint agent creates a savepoint documenting current progress, decisions made, blockers, and next steps. It is for context preservation across sessions and does not modify code.

---

## When to Use

| Situation | Notes |
|-----------|-------|
| End-of-day context capture | Prevents losing context between sessions |
| Mid-feature pause | Keeps decisions and open questions visible |
| Handoff to another developer | Provides a structured snapshot |

---

## Installation

### Option A: Manual Prompting

Ask for a checkpoint in a normal chat and paste the output into a file or commit message.

### Option B: Create Custom Slash Command

1. Create the commands directory in your project:
   ```bash
   mkdir -p .claude/commands
   ```

2. Create `.claude/commands/checkpoint.md` with the contents from the [Instruction Sheet](#instruction-sheet) section below

3. The command will be available as `/checkpoint` in Claude Code

---

## How to Use

**Recommended Model:** Claude Sonnet 4.6

**Required MCPs:** None

**Prompt template:**
```
/checkpoint Save progress on [ticket/feature].
Document: current state, decisions made, blockers, next steps.
```

---

## Instruction Sheet

> This is the content to save as `.claude/commands/checkpoint.md` for the custom slash command.

```markdown
---
name: checkpoint
description: Creates a savepoint documenting progress, decisions, and next steps for context preservation.
---

You are creating a CHECKPOINT to preserve context and progress.

## What to Capture

1. **Current State**: What's been completed, what's in progress
2. **Files Modified**: List of files changed in this session
3. **Decisions Made**: Key technical decisions and their rationale
4. **Blockers/Questions**: Anything that needs resolution
5. **Next Steps**: Prioritized list of what to do next

## Output Format

---

## Checkpoint: {Feature/Ticket} - {Date}

### Progress Summary
{2-3 sentences on current state}

### Completed
- [ ] {What's done}

### In Progress
- [ ] {What's partially done}

### Files Modified
- `{path}` - {what changed}

### Key Decisions
| Decision | Rationale |
|----------|-----------|
| {What was decided} | {Why} |

### Blockers / Open Questions
- {Issues needing resolution}

### Next Steps
1. {Priority 1}
2. {Priority 2}

---

Save this checkpoint to a file or commit message for reference.
```
