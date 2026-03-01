# AI Model Comparison

This document extends the model comparison table in the README with deeper guidance on model selection — when to switch models mid-task, how experience level affects the decision, and edge cases worth knowing.

For the quick-reference table, see the [README](../README.md#ai-model-comparison).

---

## Model Profiles

### Claude Opus 4.6 (not recommended)

**Tier:** T3
**Cost:** $5 / $25 per 1M tokens (input / output)

The latest flagship Claude model with a 1M token context window (beta) and 128K output tokens. Benchmarks show improvements in coding, planning, and agentic task execution. However, real-world SWE usage has revealed inconsistencies — the model can tangent away from the initial prompt and lose context more readily than its predecessor, sometimes hallucinating outside of initial instructions even with well-structured prompts.

**Use when:**
- Tasks requiring the largest context window (1M tokens)
- You need extended output length (128K tokens)
- Experimental agentic workflows where you can closely monitor output

**Avoid when:**
- You need reliable, focused execution on the initial prompt — Opus 4.5 or Sonnet 4.6 may be more consistent
- Working on tasks where staying on-track matters more than raw capability
- Cost is a concern and you don't need the extended context

**Internal observation:** Despite benchmark improvements, Opus 4.6 has shown degraded real-world SWE performance compared to 4.5 in our testing. The model tends to drift from the original task and can hallucinate solutions outside the provided context. For most T3 SWE work, **Opus 4.5 or Sonnet 4.6 are currently more reliable choices**.

---

### Claude Opus 4.5

**Tier:** T3
**Cost:** $5 / $25 per 1M tokens (input / output)

The previous top-tier Claude model and still the most reliable choice for high-complexity SWE work requiring focused reasoning. Its strength is in reasoning through ambiguity — when requirements are incomplete, when a bug is hard to reproduce, or when a decision has downstream architectural consequences, Opus 4.5 produces more careful, considered output than lighter models.

**Use when:**
- Designing system architecture or making decisions that are hard to reverse
- Debugging complex, cross-cutting issues with no obvious reproduction path
- Undertaking large refactors or migrations where dependency mapping matters
- Working on T3 tasks where junior developers are involved — they tend to see larger productivity gains from Opus on these tasks
- You need reliable, on-task execution without drift

**Avoid when:**
- The task is a small bugfix, minor enhancement, or maintenance change on a mature codebase
- You're doing T1 work — documentation, unit tests, small utility functions
- Cost is a constraint and the task doesn't warrant it

**Note on experienced developers:** More senior developers often see smaller marginal gains from Opus over Sonnet on T2 tasks, because at that level, clarity of requirements and strong local context matters more than raw model capability. If you're finding Opus isn't adding much, try Sonnet first.

**Note on Opus 4.6:** While 4.6 has higher benchmarks, 4.5 remains the recommended Opus version for SWE work due to its more consistent, focused execution.

---

### Claude Sonnet 4.6 (most recommended)

**Tier:** T1–T3
**Cost:** $3 / $15 per 1M tokens (input / output)

The standout model of the 4.6 release cycle. Sonnet 4.6 achieves 79.6% on SWE-bench Verified — within 1-2 points of Opus 4.6 on coding benchmarks while maintaining Sonnet-tier cost. In Claude Code testing, users preferred Sonnet 4.6 over Sonnet 4.5 roughly 70% of the time, and even preferred it to Opus 4.5 59% of the time due to less overengineering, fewer false claims of success, and better follow-through on multi-step tasks.

**Use when:**
- Most SWE work across all tiers — it's now capable enough for T3 tasks that previously required Opus
- Running the agent pipeline (Test Writer, Code Reviewer, Documentation)
- Agentic workflows requiring lead agent or subagent roles
- Full codebase analysis in a single prompt (first Sonnet to support this)
- Computer use and browser automation tasks

**Avoid when:**
- You specifically need the 1M context window (Opus 4.6 only)
- You need 128K output tokens (Opus 4.6 only)

**Key improvements over Sonnet 4.5:**
- More effectively reads context before modifying code
- Consolidates shared logic rather than duplicating it
- Less prone to "laziness" and overengineering
- Fewer hallucinations and better follow-through on multi-step tasks
- First Sonnet-class model to support full codebase analysis in a single prompt

**Internal observation:** Sonnet 4.6 is now the recommended model for most SWE work. It offers near-Opus capability at Sonnet pricing, with more reliable execution than Opus 4.6.

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

**Deprecation notice:** Gemini 3 Pro is scheduled to be deprecated on March 9th, 2026. Teams should migrate to Gemini 3.1 Pro before this date.

---

### Gemini 3.1 Pro

**Tier:** T2–T3
**Cost:** $2.50 / $15 per 1M tokens (input / output)

Google's latest flagship in the Gemini family. Released February 2026 with significant improvements over 3 Pro — notably 80.6% on SWE-bench Verified (single attempt) and doubled reasoning performance on ARC-AGI-2. Strong agentic performance and 1M token context window make it competitive for large-repo work, though usage caps remain a consideration.

**Use when:**
- Large-repo comprehension tasks where you need to reason across many files
- Agentic workflows with terminal and tool integration
- Multimodal debugging with screenshots, diagrams, or video context
- Scientific or research coding requiring cross-domain synthesis

**Avoid when:**
- Usage caps would interrupt your workflow
- You need consistent, predictable output for production code — Claude models are still more reliable
- The task is standard feature work that doesn't benefit from the large context window

**Comparison to Gemini 3 Pro:** 3.1 Pro shows up to 15% improvement across benchmarks, requires fewer output tokens for equivalent results, and has substantially improved 3D transformation reasoning. For teams already using Gemini 3 Pro, 3.1 is a direct upgrade.

**Current limitation:** While usage caps have improved since 3 Pro, they still constrain heavy use. Available through Google AI Pro/Ultra plans, Vertex AI, and NotebookLM (Pro/Ultra only).

---

## Decision Guide

Use this to quickly map a task to the right model:

| Task Type | Recommended Model | Notes |
|-----------|------------------|-------|
| Most SWE work (T1–T3) | Claude Sonnet 4.6 | New default — near-Opus capability at Sonnet cost |
| System design, architecture decisions | Claude Opus 4.5 | Ambiguity handling and reasoning depth matters here |
| Complex refactor or migration | Claude Opus 4.5 | Dependency mapping and phased planning |
| Hard-to-reproduce bug | Claude Opus 4.5 or Sonnet 4.6 | Both strong; Sonnet 4.6 often sufficient |
| Agent pipeline (Test Writer, Code Reviewer, Docs) | Claude Sonnet 4.6 | Preferred over 4.5 for better follow-through |
| Agentic workflows (lead/subagent roles) | Claude Sonnet 4.6 | Strong multi-step execution |
| Full codebase analysis | Claude Sonnet 4.6 | First Sonnet to support this |
| MVP build, iteration speed priority | GPT 5.2 | Validate output carefully |
| Multi-step agentic workflow | GPT 5.2 | Strong tool/agent integration |
| Standard feature dev, quick turnaround | GPT 5.1 | Cheaper alternative for T1–T2 |
| Large-repo or multi-doc comprehension | Gemini 3.1 Pro | Best-in-class context window; watch usage caps |
| Multimodal debugging (screenshots, diagrams) | Gemini 3.1 Pro | Strong visual reasoning |

---

## Model Selection Principles

These apply regardless of which model you're choosing:

**Match the model to the task, not to your preference.** Defaulting to the strongest available model wastes cost and often produces over-engineered output for simple tasks.

**Experience level matters.** Junior developers tend to get more from stronger models on T3 tasks — the model compensates for gaps in domain knowledge. Experienced developers often get similar or better results from Sonnet because they can provide clearer requirements and better local context.

**Validate regardless of model.** No model produces production-ready output without tests, linters, and review. Stronger models reduce the frequency of errors; they don't eliminate them.

**Reassess as models evolve.** The comparisons in this document reflect the state of these models at the time of writing. The relative strengths of GPT 5.2 and Claude Opus 4.5 in particular will shift as both are updated. Treat this as a living reference.
