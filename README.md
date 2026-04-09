# AI Excellence Playbook

![Version](https://img.shields.io/badge/version-v1.4-blue)

> A practical reference for consistent AI tool selection and usage across engineering roles at Offshorly - developers (full-stack, backend, frontend), DevOps, QA, and designers.

This playbook is **not** about enforcing identical coding styles or replacing engineering judgment. It creates shared language, shared tool choices, and repeatable techniques that every team member can adapt and improve upon.

---

## What's New

**v1.5 — Skills Layer**

Added 9 Claude Code skills: `code-review`, `test-writer`, `security-check`, `build-fix`, `docs`, `verify`, `checkpoint`, `context-seed`, and `refactor`. Skills are model-invoked — Claude auto-loads the right capability when intent matches, no command required. Each skill ships with a SKILL.md instruction file, a structured output template, and a user-facing manual under `skills/`.

For full version history → [CHANGELOG.md](CHANGELOG.md)

---

## TLDR (Start Here)

If you just cloned the repo and want the fastest path to relevant docs, use:

`/internal/tldr-agent.md`

It routes you to the most important sections based on role and task.

Quick use: open your AI chat UI and type `start internal/tldr-agent`.

---
## Why This Exists

Without a consistent approach to AI tooling, there's no opportunity for knowledge sharing, no compounding improvements when someone finds a better workflow, and no predictable quality baseline across teams. This playbook addresses that by:

- Increasing individual developer productivity without sacrificing quality
- Improving output consistency across teams and roles
- Encouraging proper AI usage patterns
- Supporting a product-owner mindset - build fast, fail fast, iterate quickly
- Evolving continuously as AI tools and capabilities change

---

## Repository Structure

```
ai-excellence-playbook/
|-- README.md                                    # This file - overview and quick reference
|-- CHANGELOG.md                                 # Version history of the playbook
|
|-- docs/
|   |-- 01-model-comparison.md                   # Extended AI model notes and decision guidance
|   |-- 02-tools-comparison.md                   # Extended tool notes and decision guidance
|   |-- 03-mcp-servers.md                        # MCP server ecosystem and integration
|   |-- 04-coding-techniques.md                  # Tier-based workflows, prompting patterns, agent usage
|   |-- 05-setup-guide.md                        # Step-by-step toolset setup with screenshots
|   |-- 06-advanced-techniques.md                # Multi-repo workspaces, context seeding, three-phase refactors
|   |-- 07-openclaw-integration.md               # OpenClaw/Embee AI assistant integration guide
|   |-- 08-basic-techniques.md                   # Day-to-day Claude Code usage: context references and shortcuts
|   |-- 09-experimental-techniques.md            # Experimental workflows under evaluation (orchestrate, multi-plan)
|   |-- 10-design-handoff.md                     # Design-to-dev-to-AI handoff standards for Figma workflows
|   |-- 11-token-saver.md                        # Token budgeting techniques for prompts, docs, and git workflows
|   |-- 13-hooks-and-automation.md               # Event-driven hook automation for quality gates and session management
|   `-- 14-skills.md                             # Skills primitive reference — what skills are, how they work, all 9 shipped skills
|
|-- hooks/
|   |-- README.md                                # Installation guide, per-hook details, troubleshooting
|   |-- settings-template.json                   # Copy-paste .claude/settings.json config for all hooks
|   `-- scripts/                                 # Hook shell scripts (copy to .claude/hooks/scripts/)
|
|-- internal/
|   `-- tldr-agent.md                            # TLDR navigation script for role-based doc routing
|
|-- prompts/
|   |-- 01-claude-md-generator.md                # Prompt for generating CLAUDE.md
|   |-- 02-security-guardrail.md                 # Security guardrail prompt extension
|   |-- 03-embee-system-prompt.md                # Embee system prompt for OpenClaw
|   `-- 04-design-system-generator.md            # Prompt for generating design-system.md
|
`-- agents/
    |-- test-writer-agent.md                     # Test Writer agent instruction sheet
    |-- code-reviewer-agent.md                   # Code Reviewer agent instruction sheet
    |-- documentation-agent.md                   # Documentation agent instruction sheet
    |-- security-reviewer-agent.md               # Security Reviewer agent instruction sheet
    |-- build-error-resolver-agent.md            # Build Error Resolver agent instruction sheet
    |-- planner-agent.md                         # Planner agent instruction sheet
    |-- architect-agent.md                       # Architect agent instruction sheet
    |-- orchestrator-agent.md                    # Orchestrator agent instruction sheet
    |-- multi-plan-agent.md                      # Multi-Plan agent instruction sheet
    |-- checkpoint-agent.md                      # Checkpoint agent for progress savepoints
    |-- verify-agent.md                          # Verify agent for implementation checks
    |-- wp-module-builder.md                     # WP Module Builder agent for ACF blocks
    `-- wp-page-builder.md                       # WP Page Builder agent for WordPress pages
```

---

## Quick Start

**New to the playbook?** Follow these steps to get set up:

1. **Install the toolset** → [`docs/05-setup-guide.md`](docs/05-setup-guide.md)
2. **Review basic Claude Code usage** → [`docs/08-basic-techniques.md`](docs/08-basic-techniques.md)
3. **Generate your project's `CLAUDE.md`** → [`prompts/01-claude-md-generator.md`](prompts/01-claude-md-generator.md)
4. **Configure the slash command agents** (Test Writer, Code Reviewer, Documentation) → [`agents/`](agents/)
5. **Reference the tier guide** when deciding how to prompt for a task → [`docs/04-coding-techniques.md`](docs/04-coding-techniques.md)

---

## Complexity Tiers

Tasks are grouped into three tiers that drive model selection, prompting style, and how much planning is required before implementation.

| Tier | Complexity | Examples |
|------|------------|---------|
| **T1** | Low | Documentation, unit tests, small functions, API wrappers |
| **T2** | Medium | CRUD operations, cloud integration, DB model schemas, multi-function references |
| **T3** | High | Full frameworks, deep cross-dependency work, architectural changes |

---

## Recommended Toolset

| Component | Choice |
|-----------|--------|
| IDE | VS Code |
| Coding Companion | Claude Code (VS Code extension + agentic workflows) |
| Primary LLM | Claude Sonnet 4.6 (T1-T3) / Claude Opus 4.5 (complex T3) |
| Code Quality MCP | SonarQube |
| Library Standards MCP | Context7 |
| Design MCP | Figma *(frontend only)* |
| Browser Automation MCP | Playwright *(QA/frontend only)* |

---

## AI Model Comparison

The table below covers the models currently recommended for SWE-related work. Use it to match model to task - not to default to whatever is "most capable."

> For extended guidance on model selection by scenario, see [`docs/01-model-comparison.md`](docs/01-model-comparison.md).

| Model | Description | Pros | Cons | Ideal Use Case | Tier | Cost (input / output per 1M tokens) |
|-------|-------------|------|------|----------------|------|--------------------------------------|
| **Claude Sonnet 4.6** ⭐ | **New default** near-Opus capability at Sonnet cost | 79.6% SWE-bench; strong multi-step execution; less overengineering than predecessors | Still needs validation gates; no 1M context window | Most SWE work across all tiers; agent pipeline; full codebase analysis | T1-T3 | $3 / $15 |
| **Claude Opus 4.5** | Top-tier Claude model for complex reasoning | Strong architecture/design thinking; excellent deep debugging; handles ambiguity well | Higher cost; slower on routine tasks; overkill for simple tickets | System design decisions; complex refactors/migrations; hard-to-reproduce bugs | T3 | $5 / $25 |
| **Claude Opus 4.6** | Latest Opus with 1M context and 128K output | Largest context window; extended output length | Prone to context drift; can hallucinate outside initial instructions | Tasks requiring 1M context window; experimental agentic workflows | T3 | $5 / $25 |
| **Claude Sonnet 4.5** | Previous daily driver for SWE | Good cost-to-performance balance; fast for daily work | Superseded by Sonnet 4.6 for most use cases | Legacy workflows; cost-sensitive T1-T2 work | T1-T2 | $3 / $15 |
| **GPT 5.2** | OpenAI flagship in the GPT-5 family | Fast implementation output; strong tool/agent workflows | Needs tight verification; can be "too confident" without tests | MVP builds and iteration; multi-step coding tasks | T2-T3 | $1.75 / $14 |
| **GPT 5.1** | GPT-5 family "everyday" option | Solid coding assistant; faster and cheaper than top tier | Less reliable on hardest architecture tasks | Standard feature dev; debugging with quick turnaround | T1-T2 | $1.25 / $10 |
| **Gemini 3.1 Pro** | Google's latest flagship - strong agentic performance | 80.6% SWE-bench; 1M context window; improved reasoning | Usage caps still apply; Claude models more reliable for production | Large-repo comprehension; agentic workflows; multimodal debugging | T2-T3 | $2.50 / $15 |
| **Gemini 3 Pro** ⚠️ | Previous Google Pro tier - deprecated March 9, 2026 | Large context window; strong multimodal reasoning | Extremely low usage cap; deprecated soon | Migrate to 3.1 Pro | T2-T3 | $2 / $12 |

**Note:** Claude Sonnet 4.6 is now the recommended default for most SWE work. GPT 5.2 remains strong for general-purpose tasks, but Claude models continue to excel at the structured, context-heavy reasoning SWE work demands. Opus 4.5 is preferred over 4.6 when you need reliable, focused execution.

> **Model Selection in Claude Code:** Claude Code defaults to Opus 4.6, but we recommend Opus 4.5 for complex T3 tasks due to better focus and less context drift. To switch models, use the `/model` command:
> ```
> /model claude-opus-4-5-20251101    # Use Opus 4.5 (recommended for T3)
> /model claude-sonnet-4-6-20260101  # Use Sonnet 4.6 (default for T1-T3)
> ```

**Internal observations on model selection:**
- Junior developers tend to see larger productivity gains from stronger models (Opus) on T3 tasks
- More experienced developers often see smaller marginal gains from Opus vs. Sonnet, where clarity of requirements and strong local context matters more than raw model output
- Model selection should be based on task complexity, expected risk, and local context - not defaulting to whatever is most capable

---

## AI Tools Comparison

The table below covers the tools in the current recommended stack and their alternatives. The General toolset (VS Code + Claude Code) is the default for most teams.

> For extended setup notes and decision guidance per tool, see [`docs/02-tools-comparison.md`](docs/02-tools-comparison.md).

| Tool | Description | Pros | Cons | Ideal Use Case | Cost |
|------|-------------|------|------|----------------|------|
| **Claude Code** ⭐ | Anthropic's agentic coding tool - VS Code extension + CLI with full repo understanding | Excellent "do X across repo"; strong plan/execute loops; native MCP support; slash command agents | Guardrails needed for commands | Most SWE work; large refactors/migrations; test + lint loops; release automation | Team Plan: $30/user/mo (recommended) |
| **GitHub Copilot** | AI pair-programmer integrated into IDEs (autocomplete + chat + coding assistance) | Very low friction; great boilerplate and patterns; strong day-to-day speedup; custom agents | Can produce plausible wrong code; risk of over-acceptance without tests | Routine implementation; small refactors; quick scaffolding | Individual: $10/mo or $100/yr. Business: $19/user/mo. Enterprise: $39/user/mo |
| **Cline** | Agentic coding tool (VS Code + CLI) with BYOK/credits; open-source, pay only for inference | Strong multi-step agent workflows; more control over model/provider; good transparency on work done | Inference costs can spike; needs permissions/guardrails discipline | Repo-wide changes; task plans → implement → run checks; teams wanting provider flexibility | Free (individuals); Teams free through 2025, then $20/mo/user + inference |
| **Cursor** | AI-first code editor focused on agentic coding and chat-driven edits across files | Very strong "edit across files"; great for shipping features fast; good context handling in editor | Subscription cost; still needs strong review/testing gates | Mid-sized features; refactors across modules; PR drafts and follow-up iterations | Subscription - see [Cursor pricing](https://cursor.com/pricing) |
| **Windsurf** | AI-native IDE with "Cascade" agentic workflow - multi-step edits integrating editor/terminal context | Agent-forward UX; strong multi-step task execution; usage visible via credits | Credit limits/cost variability; plan details can change | Multi-step repo tasks; broad codebase edits | Free: $0 (25 credits/mo). Pro: $15/mo (500 credits). Teams: $30/user/mo |

---

## The Agents

Agents are implemented as Claude Code slash commands - full instruction sheets and setup steps are in [`agents/`](agents/).

> **Note:** The pipelines shown below are *suggested workflows*, not mandatory sequences. Actual agentic workflow depends on user preference, task complexity, and project phase. For simple T1 tasks, running the full pipeline may be overkill. For complex T3 features, you may need multiple planning passes or additional security review. Adapt the pipeline to fit the task.

### Planning & Architecture Agents

For T2/T3 tasks, start with planning before implementation.

```
Requirements → Planner → [Approval] → Implementation
                 ↓
         (Complex T3?) → Architect → Planner → Implementation
```

| Agent | Recommended Model | When to Use | Full Instructions |
|-------|------------------|-------------|------------------|
| **Planner** | Claude Sonnet 4.6 | T2/T3 tasks; multi-day features; unclear scope; sprint planning | [`agents/planner-agent.md`](agents/planner-agent.md) |
| **Architect** | Claude Opus 4.5 | T3 architectural decisions; new services; major refactors; system design | [`agents/architect-agent.md`](agents/architect-agent.md) |

### Quality Pipeline Agents

Once coding is complete, these agents form the quality and documentation pipeline before a PR is raised.

```
Code Complete → Test Writer → Documentation → Code Reviewer → Verify → PR
                    ↑               ↑               |            |
                    └───────────────┴───────────────┴────────────┘
                              (handoffs between agents)
```

| Agent | Recommended Model | When to Use | Full Instructions |
|-------|------------------|-------------|------------------|
| **Test Writer** | Claude Sonnet 4.6 | Before PR; when adding behavior to critical modules (auth, billing, payments, permissions, data pipeline, infra); PoC → MVP transitions | [`agents/test-writer-agent.md`](agents/test-writer-agent.md) |
| **Documentation** | Claude Sonnet 4.6 | After every coding session (pre-PR) for endpoints/configs/models; or end-of-day to preserve context mid-feature | [`agents/documentation-agent.md`](agents/documentation-agent.md) |
| **Code Reviewer** | Claude Sonnet 4.6 | Pre-PR structured review - correctness, edge cases, security risks, pattern consistency, test coverage gaps | [`agents/code-reviewer-agent.md`](agents/code-reviewer-agent.md) |
| **Security Reviewer** | Claude Sonnet 4.6 | Pre-merge security gate for auth, payments, data handling; compliance-sensitive projects | [`agents/security-reviewer-agent.md`](agents/security-reviewer-agent.md) |

### Utility Agents

These agents handle specific situations as they arise during development.

| Agent | Recommended Model | When to Use | Full Instructions |
|-------|------------------|-------------|------------------|
| **Build Error Resolver** | Claude Sonnet 4.6 | CI/CD failures; dependency conflicts; compilation errors; Docker build issues | [`agents/build-error-resolver-agent.md`](agents/build-error-resolver-agent.md) |
| **Checkpoint** | Claude Sonnet 4.6 | Mid-work context preservation; end-of-day savepoints; handoff documentation between sessions | [`agents/checkpoint-agent.md`](agents/checkpoint-agent.md) |
| **Verify** | Claude Sonnet 4.6 | Final pre-PR gate; validates tests pass, lint clean, build succeeds, acceptance criteria met | [`agents/verify-agent.md`](agents/verify-agent.md) |

### Experimental Orchestration Agents

These agents are under evaluation and should be piloted first on complex workflows.

| Agent | Recommended Model | When to Use | Full Instructions |
|-------|------------------|-------------|------------------|
| **Orchestrator** | Claude Sonnet 4.6 / Claude Opus 4.5 | Coordinate multi-agent workflows with structured handoffs across planning, implementation quality, and security checks | [`agents/orchestrator-agent.md`](agents/orchestrator-agent.md) |
| **Multi-Plan** | Claude Sonnet 4.6 / Claude Opus 4.5 | Generate planning-only implementation plans using collaborative analysis before execution | [`agents/multi-plan-agent.md`](agents/multi-plan-agent.md) |

### WordPress CMS Agents

For teams using the Offshorly WP Boilerplate, these agents handle ACF block modules and page assembly.

```
Page Requirements → WP Page Builder → (Missing modules?) → WP Module Builder
                          ↓                                       ↓
                   Configure content ←─────────────────────────────┘
                          ↓
                   Standard Pipeline → PR
```

| Agent | Recommended Model | When to Use | Full Instructions |
|-------|------------------|-------------|------------------|
| **WP Module Builder** | Claude Sonnet 4.6 | Creating new ACF block modules - hero sections, card grids, CTAs, banners; converting Figma designs to reusable blocks | [`agents/wp-module-builder.md`](agents/wp-module-builder.md) |
| **WP Page Builder** | Claude Sonnet 4.6 | Assembling full WordPress pages using existing modules; planning page structure; configuring module instances with content | [`agents/wp-page-builder.md`](agents/wp-page-builder.md) |

---

## MCP Servers

MCPs (Model Context Protocol) are APIs wrapped as extensions that LLMs can access to pull context from external systems and run tools - enabling workflows that go beyond the provided codebase text alone.

> For full setup instructions and per-server notes, see [`docs/03-mcp-servers.md`](docs/03-mcp-servers.md).

**Currently active:**

| MCP | Purpose | Best Fit |
|-----|---------|---------|
| **SonarQube** | Code quality checks and security scanning | Enforcing quality gates; identifying vulnerabilities and code smells before merges |
| **Context7** | Keeps suggestions aligned with up-to-date libraries and coding standards | Implementation work with heavy library usage; reducing outdated/unsupported patterns |
| **Figma** | Bridges design-to-code workflows | Frontend devs working directly from Figma designs |

**Available for team exploration:** Azure, AWS, Vercel, Netlify, Render, Cloudflare, MongoDB, Supabase, Firebase, Stripe, PayPal, Jira (Atlassian Remote MCP)

---

## Coding Techniques Summary

The playbook defines two tracks - **General** (optimized for speed and new builds) and **Conservative** (optimized for predictability on mature codebases) - but both share the same core principles:

- Match tools and models to task complexity
- Prefer small, reversible changes
- Always validate outputs through tests, linters, and review gates

The full section covers tier-based prompting patterns, the PLAN workflow, agent prompting templates with real examples, and optional language-specific CLAUDE.md extensions.

> → [`docs/04-coding-techniques.md`](docs/04-coding-techniques.md)

### Basic Techniques

For daily usage patterns and quick references:

- **`@` context references** - files, folders, codebase, web, and terminal context
- **Keyboard shortcuts** - panel and code action shortcuts
- **Lightweight command flow** - `/plan`, `/test`, `/review`, `/doc`

> -> [`docs/08-basic-techniques.md`](docs/08-basic-techniques.md)

### Advanced Techniques

For power users and complex development scenarios:

- **Multi-repo workspace context** - working across multiple repositories simultaneously
- **Context seeding** - establishing patterns before complex work
- **Three-phase refactors** - safe refactoring with rollback points
- **Plan mode for T3** - explicit planning before implementation

> -> [`docs/06-advanced-techniques.md`](docs/06-advanced-techniques.md)

### Experimental Techniques

For workflows under evaluation before standard adoption:

- **Multi-agent orchestration** - coordinated workflows across specialized agents
- **Multi-model collaborative planning** - planning-only workflows with session handoffs

> -> [`docs/09-experimental-techniques.md`](docs/09-experimental-techniques.md)

### Design Handoff

For cross-discipline workflows (Design → Dev → AI), Figma prep, assets, and prompting rules:

- **Design system source of truth** - branding page, tokens, and naming rules
- **AI-friendly design rules** - simplify nesting and vector complexity
- **Prompting and assets** - strict SVG rules and boilerplate-first strategy

> -> [`docs/10-design-handoff.md`](docs/10-design-handoff.md)

---

## OpenClaw Integration

OpenClaw is Offshorly's internal AI assistant deployment running on Telegram. It uses a custom-configured Claude model (Embee) with mandatory confirmation protocols for safe action execution.

> → [`docs/07-openclaw-integration.md`](docs/07-openclaw-integration.md)

---

## Contributing

This playbook is a living document. When you discover a better workflow, prompt pattern, or agent configuration:

1. Open a PR with your proposed change
2. Update `CHANGELOG.md` with what changed and why
3. If it's a prompt or agent change, update the relevant file in `prompts/` or `agents/`

---

*Version: v1.3 — Design handoff standard*






