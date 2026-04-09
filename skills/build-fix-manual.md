# Build Fix — User Manual

A guide to diagnosing and fixing build failures using the `build-fix` skill.

---

## What It Does

The `build-fix` skill diagnoses build failures, CI/CD errors, dependency conflicts, and compilation issues — then proposes and applies a targeted fix. It parses your error output, traces the root cause, and presents a diagnosis with a diff for your approval before touching any files.

It modifies configuration and build files only. It will never modify production application logic.

---

## Adding the Skill to a Project

The skill lives in the playbook repo under `skills/build-fix/`. To use it in a project, copy it into that project's Claude configuration.

### Step 1 — Copy the skill folder

**Option A — Global level** *(available in every project on your machine — recommended)*

```
~/.claude/skills/
└── build-fix/
    ├── SKILL.md
    └── references/
        └── diagnosis-output-template.md
```

On Windows: `C:\Users\{your-username}\.claude\skills\`

**Option B — Project-level** *(available only in that specific project)*

```
your-project/
└── .claude/skills/
    └── build-fix/
        ├── SKILL.md
        └── references/
            └── diagnosis-output-template.md
```

### Step 2 — Confirm Claude Code sees it

Open Claude Code and type `/` — you should see `build-fix` listed. If it doesn't appear, restart the Claude Code session.

---

## How to Invoke It

You don't need to type a command. Paste your error output or describe the failure and the skill auto-triggers.

**Phrases that automatically invoke the skill:**

| What you say | Triggers? |
|---|---|
| "The build is broken — here's the error:" | ✅ |
| "CI is failing on the main branch" | ✅ |
| "npm install is throwing a peer dependency error" | ✅ |
| "TypeScript errors after upgrading to v5" | ✅ |
| "Docker build fails on the COPY step" | ✅ |
| "It works locally but fails in CI" | ✅ |
| "GitHub Actions pipeline is red" | ✅ |
| "Fix this dependency conflict" | ✅ |

You can also invoke explicitly with `/build-fix` if you prefer.

---

## What to Include in Your Request

| What to include | Why it helps |
|---|---|
| The full error output | The skill parses the exact error text — truncated logs miss the root cause line |
| What command triggered the failure | `npm install`, `docker build`, `tsc`, `gh workflow run`, etc. |
| What changed recently | New dependency, version upgrade, config edit — narrows the cause immediately |
| Whether it's local or CI | Helps distinguish environment mismatches from genuine code issues |

**Minimal prompt (works fine):**
```
The build is failing. Error:
npm ERR! Could not resolve dependency:
npm ERR! peer react@"^17.0.0" from @testing-library/react@12.0.0
```

**Full prompt (best results):**
```
CI build failing after upgrading React from 17 to 18.
Local build works fine. CI uses Node 18.

Error:
npm ERR! ERESOLVE unable to resolve dependency tree
npm ERR! peer react@"^17.0.0" from @testing-library/react@12.0.0
npm ERR! node_modules/@testing-library/react

Changed: bumped react and react-dom to ^18.0.0 in package.json
```

---

## What Happens After You Invoke It

### Phase 1 — Diagnosis (automatic)

The skill parses the error, classifies the failure type, reads the relevant config files (package.json, tsconfig, Dockerfile, CI workflow, etc.), traces what changed, and identifies the root cause.

### Phase 2 — Diagnosis Report (requires your approval)

The skill presents:

| Section | What you'll see |
|---------|----------------|
| Error summary | Type, failing component, environment |
| Key error output | The lines that identify the problem |
| Root cause analysis | Why it's failing — not just what the error says |
| Proposed fix | A diff showing the exact change |
| Alternative approaches | Trade-offs if multiple fixes are viable |
| Verification steps | The exact command to confirm it worked |

**The skill pauses here and waits for you.** Review the root cause explanation and the proposed diff before approving.

### Phase 3 — Apply Fix (after your approval)

Once you approve, the skill applies the minimal change and gives you the verification command. If the fix reveals a new error, it restarts the diagnosis with the new context.

---

## Error Categories

| Category | Examples |
|----------|----------|
| **Dependency Resolution** | Peer conflicts, `ERESOLVE`, missing packages, version not found |
| **Compilation** | TypeScript `TS2xxx` errors, ESLint failures, syntax errors |
| **Environment** | `command not found`, missing env variables, local vs CI mismatch |
| **Docker/Container** | `COPY failed`, failing `RUN` steps, multi-stage build issues |
| **CI/CD Pipeline** | YAML syntax errors, missing secrets, runner failures |
| **Lock File** | Corrupted lock files, merge conflicts in `package-lock.json` |
| **Cache** | Stale caches causing inconsistent results |

---

## What the Skill Will Not Do

- **Modify production application logic.** Only config and build files — unless a syntax error in application code is the direct cause of the build failure.
- **Silently upgrade dependencies.** Any version change is shown in the diff before applying. Lock file regeneration is always flagged.
- **Apply fixes without approval.** The diagnosis always pauses for your sign-off before writing any files.

---

## After the Fix

1. Run the verification command from the diagnosis report
2. Re-trigger CI if the failure was in the pipeline
3. If a new error surfaces, the skill will restart diagnosis automatically
