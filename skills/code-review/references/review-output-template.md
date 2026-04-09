# Code Review — Output Template

Use this format whenever presenting a review. Follow it exactly — consistent output makes reviews easier to scan and act on.

---

## Code Review: {Brief description or ticket reference}

### Summary
{2–3 sentences: what was changed, overall assessment, and the most important concern if any.}

**Verdict**: {one of the following}
- ✅ **Approved** — ready to merge as-is
- ⚠️ **Approved with Comments** — minor issues noted, can merge after addressing
- 🔄 **Changes Requested** — one or more issues should be fixed before merging
- ❌ **Needs Rework** — significant problems require substantial revision

---

### Files Reviewed

| File | Status | Notes |
|------|--------|-------|
| [filename](path) | ✅ / ⚠️ / 🔴 | {one-line note} |

---

### Findings

#### 🔴 Critical
> Bugs, security vulnerabilities, data loss risk. Must fix before merge.

- **[file:line](path#Lnnn)**: {Issue title}
  - **Problem:** {What's wrong and why it matters}
  - **Recommendation:** {Specific fix}

#### 🟠 Major
> Logic issues, missing validation, poor patterns. Should fix before merge.

- **[file:line](path#Lnnn)**: {Issue title}
  - **Problem:** {What's wrong}
  - **Recommendation:** {How to fix}

#### 🟡 Minor
> Style inconsistencies, small improvements. Fix if time permits.

- **[file:line](path#Lnnn)**: {Brief issue and suggestion}

#### 🔵 Suggestions
> Nice-to-haves, future improvements. No action required now.

- {Optional improvement worth noting for later}

#### 🟢 What's Done Well
> Well-written code, good patterns. Listed to reinforce good decisions.

- {Positive observation — be specific, not generic}

---

### Acceptance Criteria Check

| Criterion | Status | Notes |
|-----------|--------|-------|
| {Requirement from ticket or brief} | ✅ / ❌ / ⚠️ | {Brief note} |

> Omit this section if no ticket or acceptance criteria were provided.

---

### Test Coverage Assessment

{2–4 sentences covering: are the changed behaviors tested, are the tests meaningful or just coverage padding, are there gaps in edge case or error path coverage.}

---

### Recommendations

Prioritized action list — only include items that need action:

1. {Most important fix}
2. {Next fix}
3. {Etc.}

---

## Style Rules

- **Be specific.** Reference exact files and line numbers with links. Vague findings ("this could be cleaner") are not actionable.
- **Explain the why.** State why something is an issue, not just what it is.
- **Be balanced.** Include positive observations. Reviews that only criticize are demoralizing and less trusted.
- **Be proportionate.** Don't flag every style preference. Focus on what actually matters for this PR.
- **Security always.** Flag security issues regardless of any debate about severity level.
- **Verify before flagging.** Check that an "issue" isn't already handled elsewhere before calling it out.
