# Experimental Techniques

This document covers techniques currently under evaluation before they are recommended as standard team workflows. Use these only when task complexity justifies the coordination overhead.

For established patterns, see [Basic Techniques](08-basic-techniques.md) and [Advanced Techniques](06-advanced-techniques.md).

---

## Multi-Agent Orchestration

Multi-agent orchestration coordinates specialized agents in a single workflow, with explicit handoffs between each stage.

**Status:** Under evaluation - not yet recommended as default workflow.

> **Note:** For the standard (non-experimental) quality pipeline, see the full pipeline in [`docs/04-coding-techniques.md`](04-coding-techniques.md#the-full-pipeline):
> `Code Complete → Test Writer → Documentation → Code Reviewer → Verify → PR`

### Candidate Command

`/orchestrate`

### When to Pilot

| Situation | Notes |
|-----------|-------|
| T3 features with multiple concerns | Useful when planning, implementation quality, and security need explicit separate passes |
| Refactors with significant blast radius | Allows architecture-first and review-heavy sequencing |
| Security-sensitive deliverables | Adds security review as an explicit stage in the command workflow |

### What We Are Evaluating

- Handoff quality between agents
- Workflow overhead vs. time saved
- Output consistency compared to simpler sequential prompting
- Failure modes when one stage produces low-quality context for the next

---

## Multi-Model Collaborative Planning

Multi-model collaborative planning combines context retrieval and model-specific planning strengths to produce one implementation plan before coding.

**Status:** Under evaluation - planning only workflow.

### Candidate Command

`/multi-plan`

### When to Pilot

| Situation | Notes |
|-----------|-------|
| Full-stack tasks with frontend and backend trade-offs | Useful when different models are used for different strengths |
| Large tasks needing stronger upfront design | Produces structured plans and risk checkpoints before implementation |
| Teams using explicit plan files | Fits workflows that save plans under `.claude/plan/` before execution |

### Guardrails

- Planning only - no production code changes
- Stop-loss validation between phases
- External model calls run without direct write access to project files
- Clear handoff into a separate execution step after plan approval

---

## Experimental Agent References

- [`agents/orchestrator-agent.md`](../agents/orchestrator-agent.md)
- [`agents/multi-plan-agent.md`](../agents/multi-plan-agent.md)

Install those commands only for pilot users and review outputs before expanding usage.

