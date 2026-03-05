# Coding Techniques

This document covers the recommended workflows for using AI tools effectively across the organization. All techniques are organized around two tracks and three complexity tiers.

---

## Two Tracks

| Track | Optimized For | When to Use |
|-------|--------------|-------------|
| **General** | Speed and capability | New systems, greenfield builds, PoC â†’ MVP, teams moving fast from scratch |
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
| Coding Companion | Claude Code (VS Code extension + agentic workflows) |
| Primary LLM | Claude Sonnet 4.6 (T1â€“T3) / Claude Opus 4.5 (complex T3) |
| MCPs | SonarQube, Context7, Figma *(frontend only)* |

### Why This Toolset

Claude Code provides the best balance of agentic capability and cost efficiency for SWE work. It understands your entire repo, handles multi-file changes naturally, and integrates with MCPs for quality checks and library standards. The VS Code extension brings these capabilities directly into your IDE workflow.

Claude Sonnet 4.6 is now the primary model for most SWE work - it offers near-Opus capability at Sonnet pricing. Claude Opus 4.5 remains the choice for complex T3 tasks requiring deep reasoning. **Opus can be overkill for small changes, maintenance work, and mature codebases** - see the model guidance below.

### Model Guidance

| Experience Level | Observation |
|-----------------|-------------|
| Junior developers | Tend to see larger productivity gains from stronger models (Opus) on T3 tasks |
| Experienced developers | Often see smaller marginal gains from Opus vs. Sonnet, where clarity of requirements and local context matters more than raw model output |

**The takeaway:** Model selection should be based on task complexity, expected risk, and local context requirements - not simply choosing the "best model available."

**Switching models in Claude Code:** Claude Code defaults to Opus 4.6, but we recommend Opus 4.5 for T3 tasks. Use `/model claude-opus-4-5-20251101` to switch to Opus 4.5 when starting complex architectural work.

---

## Required Setup: CLAUDE.md

Before any development work on a new project, the first step is always to generate `/CLAUDE.md`. This file is what makes Claude Code context-aware for your specific codebase.

Claude Code automatically reads `CLAUDE.md` files from your project root or `.claude/` directory, providing project-specific context for all interactions.

**Steps:**

1. Open your project in VS Code with Claude Code
2. Open the Claude Code panel
3. Run the prompt from [`prompts/01-claude-md-generator.md`](../prompts/01-claude-md-generator.md)
4. Review and approve the generated content

---

## Tier-Based Techniques

### Tier 1 - Low Complexity

*Examples: documentation, unit tests, small functions, API wrappers*

- Use **autocompletion as the default**
- Write requirements as a short comment directly above where the function or code block is needed
- Use `TODO:` or `NOTE:` explicitly to guide output
- Keep iteration tight: generate â†’ run â†’ adjust â†’ repeat

### Tier 2 - Medium Complexity

*Examples: CRUD operations, cloud integration, DB model schemas, multi-function references*

- Use the **PLAN workflow**: explicitly define references in your prompt - file paths, functions, existing patterns
- Ask for an outline or short plan first, then implement step-by-step
- Only proceed to implementation after the plan is reviewed and approved

**Example prompt:**
```
PLAN mode. Create a short plan first. Using existing patterns in
@app/core/config.py and @env, include in the configs the env vars
that are currently missing from the Settings() class. After the
plan is approved, implement the changes with minimal diff.
```

### Tier 3 - High Complexity

*Examples: full frameworks, deep cross-dependency work, architectural changes*

- **Always use plan mode first** - explicitly include dependency mapping, architectural proposals, and validation plans
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

These agents extend the workflow beyond code generation into testing, review, and documentation. All three are built on Claude Sonnet 4.6 and use SonarQube and/or Context7 MCPs. In Claude Code, agents are invoked via slash commands.

For full agent instruction sheets and installation steps, see [`agents/`](../agents/).

### The Full Pipeline

```
Code Complete → Test Writer → Documentation → Code Reviewer → Verify → PR
                    ↑               ↑               |            |
                    └───────────────┴───────────────┴────────────┘
                              (handoffs between agents)
```

> For experimental multi-agent orchestration that automates this pipeline, see [`docs/09-experimental-techniques.md`](09-experimental-techniques.md).

---

### Test Writer Agent

**Model:** Claude Sonnet 4.6
**MCPs:** SonarQube, Context7

#### When to Use

- When the goal is production-level architecture - e.g. migrating from PoC to MVP, or strengthening an MVP for production
- When feature work is complete or near-complete and you want to prevent regressions before a PR
- When adding new behavior to critical modules: auth, billing, payments, permissions, data pipeline, infra

#### What to Provide in Your Prompt

- Exact file paths and line ranges
- Expected behaviors, or a Jira ticket as the source of acceptance criteria
- Explicit request for: unit tests first, integration tests if possible; happy paths, edge cases, and negative cases; minimal mocking with consistent test patterns

#### Example Prompt

```
Test Writer mode. Write tests for @app/services/subscriptions.py lines 45â€“210.
Reference Jira ticket Task-155.
Add coverage for happy paths, missing header/tokens, invalid tier value,
database errors (simulate possible exceptions), and a catch-all for unexpected
behavior. Include also tests for edge cases that I might have missed.
```

---

### Code Reviewer Agent

**Model:** Claude Sonnet 4.6
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

**Model:** Claude Sonnet 4.6
**MCPs:** Context7

#### When to Use

The agent ensures documentation stays current and consistent throughout the codebase - usable both as a reference for the team and as context in future Copilot prompts.

> *"We already have documentation updates every time there is a change in the code."*
> Yes - and that's already included in the `copilot-instructions.md`. But those updates are minimal because code changes are the priority in the moment. This agent is the dedicated pass that picks up what was deferred.

**Two recommended usage patterns:**

| Pattern | When | Focus |
|---------|------|-------|
| **Pre-PR** | After every coding session, before code review | Endpoints, variables, configuration, new models/directories, new operational steps |
| **End-of-Day** | When mid-feature or mid-refactor and the PR isn't ready yet | Context preservation - prevent drift and forgetting context before resuming tomorrow |

#### Example Prompt

```
DOCUMENTATION mode. As end-of-day documentation, summarize and update docs
for changes made today. Reference #changes and commits done today.
```

---

## Additional Slash Commands

Beyond the agent slash commands, these utility commands help with specific workflow tasks. To install any of these, create the corresponding `.md` file in `.claude/commands/`.

### /plan - Implementation Planning

Creates structured implementation plans before coding. Best for T2/T3 tasks.

```
/plan Create an implementation plan for [feature description].
Requirements: [list requirements]
Constraints: [list constraints]
Reference: @relevant/files for existing patterns
```

**Installation:** Create `.claude/commands/plan.md` with the instruction sheet from [`agents/planner-agent.md`](../agents/planner-agent.md)

---

### /build-fix - Build Error Resolution

Diagnoses and fixes build failures, CI/CD errors, and dependency issues.

```
/build-fix Diagnose and fix the build failure.
Error output: [paste error or reference @terminal]
Context: [what changed, what command was run]
```

**Installation:** Create `.claude/commands/build-fix.md` with the instruction sheet from [`agents/build-error-resolver-agent.md`](../agents/build-error-resolver-agent.md)

---

### /test-writer - Test Writing (TDD-friendly)

Use the Test Writer agent for test-first or TDD-style workflows. The agent writes tests only and pauses for review before finalizing.

```
/test-writer Write tests for @path/to/file.py lines X-Y.
Reference [Jira ticket or acceptance criteria].
Add coverage for happy paths, [edge cases], [error conditions],
and a catch-all for unexpected behavior.
```

**Installation:** Create `.claude/commands/test-writer.md` with the instruction sheet from [`agents/test-writer-agent.md`](../agents/test-writer-agent.md)

---

### /checkpoint - Workflow Savepoint

Creates a savepoint documenting current progress, decisions made, and next steps. Useful for context preservation across sessions.

```
/checkpoint Save progress on [ticket/feature].
Document: current state, decisions made, blockers, next steps.
```

**Installation:** Create `.claude/commands/checkpoint.md` with the instruction sheet from [`agents/checkpoint-agent.md`](../agents/checkpoint-agent.md)


---

### /verify - Implementation Verification

Runs verification checks after implementation: tests pass, linting clean, builds succeed, acceptance criteria met.

```
/verify Verify implementation for [ticket/feature].
Acceptance criteria: [list or reference ticket]
Check: tests, lint, build, [specific concerns]
```

**Installation:** Create `.claude/commands/verify.md` with the instruction sheet from [`agents/verify-agent.md`](../agents/verify-agent.md).

---

## Experimental Orchestration Commands

These commands are under evaluation and should be piloted on complex tasks before broad rollout.

### /orchestrate - Multi-Agent Workflow Coordination

Coordinates a structured chain of specialized agents with handoff documents between each stage.

```
/orchestrate feature "Add user authentication"
/orchestrate bugfix "Fix checkout timeout in payment flow"
```

**Installation:** Create `.claude/commands/orchestrate.md` with the instruction sheet from [`agents/orchestrator-agent.md`](../agents/orchestrator-agent.md)

---

### /multi-plan - Multi-Model Collaborative Planning

Creates a planning-only implementation plan using collaborative analysis, then saves the plan to `.claude/plan/`.

```
/multi-plan Plan migration from session auth to JWT for API and frontend.
Include rollout steps, fallback strategy, and test approach.
```

**Installation:** Create `.claude/commands/multi-plan.md` with the instruction sheet from [`agents/multi-plan-agent.md`](../agents/multi-plan-agent.md)

For rollout guidance and adoption constraints, see [`docs/09-experimental-techniques.md`](09-experimental-techniques.md).

---

## Design + Dev + AI Handoff (Figma)

For design-driven workflows (Figma MCP, UIkit, WP modules/pages), use the shared handoff standards in:

> [`docs/10-design-handoff.md`](10-design-handoff.md)

This includes Figma prep rules, asset/SVG policies, prompt templates, and boilerplate-first guidance.

---

## Language-Specific Prompt Extensions (Optional)

In addition to project-specific CLAUDE.md instructions, you can add language- or framework-specific rules to your `/CLAUDE.md` file. These help standardise coding patterns, reduce common mistakes, and provide a stronger baseline when working in unfamiliar territory.

**How to apply:**
1. Identify the relevant framework or language patterns for your project
2. In `/CLAUDE.md`, add a `## Language-Specific Rules` section with the appropriate conventions

**Internal observations:**
- Developers with strong domain experience tend to see limited added value from these extensions
- The biggest benefit is when working **outside your primary domain** - e.g. a backend developer building frontend components
- In those cases, the instruction sheets act as guardrails for conventions, reminders of common pitfalls, and a quick way to align AI outputs to the expected ecosystem patterns


