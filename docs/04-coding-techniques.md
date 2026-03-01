# Coding Techniques

This document covers the recommended workflows for using AI tools effectively across the organization. All techniques are organized around two tracks and three complexity tiers.

---

## Two Tracks

| Track | Optimized For | When to Use |
|-------|--------------|-------------|
| **General** | Speed and capability | New systems, greenfield builds, PoC → MVP, teams moving fast from scratch |
| **Conservative** | Predictability and low risk | Mature codebases, maintenance work, risk-sensitive changes |

Both tracks share the same core principles:

- Match tools and models to the complexity of the task
- Prefer small, reversible changes
- Always validate outputs through tests, linters, and review gates

---

## General Toolset

| Component | Choice |
|-----------|--------|
| IDE | VS Code |
| Coding Companion | GitHub Copilot (autocompletion + chat) |
| Primary LLM | Claude Opus 4.5 |
| MCPs | SonarQube, Context7, Figma *(frontend only)* |

### Why This Toolset

Most developers rely heavily on autocompletion as their default productivity multiplier. Copilot delivers high-speed, workable suggestions for T1 work and solid boilerplate for T2 tasks. Copilot chat with agentic use adds a planning and multi-step execution layer with full codebase context.

Claude Opus 4.5 is the primary model for high-complexity tasks because of its strong reasoning and planning capabilities. That said, **Opus can be overkill for small changes, maintenance work, and mature codebases** — see the model guidance below.

### Model Guidance

| Experience Level | Observation |
|-----------------|-------------|
| Junior developers | Tend to see larger productivity gains from stronger models (Opus) on T3 tasks |
| Experienced developers | Often see smaller marginal gains from Opus vs. Sonnet, where clarity of requirements and local context matters more than raw model output |

**The takeaway:** Model selection should be based on task complexity, expected risk, and local context requirements — not simply choosing the "best model available."

---

## Required Setup: Copilot Custom Instructions

Before any development work on a new project, the first step is always to generate `/.github/copilot-instructions.md`. This file is what makes Copilot context-aware for your specific codebase.

> ⚠️ Do **not** use Copilot's built-in "Generate Chat Instructions" command for this. While it generally works, the output is often inconsistent and incomplete. It's acceptable for personal projects or quick one-offs, but not for team standardisation.

**Steps:**

1. Open the Copilot chat window
2. Ensure the selected model is **Claude Opus 4.5**
3. Run the prompt from [`prompts/01-copilot-instructions-generator.md`](../prompts/01-copilot-instructions-generator.md)

---

## Tier-Based Techniques

### Tier 1 — Low Complexity

*Examples: documentation, unit tests, small functions, API wrappers*

- Use **autocompletion as the default**
- Write requirements as a short comment directly above where the function or code block is needed
- Use `TODO:` or `NOTE:` explicitly to guide output
- Keep iteration tight: generate → run → adjust → repeat

### Tier 2 — Medium Complexity

*Examples: CRUD operations, cloud integration, DB model schemas, multi-function references*

- Use the **PLAN workflow**: explicitly define references in your prompt — file paths, functions, existing patterns
- Ask for an outline or short plan first, then implement step-by-step
- Only proceed to implementation after the plan is reviewed and approved

**Example prompt:**
```
PLAN mode. Create a short plan first. Using existing patterns in
@app/core/config.py and @env, include in the configs the env vars
that are currently missing from the Settings() class. After the
plan is approved, implement the changes with minimal diff.
```

### Tier 3 — High Complexity

*Examples: full frameworks, deep cross-dependency work, architectural changes*

- **Always use plan mode first** — explicitly include dependency mapping, architectural proposals, and validation plans
- Always implement in phases, with each phase producing a runnable state
- Validate each phase before proceeding to the next

**Example prompt:**
```
Plan mode. Build a full API framework from scratch with modules X, Y, Z.
Requirements: (list). Constraints: (list).
Provide: architecture outline, folder structure, key interfaces,
error handling approach, and test plan.
Then implement in phases, with each phase producing a runnable state.
```

---

## Agent-Based Techniques

These agents extend the workflow beyond code generation into testing, review, and documentation. All three are built on Claude Sonnet 4.5 and use SonarQube and/or Context7 MCPs.

For full agent instruction sheets and installation steps, see [`agents/`](../agents/).

### The Full Pipeline

```
Code Complete → Test Writer → Documentation → Code Reviewer → PR
                    ↑               ↑               |
                    └───────────────┴───────────────┘
                              (handoffs between agents)
```

---

### Test Writer Agent

**Model:** Claude Sonnet 4.5
**MCPs:** SonarQube, Context7

#### When to Use

- When the goal is production-level architecture — e.g. migrating from PoC to MVP, or strengthening an MVP for production
- When feature work is complete or near-complete and you want to prevent regressions before a PR
- When adding new behavior to critical modules: auth, billing, payments, permissions, data pipeline, infra

#### What to Provide in Your Prompt

- Exact file paths and line ranges
- Expected behaviors, or a Jira ticket as the source of acceptance criteria
- Explicit request for: unit tests first, integration tests if possible; happy paths, edge cases, and negative cases; minimal mocking with consistent test patterns

#### Example Prompt

```
Test Writer mode. Write tests for @app/services/subscriptions.py lines 45–210.
Reference Jira ticket Task-155.
Add coverage for happy paths, missing header/tokens, invalid tier value,
database errors (simulate possible exceptions), and a catch-all for unexpected
behavior. Include also tests for edge cases that I might have missed.
```

---

### Code Reviewer Agent

**Model:** Claude Sonnet 4.5
**MCPs:** SonarQube, CodeRabbit *(if available)*

#### When to Use

Use this agent when development is done and you want a structured review of changes before creating a PR or merging to staging. It reduces the need for human-in-the-loop review by catching:

- Correctness issues
- Edge cases
- Security risks
- Inconsistent patterns vs. codebase conventions
- Missing tests or documentation gaps

#### What to Provide in Your Prompt

- Exact files and line ranges for the changes
- Acceptance criteria or a task ticket if available
- Specific review goals if needed

#### Example Prompt

```
CODE REVIEWER mode. Review changes implemented for BL-107 using Jira MCP
for acceptance criteria and context. Treat this as a pre-PR review.
Focus on @app/services/subscriptions.py, @app/api/routes/subscriptions.py,
and @app/core/auth.py for the changes, and @app/tests/subscription_services.py
for test cases.
```

---

### Documentation Agent

**Model:** Claude Sonnet 4.5
**MCPs:** Context7

#### When to Use

The agent ensures documentation stays current and consistent throughout the codebase — usable both as a reference for the team and as context in future Copilot prompts.

> *"We already have documentation updates every time there is a change in the code."*
> Yes — and that's already included in the `copilot-instructions.md`. But those updates are minimal because code changes are the priority in the moment. This agent is the dedicated pass that picks up what was deferred.

**Two recommended usage patterns:**

| Pattern | When | Focus |
|---------|------|-------|
| **Pre-PR** | After every coding session, before code review | Endpoints, variables, configuration, new models/directories, new operational steps |
| **End-of-Day** | When mid-feature or mid-refactor and the PR isn't ready yet | Context preservation — prevent drift and forgetting context before resuming tomorrow |

#### Example Prompt

```
DOCUMENTATION mode. As end-of-day documentation, summarize and update docs
for changes made today. Reference #changes and commits done today.
```

---

## Language-Specific Prompt Extensions (Optional)

In addition to project-specific Copilot instructions, you can add language- or framework-specific instruction sheets to `/.github/copilot-instructions.md`. These help standardise coding patterns, reduce common mistakes, and provide a stronger baseline when working in unfamiliar territory.

**Reference library:**
[https://github.com/Vishavjeet6/awesome-copilot-instructions/tree/master](https://github.com/Vishavjeet6/awesome-copilot-instructions/tree/master)

**How to apply:**
1. From the repository, pick the relevant framework or language
2. In `/.github/copilot-instructions.md`, add a `## Language-Specific Rules` section and paste the chosen instructions

**Internal observations:**
- Developers with strong domain experience tend to see limited added value from these extensions
- The biggest benefit is when working **outside your primary domain** — e.g. a backend developer building frontend components
- In those cases, the instruction sheets act as guardrails for conventions, reminders of common pitfalls, and a quick way to align AI outputs to the expected ecosystem patterns
