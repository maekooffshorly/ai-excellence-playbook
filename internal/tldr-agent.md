# TLDR Agent (Internal)

This file is a lightweight navigation script for the AI Excellence Playbook. It helps users jump to the highest‑value sections based on their role and task. It does NOT modify code or files.

---

## How to Use

1. In your AI UI, reference this file: `/internal/tldr-agent.md`
2. Answer the short questions below
3. Follow the recommended links

---

## Quick Questions (User Input)

**Role:** backend / frontend / full‑stack / designer / QA / DevOps / non‑tech (Embee)

**Goal:** setup / model selection / review changelog / prompting / MCP setup / WordPress modules/pages / design handoff / security review / troubleshooting / OpenClaw

**Tooling:** Claude Code / Copilot / OpenClaw / just reading

In generating the questions, provide sufficiently worded question that can be understood eg. 
- What is your role, the goal for this tl;dr, and what tool you need context for?

And then also provide example answers to the questions so the user has a reference on how to answer the question.
eg. 
- backend, just want to view changelogs, claude code
- fullstack, need to read the repo, claude code
- frontend, just reading, claude code

---

## Output Format (What You Should Return)

Provide a short, role‑based response in this exact structure:

```
START HERE
- {top 3–6 links max, in priority order}

IF YOU ONLY READ ONE THING
- {single best link}

NEXT ACTION
- {single concrete action}

OPTIONAL DEEP DIVE
- {0–2 links if relevant}
```

Rules:
- Max 6 links in START HERE
- Prefer minimal set that still solves the task
- Use only repo‑relative links

---

## Role‑Based Routing (Default)

### Backend
START HERE:
- `docs/04-coding-techniques.md`
- `docs/05-setup-guide.md`
- `docs/01-model-comparison.md`
- `docs/03-mcp-servers.md`

IF YOU ONLY READ ONE THING:
- `docs/04-coding-techniques.md`

NEXT ACTION:
- Run the `prompts/01-claude-md-generator.md` prompt to generate `CLAUDE.md` for your project.

### Frontend
START HERE:
- `docs/10-design-handoff.md`
- `docs/04-coding-techniques.md`
- `docs/05-setup-guide.md`
- `agents/wp-module-builder.md`

IF YOU ONLY READ ONE THING:
- `docs/10-design-handoff.md`

NEXT ACTION:
- Review the design system page in Figma and generate `design-system.md`.

### Full‑Stack
START HERE:
- `docs/04-coding-techniques.md`
- `docs/05-setup-guide.md`
- `docs/10-design-handoff.md`
- `docs/03-mcp-servers.md`

IF YOU ONLY READ ONE THING:
- `docs/04-coding-techniques.md`

NEXT ACTION:
- Generate `CLAUDE.md` and align it with the design system page.

### Designer
START HERE:
- `docs/10-design-handoff.md`
- `docs/05-setup-guide.md`
- `agents/wp-page-builder.md`

IF YOU ONLY READ ONE THING:
- `docs/10-design-handoff.md`

NEXT ACTION:
- Create or update the Figma design system page and ensure layers are named clearly.

### QA / Security
START HERE:
- `agents/security-reviewer-agent.md`
- `docs/04-coding-techniques.md`
- `docs/05-setup-guide.md`

IF YOU ONLY READ ONE THING:
- `agents/security-reviewer-agent.md`

NEXT ACTION:
- Run a structured security review on the most recent changes.

### DevOps
START HERE:
- `docs/05-setup-guide.md`
- `docs/03-mcp-servers.md`
- `docs/02-tools-comparison.md`

IF YOU ONLY READ ONE THING:
- `docs/05-setup-guide.md`

NEXT ACTION:
- Configure MCPs in `~/.claude/settings.json`.

### Non‑Tech (Embee)
START HERE:
- `docs/07-openclaw-integration.md`
- `prompts/03-embee-system-prompt.md`

IF YOU ONLY READ ONE THING:
- `docs/07-openclaw-integration.md`

NEXT ACTION:
- Confirm OpenClaw setup and credential flow with your team lead.

---

## Goal‑Based Overrides

If the user specifies a goal, prioritize these paths:

- **Setup:** `docs/05-setup-guide.md`
- **Model selection:** `docs/01-model-comparison.md`
- **Prompting:** `docs/04-coding-techniques.md`
- **MCP setup:** `docs/03-mcp-servers.md`
- **WordPress modules/pages:** `agents/wp-module-builder.md`, `agents/wp-page-builder.md`
- **Design handoff:** `docs/10-design-handoff.md`
- **Security review:** `agents/security-reviewer-agent.md`
- **Troubleshooting:** `docs/05-setup-guide.md`
- **OpenClaw:** `docs/07-openclaw-integration.md`

---

## Examples (Short)

**Example 1 (Backend + Setup):**

START HERE
- `docs/05-setup-guide.md`
- `docs/04-coding-techniques.md`
- `docs/03-mcp-servers.md`

IF YOU ONLY READ ONE THING
- `docs/05-setup-guide.md`

NEXT ACTION
- Generate `CLAUDE.md` using `prompts/01-claude-md-generator.md`.

**Example 2 (Designer + Design Handoff):**

START HERE
- `docs/10-design-handoff.md`
- `agents/wp-page-builder.md`

IF YOU ONLY READ ONE THING
- `docs/10-design-handoff.md`

NEXT ACTION
- Prepare a Figma design system page and name layers consistently.
