# Figma to Module — Design Analysis Workflow

Use this guide when the user provides a Figma URL or node ID. The goal is to extract layout structure, content fields, and styling decisions from the design before generating module code.

---

## Available MCP Tools

Access Figma tools via the `mcp-figma/*` pattern:

| Tool | Purpose | When to Use |
|------|---------|-------------|
| `mcp-figma/get_design_context` | Extracts layout, styles, structure, and code hints | Primary tool — use this first |
| `mcp-figma/get_screenshot` | Visual screenshot of a node | For visual reference in the module plan |
| `mcp-figma/get_metadata` | XML structure overview (IDs, layers, positions) | For exploring page/frame structure before deep analysis |
| `mcp-figma/get_variable_defs` | Color and font variable definitions | For extracting design tokens |

---

## Input Formats

The tools accept:

1. **Figma URL**: `https://figma.com/design/:fileKey/:fileName?node-id=1-2`
   - Extract `nodeId` as `1:2` from the URL (replace `-` with `:`)
2. **Node ID**: Direct format `123:456` or `123-456`
3. **No input**: Uses the currently selected node in the Figma desktop app
4. **Branch URL**: `https://figma.com/design/:fileKey/branch/:branchKey/:fileName`
   - Use `branchKey` as the `fileKey`

---

## Analysis Workflow

### Step 1 — Get Design Context (always)

```
Use mcp-figma/get_design_context with the target node
```

From the result, extract:
- Layout structure (grid, flex, stack, overlay)
- Text layers → field names and default content
- Image layers / image fills → `image` fields
- Button/link layers → `cta_field` fields
- Repeating patterns → repeater fields with sub-fields
- Background color → `styles.background_color` option
- Auto-layout direction (horizontal → `uk-grid`; vertical → standard flow)

### Step 2 — Capture Visual Reference (recommended)

```
Use mcp-figma/get_screenshot for the same node
```

Include the screenshot in the module plan you present to the user. It helps them verify the design was interpreted correctly before approving.

### Step 3 — Explore Structure (for complex pages only)

```
Use mcp-figma/get_metadata if the design is a full page or multi-section frame
```

Use this to identify which frames are individual blocks before running `get_design_context` on a specific section.

### Step 4 — Extract Design Tokens (optional)

```
Use mcp-figma/get_variable_defs to get color and font variables
```

Map Figma color variables to the project's existing theme classes (`bg--light`, `bg--dark`, etc.) rather than hardcoding values.

---

## Figma Element to Field Mapping

| Figma Element | Module Field |
|---------------|-------------|
| Heading / Title text layer | `header` or `title` (ACF Text) |
| Body / Description text layer | `body_text` (ACF Textarea or WYSIWYG) |
| Image fill or image layer | `image` (ACF Image) |
| Button / Link component | `cta_field` (ACF Link) |
| Icon component | `icon` (ACF Select or Image) |
| Repeating card frames | Repeater field with sub-fields |
| Auto-layout (horizontal) | `uk-grid` with `uk-child-width-*` |
| Auto-layout (vertical) | Standard block flow or `uk-flex uk-flex-column` |
| Frame with background fill | `styles.background_color` select field |
| Overlay on image | `uk-overlay` with `uk-position-cover` |
| Card-like container | `uk-card`, `uk-card-body` |

---

## Layer Name Conventions

Figma layer names are hints for field purpose — not literal field names. Always use the project's generic field naming conventions.

| Figma Layer Name | Field Name to Use |
|-----------------|-------------------|
| "Header", "Title", "Heading" | `header` or `title` |
| "Body", "Description", "Text" | `body_text` |
| "CTA", "Button", "Link" | `cta_field` |
| "Image", "Photo", "Media" | `image` |
| "Icon", "Badge" | `icon` |
| Repeating names (Card 1, Card 2) | Repeater field |

---

## UIkit Mapping from Auto-Layout

| Figma Auto-Layout Setting | UIkit Equivalent |
|--------------------------|------------------|
| Horizontal, gap 15px | `uk-grid uk-grid-small` |
| Horizontal, gap 30px | `uk-grid uk-grid-medium` |
| Horizontal, gap 40px+ | `uk-grid uk-grid-large` |
| Vertical stack | Standard block flow |
| Center-aligned | `uk-flex uk-flex-center` |
| Space-between | `uk-flex uk-flex-between` |
| Wrapped columns | `uk-grid uk-flex-wrap` + `uk-child-width-*` |

---

## Tips for Figma Analysis

1. **Check component variants** — different states (hover, active) often mean you need a CSS transition or hover state in SCSS
2. **Responsive frames** — if the design has mobile/tablet/desktop variants, note the breakpoints and use UIkit responsive suffixes (`@s`, `@m`, `@l`)
3. **Nested repeating components** — if you see "Card 1", "Card 2", "Card 3" inside a container, that's a repeater field
4. **Background color fills on frames** — these become `styles.background_color` select options (e.g. `white`, `light`, `dark`)
5. **SVG icons** — note them in Considerations; never recreate SVGs in code. The user will need to export them and add them to the theme

---

## Example: Analyzing a Card Grid

```
Figma Structure:
├── Card Grid (Frame, horizontal auto-layout)
│   ├── Section Header (Text)
│   ├── Section Body (Text)
│   ├── Cards Container (Auto-layout, 3 columns)
│   │   ├── Card 1 (Component Instance)
│   │   │   ├── Card Image (Image fill)
│   │   │   ├── Card Title (Text)
│   │   │   └── Card Description (Text)
│   │   ├── Card 2 ...
│   │   └── Card 3 ...
│   └── View All (Button instance)

Maps to:
Content group:
  - header: "Section Header" text
  - body_text: "Section Body" text
  - cards: Repeater
      - image: Card Image
      - title: Card Title
      - body_text: Card Description
  - cta_field: "View All" button

Styles group:
  - background_color: Frame background (select: white / light / dark)
  - columns: Number of cards per row (select: 2 / 3 / 4)

UIkit layout: uk-grid uk-child-width-1-3@m uk-grid-match
```
