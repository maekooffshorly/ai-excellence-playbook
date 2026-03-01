# AI Model Comparison

This document extends the model comparison table in the README with deeper guidance on model selection — when to switch models mid-task, how experience level affects the decision, and edge cases worth knowing.

For the quick-reference table, see the [README](../README.md#ai-model-comparison).

---

## Model Profiles

### Claude Opus 4.5

**Tier:** T3
**Cost:** $5 / $25 per 1M tokens (input / output)

The top-tier Claude model and the primary choice for high-complexity SWE work. Its strength is in reasoning through ambiguity — when requirements are incomplete, when a bug is hard to reproduce, or when a decision has downstream architectural consequences, Opus tends to produce more careful, considered output than lighter models.

**Use when:**
- Designing system architecture or making decisions that are hard to reverse
- Debugging complex, cross-cutting issues with no obvious reproduction path
- Undertaking large refactors or migrations where dependency mapping matters
- Working on T3 tasks where junior developers are involved — they tend to see larger productivity gains from Opus on these tasks

**Avoid when:**
- The task is a small bugfix, minor enhancement, or maintenance change on a mature codebase
- You're doing T1 work — documentation, unit tests, small utility functions
- Cost is a constraint and the task doesn't warrant it

**Note on experienced developers:** More senior developers often see smaller marginal gains from Opus over Sonnet on T2 tasks, because at that level, clarity of requirements and strong local context matters more than raw model capability. If you're finding Opus isn't adding much, try Sonnet first.

---

### Claude Sonnet 4.5

**Tier:** T1–T2
**Cost:** $3 / $15 per 1M tokens (input / output)

The daily driver for most SWE work. Best cost-to-performance balance in the lineup — fast enough for day-to-day use, capable enough for most feature tickets and moderate refactors. All three agents (Test Writer, Code Reviewer, Documentation) are built on Sonnet for this reason.

**Use when:**
- Handling most feature tickets and standard development work
- Running the agent pipeline (Test Writer, Code Reviewer, Documentation)
- Doing moderate refactors where the scope is well-defined
- Generating PR-ready drafts, fixes, and inline documentation

**Avoid when:**
- The task involves genuine architectural ambiguity or deep cross-dependency reasoning — step up to Opus
- The output quality consistently feels insufficient for the complexity of the work

---

### GPT 5.2

**Tier:** T2–T3
**Cost:** $1.75 / $14 per 1M tokens (input / output)

OpenAI's flagship in the GPT-5 family. Strong general capability and notably good at tool and agent workflows. Better cost-per-token than Opus at the top tier, and faster at producing implementation output.

**Use when:**
- Building MVPs quickly where iteration speed matters more than depth of reasoning
- Running multi-step coding tasks with tool/agent integrations
- Mixed tasks that combine coding, documentation, and test generation in one pass

**Watch out for:**
- GPT 5.2 can be overconfident — it produces plausible, well-formatted output that may contain subtle logic errors. Validation gates (tests, linters, review) are non-negotiable
- Cost and usage limits depend on your plan tier

**On GPT 5.2 vs. Claude Opus 4.5:** GPT 5.2 is stronger as a general-purpose base model, but Claude Opus 4.5 remains the better companion specifically for software development work. GPT 5.2 excels at higher-capacity general-purpose tasks; Opus excels at the structured, context-heavy reasoning that SWE work demands. This balance will be reassessed as both models evolve.

---

### GPT 5.1

**Tier:** T1–T2
**Cost:** $1.25 / $10 per 1M tokens (input / output)

The everyday option in the GPT-5 family. Cheaper and faster than GPT 5.2, with solid coding assistance for standard work. A reasonable alternative to Sonnet for T1–T2 tasks if you're already in a GPT-heavy workflow.

**Use when:**
- Standard feature development with quick turnaround requirements
- Debugging with a tight feedback loop
- Test scaffolding and cleanup work

**Avoid when:**
- The task involves the hardest architecture decisions — reliability drops at that level
- You need consistent output quality across a complex, multi-file change

---

### Gemini 3 Pro

**Tier:** T2–T3
**Cost:** $2 / $12 per 1M tokens (input / output)

Google's Pro-tier model with a very large context window and strong multimodal reasoning. Theoretically well-suited for large-repo comprehension and multi-document synthesis, but currently limited by an extremely low usage cap that makes it impractical for regular use.

**Use when (cap permitting):**
- You need to reason across a large volume of code or documentation in a single pass
- Synthesizing long specs or multi-document requirements into a plan
- Multimodal debugging — e.g. using screenshots or diagrams as part of the context

**Current limitation:** Usage cap is extremely low and makes this model nearly unusable for team workflows as of this writing. Monitor for changes before adopting it in any regular workflow.

---

## Decision Guide

Use this to quickly map a task to the right model:

| Task Type | Recommended Model | Notes |
|-----------|------------------|-------|
| System design, architecture decisions | Claude Opus 4.5 | Ambiguity handling and reasoning depth matters here |
| Complex refactor or migration | Claude Opus 4.5 | Dependency mapping and phased planning |
| Hard-to-reproduce bug | Claude Opus 4.5 | Cross-cutting investigation benefits from stronger reasoning |
| Most feature tickets | Claude Sonnet 4.5 | Best cost/performance for standard work |
| Agent pipeline (Test Writer, Code Reviewer, Docs) | Claude Sonnet 4.5 | All three agents are built on this model |
| Moderate refactor, well-defined scope | Claude Sonnet 4.5 | Step up to Opus if scope expands |
| MVP build, iteration speed priority | GPT 5.2 | Validate output carefully |
| Multi-step agentic workflow | GPT 5.2 | Strong tool/agent integration |
| Standard feature dev, quick turnaround | GPT 5.1 | Cheaper alternative for T1–T2 |
| Large-repo or multi-doc comprehension | Gemini 3 Pro | Only if usage cap allows |

---

## Model Selection Principles

These apply regardless of which model you're choosing:

**Match the model to the task, not to your preference.** Defaulting to the strongest available model wastes cost and often produces over-engineered output for simple tasks.

**Experience level matters.** Junior developers tend to get more from stronger models on T3 tasks — the model compensates for gaps in domain knowledge. Experienced developers often get similar or better results from Sonnet because they can provide clearer requirements and better local context.

**Validate regardless of model.** No model produces production-ready output without tests, linters, and review. Stronger models reduce the frequency of errors; they don't eliminate them.

**Reassess as models evolve.** The comparisons in this document reflect the state of these models at the time of writing. The relative strengths of GPT 5.2 and Claude Opus 4.5 in particular will shift as both are updated. Treat this as a living reference.
