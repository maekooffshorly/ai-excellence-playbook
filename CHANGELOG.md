# Changelog

All notable changes to the AI Excellence Playbook will be documented here.

Format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versions follow `v{major}.{minor}` - increment minor for content updates and additions, major for structural overhauls or significant direction changes.

---

## [Unreleased]

> Changes staged here move to a versioned release once reviewed and merged.

### Added

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
- Updated `CLAUDE.md` repository structure to reflect new docs and agent files
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

<!--
## [v1.1] - YYYY-MM-DD

### Added
-

### Changed
-

### Deprecated
-

### Removed
-

### Fixed
-

-->


