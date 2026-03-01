# AI Toolset Setup Guide

This guide walks through setting up the full General toolset from scratch — Claude Code, MCPs, and the slash command agents. Follow the steps in order on a new machine or when onboarding onto a new project.

**Estimated setup time:** 15–20 minutes

---

## Prerequisites

- VS Code installed
- Access to Claude Code Team Plan (provided by your team lead)

---

## Step 1: Install Claude Code VS Code Extension

1. Open VS Code and go to the **Extensions** tab (`Ctrl+Shift+X` / `Cmd+Shift+X`)
2. Search for `Claude Code` and install the official Anthropic extension
3. After installation, you'll see the Claude Code icon in the VS Code sidebar
4. Click the icon to open the Claude Code panel
5. Sign in with your Anthropic account credentials (Team Plan)

> Claude Code includes built-in access to Claude Sonnet 4.6 and Claude Opus 4.5 — no separate API key configuration needed with the Team Plan.

---

## Step 2: Configure MCPs

MCPs in Claude Code are configured via JSON settings files, not VS Code extensions. There are two configuration levels:

- **User-level:** `~/.claude/settings.json` — applies to all projects
- **Project-level:** `.claude/settings.json` in your project root — applies to specific project only

### Create the Settings File

**For user-level (recommended for standard MCPs):**

```bash
# Create the .claude directory if it doesn't exist
mkdir -p ~/.claude

# Create or edit settings.json
code ~/.claude/settings.json
```

**For project-level:**

```bash
# In your project root
mkdir -p .claude
code .claude/settings.json
```

### Add MCP Configuration

Add the following to your `settings.json`:

```json
{
  "mcpServers": {
    "sonarqube": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-sonarqube"],
      "env": {
        "SONARQUBE_URL": "https://your-sonarqube-instance.com",
        "SONARQUBE_TOKEN": "your-token-here"
      }
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-context7"],
      "env": {
        "CONTEXT7_API_KEY": "your-api-key-here"
      }
    }
  }
}
```

### SonarQube MCP

1. Get your SonarQube instance URL and token from your team lead
2. Add the `sonarqube` entry to your MCP configuration as shown above
3. Replace the placeholder values with your actual credentials

### Context7 MCP

1. Go to [https://context7.com/dashboard](https://context7.com/dashboard)
2. Sign up and connect your Offshorly GitHub account
3. Generate an API key
4. Add the `context7` entry to your MCP configuration as shown above

### Figma MCP *(frontend developers only)*

Add to your MCP configuration:

```json
{
  "mcpServers": {
    "figma": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-figma"],
      "env": {
        "FIGMA_ACCESS_TOKEN": "your-figma-token-here"
      }
    }
  }
}
```

To get your Figma access token:
1. Go to Figma → Settings → Account → Personal access tokens
2. Generate a new token and add it to the configuration

---

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
| Claude Code installed | Claude Code icon visible in VS Code sidebar |
| Signed in to Team Plan | Account shown in Claude Code panel, no usage warnings |
| SonarQube MCP active | Run a prompt that references SonarQube — no connection errors |
| Context7 MCP active | Run a prompt that references Context7 — no connection errors |
| Figma MCP active *(frontend only)* | Figma appears in available MCP tools |
| Slash commands working | Type `/` in Claude Code to see available commands |
| `CLAUDE.md` exists | `/CLAUDE.md` present in the project root |

---

## Troubleshooting

**Claude Code not signing in**

- Confirm your Anthropic account has Team Plan access
- Try signing out and back in
- Check your network connection — corporate firewalls may block Anthropic domains

**MCP not responding**

- Confirm the MCP is correctly configured in `~/.claude/settings.json` or `.claude/settings.json`
- Check that required environment variables (tokens, URLs) are set correctly
- Verify the MCP server package is accessible (requires npm/npx)
- Check Claude Code's output panel for error messages

**Slash commands not appearing**

- Custom commands must be in `.claude/commands/` directory
- File must have `.md` extension and proper frontmatter
- Restart Claude Code after adding new commands

**`CLAUDE.md` not being picked up**

- Confirm the file is at `/CLAUDE.md` (project root) or `/.claude/CLAUDE.md`
- Restart the Claude Code session after creating or updating the file
- Confirm the file is not listed in `.gitignore`

**MCP credentials in settings.json — security concern**

- For sensitive tokens, use environment variables instead of hardcoding:
  ```json
  "env": {
    "SONARQUBE_TOKEN": "${SONARQUBE_TOKEN}"
  }
  ```
- Set the environment variable in your shell profile or `.env` file
- Never commit `settings.json` files containing real tokens to version control
