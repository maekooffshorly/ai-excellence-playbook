# AI Excellence Playbook

> A practical reference for consistent AI tool selection and usage across engineering roles at Offshorly — developers (full-stack, backend, frontend), DevOps, QA, and designers.

This playbook is **not** about enforcing identical coding styles or replacing engineering judgment. It creates shared language, shared tool choices, and repeatable techniques that every team member can adapt and improve upon.

---

## What's New

**v0.1 — March 1, 2026 — Initial Release**

This is the first version of the AI Excellence Playbook. No changes to report yet — this is the baseline everything will be measured against going forward.

For full version history → [`CHANGELOG.md`](CHANGELOG.md)

---

## Why This Exists

Without a consistent approach to AI tooling, there's no opportunity for knowledge sharing, no compounding improvements when someone finds a better workflow, and no predictable quality baseline across teams. This playbook addresses that by:

- Increasing individual developer productivity without sacrificing quality
- Improving output consistency across teams and roles
- Encouraging proper AI usage patterns
- Supporting a product-owner mindset — build fast, fail fast, iterate quickly
- Evolving continuously as AI tools and capabilities change

---

## Repository Structure

```
ai-excellence-playbook/
├── README.md                                    # This file — overview and quick reference
├── CHANGELOG.md                                 # Version history of the playbook
│
├── docs/
│   ├── 01-model-comparison.md                   # Extended AI model notes and decision guidance
│   ├── 02-tools-comparison.md                   # Extended tool notes and decision guidance
│   ├── 03-mcp-servers.md                        # MCP server ecosystem and integration
│   ├── 04-coding-techniques.md                  # Tier-based workflows, prompting patterns, agent usage
│   └── 05-setup-guide.md                        # Step-by-step toolset setup with screenshots
│
├── prompts/
│   └── 01-copilot-instructions-generator.md     # Prompt for generating copilot-instructions.md
│
└── agents/
    ├── test-writer.md                            # Test Writer agent instruction sheet
    ├── code-reviewer.md                          # Code Reviewer agent instruction sheet
    └── documentation.md                          # Documentation agent instruction sheet
```

---

## Quick Start

**New to the playbook?** Follow these steps to get set up:

1. **Install the toolset** → [`docs/05-setup-guide.md`](docs/05-setup-guide.md)
2. **Generate your project's `copilot-instructions.md`** → [`prompts/01-copilot-instructions-generator.md`](prompts/01-copilot-instructions-generator.md)
3. **Install the three agents** (Test Writer, Code Reviewer, Documentation) → [`agents/`](agents/)
4. **Reference the tier guide** when deciding how to prompt for a task → [`docs/04-coding-techniques.md`](docs/04-coding-techniques.md)

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
| Coding Companion | GitHub Copilot (autocompletion + chat + agents) |
| Primary LLM | Claude Opus 4.5 (T3) / Claude Sonnet 4.5 (T1–T2) |
| Code Quality MCP | SonarQube |
| Library Standards MCP | Context7 |
| Design MCP | Figma *(frontend only)* |

---

## AI Model Comparison

The table below covers the models currently recommended for SWE-related work. Use it to match model to task — not to default to whatever is "most capable."

> For extended guidance on model selection by scenario, see [`docs/01-model-comparison.md`](docs/01-model-comparison.md).

| Model | Description | Pros | Cons | Ideal Use Case | Tier | Cost (input / output per 1M tokens) |
|-------|-------------|------|------|----------------|------|--------------------------------------|
| **Claude Opus 4.5** | Top-tier Claude model built for complex reasoning and SWE work | Strong architecture/design thinking; excellent deep debugging and refactors; handles ambiguity well | Higher cost per token; slower on routine tasks; overkill for simple tickets | System design decisions; complex refactors/migrations; hard-to-reproduce bugs | T3 | $5 / $25 |
| **GPT 5.2** | OpenAI flagship in the GPT-5 family | Fast implementation output; strong tool/agent workflows; good breadth across tasks | Needs tight verification for risky changes; can be "too confident" without tests | MVP builds and iteration; multi-step coding tasks; mixed coding + docs + tests | T2–T3 | $1.75 / $14 |
| **Claude Sonnet 4.5** | Balanced Claude model — the daily driver for SWE | Best cost-to-performance balance; strong coding and reasoning; fast enough for daily work | Less peak performance than Opus; still needs tests/review gates | Most feature tickets; moderate refactors; PR-ready drafts and fixes | T1–T2 | $3 / $15 |
| **GPT 5.1** | GPT-5 family "everyday" option | Solid coding assistant; faster and cheaper than top tier; good for rapid iteration | Less reliable on hardest architecture tasks; requires validation like any LLM | Standard feature dev; debugging with quick turnaround; test scaffolding and cleanup | T1–T2 | $1.25 / $10 |
| **Gemini 3 Pro** | Google Gemini "Pro" tier — strong long-context and multimodal | Very large context window; strong multimodal reasoning; good for reading lots of docs/code | Model/plan details can shift; tooling ecosystem differs; currently extremely low usage cap (almost unusable) | Large-repo comprehension; long specs/multi-doc synthesis; multimodal debugging with screenshots/diagrams | T2–T3 | $2 / $12 |

**Note:** GPT 5.2 is stronger as a general-purpose base model, but Claude Opus 4.5 remains the better companion specifically for software development work. This will be monitored as the landscape changes.

**Internal observations on model selection:**
- Junior developers tend to see larger productivity gains from stronger models (Opus) on T3 tasks
- More experienced developers often see smaller marginal gains from Opus vs. Sonnet, where clarity of requirements and strong local context matters more than raw model output
- Model selection should be based on task complexity, expected risk, and local context — not defaulting to whatever is most capable

---

## AI Tools Comparison

The table below covers the tools in the current recommended stack and their alternatives. The General toolset (VS Code + Copilot) is the default for most teams.

> For extended setup notes and decision guidance per tool, see [`docs/02-tools-comparison.md`](docs/02-tools-comparison.md).

| Tool | Description | Pros | Cons | Ideal Use Case | Cost |
|------|-------------|------|------|----------------|------|
| **GitHub Copilot** | AI pair-programmer integrated into IDEs (autocomplete + chat + coding assistance) | Very low friction; great boilerplate and patterns; strong day-to-day speedup; custom agents | Can produce plausible wrong code; risk of over-acceptance without tests | Routine implementation; small refactors; quick scaffolding; agents | Individual: $10/mo or $100/yr. Business: $19/user/mo. Enterprise: $39/user/mo |
| **Cline** | Agentic coding tool (VS Code + CLI) with BYOK/credits; open-source, pay only for inference | Strong multi-step agent workflows; more control over model/provider; good transparency on work done | Inference costs can spike; needs permissions/guardrails discipline | Repo-wide changes; task plans → implement → run checks; teams wanting provider flexibility | Free (individuals); Teams free through 2025, then $20/mo/user + inference |
| **Claude Code** | Anthropic's agentic coding tool in your terminal — understands repo, handles git workflows | Excellent "do X across repo"; strong plan/execute loops; fits CLI-heavy workflows | Guardrails needed for commands | Large refactors/migrations; test + lint loops; release chores/automation | Included with Claude Pro ($17/mo annual / $20/mo monthly) |
| **Cursor** | AI-first code editor focused on agentic coding and chat-driven edits across files | Very strong "edit across files"; great for shipping features fast; good context handling in editor | Subscription cost; still needs strong review/testing gates | Mid-sized features; refactors across modules; PR drafts and follow-up iterations | Subscription — see [Cursor pricing](https://cursor.com/pricing) |
| **Windsurf** | AI-native IDE with "Cascade" agentic workflow — multi-step edits integrating editor/terminal context | Agent-forward UX; strong multi-step task execution; usage visible via credits | Credit limits/cost variability; plan details can change | Multi-step repo tasks; broad codebase edits | Free: $0 (25 credits/mo). Pro: $15/mo (500 credits). Teams: $30/user/mo |

---

## The Three Agents

Once coding is complete, these three agents form the quality and documentation pipeline before a PR is raised. Install them via Copilot's **Configure Custom Agents** menu — full instruction sheets and setup steps are in [`agents/`](agents/).

```
Code Complete → Test Writer → Documentation → Code Reviewer → PR
                    ↑               ↑               |
                    └───────────────┴───────────────┘
                              (handoffs between agents)
```

| Agent | Recommended Model | When to Use | Full Instructions |
|-------|------------------|-------------|------------------|
| **Test Writer** | Claude Sonnet 4.5 | Before PR; when adding behavior to critical modules (auth, billing, payments, permissions, data pipeline, infra); PoC → MVP transitions | [`agents/test-writer.md`](agents/test-writer.md) |
| **Code Reviewer** | Claude Sonnet 4.5 | Pre-PR structured review — correctness, edge cases, security risks, pattern consistency, test coverage gaps | [`agents/code-reviewer.md`](agents/code-reviewer.md) |
| **Documentation** | Claude Sonnet 4.5 | After every coding session (pre-PR) for endpoints/configs/models; or end-of-day to preserve context mid-feature | [`agents/documentation.md`](agents/documentation.md) |

---

## MCP Servers

MCPs (Model Context Protocol) are APIs wrapped as extensions that LLMs can access to pull context from external systems and run tools — enabling workflows that go beyond the provided codebase text alone.

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

The playbook defines two tracks — **General** (optimized for speed and new builds) and **Conservative** (optimized for predictability on mature codebases) — but both share the same core principles:

- Match tools and models to task complexity
- Prefer small, reversible changes
- Always validate outputs through tests, linters, and review gates

The full section covers tier-based prompting patterns, the PLAN workflow, agent prompting templates with real examples, and optional language-specific Copilot instruction extensions.

> → [`docs/04-coding-techniques.md`](docs/04-coding-techniques.md)

---

## Contributing

This playbook is a living document. When you discover a better workflow, prompt pattern, or agent configuration:

1. Open a PR with your proposed change
2. Update `CHANGELOG.md` with what changed and why
3. If it's a prompt or agent change, update the relevant file in `prompts/` or `agents/`

---

*Version: v0.1 — Initial playbook outline*
