# OpenClaw Integration

OpenClaw is an internal AI assistant deployment that provides team members with accessible AI capabilities through familiar interfaces. This document covers the setup, configuration, and usage guidelines for teams participating in the OpenClaw pilot.

> This is internal tooling currently available to select teams. Contact the AI Excellence team for access.

---

## What is OpenClaw?

OpenClaw provides:

- An internally-hosted AI assistant accessible via Telegram
- Runs Claude Sonnet 4.5 for balanced performance and cost
- Designed for quick queries, task assistance, and workflow support
- Named "Embee" — a professional AI assistant with a warm, direct personality

OpenClaw is **not** a replacement for IDE-based coding tools like Copilot or Claude Code. It's designed for non-coding tasks and quick assistance outside the development environment.

---

## Infrastructure

| Component | Details |
|-----------|---------|
| Hosting | Google Cloud E2 VM instance |
| Model | Claude Sonnet 4.5 / Claude Opus 4.5 |
| Interface | Telegram Bot |
| Access | Via Telegram access code |

---

## Installation Guide

### For End Users

1. Install Telegram (mobile or desktop) if not already installed
2. Start a conversation with `@EmbeeBot` (or the designated bot name)
3. Give your access code to the developer to connect to the OpenClaw instance
4. Send "Hello, I'm {your name}" to start the conversation

### For Administrators

Contact the AI Excellence team for deployment and configuration details.

---

## Usage Guidelines

### Good Use Cases

| Use Case | Example |
|----------|---------|
| Summarizing, formatting, or restructuring texts | "Summarize this meeting transcript into action items" |
| Drafting emails, documentation, or messages | "Draft a follow-up email for the client meeting" |
| Creating calendar invites | "Create a calendar invite for a 30-min sync tomorrow at 2pm" |
| Creating reports from emails, timesheets, or meeting notes | "Turn these notes into a weekly status report" |
| General knowledge queries about work | "What's our standard process for code reviews?" |

### Not Recommended For

| Use Case | Why | Use Instead |
|----------|-----|-------------|
| Writing or reviewing code | Not connected to your codebase | GitHub Copilot, Claude Code |
| Complex debugging | No access to terminal or logs | IDE-based tools |
| Sensitive data processing | Telegram is external | Internal tools only |

---

## Embee Personality and Behavior

Embee is configured with specific personality traits and safety guardrails:

**Personality:**
- Professional but warm — direct without being cold
- Confident and helpful, with genuine care for user success
- Clear, concise language without unnecessary fluff
- Subtle personality without being overly casual
- Avoids emojis unless necessary for clarity

**Action Confirmation Protocol:**

Before executing any action, Embee will:

1. Present a clear action plan in bullet points
2. Show what will be done
3. List which files/systems/services will be affected
4. State the expected outcome
5. Indicate risk level (low/medium/high)
6. Wait for explicit "yes" or "proceed" confirmation

**Example confirmation:**
```
I'm about to:
- Update 15 employee records in the database
- Modify fields: email, department, manager
- Systems affected: Zoho CRM, HR database
- Risk level: MEDIUM (changes are reversible)
- Estimated time: 2 minutes

Should I proceed? (Reply 'yes' to continue)
```

**Confirmation is required especially for:**
- Multi-step operations (3+ steps)
- File deletions or modifications
- Database changes
- Email sending or forwarding
- Calendar modifications
- Any Zoho operations
- System configuration changes
- API calls that modify data
- Anything affecting production systems
- Operations involving sensitive employee/financial data

---

## Feeding Updated Information

There are instances where Embee cannot provide the answer correctly or will say it doesn't have current information. In these cases, you can feed it proper, updated information such as:

- API documentation
- Recent news
- Links to publicly accessible social media posts
- Newly published blogs

### How to Provide Context

Simply provide the link and specify what you need:

```
Please access this link and use it as reference for [SPECIFIC ACTION REQUIRED].
[link_to_documentation]
```

**Example:**
```
Please access this link and use it as reference for writing API integration code.
https://docs.stripe.com/api/payment_intents
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Bot not responding | Check if bot is online; contact AI Excellence team |
| "I don't have access to that" | The requested system isn't connected to OpenClaw |
| Outdated information | Provide a link to current documentation |
| Incorrect action taken | Report to AI Excellence team for prompt tuning |

---

## Related Resources

- Embee System Prompt: [`prompts/03-embee-system-prompt.md`](../prompts/03-embee-system-prompt.md)
- Security guidelines: Follow the same security guardrails as other AI tools — never share credentials, API keys, or sensitive data in chat
