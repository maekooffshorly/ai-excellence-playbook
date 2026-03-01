# AI Toolset Setup Guide

This guide walks through setting up the full General toolset from scratch — GitHub Copilot, Claude API access, MCPs, and the three agents. Follow the steps in order on a new machine or when onboarding onto a new project.

**Estimated setup time:** 15–20 minutes

---

## Prerequisites

- VS Code installed
- A GitHub account connected to Offshorly
- A Claude API key (provided by your team lead or obtained from the Anthropic console)

---

## Step 1: Install GitHub Copilot

1. Open VS Code and go to the **Extensions** tab (`Ctrl+Shift+X` / `Cmd+Shift+X`)
2. Search for `GitHub Copilot` and install the extension
3. To connect your GitHub account, open the Copilot chat window (the chat icon next to the project search bar in the top bar) and follow the account connection instructions

> Both **GitHub Copilot** and **GitHub Copilot Chat** extensions will be installed. This is expected.

---

## Step 2: Add Claude API Access

By default, Copilot uses its own models. To enable Claude Sonnet 4.5 and Claude Opus 4.5:

1. Open the Copilot chat window
2. Click the model selector dropdown (defaults to **Auto**)
3. Select **Manage Models** → **+ Add Models** → **Anthropic**
4. Enter your Claude API key when prompted
5. Enable **Claude Sonnet 4.5** and **Claude Opus 4.5** from the model list

You should now see both Claude models available in the model selector dropdown.

---

## Step 3: Install MCPs

MCPs are installed as VS Code extensions. Install the following three for the standard toolset:

### SonarQube MCP

1. In the Extensions tab, search `@mcp sonarqube`
2. Install the SonarQube MCP server
3. Follow any authentication prompts — you'll need your SonarQube instance URL and token (ask your team lead if you don't have these)

### Context7 MCP

1. In the Extensions tab, search `@mcp context7`
2. Install the Context7 MCP server

**Optional: Add a Context7 API key for higher rate limits**

1. Go to [https://context7.com/dashboard](https://context7.com/dashboard)
2. Sign up and connect your Offshorly GitHub account
3. Generate an API key and store it temporarily (e.g. in a notepad — don't commit it)
4. Open the Context7 configuration JSON file (accessible from the extension settings)
5. Set the `CONTEXT7_API_KEY` environment variable to your key, or follow the instructions shown in the Context7 dashboard

### Figma MCP *(frontend developers only)*

1. In the Extensions tab, search `@mcp figma`
2. Install the Figma MCP server
3. Connect your Figma account when prompted

---

## Step 4: Install the Three Agents

All three agents are installed the same way. Repeat these steps for each one.

**For each agent:**

1. Open the Copilot chat window
2. At the bottom of the chat window, click the **Agent** selector
3. Select **Configure Custom Agents…**
4. Click **+ Create new custom agent…**
5. Choose the storage location:
   - **`.github/agents`** — scopes the agent to the current project repository
   - **User Data** — makes the agent available globally across all projects
6. Enter the agent name (exact names matter for handoffs between agents):

| Agent | Name to enter |
|-------|--------------|
| Test Writer | `Test Writer` |
| Code Reviewer | `Code Reviewer` |
| Documentation | `Documentation` |

7. Replace the generated instruction content with the full instruction sheet from the relevant agent file:
   - Test Writer → [`agents/test-writer.md`](../agents/test-writer.md) — copy everything inside the fenced code block under **Instruction Sheet**
   - Code Reviewer → [`agents/code-reviewer.md`](../agents/code-reviewer.md) — same section
   - Documentation → [`agents/documentation.md`](../agents/documentation.md) — same section

> **Tip:** Store agents in **User Data** if you work across multiple projects and want the full pipeline available everywhere. Use `.github/agents` if you want project-specific agent configurations that can vary between repos.

---

## Step 5: Generate `copilot-instructions.md`

This step is per-project and must be done before starting any development work on a new codebase.

1. Open the Copilot chat window
2. Set the model to **Claude Opus 4.5**
3. Copy the full prompt from [`prompts/01-copilot-instructions-generator.md`](../prompts/01-copilot-instructions-generator.md) — everything inside the fenced code block under **The Prompt**
4. Paste it into the chat and run it
5. Review the generated `<project-context>` section when Copilot asks for your confirmation
6. Approve or request corrections
7. Copilot will then suggest three development routes to proceed from

The file will be created at `/.github/copilot-instructions.md` in your project. Commit it to the repo so the whole team benefits from it.

---

## Verification Checklist

Once setup is complete, confirm the following:

| Item | How to verify |
|------|--------------|
| GitHub Copilot installed | Copilot icon visible in VS Code sidebar and status bar |
| Claude models available | Both Claude Sonnet 4.5 and Claude Opus 4.5 appear in the Copilot model selector |
| SonarQube MCP active | Running a Copilot agent prompt that references SonarQube doesn't error |
| Context7 MCP active | Running a Copilot agent prompt that references Context7 doesn't error |
| Figma MCP active *(frontend only)* | Figma MCP appears in available tools |
| All three agents installed | Test Writer, Code Reviewer, and Documentation appear in the Agent selector in Copilot chat |
| `copilot-instructions.md` exists | `/.github/copilot-instructions.md` present in the project root |

---

## Troubleshooting

**Claude models not appearing after adding the API key**

- Double-check the API key was entered correctly — no leading/trailing spaces
- Confirm the key has access to both `claude-sonnet-4-5` and `claude-opus-4-5` in the Anthropic console
- Try restarting VS Code after adding the key

**MCP not responding in agent prompts**

- Confirm the MCP extension is installed and enabled (not just installed)
- Check the MCP's output panel in VS Code for error messages
- For SonarQube: confirm your instance URL and token are correctly configured
- For Context7: the free tier has rate limits — consider adding an API key if you're hitting them frequently

**Agent handoffs not working (e.g. "Test Writer" not found)**

- Agent names are case-sensitive — confirm the names match exactly: `Test Writer`, `Code Reviewer`, `Documentation`
- If agents are stored in `.github/agents`, confirm the files exist in that directory in your current project
- If stored in User Data, confirm they weren't accidentally deleted

**`copilot-instructions.md` not being picked up by Copilot**

- Confirm the file is at `/.github/copilot-instructions.md` (project root, not a subdirectory)
- Restart the Copilot chat session after creating or updating the file
- Confirm the file is not listed in `.gitignore`
