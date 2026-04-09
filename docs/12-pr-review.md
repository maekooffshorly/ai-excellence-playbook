# AI-Assisted PR Code Review Guide

> **Environment note:** The `/review` command requires an AI coding agent with slash command support (e.g., Cursor, Windsurf). Otherwise, use the prompt text directly without the prefix.

---

## Why This Approach?

### The Problem with Traditional GitHub PR Reviews

GitHub's built-in PR review is line-by-line and comment-by-comment. While familiar, it has real limitations in practice:

- **Time consuming** — reviewers manually read every changed line, leave inline comments, and wait for responses. On large PRs this can take hours.
- **Context is fragmented** — inline comments are scattered across files, making it hard to see the full picture of what's broken and what's been fixed.
- **AI assistance is limited by your plan** — GitHub Copilot's PR review feature is gated behind specific enterprise or team plans. Its scope is also limited to what GitHub exposes in its environment, meaning it may not have full context of your codebase, project structure, or custom conventions.
- **No structured audit trail** — GitHub comments are threaded per line, not per issue. Tracking whether a bug was actually fixed across review rounds requires manually hunting through resolved threads.
- **Review fatigue** — long PRs with many comments often result in rubber-stamp approvals just to unblock the developer.

### Why This Approach is Better

This workflow pairs your local AI coding agent — which has **full context of your entire codebase** — with a structured, file-based review process:

- **Faster reviews** — the AI scans the entire branch diff against main in seconds, not hours. The reviewer's job shifts from finding bugs to validating findings.
- **Full codebase context** — unlike GitHub's AI which only sees the diff, your local agent sees the whole project. This means it can catch regressions, cross-file impacts, and architectural issues that line-by-line review would miss.
- **No plan restrictions** — this works with any AI coding agent regardless of your GitHub plan tier. The capability lives in your local environment, not behind a paywall.
- **Structured audit trail** — a single file captures the full review history in order: findings, fixes, and validations. Anyone can read it top to bottom and understand the entire review cycle instantly.
- **Consistent format** — every review follows the same template, making it easy to compare across PRs, onboard new reviewers, and enforce standards.

> **Bottom line:** Traditional PR reviews scale poorly with PR size and team velocity. This approach offloads the time-intensive scanning work to AI while keeping humans in control of the final judgment — which is exactly where human judgment adds the most value.

---

## Overview

```
[Reviewer] Initial Review → [Developer] Fix Issues → [Reviewer] Validate Fixes → Merge or Loop
```

---

## Review File

A single file is used throughout the entire cycle. Each round appends a short response block to the bottom — no new files, no repeated content. Each response block references only the issue IDs from the original review.

**File naming:** `reviews/review-{branch-name}-{date}.txt`

**Template:**

```
================================================================================
CODE REVIEW: {branch name}
Date: {date}
Model: {AI model}
================================================================================

SUMMARY
-------
{summary}


ISSUES FOUND
================================================================================
[BUG-001] Critical: {description}
[BUG-002] High: {description}
[BUG-003] Low: {description}


POTENTIAL ISSUES (Non-Blocking)
================================================================================
[WARN-001] Performance: {description}
[WARN-002] Style: {description}


VERDICT
================================================================================
{Request Changes / Approved / Blocked}


--------------------------------------------------------------------------------
-- AWAITING FIX RESPONSE FROM DEVELOPER --
--------------------------------------------------------------------------------
```

**Completed file example:**

```
...

VERDICT
================================================================================
Request Changes


--------------------------------------------------------------------------------
FIX RESPONSE: {date}
--------------------------------------------------------------------------------
[BUG-001] Fixed — {brief description}
[BUG-002] Fixed — {brief description}
[BUG-003] Acknowledged — {deferral reason}


--------------------------------------------------------------------------------
VALIDATION: {date}
--------------------------------------------------------------------------------
[BUG-001] ✅ Confirmed fixed
[BUG-002] ✅ Confirmed fixed
[BUG-003] ⏭️ Deferred — noted
VERDICT: Approved
```

---

## PART 1 — Code Review (Reviewer)

### Step 1: Sync and Checkout Branch

```bash
git fetch --all
git checkout main
git pull
git checkout {branch name}
```

### Step 2: Set Up Reviews Folder

> Skip if `reviews/` already exists. Create the folder and add `template.txt` using the template above.

### Step 3: Run the AI Review

```
/review {branch name} for bugs or regressions, compare with main for impact on existing functionality, use /reviews/template.txt, save to reviews folder, leave the AWAITING marker as-is.
```

### Step 4: Validate the AI Review

> ⚠️ Manually read through the generated file before sending. Verify findings are accurate and the AI has not hallucinated issues or missed context. Add, remove, or clarify items as needed.

Send the validated review file to the developer.

---

## PART 2 — Fixing Issues (Developer)

### Step 1: Set Up Reviews Folder

> Skip if `reviews/` already exists.

### Step 2: Sync Main and Merge into Your Branch

> ⚠️ **Critical:** Always ensure your branch is up to date with `main` before fixing. If your branch is behind, the AI will produce inaccurate results.

```bash
git fetch --all
git checkout main
git pull
git checkout {branch name}
git merge main
```

Or using the shortcut:

```bash
git fetch --all && git checkout {branch name} && git pull origin main
```

Resolve any merge conflicts before proceeding.

### Step 3: Save the Review File

Place the review file from the reviewer into your `reviews/` folder.

### Step 4: Fix with AI Assistance

```
Read the review file, fix all valid issues, then append a FIX RESPONSE block referencing only the issue IDs and a brief description of each fix.
```

> ⚠️ Manually verify the AI's fixes and the appended FIX RESPONSE block before pushing. Confirm fixes are accurate and the response block correctly reflects what was done.

### Step 5: Push and Return the Review File

1. Push the updated branch to the PR.
2. Send the updated review file back to the reviewer.

---

## PART 3 — Validating Fixes (Reviewer)

### Step 1: Save the Updated Review File

Replace the review file in your `reviews/` folder with the version received from the developer.

### Step 2: Re-run AI Validation

```
/review {branch name} was updated. Verify fixes against the review file, recheck for bugs or regressions, compare with main for impact, and append a VALIDATION block.
```

### Step 3: Determine the Outcome

| Outcome | Action |
|---|---|
| ✅ All issues resolved | Approve the PR for merge |
| ⚠️ Minor issues remain | Note them and approve at your discretion |
| ❌ Critical issues persist | Block the merge and loop back to Part 2 |

> **Merge authority:** The reviewer owns the final decision. Disputed findings should be escalated to the team lead — do not rely on the AI to settle disagreements.

---

## Full Cycle Summary

```
[Reviewer]   Sync → Checkout branch → Generate review → Validate → Send file
     ↓
[Developer]  Sync main → Merge into branch → Fix issues → Append FIX RESPONSE → Push & return file
     ↓
[Reviewer]   Receive file → AI validates → Append VALIDATION → Approve / Block
     ↓
              Loop until approved → Merge
```
