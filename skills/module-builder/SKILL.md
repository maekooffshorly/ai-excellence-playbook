---
name: module-builder
description: Build ACF block modules for the WordPress Boilerplate. Use this skill whenever the user wants to create a WordPress block, module, ACF block, Gutenberg block, hero section, card grid, CTA, banner, testimonial, or any reusable content component for a WordPress project. Trigger even when the user just says "build a block", "new module", or describes a layout component they want in WordPress — they don't need to say "ACF" or "boilerplate" explicitly. Also use when converting a Figma design into a WordPress block.
---

You generate ACF block modules for the Offshorly WP Boilerplate — nothing else. You never modify code outside `/modules/`, `field-groups/`, or `assets/styles/app.scss`.

## Stopping Rules

Stop immediately if you're about to:
- Write tests, refactor unrelated code, or touch files outside the module context
- Create more than the standard 4 files per module
- Modify `functions.php` for anything other than adding an SCSS import

Allowed terminal commands: `gulp build`, `gulp watch`, `lando wp eval-file`

---

## Context Loading Strategy

Before doing any research, read the user's prompt and decide what to load:

| Prompt signals | What to load |
|----------------|--------------|
| Specific module name + field requirements | `references/pattern-reading.md` → scan `modules/` |
| "how do I", "what's the convention", vague requirements | `references/guidelines.md` |
| Figma URL or node ID present | `references/figma-to-module.md` |
| "register block", "register in code", "add to functions.php", "block.json" | `references/block-registration.md` |
| "field group", "add fields", "acf fields", "field-group.json" | `references/field-group-registration.md` |
| "test page", "sample data", "preview" | `references/test-page.md` |
| Default (building something specific) | `references/pattern-reading.md` → scan `modules/` |

Load only what you need. Scanning existing modules is faster and more reliable than reading the full guidelines — the codebase is always the ground truth for what conventions the project actually uses.

---

## Workflow

### Phase 1 — Gather Context

Follow your context loading strategy above. For most builds:

1. Read `references/pattern-reading.md` to understand how to analyze the codebase
2. Scan the project's `modules/` directory and read 1–2 existing modules to extract conventions
3. Check for duplicate modules before generating anything new
4. Parse the user's prompt for: module name, fields needed, layout description, style options

When requirements are vague or the user asks about conventions, read `references/guidelines.md` instead of (or alongside) scanning modules.

### Phase 2 — Present Module Plan

Show the user the following before writing any files:

```
## Module Plan: {Module Name}

### Figma Design Analysis (if applicable)
- Screenshot, layout structure, UIkit classes mapped, custom styling needed

### Requirements
- Fields: {list with types}
- Block options: {background color, alignment, etc.}
- Acceptance criteria: {summary}

### Generated Code
{module.twig, _module.scss, field-groups/{name}.php as code blocks}

### Considerations
1. {Assumptions made}
2. {Suggested additions}
3. {Dependencies or setup requirements}
```

**Stop here. Wait for the user to approve or request changes before proceeding.**

### Phase 3 — Write Files (only after approval)

When the user says "go ahead", "make it", "create it", or similar:

1. Write all module files to their correct locations
2. Add SCSS import to `assets/styles/app.scss`
3. Run `gulp build` (skip if `gulp watch` is already running)
4. If the user requested a test page, follow `references/test-page.md`
5. If the user explicitly asks to register the block in code, follow `references/block-registration.md`
6. If the user explicitly asks to register the field group in code, follow `references/field-group-registration.md`

---

## Module Files

| File | Location |
|------|----------|
| Twig template | `modules/{module-name}/module.twig` |
| Styles | `modules/{module-name}/_module.scss` |
| ACF fields | `field-groups/{module-name}.php` |

> Block registration (`block.json`) and field group registration (`field-group.json`) are handled in the WordPress admin by default.
> Only generate them when the user explicitly asks to register in code — see `references/block-registration.md` and `references/field-group-registration.md`.

---

## Core Conventions (Quick Reference)

### Naming
- Module names describe components: `hero-and-image`, `card-grid-and-content`, `banner-and-cta`
- Use generic names, not specific use cases: `banner-and-cta` not `watch-demo-banner`
- Code/classes: lowercase, dash-separated, "+" → "and"

### Field Groups
- Group name format: `"Block: [Name-of-Block-Type]"`
- Exactly two group fields: **Content** and **Styles** (no tabs)
- Generic field names only: `header`, `body_text`, `title`, `image`, `cta_field`, `icon`
- No BEM notation: ❌ `cards_header`, `banner_title` → ✅ `header`, `title`
- All fields need default values (Lorem ipsum text, placeholder images)

### Twig Wrapper (mandatory)
```twig
<div class="uk-width-1-1 {module-name} bg--{{ styles.background_color }}">
    <div class="uk-width-1-1 content-wrapper">
        {module content here}
    </div>
</div>
```

### UIkit First
Always use UIkit classes before writing any custom CSS. Custom SCSS is only for:
- ✅ Transitions, hover states, aspect ratios, custom positioning
- ❌ Colors, borders, typography, spacing (use UIkit utilities instead)

If your SCSS exceeds ~30 lines, you're likely not using enough UIkit.

---

## Reference Files

| File | When to read |
|------|--------------|
| `references/guidelines.md` | Full UIkit class tables, SCSS rules, field group patterns, module coverage checklist |
| `references/pattern-reading.md` | How to scan existing modules, extract conventions, detect duplicates |
| `references/figma-to-module.md` | Figma MCP tools, design analysis workflow, layer-to-field mapping |
| `references/block-registration.md` | block.json (ACFE format) — only when user explicitly requests it |
| `references/field-group-registration.md` | field-group.json (ACF export format) — only when user explicitly requests it |
| `references/test-page.md` | PHP script pattern for creating test pages with sample block data |
