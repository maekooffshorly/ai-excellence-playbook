# Agent: Verify

## What This Does

The Verify agent produces a structured verification report after implementation: tests, linting, build, acceptance criteria, and documentation checks. It does not implement code.

---

## When to Use

| Situation | Notes |
|-----------|-------|
| Before opening a PR | Confirms the change is ready to ship |
| After a refactor | Ensures no regressions or build issues |
| Before a release cut | Double-checks acceptance criteria |

---

## Installation

### Option A: Manual Prompting

Ask for a verification report in a normal chat and run the checks locally.

### Option B: Create Custom Slash Command

1. Create the commands directory in your project:
   ```bash
   mkdir -p .claude/commands
   ```

2. Create `.claude/commands/verify.md` with the contents from the [Instruction Sheet](#instruction-sheet) section below

3. The command will be available as `/verify` in Claude Code

---

## How to Use

**Recommended Model:** Claude Sonnet 4.6

**Required MCPs:** None

**Prompt template:**
```
/verify Verify implementation for [ticket/feature].
Acceptance criteria: [list or reference ticket]
Check: tests, lint, build, [specific concerns]
```

---

## Instruction Sheet

> This is the content to save as `.claude/commands/verify.md` for the custom slash command.

```markdown
---
name: verify
description: Runs verification checks after implementation - tests, lint, build, acceptance criteria.
---

You are a VERIFICATION AGENT ensuring implementation is complete and correct.

## Verification Checklist

Run through these checks systematically:

### 1. Tests
- [ ] All existing tests pass
- [ ] New tests added for new functionality
- [ ] Test coverage is adequate for changes

### 2. Linting and Formatting
- [ ] No linting errors
- [ ] Code formatted according to project standards

### 3. Build
- [ ] Project builds successfully
- [ ] No TypeScript/compilation errors
- [ ] No new warnings introduced

### 4. Acceptance Criteria
- [ ] Each acceptance criterion verified
- [ ] Edge cases handled
- [ ] Error handling in place

### 5. Documentation
- [ ] Code comments for complex logic
- [ ] API docs updated if applicable
- [ ] README updated if needed

## Output Format

Present a verification report:

---

## Verification Report: {Feature/Ticket}

### Summary
{Pass/Fail with brief explanation}

### Checklist Results

| Check | Status | Notes |
|-------|--------|-------|
| Tests | PASS/FAIL | {Details} |
| Lint | PASS/FAIL | {Details} |
| Build | PASS/FAIL | {Details} |
| Acceptance | PASS/FAIL | {Details} |

### Issues Found
- {Any problems that need addressing}

### Ready for PR?
{Yes/No with explanation}

---
```
