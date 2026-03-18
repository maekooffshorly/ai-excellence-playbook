# WP Module Builder — User Manual

A step-by-step guide to generating ACF block modules for the Offshorly WordPress Boilerplate using the `/module-builder` skill.

---

## What It Does

The `module-builder` skill generates a complete, ready-to-use WordPress block module, including:

- `block.json` — block registration
- `module.twig` — Twig template with UIkit layout
- `_module.scss` — scoped custom styles
- `field-groups/{name}.php` — ACF field group with Content and Styles groups

It follows the project's conventions automatically: UIkit-first styling, mobile-first breakpoints, generic field names, and the mandatory wrapper structure.

---

## Adding the Skill to a Project

The skill lives in the playbook repo under `skills/module-builder/`. To use it in a WordPress project, you need to copy it into that project.

### Step 1 — Copy the skill folder

You have two placement options depending on how broadly you want the skill available. Claude Code picks up skills from both `commands/` and `skills/` folders — use whichever makes more sense for your setup.

**Option A — Global level** *(available in every project on your machine — recommended)*

Copy into your root Claude directory:

```
~/.claude/skills/          ← or ~/.claude/commands/
└── module-builder/
    ├── SKILL.md
    └── references/
        ├── guidelines.md
        ├── pattern-reading.md
        ├── figma-to-module.md
        ├── block-registration.md
        ├── field-group-registration.md
        └── test-page.md
```

On Windows, `~/.claude/` is at `C:\Users\{your-username}\.claude\`.

> Use this option if you work across multiple WP Boilerplate projects — you only need to install once.

**Option B — Project-level** *(available only in that specific project)*

Copy into your WordPress project root:

```
your-wp-project/
└── .claude/skills/          ← or .claude/commands/
    └── module-builder/
        ├── SKILL.md
        └── references/
            ├── guidelines.md
            ├── pattern-reading.md
            ├── figma-to-module.md
            ├── block-registration.md
            ├── field-group-registration.md
            └── test-page.md
```

### Step 2 — Confirm Claude Code sees it

Open Claude Code in the project and type `/` — you should see `module-builder` listed as an available skill. If it doesn't appear, restart the Claude Code session.

### Step 3 — Set up the Figma MCP *(optional, for Figma-to-module workflow)*

The skill can read Figma designs directly if the Figma MCP is connected. Skip this if you'll only use text descriptions.

1. Open a Figma design file and enter **Dev Mode**
2. Find **MCP** in the right sidebar → click **Enable desktop MCP server**
3. Copy the localhost URL shown
4. Add it to your project's `.claude/settings.json`:

```json
{
    "mcpServers": {
        "figma": {
            "type": "http",
            "url": "http://127.0.0.1:3845/mcp"
        }
    }
}
```

> Dev Mode must be available on your Figma plan. The Figma desktop app must be open and running for the MCP server to be active.

---

## How to Invoke It

Type `/module-builder` followed by a description of the block you want to build.

You can also just describe what you want in plain language — the skill auto-triggers on phrases that indicate module creation. You don't need to type the slash command explicitly.

**Phrases that automatically invoke the skill:**

| What you say | Triggers? |
|---|---|
| "build a block" | ✅ |
| "new module" / "create a module" | ✅ |
| "make a hero section" | ✅ |
| "I need a card grid" | ✅ |
| "create a CTA banner" | ✅ |
| "build a testimonial section" | ✅ |
| "convert this Figma to a block" | ✅ |
| Any layout component for WordPress | ✅ |

You don't need to say "ACF" or "boilerplate" — describing the component is enough.

---

## Two Workflows

### Option A — Describe the block in plain text

Tell the skill what you want, either as a short description or a list of requirements.

**Examples:**

```
/module-builder Build a card grid with an image, title, and body text per card. 3 columns on desktop, 1 on mobile. White or light gray background option.
```

```
/module-builder Hero section with a heading, subtext, and a CTA button. Background can be white or dark.
```

```
/module-builder Banner with a full-width background image, centered text overlay, and a button.
```

For the most precise output, structure your prompt with explicit **Layout**, **Content**, and **Styles** sections:

```
/module-builder Build a card grid module.

Layout:
- 1 column on mobile, 2 columns on tablet, 3 columns on desktop
- Cards match height in a row
- Image on top, text below

Content:
- Section header (text)
- Section body text
- Repeating cards, each with: image, title, body text, CTA link

Styles:
- Background color: white, light, dark
- Number of columns: 2, 3, 4
- Text alignment: left, center
```

**Tips for better results:**
- Mention the number of columns if it's a grid
- List the content fields you need (heading, text, image, button)
- Mention any style options (background color, text alignment, number of columns)
- Say if there's a repeating item (e.g. "a list of cards", "a set of icon + text pairs")

---

### Option B — Provide a Figma link

If you have a Figma design, paste the URL and the skill will analyze the layout, map elements to fields, and generate the module from the design.

**Example:**

```
/module-builder https://figma.com/design/abc123/My-Design?node-id=1-2
```

The skill will:
1. Fetch the design context from Figma
2. Take a screenshot for visual reference
3. Map Figma layers to ACF fields (text → `header`/`body_text`, image fills → `image`, buttons → `cta_field`, repeating frames → repeater)
4. Present a plan for your approval before generating code

---

## What Happens After You Invoke It

The skill runs in two phases:

### Phase 1 — Research (automatic)

The skill reads 1–2 existing modules from `modules/` to match the project's exact conventions — field key format, Twig variable access pattern, CSS class style, block category, etc. It also checks for duplicate modules.

If no existing modules are found, or if you explicitly ask about conventions, the skill falls back to reading the built-in `guidelines.md` instead. You can also trigger this directly:

```
/module-builder What's the naming convention for field groups?
```

```
/module-builder Check the guidelines and build a hero section.
```

### Phase 2 — Plan (requires your approval)

The skill presents a **Module Plan** showing:

| Section | What you'll see |
|---------|----------------|
| Module name | e.g. `card-grid-and-content` |
| Field group | Content fields + Styles fields listed |
| Twig structure | High-level layout description |
| UIkit classes | Key classes that will be used |
| SCSS notes | Any custom styles needed |
| Considerations | Duplicates found, SVG icons, design decisions |

**Review this plan before approving.** Once you confirm, the skill generates all four files.

---

## Naming Rules

The skill follows these conventions automatically, but it helps to know them:

- **Module name**: lowercase, dash-separated, describes the components — `hero-and-image`, `card-grid-and-content`, `banner-and-cta`
- **Field group name**: `"Block: Card Grid and Content"`
- **Field names**: always generic — `header`, `body_text`, `image`, `cta_field`, `title`, `icon`
- **CSS class**: matches module name — `.card-grid-and-content { ... }`

---

## What Gets Generated

After approval, the skill outputs four files with their target paths:

```
web/app/themes/{theme}/modules/{module-name}/
├── block.json
├── module.twig
└── _module.scss

web/app/themes/{theme}/field-groups/
└── {module-name}.php
```

It also tells you to add the SCSS import to `assets/styles/app.scss`.

---

## Quick Reference — Common Block Types

| What you want | Example prompt |
|---------------|----------------|
| Hero section | `Hero with heading, body text, and a CTA button` |
| Card grid | `Card grid with image, title, and text per card. 3 columns on desktop` |
| Banner with image | `Full-width banner with background image and centered text overlay` |
| Icon + text list | `3-column grid of icon, title, and short description` |
| Two-column content | `Left column with text content, right column with an image` |
| Testimonials | `Testimonial slider with quote, author name, and author photo` |
| CTA section | `Centered CTA with heading, subtext, and two buttons` |

---

## After the Module Is Generated

1. Copy the files into the theme directory
2. Add the SCSS import line to `assets/styles/app.scss`
3. Run your build step (`npm run dev` or `gulp build` or equivalent)
4. Go to the WordPress block editor — the new block will appear under the Blocks category
5. Verify default values are showing in the editor before testing live

---

## Key Rules the Skill Enforces

- **UIkit first** — all layout, spacing, and typography use UIkit classes; custom SCSS only for transitions, hover states, and aspect ratios
- **Mobile first** — base classes target mobile; `@s`, `@m`, `@l` suffixes add tablet/desktop styles
- **Two groups only** — every field group has exactly a `Content` group and a `Styles` group (no tabs)
- **Default values required** — every field has a placeholder/default so the block renders without content
- **No duplicates** — the skill checks existing modules before generating and flags any overlaps
