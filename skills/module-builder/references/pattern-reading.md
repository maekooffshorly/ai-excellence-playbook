# Pattern Reading — How to Analyze Existing Modules

Use this guide when the user has a specific module to build. Reading the codebase gives you the ground truth for what conventions the project actually uses — always prefer this over assumptions.

---

## Where to Look

```
modules/
├── {module-name}/
│   ├── block.json        ← block registration and metadata
│   ├── module.twig       ← Twig template (layout, UIkit classes, variable usage)
│   └── _module.scss      ← styles (scope, what's custom vs UIkit)
field-groups/
└── {module-name}.php     ← ACF field group (field names, types, structure, defaults)
assets/styles/
└── app.scss              ← SCSS import order
```

---

## How Many Modules to Sample

- **Minimum**: Read 1 module fully (all 4 files)
- **Recommended**: Read 2 modules — one simple (e.g. hero, banner) and one complex (e.g. card grid, repeater)
- **When in doubt**: Pick the most recently modified modules — they're likely to reflect current conventions

To find them:
```
Glob: web/app/themes/{theme_name}/modules/*/block.json       ← lists all modules
Glob: web/app/themes/{theme_name}/modules/*/module.twig      ← good for seeing Twig patterns
Glob: web/app/themes/{theme_name}/field-groups/*.php         ← all field group registrations
```

---

## What to Extract From Each File

### `block.json`
- Category name used (`"category": "..."`) — use the same in your new block
- Icon naming convention
- Whether `"mode": "preview"` is standard
- Keyword patterns

### `module.twig`
Answer these questions after reading:
1. How are `content` and `styles` accessed? (`block.content`, `fields.content`, etc.)
2. What does the outer wrapper look like? Match it exactly.
3. Which UIkit grid/card/flex/overlay classes are used and how?
4. What custom class names exist — are they simple or BEM-style?
5. How are optional fields handled? (`{% if content.image %}`, `|default('')`, etc.)
6. How are repeater fields looped? (`{% for item in content.items %}`)
7. How are ACF link fields rendered? (`item.url`, `item.title`, `item.target`)

### `_module.scss`
Answer these questions:
1. How is the module scoped? (`.{module-name} { ... }`)
2. What is actually in custom CSS vs delegated to UIkit?
3. Are there any patterns you should replicate (e.g. hover transitions, aspect ratios)?
4. Is the file mostly empty? That means UIkit is doing most of the work — do the same.

### `field-groups/{module-name}.php`
Answer these questions:
1. What is the group key format? (`'group_'` prefix, then what?)
2. What is the field key format? (`'field_'` prefix, then what?)
3. How are Content and Styles groups structured? (nested field arrays)
4. How are repeater sub-fields defined?
5. What default values are set for text fields and images?
6. What are the select field option formats?

---

## Extracting Naming Conventions

After reading 1–2 modules, you should be able to answer:

| Convention | Example from codebase |
|------------|----------------------|
| Group key prefix | `group_herogrid`, `group_cardgrid` |
| Field key prefix | `field_herogrid_content`, `field_hero_header` |
| CSS class naming | `.hero-and-image`, `.card-grid` (simple, no BEM) |
| Block category | `"offshorly-blocks"` |
| Twig variable access | `block.content.header`, `fields.content.header` |

Lock these in before generating new code — consistency matters more than the specific convention used.

---

## Duplicate Detection

Before generating a new module, check whether one already exists that covers the same requirement.

### Step 1 — Search by name similarity

```
Glob: modules/*/block.json
```

Read the `"title"` field from each result. Look for modules that match the component type:
- Building a "card grid"? Look for: `card`, `grid`, `cards`
- Building a "hero"? Look for: `hero`, `banner`, `header`

### Step 2 — Check field overlap

If a similar module exists, read its `field-groups/{name}.php` and compare:
- Does it have the same core fields? (`header`, `body_text`, `image`, `cta_field`)
- Does it support the same style options? (background color, columns, alignment)

### Step 3 — Decide

| Situation | Action |
|-----------|--------|
| Existing module covers 80%+ of requirements | Tell the user — suggest extending or reusing it |
| Existing module is similar but structurally different | Build new module, note the overlap in Considerations |
| No similar module found | Proceed with new module |

**Never silently duplicate.** If you find a close match, surface it in Phase 2 so the user can decide.

---

## Red Flags — Modules to Avoid Copying

Some existing modules may be outdated or non-standard. Skip a module as a reference if you see:

- BEM-style field names (`cards__header`, `block--featured`)
- Tab fields in the field group (use groups instead)
- Heavy SCSS with colors, typography, or spacing defined in CSS
- No Content/Styles group separation
- Missing default values on text or image fields
- `renderCallback` instead of `renderTemplate` in block registration

If most modules have a red flag, flag it to the user in your Considerations — don't silently adopt the bad pattern.
