# MCP Servers

## What Are MCPs?

MCP (Model Context Protocol) servers are APIs wrapped as extensions that LLMs can access to pull context from external systems and run tools — going beyond what's available in the codebase text alone. In practical terms, an MCP-enabled workflow can:

- Pull context from external systems (Jira tickets, design files, cloud configs)
- Run checks or tools against your code (linters, security scanners, quality gates)
- Assist with review and validation against real-time data from connected services

MCPs are what make the agent pipeline genuinely useful rather than just code-aware — they give agents the ability to fetch acceptance criteria, check code quality, stay current with library docs, and interact with the broader systems your code connects to.

---

## Setup

MCPs in Claude Code are configured via JSON settings files:

- **User-level:** `~/.claude/settings.json` — applies to all projects
- **Project-level:** `.claude/settings.json` in your project root — applies to specific project only

### Basic Configuration Structure

```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-name"],
      "env": {
        "API_KEY": "your-key-here"
      }
    }
  }
}
```

For full setup instructions, see [`docs/05-setup-guide.md`](05-setup-guide.md#step-2-configure-mcps).

---

## Currently Active MCPs

These are the MCPs in use across the standard toolset. They are referenced in the agent instruction sheets and should be installed as part of the standard setup.

---

### SonarQube

**Category:** Code Quality and Security
**Used by:** Test Writer agent, Code Reviewer agent

Runs code quality checks and security scanning against your codebase. Identifies vulnerabilities, code smells, and risk areas that should inform both test coverage and code review decisions.

| Detail | Info |
|--------|------|
| **Primary use case** | Identifying vulnerabilities, code smells, and risks before merge |
| **Best fit** | Enforcing quality gates; reducing risk on pre-PR changes |
| **Required for** | Test Writer agent, Code Reviewer agent |

---

### Context7

**Category:** Up-to-Date Coding Standards
**Used by:** Test Writer agent, Documentation agent

Keeps code suggestions aligned with current library versions, up-to-date practices, and coding standards. Prevents the common problem of AI models generating code using deprecated APIs or outdated patterns from their training data.

| Detail | Info |
|--------|------|
| **Primary use case** | Reducing outdated or unsupported patterns in generated code |
| **Best fit** | Any implementation work with heavy library usage |
| **Required for** | Test Writer agent, Documentation agent |

**Getting a Context7 API key (optional, for higher rate limits):**

1. Go to [https://context7.com/dashboard](https://context7.com/dashboard)
2. Sign up and connect your Offshorly GitHub account
3. Generate your API key
4. Add to your `~/.claude/settings.json` under the context7 MCP config:
   ```json
   "env": {
     "CONTEXT7_API_KEY": "your-key-here"
   }
   ```

---

### Figma

**Category:** Design and Frontend
**Used by:** Frontend developers working from Figma designs

Bridges the design-to-code workflow by giving AI tools direct access to Figma design data — component properties, spacing, colors, layout details — rather than requiring manual translation.

| Detail | Info |
|--------|------|
| **Primary use case** | Extracting design details and aligning UI implementations to design specs |
| **Best fit** | Frontend developers working directly from Figma |
| **Required for** | Not required for all — frontend only |

---

## MCPs Available for Team Exploration

The following MCPs have been identified as valuable but have not yet been evaluated or adopted across teams. Each category is worth assessing against the projects and services your team actively uses.

> If your team adopts and validates one of these, update this document and `CHANGELOG.md` to reflect the decision.

### Cloud and Infrastructure

| MCP | Purpose |
|-----|---------|
| **Azure MCP** | Interact with Azure resources, configs, and deployments from the AI context |
| **AWS API MCP** | Interact with AWS services and infrastructure |

### Deployment and Hosting Platforms

| MCP | Purpose |
|-----|---------|
| **Vercel MCP** | Deployment status, environment config, preview URL management |
| **Netlify MCP** | Build and deployment management |
| **Render MCP** | Service management and deployment triggers |
| **Cloudflare MCP** | Workers, DNS, and edge config management |

### Backend and Database Services

| MCP | Purpose |
|-----|---------|
| **MongoDB MCP** | Schema introspection and query context |
| **Supabase MCP** | Database schema, auth config, and row-level security context |
| **Firebase MCP** | Firestore schema, auth rules, and config context |

### Payment Integration Services

| MCP | Purpose |
|-----|---------|
| **Stripe MCP** | Payment flow context, event handling, webhook management |
| **PayPal MCP** | Payment integration context |

### Task Management

| MCP | Purpose |
|-----|---------|
| **Atlassian Remote MCP (Jira)** | Fetch ticket details, acceptance criteria, and issue context directly into agent workflows |

---

## Adopting a New MCP

When you or your team evaluates and decides to adopt one of the MCPs above:

1. **Validate it** — test the MCP on a real task and confirm it adds genuine value
2. **Document the setup** — add the JSON configuration snippet and any required credentials to this file under a new "Currently Active" entry, following the same format as SonarQube, Context7, and Figma
3. **Update agent slash commands** if the new MCP should be referenced in any agent's workflow — the relevant agent files are in [`agents/`](../agents/)
4. **Log the decision** in `CHANGELOG.md`
