# Token Saver: Prompt Techniques & Best Practices

## Why Token Budgeting Matters

Every token counts — both for cost and for context window limits. Efficient prompting lets you fit more meaningful content into each request, reduce API costs, and avoid hitting context limits on large tasks.

---

## Core Prompt Techniques

### 1. Be Direct and Specific
Vague prompts invite verbose responses. Precise prompts get precise answers.

- **Instead of:** "Can you explain how authentication works and maybe give some examples?"
- **Use:** "Explain JWT authentication in 3 sentences."

### 2. Set Explicit Output Constraints
Tell the model exactly what format and length you want.

- "Respond in under 100 words."
- "Return only the code, no explanation."
- "Answer in one sentence."

### 3. Use Positive Instructions Over Negative Ones
Negative constraints ("don't include...") still consume tokens to process. Positive framing is more direct.

- **Instead of:** "Don't write an introduction or conclusion."
- **Use:** "Write only the body paragraphs."

### 4. Provide Examples Sparingly (One-Shot Over Few-Shot)
Each example adds tokens. One well-chosen example is often enough for the model to infer the pattern.

### 5. Eliminate Filler and Pleasantries
Phrases like "Please could you kindly help me with..." waste tokens before the actual task even begins. Lead with the task directly.

### 6. Reuse Context via System Prompts
Place stable, reusable instructions in the system prompt rather than repeating them in every user message. This avoids redundant tokens per turn.

### 7. Summarize Long Conversations
In multi-turn sessions, periodically compress prior context into a tight summary. Replace the full history with the summary to reclaim context window space.

### 8. Request Structured Output Judiciously
JSON/XML adds structural tokens (brackets, quotes, tags). Only request structured output when you'll actually parse it programmatically.

---

## File & Document Practices

### 9. Use Plain Text for Plans and Instructions — Not Markdown
When generating plans, instructions, or internal documentation, use plain text instead of Markdown.

Markdown formatting characters (`#`, `**`, `-`, `>`, ` ``` `) appear minor individually but accumulate significantly in large files. A 500-line instruction document with heavy Markdown can carry hundreds of extra tokens that add zero semantic value to the model's understanding.

**Plain text equivalent is just as readable to the model and far more token-efficient:**

```
Instead of:
## Step 1: Setup
**Install dependencies** by running the following:
- Node.js
- npm packages

Use:
Step 1: Setup
Install dependencies: Node.js, npm packages.
```

Reserve Markdown only for final deliverables meant to be rendered and read by humans in a browser or documentation viewer.

---

## Version Control Practices

### 10. Use Git Commands to Fetch Only What You Need
When working with large repositories, avoid loading entire file trees or histories into context. Git's targeted commands let you retrieve the minimum necessary content.

**Fetch/pull selectively:**
```bash
# Fetch a single branch without checking out everything
git fetch origin feature/my-branch

# Pull only a specific branch
git pull origin main

# Shallow clone — fetch only the latest commit, not full history
git clone --depth 1 https://github.com/org/repo.git

# Fetch a single file's history instead of the whole log
git log --oneline --follow -- path/to/file.ts

# Check only changed files between two commits
git diff --name-only HEAD~1 HEAD
```

**Why this reduces tokens:** Pulling full repository histories, all branches, or entire directory trees into a prompt bloats context fast. A full `git log` on an active repo can generate thousands of lines. Targeted fetching means you only include the diff, file, or commit range that is actually relevant to the task.

---

## Quick Reference Checklist

```
[ ] Task stated directly — no filler preamble
[ ] Output length or format explicitly constrained
[ ] Single example used instead of multiple (if needed at all)
[ ] Stable instructions placed in system prompt, not repeated per turn
[ ] Long conversation history summarized or trimmed
[ ] Plans and internal docs written in plain text, not Markdown
[ ] Git fetches scoped to relevant branch, file, or commit range
[ ] Structured output (JSON/XML) only requested when parsed programmatically
[ ] Negative constraints replaced with positive framing where possible
```

---

## Token Cost Mental Model

| Habit | Token Impact |
|---|---|
| Verbose preamble ("Please kindly help me...") | +10–30 tokens wasted per message |
| Full Markdown in large instruction files | +5–15% overhead on document size |
| Loading full git history vs. targeted fetch | Potentially thousands of wasted tokens |
| Repeating system instructions in user turns | Doubles instruction cost per turn |
| Few-shot (3 examples) vs. one-shot (1 example) | 2x–3x example token cost |
| Plain text plan vs. Markdown plan (500 lines) | Saves ~50–150 tokens per document |