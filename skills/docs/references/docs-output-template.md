# Docs — Output Template

Use this format when presenting documentation drafts. Follow it exactly — showing the changes-analyzed table first lets the user verify scope before reading drafted content.

---

## Documentation Update: {Brief description or date}

### Summary

{1–2 sentences: what triggered this update and the scope of changes being documented.}

**Pattern**: {Pre-PR Documentation | End-of-Day Checkpoint}

---

### Changes Analyzed

| File | Type of Change | Documentation Impact |
|------|----------------|---------------------|
| [filename](path) | {New / Modified / Deleted} | {What needs documenting — e.g. "new endpoint", "new env var", "renamed function"} |

---

### Documentation Drafts

#### {File or Section Name}

**Location**: `path/to/doc/file.md` *(or: inline in `path/to/source/file.py`)*
**Action**: {Create | Update | Expand}

{Drafted documentation content — written exactly as it will appear in the file, including headings, code blocks, and examples. Not a description of what to write — the actual content.}

---

#### {Next Documentation Section}

**Location**: `path/to/another/file.md`
**Action**: {Create | Update | Expand}

{Drafted content}

*Repeat for each documentation area that needs updating.*

---

### Context Preserved *(End-of-Day only — omit for Pre-PR)*

- **Work in progress**: {What's incomplete and its current state}
- **Decisions made**: {Key choices made today and the rationale}
- **Next steps**: {Exactly what to pick up tomorrow}
- **TODOs flagged**: {Items that need attention but weren't addressed today}

---

### Documentation Debt Identified

{Only include if gaps were found that are outside the current scope. Omit if nothing was identified.}

| Gap | Priority | Notes |
|-----|----------|-------|
| {Missing or drifted documentation} | High / Medium / Low | {Brief context — why it matters} |

---

**Stop here. Waiting for your review before writing any files.**

---

## Style Rules

- **Write the actual content, not a description of it.** Every section under Documentation Drafts should contain the exact text that will be written to the file — not "add a description of the endpoint" but the actual endpoint description.
- **Match the project's existing documentation style.** Read a nearby doc file before writing. Use the same heading levels, code block style, table format, and terminology.
- **Use examples for APIs and config.** A request/response example or config snippet teaches faster than prose.
- **Explain "why", not "what".** Inline comments should capture intent and decisions — the code already shows what it does.
- **Be concise.** Documentation that takes longer to read than the code it describes has failed its purpose.
- **Date CHANGELOG entries.** Format: `## [Unreleased]` or `## [v0.X] — YYYY-MM-DD` depending on project convention.
- **Omit empty sections.** If there's no documentation debt identified, don't include that section. If this is a pre-PR pass, omit the "Context Preserved" section entirely.
- **Link, don't duplicate.** If information exists elsewhere, reference it. Two sources of truth immediately diverge.
