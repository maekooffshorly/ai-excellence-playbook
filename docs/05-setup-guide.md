# AI Toolset Setup Guide

This guide walks through setting up the full General toolset from scratch — Claude Code, MCPs, and the slash command agents. Follow the steps in order on a new machine or when onboarding onto a new project.

**Estimated setup time:** 15–20 minutes

---

## Prerequisites

- VS Code installed
- Access to Claude Code Team Plan (provided by admin)

---

## Step 1: Install Claude Code

### 1a. Install the CLI

Run the following command in your terminal:

```
npm install -g @anthropic-ai/claude-code
```

Confirm it worked:

```
claude --version
```

### 1b. Install the VS Code Extension

1. Open VS Code and go to the **Extensions** tab (`Ctrl+Shift+X` / `Cmd+Shift+X`)
2. Search for `Claude Code` and install the official Anthropic extension
3. After installation, you'll see the Claude Code icon in the VS Code sidebar
4. Click the icon to open the Claude Code panel
5. Sign in with your Anthropic account credentials (Team Plan)

> Claude Code includes built-in access to Claude Sonnet 4.6 and Claude Opus 4.5 — no separate API key configuration needed with the Team Plan.

### Model Selection

**Recommended model: Sonnet 4.6** — suitable for T1–T3 tasks, cost-efficient, and the default for most daily work.

**Opus 4.5** is recommended for complex T3 tasks due to better reasoning, but burns token limits ~40% faster than Sonnet. Use it intentionally.

#### Switching to Sonnet 4.6

1. In the chat UI, type `/model` and click **Switch model**
2. Select **Sonnet 4.6** — done

#### Switching to Opus 4.5

Opus 4.5 is not available via the `/model` command in the chat UI. Use the IDE config instead:

1. In the chat UI, type `/config` and select **General config...**
2. This opens the IDE settings for Claude Code — scroll down to find **Claude Code: Selected Model**
3. Set the value from `default` to `claude-opus-4-5-20251101`
4. Save and restart the IDE to apply

> The IDE config sets Opus 4.5 as the default for every session. Remember to switch back to Sonnet 4.6 after finishing T3 work to avoid unnecessary token burn.

---

## Step 2: Configure MCPs

MCPs in Claude Code are added via the `claude mcp add` CLI command. This writes configuration to `~/.claude.json` (user scope) or `.mcp.json` in your project root (project scope).

| Scope | Where it's stored | Who it applies to |
|-------|------------------|-------------------|
| `--scope user` | `~/.claude.json` | You, across all projects |
| `--scope project` | `.mcp.json` in project root | Everyone on the project (commit this file) |
| *(default / local)* | `~/.claude.json` under project path | You, in the current project only |

### SonarQube MCP

1. Get your SonarQube instance URL and token from admin or use the free tier
2. Run:

```
claude mcp add --scope user --transport stdio \
  --env SONARQUBE_URL=https://your-sonarqube-instance.com \
  --env SONARQUBE_TOKEN=your-token-here \
  sonarqube -- npx -y @anthropic/mcp-server-sonarqube
```

### Context7 MCP

1. Go to [https://context7.com/dashboard](https://context7.com/dashboard)
2. Sign up and generate an API key
3. Run either of the following:

**Remote (recommended):**

```
claude mcp add --scope user --transport http \
  --header "CONTEXT7_API_KEY: your-api-key-here" \
  context7 https://mcp.context7.com/mcp
```

**Local (stdio fallback):**

```
claude mcp add --scope user \
  context7 -- npx -y @upstash/context7-mcp --api-key your-api-key-here
```

### Figma MCP *(frontend developers only)*

> **Note:** Dev Mode must be available on your current Figma plan to enable Figma's MCP Server.

1. Open a Figma design file
2. Enter Dev Mode
3. Find **MCP** in the right sidebar and click `Enable desktop MCP server`
4. Copy the URL displayed alongside the confirmation message that the MCP server has been enabled (it should be a localhost URL)
5. In your terminal, run `claude mcp add --transport http figma <localhost-url>`, or add the following to your `.claude/settings.json`:

```json
{
    "mcpServers": {
        "figma": {
        "type": "http",
        "url": "http://127.0.0.1:3845/mcp"
        }
    }
}
```

## Step 3: Configure Slash Command Agents

Claude Code uses slash commands for agent-like workflows. The playbook agents (Test Writer, Code Reviewer, Documentation) are invoked via slash commands with specific prompting patterns.

### Option A: Use Built-in Slash Commands

Claude Code includes built-in slash commands that align with the playbook agents:

| Slash Command | Equivalent Agent | Purpose |
|---------------|-----------------|---------|
| `/test` | Test Writer | Generate tests for specified code |
| `/review` | Code Reviewer | Review code for issues and improvements |
| `/doc` | Documentation | Generate or update documentation |

### Option B: Create Custom Slash Commands

For more control, create custom slash commands in your project's `.claude/commands/` directory:

```bash
# In your project root
mkdir -p .claude/commands
```

Create a file for each agent (e.g., `.claude/commands/test-writer.md`):

```markdown
---
name: test-writer
description: Generate comprehensive tests for specified code
---

Test Writer mode. Write tests for the specified files.
Reference the provided acceptance criteria if available.
Add coverage for happy paths, edge cases, and error scenarios.
Use existing test patterns from the codebase.
```

Once created, invoke with `/test-writer` in Claude Code.

> For full agent instruction sheets, see [`agents/`](../agents/).

---

## Step 4: Generate `CLAUDE.md`

This step is per-project and should be done before starting any development work on a new codebase.

1. Open your project in VS Code with Claude Code
2. Open the Claude Code panel
3. Copy the full prompt from [`prompts/01-claude-md-generator.md`](../prompts/01-claude-md-generator.md)
4. Paste it into Claude Code and run it
5. Review the generated `<project-context>` section when Claude asks for confirmation
6. Approve or request corrections

The file will be created at `/CLAUDE.md` in your project root. Commit it to the repo so the whole team benefits from it.

> **Note:** Claude Code automatically reads `CLAUDE.md` files from your project root or `.claude/` directory for project context.

---

## Verification Checklist

Once setup is complete, confirm the following:

| Item | How to verify |
|------|--------------|
| Claude Code CLI installed | `claude --version` returns a version number |
| Claude Code installed | Claude Code icon visible in VS Code sidebar |
| Signed in to Team Plan | Account shown in Claude Code panel, no usage warnings |
| SonarQube MCP active | Run a prompt that references SonarQube — no connection errors |
| Context7 MCP active | Run a prompt that references Context7 — no connection errors |
| Figma MCP active *(frontend only)* | Figma appears in available MCP tools |
| Slash commands working | Type `/` in Claude Code to see available commands |
| `CLAUDE.md` exists | `/CLAUDE.md` present in the project root |

---

## Next Step: Basic Usage Techniques

After setup is complete, review [`docs/08-basic-techniques.md`](08-basic-techniques.md) for day-to-day usage patterns:

- `@` context references (`@file`, `@folder`, `@codebase`, `@web`, `@terminal`)
- Keyboard shortcuts for panel and code actions
- Basic context management tips for faster sessions

---
## Troubleshooting

**CLI installation fails**

Run the following to clear any conflicting files and retry:

```
sudo rm -rf /opt/homebrew/lib/node_modules/@anthropic-ai/claude-code
npm cache clean --force
npm install -g @anthropic-ai/claude-code
claude --version
```

**Claude Code not signing in**

- Confirm your Anthropic account has Team Plan access
- Try signing out and back in
- Check your network connection — corporate firewalls may block Anthropic domains

**MCP not responding**

- Run `claude mcp list` to confirm the server is registered
- Check that required environment variables (tokens, URLs) are correct — run `claude mcp get <server-name>` to inspect the config
- Verify the MCP server package is accessible (requires npm/npx)
- Check Claude Code's output panel for error messages
- Run `/mcp` inside Claude Code to see server status and re-authenticate if needed

**Slash commands not appearing**

- Custom commands must be in `.claude/commands/` directory
- File must have `.md` extension and proper frontmatter
- Restart Claude Code after adding new commands

**`CLAUDE.md` not being picked up**

- Confirm the file is at `/CLAUDE.md` (project root) or `/.claude/CLAUDE.md`
- Restart the Claude Code session after creating or updating the file
- Confirm the file is not listed in `.gitignore`

**MCP credentials — security concern**

- Pass tokens directly in the `claude mcp add` command at setup time; they are stored in `~/.claude.json` (not committed to version control)
- For project-scoped configs (`.mcp.json`), use environment variable expansion instead of hardcoding values:
  ```json
  "env": {
    "SONARQUBE_TOKEN": "${SONARQUBE_TOKEN}"
  }
  ```
  
- Set the variable in your shell profile and never commit `.mcp.json` files containing real tokens
