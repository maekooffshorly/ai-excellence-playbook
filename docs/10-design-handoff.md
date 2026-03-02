# Design → Dev → AI Handoff

This document defines how design teams prepare Figma files and how devs prompt AI tools for consistent, reliable design-to-code results. It is the shared workflow between Design, Dev, and AI.

For WordPress generation workflows, pair this with the WP Module Builder and WP Page Builder agents.

---

## [WIP] Design Ruleset Coming Soon

> **Work in Progress:** The design team is developing a comprehensive design ruleset/rulebook that will provide detailed guidelines for the following areas:
>
> - Grid system and breakpoints
> - Above-the-fold considerations and lazy loading
> - Padding and spacing standards
> - Placeholder usage
> - UIkit icon utilization
> - Responsive font scales
>
> This section will be updated once the ruleset is finalized. The guidelines below are interim standards.

---

## Design System Source of Truth

Create a dedicated **Branding / Design System** page in Figma and keep it current. This is the source of truth for reusable elements:

- Typography scale and text styles
- Buttons and UI components
- Color palette and tokens
- Grid, spacing, and layout rules
- Header/footer patterns

**Rule:** prefer Figma over PDF for handoff. Figma preserves variables, variants, and component structure.

---

## Figma File Preparation Rules

Use these rules before handing designs to AI or developers:

| Rule | Why |
|------|-----|
| Use consistent, meaningful layer names | AI and devs can reference the correct components quickly |
| Avoid deep nesting | Deep component trees are hard to parse and easy to mis-implement |
| Keep vector complexity low | Complex vectors translate poorly into code |
| Prefer a single combined logo vector | Multi-layer logos often break in translation |
| Use UIkit patterns where possible | Aligns directly with implementation constraints |

### What to Avoid

- Deep nested component meshes
- Complex vector artwork or multi-layer SVGs
- Hover-heavy and smart-animated effects
- Excessive gradients (AI reproduction is inconsistent)

---

## AI-Friendly Design Rules

Design can still use:

- Styles
- Auto layout
- Components and variants

But keep these constraints:

- Avoid overly deep component nesting
- Simplify or flatten layouts when needed
- If necessary, export a merged PNG to simplify complex regions

---

## Asset and SVG Rules

**Strict rules for AI workflows:**

- Export real SVGs from Figma when they exist
- Never ask AI to recreate or invent SVGs
- Use existing approved assets first, UIkit icons second, placeholders last
- Use consistent asset naming when possible (`apple_logo.svg`, `7eleven_logo.svg`)

---

## Handoff Checklist (Design → Dev → AI)

Use this as a required handoff checklist:

| Item | Requirement |
|------|-------------|
| Design system page | Present and current |
| Layer naming | Clear and consistent |
| Assets | Approved icons/logos provided |
| Constraints | Max width, grid rules, header/footer requirements |
| Responsive rules | Breakpoints and menu behavior (e.g., burger menu) |
| Do/Don't list | Explicitly stated (e.g., no SVG generation) |

**If using PDF:** treat it as **basic branding only** (colors, typography). Do not expect component extraction.

---

## Prompting Workflow (Claude Code)

Use a consistent feed → confirm → generate flow:

1. Feed reference / peg and confirm understanding
2. Feed brief and confirm understanding
3. Feed design system and confirm understanding
4. Add explicit specs (width, grid, header/footer, UIkit usage)
5. Generate the page or module

**Tip:** use a prompt-writer (e.g., ChatGPT) to structure the brief, then run that prompt in Claude Code.

---

## Boilerplate-First Strategy

Prefer applying the design system to an existing boilerplate rather than generating from scratch:

- Reduces token waste
- Improves consistency
- Speeds up output

---

## UIkit + Performance Rules

- Always use UIkit grid/components unless explicitly told not to
- Avoid heavy UIkit components above the fold if it causes layout shift (CLS)
- Use critical CSS or minimal CSS for above-the-fold sections when needed
- Default all images to `loading="lazy"`

---

## Multi-Page Generation Technique

Use the homepage as the style anchor:

- Generate a strong homepage first
- For additional pages, reference the homepage style and provide a minimal brief
- Without a brief, AI will generate generic pages

**Minimum brief for non-home pages:**
- Required sections
- Layout intent
- Content bullets

---

## Tool Positioning

- **Figma Make**: best for small static sites and quick design-led generation
- **Claude Code**: better for flexible workflows, maintainability, and complex builds

---

## Reusable Prompt Template

Use this template for consistent handoff prompting:

```
Project: {site or page name}

Reference:
- Figma file: {url}
- Design system page: {url or node id}
- Assets folder: {link or path}

Constraints:
- Max width: {value}
- Grid rules: {value}
- Header/footer: {requirements}
- Responsive rules: {breakpoints, menu behavior}
- UIkit: {required / optional}
- SVGs: do not generate; use exported assets only

Do:
- Use UIkit components first
- Match typography and spacing to design system
- Use existing boilerplate patterns

Don't:
- Invent new SVGs
- Add unapproved icons
- Use deep nested custom components

Output:
- Modules or page files required
- Assets used and where they were sourced
```

---

## Recommended Artifacts

- `CLAUDE.md` or project AI instruction file
- Reusable prompt template (brief + constraints + do/don't)
- Design system prompt: [`prompts/04-design-system-generator.md`](../prompts/04-design-system-generator.md)
