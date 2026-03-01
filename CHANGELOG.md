# Changelog

All notable changes to the AI Excellence Playbook will be documented here.

Format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versions follow `v{major}.{minor}` — increment minor for content updates and additions, major for structural overhauls or significant direction changes.

---

## [Unreleased]

> Changes staged here move to a versioned release once reviewed and merged.

---

## [v0.2]

### Added
- `docs/06-experimental-techniques.md` — multi-repo workspace context, security guardrails, `#` symbol references, slash commands, keyboard shortcuts, and advanced situational techniques
- `docs/07-openclaw-integration.md` — OpenClaw/Embee AI assistant integration guide with installation, usage guidelines, and troubleshooting
- `prompts/02-security-guardrail.md` — security guardrail prompt extension for credential safety in AI-generated code
- `prompts/03-embee-system-prompt.md` — system prompt reference for OpenClaw Embee configuration
- `agents/wp-module-builder.md` — WP Module Builder agent for creating ACF block modules in the Offshorly WP Boilerplate
- `agents/wp-page-builder.md` — WP Page Builder agent for assembling WordPress pages using existing modules
- WordPress CMS Agents section in README with pipeline diagram
- Experimental Techniques section in README
- OpenClaw Integration section in README

### Changed
- Updated repository structure in README to reflect new files
- Renamed "The Three Agents" section to "The Agents" with subsections for Standard Pipeline and WordPress CMS agents
- Updated agent file references in README (test-writer.md → test-writer-agent.md, etc.)

---

## [v0.1]

### Added
- Initial playbook outline and structure
- `README.md` — overview, quick start, complexity tiers, recommended toolset, model and tools comparison tables, agent pipeline summary, MCP overview
- `docs/01-model-comparison.md` — extended model profiles and decision guidance for Claude Opus 4.5, Claude Sonnet 4.5, GPT 5.2, GPT 5.1, and Gemini 3 Pro
- `docs/02-tools-comparison.md` — extended tool profiles and decision guidance for GitHub Copilot, Cline, Claude Code, Cursor, and Windsurf
- `docs/03-mcp-servers.md` — active MCP documentation (SonarQube, Context7, Figma) and catalogue of MCPs available for team exploration
- `docs/04-coding-techniques.md` — two-track framework, tier-based prompting techniques, and agent usage guidance
- `docs/05-setup-guide.md` — step-by-step setup for Copilot, Claude API access, MCPs, agents, and `copilot-instructions.md` generation; includes verification checklist and troubleshooting
- `prompts/01-copilot-instructions-generator.md` — prompt for generating standardised `/.github/copilot-instructions.md` files
- `agents/test-writer.md` — Test Writer agent instruction sheet and usage guide
- `agents/code-reviewer.md` — Code Reviewer agent instruction sheet and usage guide
- `agents/documentation.md` — Documentation agent instruction sheet and usage guide

---

<!--
## [v0.2] — YYYY-MM-DD

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
