# Security Check — User Manual

A guide to running a dedicated security review before merging critical code changes using the `security-check` skill.

---

## What It Does

The `security-check` skill performs a structured OWASP-based security analysis of your code changes before a PR is created or merged. It maps data flows, identifies trust boundaries, runs SonarQube for static analysis, and returns a severity-classified security report — pausing for your review before finalizing.

It is read-only. It will never modify your code.

---

## Adding the Skill to a Project

The skill lives in the playbook repo under `skills/security-check/`. To use it in a project, copy it into that project's Claude configuration.

### Step 1 — Copy the skill folder

**Option A — Global level** *(available in every project on your machine — recommended)*

```
~/.claude/skills/
└── security-check/
    ├── SKILL.md
    └── references/
        └── security-findings-template.md
```

On Windows: `C:\Users\{your-username}\.claude\skills\`

**Option B — Project-level** *(available only in that specific project)*

```
your-project/
└── .claude/skills/
    └── security-check/
        ├── SKILL.md
        └── references/
            └── security-findings-template.md
```

### Step 2 — Confirm Claude Code sees it

Open Claude Code and type `/` — you should see `security-check` listed. If it doesn't appear, restart the Claude Code session.

---

## How to Invoke It

You don't need to type a command. Describe what you want and the skill auto-triggers.

**Phrases that automatically invoke the skill:**

| What you say | Triggers? |
|---|---|
| "Security review before I merge AUTH-042" | ✅ |
| "Check for vulnerabilities in my auth changes" | ✅ |
| "Is this safe to merge?" | ✅ |
| "Can you check for injection risks?" | ✅ |
| "Check my token validation logic" | ✅ |
| "OWASP scan on these files" | ✅ |
| "Are there any sensitive data exposure issues?" | ✅ |
| "This hits a payment API — check it before we ship" | ✅ |

You can also invoke explicitly with `/security-check` if you prefer.

---

## What to Include in Your Request

| What to include | Why it helps |
|---|---|
| File paths (`@path/to/file.py`) | Focuses the review on exactly what changed |
| Type of functionality | e.g. "auth logic", "payment processing", "file upload" — affects threat model |
| Ticket reference (Jira, Linear, GitHub issue) | Provides requirements context for the threat model |
| Specific concerns | e.g. "I'm worried about IDOR" or "check the token expiry logic" |
| Compliance requirements | SOC2, HIPAA, PCI-DSS — escalates relevant findings to Critical |

**Minimal prompt (works fine):**
```
Security check on @app/api/routes/auth.py before I open the PR.
```

**Full prompt (best results):**
```
Security review for AUTH-042.
Changed files: @app/api/routes/auth.py, @app/services/auth_service.py,
@app/middleware/jwt_handler.py
Pay special attention to token validation and session handling.
We're PCI-DSS compliant so flag anything that touches payment data.
```

---

## What Happens After You Invoke It

### Phase 1 — Research (automatic)

The skill maps data flows through the changed files, identifies trust boundaries, runs SonarQube for existing security hotspots, checks for OWASP Top 10 vulnerabilities, and reviews authentication, authorization, and input handling patterns.

### Phase 2 — Security Report (requires your response)

The skill presents a structured report including:

| Section | What you'll see |
|---------|----------------|
| Summary | What was reviewed, overall risk level |
| Files reviewed | Security relevance and finding count per file |
| Findings | Classified by severity (🔴 Critical → ⚪ Informational) |
| OWASP Top 10 assessment | Pass/concern/fail per category |
| Recommendations | Prioritized action list |

**The skill pauses here and waits for you.** Ask follow-up questions, dispute a finding, or provide threat model context before finalizing.

### Phase 3 — Iteration

Respond with questions or additional context. The skill will refine its findings and re-present the updated report. This continues until you're satisfied.

---

## Severity Levels

| Severity | Icon | Meaning | What to do |
|----------|------|---------|------------|
| Critical | 🔴 | Exploitable vulnerability, data breach risk | Fix before merge — block PR |
| High | 🟠 | Security weakness that could be exploited | Fix before merge |
| Medium | 🟡 | Defense-in-depth gap, improvement needed | Fix if time permits; track for follow-up |
| Low | 🔵 | Best practice recommendation | Consider for later |
| Informational | ⚪ | Security observation, no immediate risk | No action needed |

---

## When to Use Security Check

Security check is always useful, but mandatory for:

- Auth, session management, or token handling changes
- Billing, payment, or financial data flows
- User input that reaches a database, shell command, or rendered output
- File upload or external API integration
- Compliance-sensitive projects (SOC2, HIPAA, PCI-DSS)

---

## What the Skill Will Not Do

- **Fix code.** It reviews and reports only. Address findings in your codebase, then re-run if needed.
- **Approve PRs on your behalf.** The overall risk level is guidance — the merge decision is yours.
- **Review the entire codebase.** Scope your request to the files that changed.

---

## After the Review

1. Fix all Critical and High findings before opening the PR
2. Track Medium findings as follow-up tickets if not addressed immediately
3. Run `/code-review` for non-security aspects if you haven't already
4. Open the PR — include the overall risk level in the PR description
