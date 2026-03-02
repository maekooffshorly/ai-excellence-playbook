# Agent: Orchestrator

## What This Does

The Orchestrator agent coordinates sequential or mixed workflows across multiple specialized agents for complex tasks. It defines workflow order, creates structured handoff documents between stages, and produces one consolidated orchestration report at the end.

This agent is a workflow coordinator. It should not replace the domain reasoning done by Planner, Architect, Code Reviewer, Security Reviewer, or Test Writer workflows.

---

## When to Use

| Situation | Notes |
|-----------|-------|
| T3 features needing planning, quality, and security in one flow | Avoids ad hoc stage ordering and missing handoffs |
| Risky refactors touching multiple components | Forces explicit architecture/review checkpoints |
| Security-sensitive delivery (auth, payments, PII) | Makes security review first-class in the sequence |
| Multi-step tasks where context gets lost between prompts | Uses handoff documents to keep context stable |

---

## Installation

### Option A: Manual Coordination Prompting

You can coordinate agents manually in a normal Claude Code chat by invoking each stage and writing handoff notes after each pass.

### Option B: Create Custom Slash Command

For the full Orchestrator experience with a fixed report format:

1. Create the commands directory in your project:
   ```bash
   mkdir -p .claude/commands
   ```

2. Create `.claude/commands/orchestrate.md` with the contents from the [Instruction Sheet](#instruction-sheet) section below

3. The command will be available as `/orchestrate` in Claude Code

---

## How to Use

**Recommended Model:** Claude Sonnet 4.6 or Claude Opus 4.5 (complex T3)

**Required MCPs:** Context7 (recommended), SonarQube (recommended when security/code review stages are included)

**Prerequisites:**
- The agents used in your workflow must exist and be usable in the user or local repository context (for example, `agents/planner-agent.md`, `agents/architect-agent.md`, `agents/code-reviewer-agent.md`, `agents/security-reviewer-agent.md`, `agents/test-writer-agent.md`).
- If an agent is missing, install or copy it into your project before running orchestration.

**Prompt template:**
```
/orchestrate [workflow-type] [task description]
```

**Workflow types:**

| Type | Sequence |
|------|----------|
| `feature` | planner -> test-writer -> code-reviewer -> security-reviewer |
| `bugfix` | planner -> test-writer -> code-reviewer |
| `refactor` | architect -> code-reviewer -> test-writer |
| `security` | security-reviewer -> code-reviewer -> architect |
| `custom` | user-specified sequence |

**Example prompts:**
```
/orchestrate feature "Add user authentication"
/orchestrate bugfix "Fix intermittent checkout timeout"
/orchestrate custom "architect,test-writer,code-reviewer" "Redesign caching layer"
```

---

## Handoff Document Format

Use this format between every stage in the workflow:

```markdown
## HANDOFF: [previous-agent] -> [next-agent]

### Context
[Summary of what was done]

### Findings
[Key discoveries or decisions]

### Files Modified
[List of files touched]

### Open Questions
[Unresolved items for next agent]

### Recommendations
[Suggested next steps]
```

---

## Final Report Format

At the end of orchestration, provide one consolidated report:

```markdown
ORCHESTRATION REPORT
====================
Workflow: [workflow type]
Task: [task description]
Agents: [executed sequence]

SUMMARY
-------
[One paragraph summary]

AGENT OUTPUTS
-------------
[Per-agent summary]

FILES CHANGED
-------------
[List all files modified]

TEST RESULTS
------------
[Test pass/fail summary]

SECURITY STATUS
---------------
[Security findings]

RECOMMENDATION
--------------
[SHIP / NEEDS WORK / BLOCKED]
```

---

## Handoffs

The Orchestrator agent sits above other agents and coordinates their execution order.

```
Task Request -> Orchestrator -> Specialized Agent Chain -> Consolidated Report -> PR Decision
```

| Follow-up Action | Command |
|------------------|---------|
| **Run verification before merge** | `/verify` |
| **Save progress checkpoint** | `/checkpoint` |
| **Re-run one stage only** | Invoke target stage command directly |

---

## Instruction Sheet

> This is the content to save as `.claude/commands/orchestrate.md` for the custom slash command.

````markdown
---
name: orchestrate
description: Coordinates a multi-agent workflow with structured handoffs and a consolidated final report.
---

You are an ORCHESTRATOR AGENT.

Your job is to coordinate specialized agents in a structured workflow. You do not replace
specialized reasoning from planner, architect, test-writer, code-reviewer, or security-reviewer.

<workflow_types>
feature: planner -> test-writer -> code-reviewer -> security-reviewer
bugfix: planner -> test-writer -> code-reviewer
refactor: architect -> code-reviewer -> test-writer
security: security-reviewer -> code-reviewer -> architect
custom: user-defined sequence
</workflow_types>

<execution_rules>
1. Parse arguments as: /orchestrate [workflow-type] [task description]
2. Resolve workflow sequence from <workflow_types>
3. For each stage:
   - Invoke the stage with current task context
   - Capture stage output
   - Generate handoff document for next stage
4. After final stage, produce one consolidated orchestration report
5. If workflow-type is invalid, return supported workflow types and usage examples
</execution_rules>

<handoff_template>
## HANDOFF: [previous-agent] -> [next-agent]

### Context
[Summary of what was done]

### Findings
[Key discoveries or decisions]

### Files Modified
[List of files touched]

### Open Questions
[Unresolved items for next agent]

### Recommendations
[Suggested next steps]
</handoff_template>

<report_template>
ORCHESTRATION REPORT
====================
Workflow: [workflow type]
Task: [task description]
Agents: [executed sequence]

SUMMARY
-------
[One paragraph summary]

AGENT OUTPUTS
-------------
[Per-agent summary]

FILES CHANGED
-------------
[List all files modified]

TEST RESULTS
------------
[Test pass/fail summary]

SECURITY STATUS
---------------
[Security findings]

RECOMMENDATION
--------------
[SHIP / NEEDS WORK / BLOCKED]
</report_template>

<quality_rules>
- Keep handoffs concise and actionable
- Preserve unresolved questions for the next stage
- Do not skip code-reviewer in feature, bugfix, or refactor flows
- For auth/payment/PII tasks, strongly prefer including security-reviewer
- If a stage fails due to missing context, pause and ask for required context before continuing
</quality_rules>
````

