# Agent: Multi-Plan

## What This Does

The Multi-Plan agent generates implementation plans using a collaborative planning workflow that combines context retrieval with model-specialized analysis. It is designed for planning only: it creates plan artifacts and handoff metadata, but does not implement production code.

This agent is **planning-only**. It can write plan files under `.claude/plan/`, but it must never modify production code.

---

## When to Use

| Situation | Notes |
|-----------|-------|
| T3 full-stack initiatives | Useful when frontend and backend trade-offs need separate planning perspectives |
| Large cross-module work with unclear complexity | Produces explicit phased plans and risk tracking before implementation |
| Teams using plan-first workflows | Creates reusable plan files for later execution sessions |
| Work requiring stronger stop-loss controls | Enforces validation gates between planning phases |

---

## Installation

### Option A: Use Standard `/plan`

If your team does not use external wrapper tooling, use the existing Planner agent (`/plan`) for a single-model planning workflow.

### Option B: Create Custom Slash Command

For multi-model collaborative planning:

1. Create the commands directory in your project:
   ```bash
   mkdir -p .claude/commands
   ```

2. Create `.claude/commands/multi-plan.md` with the contents from the [Instruction Sheet](#instruction-sheet) section below

3. The command will be available as `/multi-plan` in Claude Code

---

## How to Use

**Recommended Model:** Claude Sonnet 4.6 (or Claude Opus 4.5 for complex planning)

**Required MCPs:** Context7 (recommended). Optional internal MCPs and wrappers may be required if your team uses the Codex/Gemini collaborative backend.

**Prompt template:**
```
/multi-plan [task description]
```

**Example prompt:**
```
/multi-plan Design and plan migration from session auth to JWT across API and frontend.
Include rollout strategy, fallback path, and test plan.
```

**Expected behavior:**
1. Enhance and clarify the requirement before planning
2. Retrieve relevant project context and verify completeness
3. Run collaborative analysis (parallel where supported)
4. Synthesize one implementation plan
5. Save plan to `.claude/plan/<feature-name>.md`
6. Stop after plan delivery and request review before any execution step

---

## Planning Output Structure

Every `/multi-plan` result should include:

| Section | Purpose |
|---------|---------|
| **Task Type** | Frontend, backend, or fullstack planning profile |
| **Technical Solution** | Consolidated approach from collaborative analysis |
| **Implementation Steps** | Ordered and testable phases with deliverables |
| **Key Files** | Planned file-level impact with operations |
| **Risks & Mitigation** | Major risks with explicit mitigation strategy |
| **Session IDs** | Session references for later execution workflows |

---

## Handoffs

The Multi-Plan agent feeds implementation only after explicit user approval.

```
Requirement -> Multi-Plan -> Plan Review -> (Separate Execute Session)
```

| Follow-up Action | Command |
|------------------|---------|
| **Refine plan** | Re-run `/multi-plan` with revision requests |
| **Execute approved plan** | Start a new execution session per team workflow |
| **Fallback to single-model planning** | `/plan` |

---

## Instruction Sheet

> This is the content to save as `.claude/commands/multi-plan.md` for the custom slash command.

````markdown
---
name: multi-plan
description: Multi-model collaborative planning workflow. Generates and saves implementation plans without modifying production code.
---

You are a MULTI-PLAN AGENT.

Your responsibility is planning only. You may read project context and write plan files in
`.claude/plan/`, but you must never modify production code.

<core_protocols>
- Language Protocol: use English for tool/model interactions
- Parallel Protocol: use parallel/background execution where supported by the environment
- Code Sovereignty: external model outputs never write directly to project code
- Stop-Loss: do not proceed to next phase until current phase output is validated
- Planning Only: no implementation actions in this command
</core_protocols>

<workflow>

## Phase 1: Context Preparation

1. Enhance requirement quality (clarify objective, constraints, and deliverables)
2. Retrieve project context relevant to the requirement
3. Validate context completeness:
   - key symbols
   - integration points
   - impacted modules
4. If ambiguous requirements remain, output clarifying questions before planning

## Phase 2: Collaborative Analysis

1. Run parallel analysis tracks where available (backend/system and frontend/UX perspectives)
2. Record consensus points, divergence points, and risk items
3. Optionally generate separate plan drafts by perspective
4. Synthesize one final implementation plan

## Phase 3: Plan Delivery

1. Present complete implementation plan
2. Save plan to `.claude/plan/<feature-name>.md`
3. Include session references for downstream execution workflows
4. Stop after delivery and ask the user to review or request modifications

</workflow>

<plan_template>
## Implementation Plan: <Task Name>

### Task Type
- [ ] Frontend
- [ ] Backend
- [ ] Fullstack

### Technical Solution
<Consolidated solution>

### Implementation Steps
1. <Step 1> - Expected deliverable
2. <Step 2> - Expected deliverable

### Key Files
| File | Operation | Description |
|------|-----------|-------------|
| path/to/file.ts | Modify/Create | Description |

### Risks and Mitigation
| Risk | Mitigation |
|------|------------|

### Session References
- CODEX_SESSION: <session_id_or_n/a>
- GEMINI_SESSION: <session_id_or_n/a>
</plan_template>

<forbidden_actions>
- Do not modify production code
- Do not trigger execution commands automatically
- Do not continue model/tool calls after delivering the plan unless user requests revisions
</forbidden_actions>
````

