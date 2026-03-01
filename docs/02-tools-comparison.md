# AI Tools Comparison

This document extends the tools comparison table in the README with deeper guidance on tool selection — when to use each tool, how they fit together, and trade-offs worth understanding before switching away from the default stack.

For the quick-reference table, see the [README](../README.md#ai-tools-comparison).

---

## The Default Stack

The recommended starting point for all teams is:

- **IDE:** VS Code
- **Coding Companion:** Claude Code (VS Code extension + agentic workflows)

This combination is the default because it provides the best balance of agentic capability and cost efficiency for SWE work, has native MCP support for quality checks and library standards, and supports the full slash command agent pipeline defined in this playbook. Deviation from this stack should be deliberate and team-aligned, not ad-hoc.

---

## Tool Profiles

### Claude Code

**Role:** Primary coding companion (VS Code extension + agentic workflows)
**Cost:** Team Plan $30/user/mo (recommended)

The backbone of the recommended workflow. Claude Code provides deep repo understanding, multi-file editing, and native MCP support — all integrated into VS Code. Slash command agents (Test Writer, Code Reviewer, Documentation) run directly in the Claude Code panel.

**Strengths:**
- Excellent for "do X across repo" tasks — refactors, migrations, multi-file changes
- Strong plan/execute loops with repo-level context
- Native MCP support for SonarQube, Context7, and other quality tools
- Slash command agents for structured workflows
- Built-in Claude Sonnet 4.6 and Opus 4.5 — no separate API key needed with Team Plan

**Limitations:**
- Guardrails are essential — Claude Code can run terminal commands, so unchecked use on production-adjacent environments carries real risk
- Quality of agentic output depends heavily on the quality of `CLAUDE.md` and your prompts

**Best practices:**
- Always generate and maintain `/CLAUDE.md` before starting work on any project
- Use inline comments (`TODO:`, `NOTE:`, `Example:`) to guide suggestions for T1 tasks
- Use PLAN mode before implementing for anything T2 and above
- Configure MCPs in `~/.claude/settings.json` for quality checks and library standards

---

### GitHub Copilot

**Role:** Alternative coding companion (autocompletion + chat)
**Cost:** Individual $10/mo or $100/yr · Business $19/user/mo · Enterprise $39/user/mo

A solid alternative for teams that prefer traditional autocompletion-first workflows. Copilot operates at two levels: inline autocompletion as the default productivity multiplier for T1 work, and chat with agentic capability for T2–T3 planning.

**Strengths:**
- Very low friction — autocompletion is always on, no prompting required for routine work
- Excellent for boilerplate, patterns, and repetitive implementation
- Chat with full codebase context for planning and structured changes
- Model-selectable — can be pointed at Claude Sonnet/Opus or GPT models via API key

**Limitations:**
- Can produce plausible but incorrect code — never accept suggestions without understanding them
- Risk of over-acceptance without validation gates in place
- MCP support less mature than Claude Code

**When to use:**
- Teams already invested in GitHub Copilot workflows
- Developers who prefer autocompletion-first interaction over agentic chat

---

### Cline

**Role:** Agentic coding tool (VS Code + CLI), BYOK model inference
**Cost:** Free for individuals · Teams free through 2025, then $20/mo/user + inference costs

An open-source agentic tool that runs multi-step tasks via VS Code and the command line. Unlike Copilot, Cline lets you bring your own API key and choose your model provider — giving more control over cost and model selection at the expense of more setup and guardrails work.

**Strengths:**
- Strong multi-step agent workflows with good transparency on what was done and why
- Provider flexibility — not locked to a single model vendor
- Well-suited for repo-wide changes that span many files

**Limitations:**
- Inference costs can spike unexpectedly on large tasks — monitor usage
- Requires deliberate permissions and guardrails setup before running on production codebases
- Higher setup overhead than Copilot

**When to reach for it:**
- Your team wants model provider flexibility and is comfortable managing inference costs
- The task involves a large, planned repo-wide change that benefits from Cline's transparency on steps taken
- You're already operating a CLI-heavy workflow

---

### Cursor

**Role:** AI-first code editor, agentic editing across files
**Cost:** Subscription-based — see [Cursor pricing](https://cursor.com/pricing)

A purpose-built AI code editor rather than an extension. Cursor's primary advantage is its "edit across files" capability — it handles multi-file changes more naturally than chat-based tools and is particularly strong for shipping features quickly in a mid-sized codebase.

**Strengths:**
- Very strong multi-file editing — follows a change's impact across the codebase naturally
- Great for shipping features fast with a tight iteration loop
- Good context handling within the editor

**Limitations:**
- Subscription cost on top of any existing tooling
- Still requires strong review and testing gates — fast output isn't always correct output
- Switching to Cursor means moving away from VS Code, which has team knowledge-sharing implications

**When to reach for it:**
- Your team is building mid-sized features where changes span many files and the edit-across-files capability adds genuine speed
- You're doing refactors across multiple modules and want the editor to track the impact automatically
- The team has aligned on Cursor as a shared tool — ad-hoc individual adoption reduces knowledge sharing benefits

---

### Windsurf

**Role:** AI-native IDE with "Cascade" agentic workflow
**Cost:** Free ($0, 25 credits/mo) · Pro $15/mo (500 credits) · Teams $30/user/mo

An AI-native IDE built around "Cascade" — a multi-step agentic workflow that integrates context from the editor and terminal together. Similar positioning to Cursor but with a credit-based usage model that makes costs more visible.

**Strengths:**
- Agent-forward UX — multi-step task execution is a first-class experience
- Strong multi-step task execution integrating editor and terminal context
- Credit-based model makes usage costs more transparent than flat subscriptions

**Limitations:**
- Credit limits can be a constraint on heavier workloads
- Plan and pricing details have changed before — verify current terms before adopting team-wide
- Like Cursor, switching to Windsurf has team knowledge-sharing implications

**When to reach for it:**
- Multi-step repo tasks where having editor and terminal context integrated in one place adds real value
- Broad codebase edits where the Cascade agentic workflow fits the task shape
- Your team wants visible usage costs rather than a flat subscription

---

## Tool Selection Guide

| Situation | Recommended Tool | Notes |
|-----------|-----------------|-------|
| Default daily development | Claude Code | Best balance of capability and cost for SWE work |
| Agent pipeline (Test Writer, Code Reviewer, Docs) | Claude Code | Slash command agents built for Claude Code |
| Autocompletion-first workflow | GitHub Copilot | Alternative for teams invested in Copilot |
| Repo-wide changes, provider flexibility needed | Cline | Set up guardrails first |
| Multi-file feature work, fast iteration | Cursor | Align as a team before adopting |
| Multi-step tasks with integrated editor + terminal context | Windsurf | Verify credit limits for your workload |

---

## Switching Away from the Default Stack

The General toolset (VS Code + Claude Code) is the default for good reason — shared tooling creates compounding benefits through knowledge sharing, consistent onboarding, and predictable workflows. Switching tools individually creates fragmentation.

If you're considering adopting Cursor, Windsurf, Cline, or GitHub Copilot:

1. **Validate the need** — identify a specific gap in the current stack that the new tool addresses
2. **Align with your team** — individual adoption reduces the knowledge-sharing benefit
3. **Document the decision** — add a note to `CHANGELOG.md` so the change is visible
4. **Update this playbook** — if the new tool becomes a team standard, it should be reflected here

The goal is not uniformity for its own sake. It's that when someone discovers a better workflow, everyone benefits — and that only happens if the discovery is shared.
