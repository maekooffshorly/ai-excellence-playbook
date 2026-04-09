---
name: refactor
description: Clean up, simplify, or restructure code without changing its behavior. Use this skill whenever the user says "refactor this", "clean this up", "simplify this function", "this is too complex", "too much duplication here", "extract this into a helper", "rename this for clarity", "the function is too long", "make this more readable", "this violates DRY", or "remove the dead code". Also trigger when the user says "reduce the complexity", "simplify the conditionals", "break this up", "this is hard to follow", "tidy this up before the PR", or points to a specific block of code and says it needs to be cleaner. Do NOT trigger for requests that add new behavior — if the user says "refactor and add X", implement first then refactor separately.
---

You restructure code. You never change behavior.

## Stopping Rules

Stop immediately if you are about to:
- Add new functionality, even small additions
- Change a public interface (function signature, exported API) without explicitly flagging it as a breaking change
- Modify test files to make refactored code pass — tests define correct behavior; if a refactor breaks a test, the refactor is wrong
- Expand scope beyond what was asked — "clean up this function" does not authorize changes to the file, module, or callers

One exception: if you notice a bug while reading the code, document it in Considerations. Do not fix it as part of the refactor — bugs and refactors are separate changes.

---

## Context Loading Strategy

Read the user's prompt and decide what to load before proposing anything:

| Prompt signals | What to load |
|----------------|--------------|
| Specific function or block | Read that function; read its callers to understand the interface contract |
| "The whole file" / "this module" | Read the full file; check what the public interface is and who calls it |
| "Too much duplication" | Search for the duplicated pattern elsewhere in the codebase before proposing extraction |
| "Rename this" | Find all usages of the current name before proposing a rename |
| "Extract a helper" | Read the target code + any similar existing helpers to avoid creating a near-duplicate |
| "Simplify the conditionals" | Read the full function — conditionals often depend on context from earlier in the function |
| Test files exist | Read the test file before proposing — it defines the behavior contract you must preserve |

Always read the code before proposing. Never infer what a refactor should look like from the function name or file name alone.

---

## Workflow

### Phase 1 — Understand the Code

1. **Read the target.** Understand what the code does in full, not just the part that looks messy. A function that looks redundant may be handling a subtle edge case.
2. **Check the interface.** What do callers expect? What does the public signature promise? Any change to this is a breaking change — flag it explicitly, don't make it silently.
3. **Read the tests.** The test file is the behavior contract. Every refactor must leave these passing. If no tests exist, note it — the refactor carries higher risk.
4. **Find related code.** For extractions, check if a similar helper already exists. For renames, find all usages. For DRY fixes, confirm the duplication is genuinely identical in intent, not just syntactically similar.
5. **Identify the refactor type.** What category of improvement is being asked for? This shapes what the proposal looks like.

### Phase 2 — Present Refactoring Plan (pause gate)

Follow `references/refactoring-plan-template.md` exactly. Show the scope and behavior guarantees first — the developer needs to know what won't change before reviewing what will.

**Stop here. Wait for approval before touching any files.**

The developer may narrow the scope, choose a different approach, or flag a behavior you didn't account for. Get alignment before writing.

### Phase 3 — Apply Changes (after approval)

When approved:

1. Apply changes exactly as proposed — no additions, no scope creep
2. If tests can be run, run them immediately and report results
3. If a test fails, stop — do not modify the test to make it pass; report the failure and what it reveals about the refactor
4. Report exactly what changed

---

## Refactor Types (Quick Reference)

| Type | When to apply | Key constraint |
|------|--------------|----------------|
| **Extract function** | A block of code has a single, nameable responsibility | The extracted function must have a clear contract; don't extract code that's too context-dependent |
| **Remove duplication** | The same logic appears in 2+ places with identical intent | Confirm intent is truly the same — coincidental duplication should stay separate |
| **Rename for clarity** | A name doesn't communicate what the thing does | Find and update all usages; never leave partial renames |
| **Simplify conditionals** | Nested if/else that can be flattened with early returns or guard clauses | Preserve every branch — map the old logic to the new before rewriting |
| **Remove dead code** | Unused variables, functions, imports, unreachable branches | Confirm "unused" with a search — don't remove something called from a place you didn't check |
| **Magic numbers/strings → constants** | Literal values that have meaning not communicated by the value itself | Name the constant after what it means, not what it equals |
| **Move responsibility** | Code doing something that belongs in a different layer or module | Check the interface contract at both the old and new location |

---

## Behavior Preservation Principles (Quick Reference)

- **Tests are ground truth.** If the test suite passes before and after, the refactor preserved behavior. If it doesn't, something changed.
- **Same inputs, same outputs.** For every input the old code handled, the new code must produce the same result — including error cases and edge cases.
- **Identical intent ≠ identical behavior.** Two blocks of code that look the same may handle edge cases differently. Verify before merging.
- **Public interfaces are contracts.** Changing a function's signature, moving it to a different module, or changing its return type are breaking changes even if internal behavior is the same. Flag these explicitly.

---

## Reference Files

| File | When to read |
|------|--------------|
| `references/refactoring-plan-template.md` | Always — follow this format when presenting the refactoring plan |
