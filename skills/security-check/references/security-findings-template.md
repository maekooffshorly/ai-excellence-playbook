# Security Check — Output Template

Use this format when presenting a security report. Follow it exactly — leading with the overall risk level lets the developer triage immediately without reading every finding first.

---

## Security Report: {Brief description or ticket reference}

### Summary

{2–3 sentences: what was reviewed, overall security posture, key risks identified.}

**Overall Risk Level**: {🟢 Low | 🟡 Medium | 🟠 High | 🔴 Critical}

---

### Files Reviewed

| File | Security Relevance | Findings |
|------|--------------------|----------|
| [filename](path) | {auth logic / data handling / input processing / config} | {count and brief note, or "No issues found"} |

---

### Security Findings

#### 🔴 Critical

- **[filename:line](path#Lline)**: {Vulnerability name and description}
  - **Risk**: {What an attacker could do and the impact — be specific}
  - **Recommendation**: {Clear remediation path}

#### 🟠 High

- **[filename:line](path#Lline)**: {Issue description}
  - **Risk**: {Potential impact}
  - **Recommendation**: {How to fix}

#### 🟡 Medium

- **[filename:line](path#Lline)**: {Issue description}
  - **Risk**: {Potential impact}
  - **Recommendation**: {Improvement}

#### 🔵 Low / Best Practices

- **[filename:line](path#Lline)**: {Recommendation}

#### ⚪ Informational

- {Observation with no immediate risk}

*Omit any severity section that has no findings.*

---

### OWASP Top 10 Assessment

| Category | Status | Notes |
|----------|--------|-------|
| A01: Broken Access Control | ✅ / ⚠️ / ❌ | {Brief note} |
| A02: Cryptographic Failures | ✅ / ⚠️ / ❌ | {Brief note} |
| A03: Injection | ✅ / ⚠️ / ❌ | {Brief note} |
| A04: Insecure Design | ✅ / ⚠️ / ❌ | {Brief note} |
| A05: Security Misconfiguration | ✅ / ⚠️ / ❌ | {Brief note} |
| A06: Vulnerable Components | ✅ / ⚠️ / ❌ | {Brief note} |
| A07: Auth & Session Failures | ✅ / ⚠️ / ❌ | {Brief note} |
| A08: Data Integrity Failures | ✅ / ⚠️ / ❌ | {Brief note} |
| A09: Logging & Monitoring Failures | ✅ / ⚠️ / ❌ | {Brief note} |
| A10: SSRF | ✅ / ⚠️ / ❌ | {Brief note} |

*✅ = no issues found | ⚠️ = minor concern or observation | ❌ = finding present*

---

### Recommendations

1. {Highest-priority security action — link to the Critical/High finding}
2. {Next action}
3. {Additional follow-up items}

---

**Stop here. Wait for the user to review the security report before continuing.**

---

## Style Rules

- **Be specific.** Reference exact files and line numbers. Vague findings are unfixable.
- **Explain the risk.** Describe what an attacker could actually do — not just what's wrong syntactically. A developer needs to understand the real-world impact to prioritize correctly.
- **Be actionable.** Every finding must have a clear remediation path. If you can't recommend a fix, say what additional investigation is needed.
- **Don't cry wolf.** Only flag real risks, not theoretical edge cases that require multiple prerequisite conditions. Inflate severity and the report loses credibility.
- **Consider context.** A vulnerability in an internal admin tool differs from public-facing code. Note when context affects severity.
- **Omit empty severity sections.** Don't include "#### 🔴 Critical" with nothing under it — it creates noise.
- **Link to specific lines.** Use `[filename:line](path#Lline)` format so the developer can jump directly to the vulnerable code.
