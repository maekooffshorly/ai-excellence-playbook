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
| Coding Companion | Claude Code (VS Code extension + agentic workflows) |
| Primary LLM | Claude Sonnet 4.6 (T1–T3) / Claude Opus 4.5 (complex T3) |
| MCPs | SonarQube, Context7, Figma *(frontend only)* |

### Why This Toolset

Claude Code provides the best balance of agentic capability and cost efficiency for SWE work. It understands your entire repo, handles multi-file changes naturally, and integrates with MCPs for quality checks and library standards. The VS Code extension brings these capabilities directly into your IDE workflow.

Claude Sonnet 4.6 is now the primary model for most SWE work — it offers near-Opus capability at Sonnet pricing. Claude Opus 4.5 remains the choice for complex T3 tasks requiring deep reasoning. **Opus can be overkill for small changes, maintenance work, and mature codebases** — see the model guidance below.

### Model Guidance

| Experience Level | Observation |
|-----------------|-------------|
| Junior developers | Tend to see larger productivity gains from stronger models (Opus) on T3 tasks |
| Experienced developers | Often see smaller marginal gains from Opus vs. Sonnet, where clarity of requirements and local context matters more than raw model output |

**The takeaway:** Model selection should be based on task complexity, expected risk, and local context requirements — not simply choosing the "best model available."

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

These agents extend the workflow beyond code generation into testing, review, and documentation. All three are built on Claude Sonnet 4.6 and use SonarQube and/or Context7 MCPs. In Claude Code, agents are invoked via slash commands.

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

**Model:** Claude Sonnet 4.6
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

## Additional Slash Commands

Beyond the agent slash commands, these utility commands help with specific workflow tasks. To install any of these, create the corresponding `.md` file in `.claude/commands/`.

### /plan — Implementation Planning

Creates structured implementation plans before coding. Best for T2/T3 tasks.

```
/plan Create an implementation plan for [feature description].
Requirements: [list requirements]
Constraints: [list constraints]
Reference: @relevant/files for existing patterns
```

**Installation:** Create `.claude/commands/plan.md` with the instruction sheet from [`agents/planner-agent.md`](../agents/planner-agent.md)

---

### /build-fix — Build Error Resolution

Diagnoses and fixes build failures, CI/CD errors, and dependency issues.

```
/build-fix Diagnose and fix the build failure.
Error output: [paste error or reference @terminal]
Context: [what changed, what command was run]
```

**Installation:** Create `.claude/commands/build-fix.md` with the instruction sheet from [`agents/build-error-resolver-agent.md`](../agents/build-error-resolver-agent.md)

---

### /tdd — Test-Driven Development

Structures a TDD workflow: write failing tests first, then implement to make them pass.

```
/tdd Implement [feature] using TDD.
Start with failing tests for: [scenarios]
Reference: @path/to/related/code for patterns
```

**Installation:** Create `.claude/commands/tdd.md`:

````markdown
---
name: tdd
description: Guides test-driven development workflow — write failing tests first, then implement.
---

You are a TDD GUIDE helping the user follow test-driven development.

## TDD Workflow

1. **Red**: Write a failing test for the next piece of functionality
2. **Green**: Write the minimum code to make the test pass
3. **Refactor**: Clean up the code while keeping tests green
4. Repeat

## Rules

- ALWAYS write the test first, before any implementation
- Tests should fail for the right reason (testing the right thing)
- Implementation should be minimal — just enough to pass
- Refactor only when tests are green
- Each cycle should be small (5-10 minutes)

## Your Role

1. Help the user write a failing test for the requested functionality
2. Verify the test fails for the right reason
3. Guide implementation to make it pass
4. Suggest refactoring opportunities
5. Move to the next test

Present tests using the project's existing test patterns and conventions.
````

---

### /checkpoint — Workflow Savepoint

Creates a savepoint documenting current progress, decisions made, and next steps. Useful for context preservation across sessions.

```
/checkpoint Save progress on [ticket/feature].
Document: current state, decisions made, blockers, next steps.
```

**Installation:** Create `.claude/commands/checkpoint.md`:

````markdown
---
name: checkpoint
description: Creates a savepoint documenting progress, decisions, and next steps for context preservation.
---

You are creating a CHECKPOINT to preserve context and progress.

## What to Capture

1. **Current State**: What's been completed, what's in progress
2. **Files Modified**: List of files changed in this session
3. **Decisions Made**: Key technical decisions and their rationale
4. **Blockers/Questions**: Anything that needs resolution
5. **Next Steps**: Prioritized list of what to do next

## Output Format

---

## Checkpoint: {Feature/Ticket} — {Date}

### Progress Summary
{2-3 sentences on current state}

### Completed
- [ ] {What's done}

### In Progress
- [ ] {What's partially done}

### Files Modified
- `{path}` — {what changed}

### Key Decisions
| Decision | Rationale |
|----------|-----------|
| {What was decided} | {Why} |

### Blockers / Open Questions
- {Issues needing resolution}

### Next Steps
1. {Priority 1}
2. {Priority 2}

---

Save this checkpoint to a file or commit message for reference.
````

---

### /verify — Implementation Verification

Runs verification checks after implementation: tests pass, linting clean, builds succeed, acceptance criteria met.

```
/verify Verify implementation for [ticket/feature].
Acceptance criteria: [list or reference ticket]
Check: tests, lint, build, [specific concerns]
```

**Installation:** Create `.claude/commands/verify.md`:

````markdown
---
name: verify
description: Runs verification checks after implementation — tests, lint, build, acceptance criteria.
---

You are a VERIFICATION AGENT ensuring implementation is complete and correct.

## Verification Checklist

Run through these checks systematically:

### 1. Tests
- [ ] All existing tests pass
- [ ] New tests added for new functionality
- [ ] Test coverage is adequate for changes

### 2. Linting & Formatting
- [ ] No linting errors
- [ ] Code formatted according to project standards

### 3. Build
- [ ] Project builds successfully
- [ ] No TypeScript/compilation errors
- [ ] No new warnings introduced

### 4. Acceptance Criteria
- [ ] Each acceptance criterion verified
- [ ] Edge cases handled
- [ ] Error handling in place

### 5. Documentation
- [ ] Code comments for complex logic
- [ ] API docs updated if applicable
- [ ] README updated if needed

## Output Format

Present a verification report:

---

## Verification Report: {Feature/Ticket}

### Summary
{Pass/Fail with brief explanation}

### Checklist Results

| Check | Status | Notes |
|-------|--------|-------|
| Tests | ✅/❌ | {Details} |
| Lint | ✅/❌ | {Details} |
| Build | ✅/❌ | {Details} |
| Acceptance | ✅/❌ | {Details} |

### Issues Found
- {Any problems that need addressing}

### Ready for PR?
{Yes/No with explanation}

---
````

---

## Language-Specific Prompt Extensions (Optional)

In addition to project-specific CLAUDE.md instructions, you can add language- or framework-specific rules to your `/CLAUDE.md` file. These help standardise coding patterns, reduce common mistakes, and provide a stronger baseline when working in unfamiliar territory.

**How to apply:**
1. Identify the relevant framework or language patterns for your project
2. In `/CLAUDE.md`, add a `## Language-Specific Rules` section with the appropriate conventions

**Internal observations:**
- Developers with strong domain experience tend to see limited added value from these extensions
- The biggest benefit is when working **outside your primary domain** — e.g. a backend developer building frontend components
- In those cases, the instruction sheets act as guardrails for conventions, reminders of common pitfalls, and a quick way to align AI outputs to the expected ecosystem patterns
