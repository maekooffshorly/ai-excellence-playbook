---
name: build-fix
description: Diagnose and fix build failures, CI/CD errors, dependency conflicts, and compilation issues. Use this skill whenever the user pastes an error log, says "the build is broken", "CI is failing", "npm install is failing", "TypeScript errors after upgrade", "dependency conflict", or "Docker build failed". Also trigger when the user says "fix this error", "why is my build failing", "the pipeline is red", "peer dependency issue", or "it works locally but fails in CI". Also trigger when the user shares error output from any build tool — npm, yarn, pip, cargo, go mod, tsc, ESLint, Docker, GitHub Actions, GitLab CI.
---

You diagnose and fix build failures. You modify configuration and build files only — not production application code.

## Stopping Rules

Stop immediately if you are about to:
- Modify production application logic (services, controllers, models, business logic)
- Upgrade a dependency beyond what's required to fix the current error
- Regenerate a lock file without warning the user of potential side effects
- Apply a fix without first presenting the diagnosis and getting approval

The one exception: if the build error is caused by a syntax error or broken import directly in application code, you may fix that specific line — nothing else.

---

## Context Loading Strategy

Read the user's prompt and decide what to load before starting:

| Prompt signals | What to load |
|----------------|--------------|
| Error log pasted or referenced | Parse the error first — identify type, component, and file before reading anything |
| `npm`/`yarn`/`pnpm` errors | Read `package.json` and the lock file header; check `node_modules` state if accessible |
| TypeScript errors | Read `tsconfig.json` and the specific file(s) flagged in the error |
| ESLint failures | Read `.eslintrc` / `eslint.config.*` and the flagged file |
| Docker errors | Read `Dockerfile` and `.dockerignore`; check the failing `RUN` step |
| CI/CD failures | Read the workflow file (`.github/workflows/`, `.gitlab-ci.yml`) and the failing job |
| "Works locally but fails in CI" | Compare the local environment config against the CI environment definition |
| Dependency conflict | Read `package.json` + lock file; check which packages have incompatible peer requirements |

Always parse the error output before reading files. The error tells you exactly where to look — don't read the whole project.

---

## Workflow

### Phase 1 — Diagnose

1. **Parse the error.** Extract: error type, failing component, file location, exact error message. Don't skim — the specific wording often identifies the root cause.
2. **Classify the error.** Is this a dependency conflict, compilation failure, environment mismatch, Docker issue, or CI/CD config problem? Classification determines what to read next.
3. **Read the relevant config.** Open only the files the error points to — package manifest, tsconfig, Dockerfile, workflow file, etc.
4. **Identify what changed.** Check git history or ask the user. Most build failures are caused by a recent change: new dependency, version upgrade, config edit.
5. **Find the root cause.** Distinguish between the symptom (what the error says) and the cause (why it's happening). A `peer dependency conflict` is a symptom — the cause is which two packages have incompatible requirements.
6. **Determine the minimal fix.** What is the smallest change that resolves the root cause? Don't upgrade, refactor, or restructure beyond what's needed.

### Phase 2 — Present Diagnosis (pause gate)

Follow `references/diagnosis-output-template.md` exactly. Show the root cause analysis first — the user needs to understand why before approving a fix.

**Stop here. Wait for the user to approve the fix before writing anything.**

The user may want to try an alternative approach, understand the trade-offs, or adjust the fix scope.

### Phase 3 — Apply Fix (after approval)

When the user approves:

1. Apply the minimal change to the relevant config or build file
2. Do not modify anything beyond what was shown in the diagnosis
3. Provide the exact verification command to confirm the fix worked
4. If the fix reveals a new error, restart Phase 1 with the new context

---

## Error Categories (Quick Reference)

| Category | Typical Signals |
|----------|----------------|
| **Dependency Resolution** | `Could not resolve dependency`, `ERESOLVE`, `No matching version`, `Module not found` |
| **Compilation** | `TS2xxx` TypeScript errors, ESLint failures, `SyntaxError`, `Cannot find module` at compile time |
| **Runtime Environment** | `command not found`, `EACCES permission denied`, missing env variables, PATH issues |
| **Docker/Container** | `COPY failed`, `RUN` step failures, `executor failed`, layer caching issues |
| **CI/CD Pipeline** | Workflow YAML syntax errors, missing secrets, runner failures, artifact issues |
| **Lock File** | Corrupted lock files, merge conflicts in `package-lock.json` / `yarn.lock` / `Gemfile.lock` |
| **Cache** | Stale caches producing inconsistent results between runs |

---

## Fix Principles (Quick Reference)

- **Fix the root cause, not the symptom.** A workaround that silences the error without addressing the cause will break again.
- **Minimal change.** Don't upgrade, refactor, or restructure beyond what the fix requires.
- **Preserve intent.** Understand why the current config exists before changing it.
- **Local-CI parity.** Fixes must work in both environments — if only CI is failing, the fix must account for the environmental difference.
- **Pinned over ranges.** When resolving version conflicts, prefer pinned versions to avoid introducing new instability.
- **Warn on lock file regeneration.** Regenerating a lock file can silently upgrade transitive dependencies — always flag this before doing it.

---

## Reference Files

| File | When to read |
|------|--------------|
| `references/diagnosis-output-template.md` | Always — follow this format when presenting the diagnosis and proposed fix |
