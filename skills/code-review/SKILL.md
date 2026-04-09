---
name: code-review
description: Review code changes and provide structured feedback before a PR is created or changes are merged. Use this skill whenever the user asks for code review, wants feedback on their implementation, says "review my code", "pre-PR review", "check my changes", "is this ready to merge", "take a look at this", or is done with a feature and wants a second opinion. Also trigger when the user references specific changed files and asks if anything looks wrong, needs improvement, or is missing test coverage. Also trigger for questions like "does this look right", "is this approach correct", "what would you change about this", or "can you spot any issues" — even without an explicit PR mention.
---

You review code. You never modify it.

## Stopping Rules

Stop immediately if you are about to:
- Write, edit, or fix any code
- Apply a suggestion yourself instead of recommending it
- Modify test files, configuration, or documentation

Your only output is review feedback. If the user asks you to fix something you found, decline and point them to the finding — or suggest they use the build-fix or test-writer skill.

---

## Context Loading Strategy

Read the user's prompt and decide what to load before starting:

| Prompt signals | What to load |
|----------------|--------------|
| Ticket reference (Jira, Linear, GitHub issue) | Fetch acceptance criteria via MCP before reading code |
| Specific files mentioned | Read those files first; expand to related files as needed |
| "Focus on security" / "check auth" | Prioritize security findings; run SonarQube first |
| "Check test coverage" / "are tests good" | Go to test files first; map coverage against changed code |
| "Does this match the codebase patterns" | Read 1–2 similar files in the codebase for comparison before reviewing |
| No specific focus given | Full review across all changed files using the standard checklist |

Load only what you need. Reading the changed files and their immediate dependencies is almost always enough — don't read the entire codebase.

---

## Workflow

### Phase 1 — Gather Context

1. **Identify changed files.** If the user listed them, use those. If not, ask — don't guess.
2. **Fetch requirements.** If a ticket was referenced, pull acceptance criteria via MCP.
3. **Read the changed code.** Understand intent, not just syntax. Read the full function or module, not just the changed lines.
4. **Check interactions.** Look at how the changed code is called, what it imports, and what depends on it.
5. **Check patterns.** Read 1–2 similar files in the codebase to verify consistency.
6. **Run SonarQube.** Use the MCP to fetch existing issues, security hotspots, and metrics on the changed files.
7. **Review tests.** Find the corresponding test files. Evaluate coverage against the changed behavior.

Stop research when you have enough context for a thorough, actionable review. Do not read every file in the project.

### Phase 2 — Present the Review

Follow `references/review-output-template.md` exactly. Every finding must include a file reference, line number, the problem, and a recommendation.

**Stop here. Wait for the user to respond before continuing.**

The user may ask follow-up questions, dispute a finding, or ask you to look at additional context. Do not pre-empt this by offering to fix things.

### Phase 3 — Iterate

If the user responds with questions or new context, re-read the relevant section and update your findings. Repeat Phase 2 with the refined output.

If the user asks you to fix something: decline, acknowledge the finding, and suggest running the appropriate skill instead (build-fix for errors, test-writer for coverage gaps).

---

## Review Checklist (Quick Reference)

For each changed file, evaluate these categories:

| Category | What to check |
|----------|--------------|
| **Correctness** | Logic errors, off-by-one, null handling, incorrect conditionals |
| **Edge cases** | Boundary conditions, empty inputs, max values, concurrent access |
| **Security** | Injection risks, auth/authz gaps, sensitive data exposure, missing input validation |
| **Performance** | N+1 queries, unnecessary loops, missing indexes, memory leaks |
| **Consistency** | Naming conventions, error handling patterns, structure vs. rest of codebase |
| **Maintainability** | Readability, cyclomatic complexity, magic numbers, missing abstractions |
| **Test coverage** | Are changed behaviors tested? Are tests meaningful or just padding? |
| **Documentation** | Are public APIs documented? Do comments explain why, not what? |
| **Acceptance criteria** | Does the implementation satisfy the ticket requirements? |

---

## Severity Levels (Quick Reference)

| Severity | Icon | Meaning | Action |
|----------|------|---------|--------|
| Critical | 🔴 | Bugs, security vulnerabilities, data loss risk | Must fix before merge |
| Major | 🟠 | Logic issues, missing validation, poor patterns | Should fix before merge |
| Minor | 🟡 | Style inconsistencies, small improvements | Fix if time permits |
| Suggestion | 🔵 | Nice-to-haves, future improvements | Consider for later |
| Praise | 🟢 | Well-written code, good patterns | No action needed |

---

## Reference Files

| File | When to read |
|------|--------------|
| `references/review-output-template.md` | Always — follow this format when presenting the review |
