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
| Hosting | Google Cloud E2-small VM instance |
| Model | Claude Sonnet 4.5 / Claude Opus 4.5 |
| Interface | Telegram Bot |
| Access | Via Telegram access code |

---

## Installation Guide

### For End Users

1. Install Telegram (mobile or desktop) if not already installed
2. Start a conversation with `@EmbeeBot` (or the designated bot name to be given by admin)
3. Give your access code to the developer to connect to the OpenClaw instance
4. Send "Hello, I'm {your name}" to start the conversation

### For Administrators

Contact the AI Excellence team for deployment and configuration details.

---

## Setting Up Integration Credentials

OpenClaw connects to Google and Zoho services for calendar, email, and HR operations. Administrators need to create OAuth credentials for these integrations.

### Google Credentials

#### Step 1: Create or Select a Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click the **project dropdown** (top left)
3. Click **New Project** (or select an existing project)
4. Give it a name (e.g., `Embee-OpenClaw Integration`)
5. Click **Create**
6. Make sure the newly created project is selected

#### Step 2: Enable Required Google APIs

1. Navigate to **APIs & Services → Library**
2. Search for and enable the APIs your deployment needs:
   - Gmail API
   - Google Drive API
   - Google Docs API
   - Google Sheets API
   - Google Slides API
   - Google Calendar API

For each API: click the API, then click **Enable**.

#### Step 3: Configure the OAuth Consent Screen

1. Go to **APIs & Services → OAuth consent screen**
2. Click **Get Started** (if first time)
3. Choose your **User Type**:
   - **Internal** (select this one) — Only users in your Google Workspace organization
   - **External** — Anyone with a Google account
4. Fill in required details (app name, support email, etc. -- use <youremail@offshorly.com>)
5. Continue through the setup steps
6. On the final step, accept the **Google API Services User Data Policy** and click **Create**

#### Step 4: Create OAuth Client Credentials

1. Go to **APIs & Services → Credentials**
2. Click **Create Credentials → OAuth client ID**
3. Set **Application Type** to **Web application**
4. Enter a **Name** for your client
5. Add **Authorized JavaScript Origins**:
   ```
   https://localhost
   ```
6. Add **Authorized Redirect URIs**:
   ```
   https://localhost/oauth/callback
   ```
7. Click **Create**

#### Step 5: Download the Credentials JSON File

After creation:

1. A popup will display your Client ID and Client Secret
2. Click **Download JSON**
3. Save the file securely (outside version control)

This downloaded file (`google_credentials.json`) contains:
- `client_id`
- `client_secret`
- `redirect_uris`
- `auth_uri`
- `token_uri`

---

### Zoho Credentials

#### Step 1: Go to Zoho API Console

1. Navigate to [Zoho API Console](https://api-console.zoho.com/)
   - Regional accounts may use: `api-console.zoho.eu`, `api-console.zoho.in`, etc.
2. Log in with your Zoho account

#### Step 2: Create a New Client

1. Click **Add Client**
2. Choose **Client Type**: **Server-based Applications**
3. Click **Create Now**

#### Step 3: Fill in Application Details

Enter the following:

| Field | Example Value |
|-------|---------------|
| Client Name | `Embee-OpenClaw Integration` |
| Homepage URL | `http://localhost` |
| Authorized Redirect URI | `http://localhost/oauth` |

Click **Create**.

#### Step 4: Retrieve Client Credentials

After creation, Zoho will generate:

- **Client ID**
- **Client Secret**

These are displayed on the application details page. You can return to this page later to view them.

#### Step 5: Save Your Credentials Securely

Store the following securely as a text file:

```
Client ID: <your_client_id>
Client Secret: <your_client_secret>
Redirect URI: <your_redirect_uri>
Refresh Token: <your_refresh_token>
```

---

## Connecting Credentials to Embee

Once you have your credential files ready, you need to send them to Embee for authorization. Complete each integration one at a time.

### Step 1: Authorize Google Integration

1. Open your conversation with Embee in Telegram
2. Send your `google_credentials.json` file to Embee
3. Send this message or something similar to it:
   ```
   Please help me authorize Google integration using the credentials file I just sent.
   Give me step-by-step instructions on what to do.
   ```
4. Follow Embee's instructions to complete the OAuth flow
5. Confirm authorization is successful before proceeding

### Step 2: Authorize Zoho Integration

1. Send your Zoho credentials text file to Embee
2. Send this message or something similar to it:
   ```
   Please help me authorize Zoho integration using the credentials I just sent.
   Give me step-by-step instructions on what to do.
   ```
3. Follow Embee's instructions to complete the OAuth flow
4. Confirm authorization is successful

### Troubleshooting Authorization

| Issue | Solution |
|-------|----------|
| Authorization fails | Embee will provide a re-authorization URL with step-by-step guidance |
| Token expired | Request Embee to refresh the token or guide you through re-authorization |
| Wrong redirect URI | Ensure the redirect URI in your credentials matches your Zoho/Google app settings |
| Scope errors | Contact the AI Excellence team to verify the required scopes are configured |

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
