# Test Writer — Output Template

Use this format when presenting a test plan and generated tests. Follow it exactly — consistent output makes it easy for developers to review and approve before the tests are finalized.

---

## Test Plan: {Brief description of what's being tested}

### Target Code

- **Files:** [filename](path) lines X–Y
- **Functions:** `function_name`, `another_function`
- **Requirements:** {Jira ticket reference or acceptance criteria summary — omit if none provided}

---

### Coverage Summary

| Category | Count | Notes |
|----------|-------|-------|
| Happy paths | N | {brief description of what's covered} |
| Edge cases | N | {boundary conditions, empty inputs, limits} |
| Negative cases | N | {invalid inputs, missing fields, malformed data} |
| Error handling | N | {exceptions, timeouts, failures simulated} |
| State transitions | N | {before/after states, idempotency — omit if not applicable} |
| Security paths | N | {auth failures, injection — critical modules only} |

---

### Test Code

{Generated test code, following the project's existing conventions for file structure, naming, imports, fixtures, and mocking patterns.}

---

### Considerations

1. {Any assumptions made about the code under test}
2. {Mocking decisions and why}
3. {Additional tests worth adding if time permits — don't add them without asking}
4. {Setup or dependency requirements — e.g. fixtures, database state, environment variables}

---

**Stop here. Wait for the user to review the test plan and code before finalizing.**

---

## Style Rules

- **Match the project's test conventions.** Read existing test files before writing. Use the same naming format, import style, fixture patterns, and assertion library.
- **Use descriptive test names.** Format: `test_{function}_{scenario}_{expected_outcome}`. The test name alone should explain the behavior being verified.
- **Prefer minimal mocking.** Only mock external dependencies and I/O (database calls, HTTP requests, file system). Never mock the code under test itself.
- **Keep tests independent.** Each test must pass or fail on its own — no shared state between tests.
- **Group related tests.** Use test classes or describe blocks to organize by function or behavior.
- **Add comments for complex logic.** Brief inline comments explaining why a test is structured a certain way — not what it does (the name covers that).
- **Avoid brittle tests.** Don't assert on implementation details that could change without changing behavior. Assert on outcomes.
- **Unit tests first.** Propose integration tests separately and only when cross-boundary coverage is genuinely needed.
