# Changelog

All notable changes to the AI Excellence Playbook will be documented here.

Format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versions follow `v{major}.{minor}` - increment minor for content updates and additions, major for structural overhauls or significant direction changes.

---

## [Unreleased]

> Changes staged here move to a versioned release once reviewed and merged.

### Added
-

### Changed
-

### Removed
-

### Fixed
-

---

## [v1.4] — 2026-03-12

### Added
- `docs/12-pr-review.md` — AI-assisted PR code review guide covering limitations of GitHub's built-in review flow and how to leverage AI agents with full codebase context for faster, more thorough reviews

---

## [v1.3] — 2026-03-11

### Added
- `docs/11-token-saver.md` — token budgeting guide covering prompt techniques, file/document practices, git-scoped fetching, a quick-reference checklist, and a token cost mental model table

---

## [v1.2] — 2026-03-09

### Changed
- `docs/07-openclaw-integration.md` — removed Gmail API from enabled APIs list; replaced credential-via-chat provisioning steps with admin-only provisioning; added prompt injection and data trust warnings for document-based Google APIs
- `prompts/03-embee-system-prompt.md` — added security section disallowing Gmail integration, prohibiting credential receipt via chat, and enforcing untrusted-data treatment for Google document content

### Removed
- Credential-delivery-via-bot pattern from `docs/07-openclaw-integration.md` (replaced with admin-side provisioning)

---

## [v1.1] — 2026-03-02

### Added
- `docs/10-design-handoff.md` — design → dev → AI handoff standards for Figma prep, assets, and prompting
- `prompts/04-design-system-generator.md` — prompt for generating design-system.md from Figma design system pages
- `internal/tldr-agent.md` — TLDR navigation script for role-based doc routing
- `agents/checkpoint-agent.md` — Checkpoint agent for creating workflow savepoints and preserving context across sessions
- `agents/verify-agent.md` — Verify agent for implementation verification checks (tests, lint, build, acceptance criteria)

### Changed
- Updated `docs/04-coding-techniques.md` — added Design → Dev → AI handoff reference
- Updated `agents/wp-module-builder.md` — added Figma handoff guidance and link
- Updated `agents/wp-page-builder.md` — added Figma handoff guidance and link
- Updated `README.md` — repository structure, coding techniques summary, TLDR section, and design handoff section
- Updated `docs/10-design-handoff.md` — added link to the design system prompt
- Updated quality pipeline in `docs/04-coding-techniques.md` and `README.md` — added Verify as final pre-PR gate
- Updated `README.md` Utility Agents table — added Checkpoint and Verify agents
- Updated `docs/09-experimental-techniques.md` — added cross-reference to standard quality pipeline
- `docs/05-setup-guide.md` — Updated Model Selection section: replaced broken `/model` CLI commands with correct step-by-step UI instructions for switching to Sonnet 4.6 (via `/model`) and Opus 4.5 (via `/config` IDE settings); added token burn caveat for Opus 4.5
- `docs/05-setup-guide.md` — Step 1 now includes CLI installation (`npm install -g @anthropic-ai/claude-code`) alongside the VS Code extension; added CLI failure recovery steps to Troubleshooting; added CLI version check to Verification Checklist; Step 2 rewritten to use `claude mcp add` CLI commands (replacing manual JSON editing); corrected Context7 package name to `@upstash/context7-mcp` and added remote HTTP install option; updated config file references from `~/.claude/settings.json` to `~/.claude.json`; updated MCP troubleshooting to use `claude mcp list` and `claude mcp get`

---

## [v1.0] — 2026-03-02

### Added
- Claude Opus 4.6 model profile in `docs/01-model-comparison.md` — with internal observation noting degraded real-world SWE performance compared to 4.5
- Claude Sonnet 4.6 model profile in `docs/01-model-comparison.md` — now the recommended model for most SWE work
- Gemini 3.1 Pro model profile in `docs/01-model-comparison.md` — Google's latest flagship with 80.6% SWE-bench Verified
- Google and Zoho credential setup guides in `docs/07-openclaw-integration.md` — step-by-step OAuth configuration
- "Connecting Credentials to Embee" section in `docs/07-openclaw-integration.md` — authorization workflow and troubleshooting
- Zoho-Related Operations section in `prompts/03-embee-system-prompt.md` — API documentation references for People, Mail, and Projects
- Authorization section in `prompts/03-embee-system-prompt.md` — auth scope URL for Zoho re-authorization flow
- `prompts/01-claude-md-generator.md` — prompt for generating CLAUDE.md files (replaces copilot-instructions-generator)
- `agents/security-reviewer-agent.md` — dedicated security review agent for OWASP Top 10, auth/authz gaps, and vulnerability scanning
- `agents/build-error-resolver-agent.md` — agent for diagnosing and fixing CI/CD failures, dependency conflicts, and build errors
- `agents/planner-agent.md` — planning agent for task breakdown, implementation sequencing, and T2/T3 scope definition
- `agents/architect-agent.md` — system architecture design agent for T3 tasks, component design, and technical decisions
- `agents/orchestrator-agent.md` — orchestration agent for coordinated multi-agent workflows with structured handoffs
- `agents/multi-plan-agent.md` — planning-only collaborative workflow agent for multi-model plan generation
- Additional Slash Commands section in `docs/04-coding-techniques.md` — `/plan`, `/build-fix`, `/tdd`, `/checkpoint`, `/verify` with installation instructions
- Experimental Orchestration Commands section in `docs/04-coding-techniques.md` — `/orchestrate` and `/multi-plan` usage and installation references
- Planning & Architecture Agents section in README — new agent category for pre-implementation planning
- Utility Agents section in README — new agent category for situational tools like Build Error Resolver
- Pipeline disclaimer note in README — clarifies that agent pipelines are suggested workflows, not mandatory sequences
- Model selection guidance in README, setup guide, and coding techniques — `/model claude-opus-4-5-20251101` command for switching to Opus 4.5 (recommended over default Opus 4.6 for T3 tasks)
- `docs/08-basic-techniques.md` — dedicated basic techniques doc for `@` context references, shortcuts, and lightweight command flow
- `docs/09-experimental-techniques.md` — dedicated experimental workflows doc for `/orchestrate` and `/multi-plan`

### Changed
- **MAJOR: Migrated from GitHub Copilot to Claude Code as primary coding companion** — reflects cost efficiency and better agentic capabilities
- Rewrote `docs/05-setup-guide.md` — Claude Code VS Code extension install, MCP config via `settings.json`, CLAUDE.md generation
- Renamed and restructured `docs/06-experimental-techniques.md` -> `docs/06-advanced-techniques.md` — now focused only on established advanced techniques (multi-repo, context seeding, three-phase refactors, plan mode)
- Split technique references into dedicated docs: `docs/08-basic-techniques.md` (basic usage) and `docs/09-experimental-techniques.md` (experimental workflows)
- Updated `docs/05-setup-guide.md` to keep setup-focused content and link out to basic usage techniques
- Updated `docs/02-tools-comparison.md` — Claude Code now primary, GitHub Copilot moved to alternative
- Updated `docs/03-mcp-servers.md` — MCP installation via Claude Code `settings.json` instead of VS Code extensions
- Updated `docs/04-coding-techniques.md` — Copilot references changed to Claude Code, instruction file references updated
- Updated all agent files to use Claude Code slash commands instead of Copilot custom agents
- Updated `README.md` — repository structure, quick start, technique doc references, and orchestration agent listings
- Updated Decision Guide table in `docs/01-model-comparison.md` to reflect Sonnet 4.6 as the new default recommendation
- Updated Embee system prompt with Zoho API documentation and authorization handling
- Added deprecation notice to Gemini 3 Pro — scheduled for deprecation March 9, 2026

### Removed
- `prompts/01-copilot-instructions-generator.md` — replaced by `prompts/01-claude-md-generator.md`

### Fixed
- Fixed broken code fences in `agents/wp-module-builder.md` and `agents/wp-page-builder.md` — changed outer fence from triple to quadruple backticks to support nested code blocks

---

## [v0.2]

### Added
- `docs/06-experimental-techniques.md` - multi-repo workspace context, security guardrails, `#` symbol references, slash commands, keyboard shortcuts, and advanced situational techniques
- `docs/07-openclaw-integration.md` - OpenClaw/Embee AI assistant integration guide with installation, usage guidelines, and troubleshooting
- `prompts/02-security-guardrail.md` - security guardrail prompt extension for credential safety in AI-generated code
- `prompts/03-embee-system-prompt.md` - system prompt reference for OpenClaw Embee configuration
- `agents/wp-module-builder.md` - WP Module Builder agent for creating ACF block modules in the Offshorly WP Boilerplate
- `agents/wp-page-builder.md` - WP Page Builder agent for assembling WordPress pages using existing modules
- WordPress CMS Agents section in README with pipeline diagram
- Experimental Techniques section in README
- OpenClaw Integration section in README

### Changed
- Updated repository structure in README to reflect new files
- Renamed "The Three Agents" section to "The Agents" with subsections for Standard Pipeline and WordPress CMS agents
- Updated agent file references in README (test-writer.md -> test-writer-agent.md, etc.)

---

## [v0.1]

### Added
- Initial playbook outline and structure
- `README.md` - overview, quick start, complexity tiers, recommended toolset, model and tools comparison tables, agent pipeline summary, MCP overview
- `docs/01-model-comparison.md` - extended model profiles and decision guidance for Claude Opus 4.5, Claude Sonnet 4.5, GPT 5.2, GPT 5.1, and Gemini 3 Pro
- `docs/02-tools-comparison.md` - extended tool profiles and decision guidance for GitHub Copilot, Cline, Claude Code, Cursor, and Windsurf
- `docs/03-mcp-servers.md` - active MCP documentation (SonarQube, Context7, Figma) and catalogue of MCPs available for team exploration
- `docs/04-coding-techniques.md` - two-track framework, tier-based prompting techniques, and agent usage guidance
- `docs/05-setup-guide.md` - step-by-step setup for Copilot, Claude API access, MCPs, agents, and `copilot-instructions.md` generation; includes verification checklist and troubleshooting
- `prompts/01-copilot-instructions-generator.md` - prompt for generating standardised `/.github/copilot-instructions.md` files
- `agents/test-writer.md` - Test Writer agent instruction sheet and usage guide
- `agents/code-reviewer.md` - Code Reviewer agent instruction sheet and usage guide
- `agents/documentation.md` - Documentation agent instruction sheet and usage guide

---




