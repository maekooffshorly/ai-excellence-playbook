# Refactor — Output Template

Use this format when presenting a refactoring plan. Show scope and behavior guarantees first — the developer needs to know what won't change before reviewing what will.

---

## Refactoring Plan: {Brief description of what's being cleaned up}

### Target

- **File:** [filename](path)
- **Scope:** {Function name, line range, or "full file"}
- **Refactor type:** {Extract function / Remove duplication / Rename / Simplify conditionals / Remove dead code / Magic numbers → constants / Move responsibility}

---

### What Will NOT Change

{Explicit list of behavior that will be preserved. This section builds confidence before the developer reads the proposed changes.}

- {External function signature remains the same — callers are unaffected}
- {Return values and error behavior preserved}
- {Test suite remains valid — no test modifications needed}

*If any of these can't be guaranteed, it must appear in Risk Assessment below — not silently omitted.*

---

### Proposed Changes

{For each change: show before/after as a diff. Keep diffs minimal — only the lines that actually change.}

#### {Change 1 — descriptive label}

**Why:** {One sentence explaining the problem this change solves}

```diff
- {old code}
+ {new code}
```

#### {Change 2 — descriptive label}

**Why:** {Rationale}

```diff
- {old code}
+ {new code}
```

*Use one subsection per logical change. If all changes are tightly coupled, a single diff covering the full refactor is fine.*

---

### Risk Assessment

{Only include this section if there is genuine uncertainty about behavior preservation.}

- **{Risk}**: {What might change and why — what to verify carefully after applying}

*If the refactor is straightforward and tests exist, this section can be omitted.*

---

### Considerations

{Anything worth noting that doesn't fit above.}

1. {e.g. "No tests exist for this function — manual verification recommended before merging"}
2. {e.g. "Found a bug in line 47 while reading — not addressed here; tracked separately"}
3. {e.g. "A similar helper exists at `utils/format.py` — worth checking if it can replace both"}

---

### Verification

1. `{Test command}` — all tests that cover this code should pass unchanged
2. {Any manual verification step if automated coverage is incomplete}

---

**Waiting for your approval before making any changes.**

---

## Style Rules

- **Diffs over prose.** Show exactly what changes. "Rename the variable" followed by the old name is not enough — show the before and after.
- **One change per subsection.** If a function extraction and a rename happen together, describe them separately so the developer can approve or reject each independently.
- **"What Will NOT Change" is mandatory.** Every refactoring plan must include an explicit statement of what is preserved. This is what distinguishes a safe refactor from a risky one.
- **Never modify tests in the proposal.** If the proposal requires a test change, that is a signal the refactor is changing behavior, not just structure. Stop and reconsider.
- **Flag interface changes explicitly.** If the refactor changes a public API — even a small one — it must appear in the proposal as a named change with a "breaking change" note, not as a side effect of something else.
- **Risk Assessment is honest.** If you're not certain a change preserves behavior, say so. Don't omit the section to make the proposal look cleaner.
- **Considerations captures bugs found.** If you spotted a bug while reading, document it here — don't fix it in the refactor.
