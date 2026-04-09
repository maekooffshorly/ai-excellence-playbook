# WordPress Module Builder — Guidelines

Full style guide for generating ACF block modules in the Offshorly WP Boilerplate.

---

## Design Principles

### UI Kit First

Always use UIkit classes before writing any custom CSS or SCSS. Every layout decision, spacing value, typography style, color, and alignment must be handled with UIkit utilities first. Only reach for custom SCSS when UIkit has no equivalent — transitions, hover states, and custom aspect ratios are the main exceptions.

- ✅ `uk-grid uk-child-width-1-3@m` for a 3-column layout
- ❌ Writing `.my-grid { display: grid; grid-template-columns: repeat(3, 1fr); }`

### Mobile First

Design and build for the smallest screen first, then progressively enhance for larger breakpoints using UIkit's responsive suffixes (`@s`, `@m`, `@l`, `@xl`). The base (no suffix) class always targets mobile. Never write desktop styles first and try to override them for mobile.

- ✅ `uk-child-width-1-1 uk-child-width-1-2@s uk-child-width-1-3@m` — stacked on mobile, 2-col on tablet, 3-col on desktop
- ❌ `uk-child-width-1-3` with overrides to stack on mobile

UIkit breakpoints for reference:

| Suffix | Breakpoint |
|--------|------------|
| *(none)* | All screens (mobile base) |
| `@s` | 640px and up |
| `@m` | 960px and up |
| `@l` | 1200px and up |
| `@xl` | 1600px and up |

---

## Module Naming Conventions

- Include components in the name: `hero-and-image`, `card-grid-and-content`, `banner-and-cta`
- Use generic block names, not specific use cases
  - ✅ `banner-and-cta`
  - ❌ `watch-demo-banner`
- In code and CSS classes: lowercase, dash-separated, replace "+" with "and"

---

## Field Group Structure (ACF)

- **Group name**: `"Block: [Name-of-Block-Type]"` — e.g., `"Block: Card Grid and Content"`
- **Structure**: Always create exactly two group fields (not tabs):
  1. **Content** — all content fields (headers, text, images, CTAs, repeaters)
  2. **Styles** — all styling and appearance options (background color, alignment, columns)

### Recommended Field Names

Always use these generic names. Never use BEM or module-specific prefixes.

| Purpose | Field Name |
|---------|------------|
| Main heading | `header` |
| Paragraph / rich text | `body_text` |
| Component title (e.g. card title) | `title` |
| Image | `image` |
| Button / link / CTA | `cta_field` |
| Icon | `icon` |

### Default Values

Every field must have a default value:
- Text fields: `"Lorem ipsum dolor sit amet, consectetur adipiscing elit"`
- Short text / header: `"Lorem ipsum dolor sit amet"`
- Images: Use placeholder image attachment ID from existing blocks (check current project)
- Select fields: Set the first option as default

---

## Twig Template Structure

### Mandatory Wrapper

Every module must use this wrapper — no exceptions:

```twig
<div class="uk-width-1-1 {module-name} bg--{{ styles.background_color }}">
    <div class="uk-width-1-1 content-wrapper">
        {module content here}
    </div>
</div>
```

### Variable Assignment Pattern

Set variables at the top of the template to keep markup clean:

```twig
{% set content = block.content %}
{% set styles = block.styles %}
```

---

## UIkit Classes Reference

Always use UIkit classes before writing any custom CSS. Below is some popular classes for reference for what to use and when.

### Cards

Use for any contained content block with a border, shadow, or background.

| Class | What it does |
|-------|-------------|
| `uk-card` | Base card class — required on the card container |
| `uk-card-default` | White background with subtle border and shadow |
| `uk-card-primary` | Primary color background (theme-dependent) |
| `uk-card-secondary` | Secondary color background |
| `uk-card-hover` | Adds a hover shadow effect to the card |
| `uk-card-body` | Adds standard padding inside the card |
| `uk-card-header` | Top section of a card (above media or body) |
| `uk-card-footer` | Bottom section of a card |
| `uk-card-media-top` | Image/media area at the top of a card, full width |
| `uk-card-media-bottom` | Image/media area at the bottom of a card |
| `uk-card-media-left` | Image/media on the left side of a horizontal card |
| `uk-card-media-right` | Image/media on the right side of a horizontal card |
| `uk-card-title` | Styles the card heading (typically an `<h3>`) |
| `uk-card-badge` | Positions a badge label in the top-right corner of a card |
| `uk-card-small` | Reduces card padding for compact layouts |
| `uk-card-large` | Increases card padding for spacious layouts |

```twig
{# Standard card #}
<div class="uk-card uk-card-default">
    <div class="uk-card-media-top">
        <img src="{{ image.url }}" alt="{{ image.alt }}">
    </div>
    <div class="uk-card-body">
        <h3 class="uk-card-title">{{ title }}</h3>
        <p>{{ body_text }}</p>
    </div>
    <div class="uk-card-footer">
        <a href="{{ cta_field.url }}" class="uk-button uk-button-text">{{ cta_field.title }}</a>
    </div>
</div>
```

---

### Grid

Use for any multi-column layout. Always add `uk-grid` as a data attribute or class alongside child width classes.

| Class | What it does |
|-------|-------------|
| `uk-grid` | Enables the grid layout on the container (also used as `uk-grid` attribute) |
| `uk-grid-small` | Small gap between columns (~15px) |
| `uk-grid-medium` | Medium gap between columns (~30px) |
| `uk-grid-large` | Large gap between columns (~40px) |
| `uk-grid-collapse` | Removes all gaps between columns |
| `uk-grid-match` | Makes all child cards/items equal height |
| `uk-grid-divider` | Adds a vertical divider line between columns |
| `uk-child-width-1-1` | All children full width (stacked) |
| `uk-child-width-1-2` | All children 50% width |
| `uk-child-width-1-3` | All children 33% width |
| `uk-child-width-1-4` | All children 25% width |
| `uk-child-width-1-2@s` | 50% width on small screens and up (640px+) |
| `uk-child-width-1-2@m` | 50% width on medium screens and up (960px+) |
| `uk-child-width-1-3@m` | 33% width on medium screens and up |
| `uk-child-width-1-4@m` | 25% width on medium screens and up |
| `uk-child-width-1-3@l` | 33% width on large screens and up (1200px+) |
| `uk-child-width-expand` | Each child expands to fill available space equally |
| `uk-child-width-auto` | Each child sizes to its content |

```twig
{# 3-column responsive grid, stacked on mobile #}
<div class="uk-grid uk-grid-medium uk-child-width-1-1 uk-child-width-1-2@s uk-child-width-1-3@m uk-grid-match" uk-grid>
    {% for item in content.items %}
        <div>
            <div class="uk-card uk-card-default">
                ...
            </div>
        </div>
    {% endfor %}
</div>
```

---

### Flexbox Utilities

Use for alignment, centering, and direction control within a container.

| Class | What it does |
|-------|-------------|
| `uk-flex` | Sets `display: flex` on the container |
| `uk-flex-inline` | Sets `display: inline-flex` |
| `uk-flex-left` | Aligns items to the left (default) |
| `uk-flex-center` | Centers items horizontally |
| `uk-flex-right` | Aligns items to the right |
| `uk-flex-between` | Distributes items with space between |
| `uk-flex-around` | Distributes items with space around each |
| `uk-flex-top` | Aligns items to the top |
| `uk-flex-middle` | Centers items vertically |
| `uk-flex-bottom` | Aligns items to the bottom |
| `uk-flex-row` | Horizontal layout (default) |
| `uk-flex-row-reverse` | Horizontal layout, reversed order |
| `uk-flex-column` | Vertical stacking layout |
| `uk-flex-column-reverse` | Vertical layout, reversed order |
| `uk-flex-wrap` | Allows items to wrap to a new line |
| `uk-flex-nowrap` | Prevents wrapping |
| `uk-flex-wrap-reverse` | Wrapped items flow in reverse |
| `uk-flex-1` | Makes item fill remaining space (`flex: 1`) |
| `uk-flex-none` | Prevents item from growing or shrinking |

```twig
{# Centered hero content #}
<div class="uk-flex uk-flex-center uk-flex-middle uk-flex-column">
    <h1>{{ content.header }}</h1>
    <p>{{ content.body_text }}</p>
</div>
```

---

### Overlay

Use when text or content sits on top of an image.

| Class | What it does |
|-------|-------------|
| `uk-overlay` | Styles an overlay element inside a `uk-cover-container` |
| `uk-overlay-default` | Semi-transparent white overlay background |
| `uk-overlay-primary` | Semi-transparent dark/primary overlay background |
| `uk-position-cover` | Stretches an element to fill its parent completely |
| `uk-position-center` | Centers an element both horizontally and vertically |
| `uk-position-top` | Positions element at the top |
| `uk-position-bottom` | Positions element at the bottom |
| `uk-position-top-left` | Positions element at top-left corner |
| `uk-position-top-right` | Positions element at top-right corner |
| `uk-position-bottom-left` | Positions element at bottom-left corner |
| `uk-position-bottom-right` | Positions element at bottom-right corner |
| `uk-position-center-left` | Positions element centered on the left edge |
| `uk-position-center-right` | Positions element centered on the right edge |
| `uk-position-small` | Adds a small offset from edges (use with positional classes) |
| `uk-position-medium` | Adds a medium offset from edges |
| `uk-position-large` | Adds a large offset from edges |

```twig
{# Image with overlay that appears on hover — see SCSS for hover transition #}
<div class="uk-cover-container card-wrapper">
    <img src="{{ image.url }}" alt="{{ image.alt }}" uk-cover>
    <canvas width="600" height="400"></canvas>
    <div class="uk-overlay uk-overlay-primary uk-position-cover uk-flex uk-flex-center uk-flex-middle hover-overlay">
        <p class="uk-text-center uk-margin-remove">{{ content.header }}</p>
    </div>
</div>
```

---

### Cover (Responsive Images)

Use when an image needs to fill a container while maintaining aspect ratio.

| Class | What it does |
|-------|-------------|
| `uk-cover-container` | Sets `position: relative; overflow: hidden` on the parent |
| `uk-cover` | Makes the image or video fill the container (`object-fit: cover`) |

Always include a `<canvas>` with the desired aspect ratio alongside `uk-cover` images — this is what sets the container's height:

```twig
<div class="uk-cover-container">
    <canvas width="16" height="9"></canvas>  {# Sets 16:9 aspect ratio #}
    <img src="{{ image.url }}" alt="{{ image.alt }}" uk-cover>
</div>
```

---

### Text Utilities

| Class | What it does |
|-------|-------------|
| `uk-text-left` | Aligns text left |
| `uk-text-center` | Centers text |
| `uk-text-right` | Aligns text right |
| `uk-text-justify` | Justifies text |
| `uk-text-left@m` | Aligns text left on medium screens and up |
| `uk-text-center@m` | Centers text on medium screens and up |
| `uk-text-uppercase` | Transforms text to uppercase |
| `uk-text-lowercase` | Transforms text to lowercase |
| `uk-text-capitalize` | Capitalizes first letter of each word |
| `uk-text-bold` | Bold text |
| `uk-text-italic` | Italic text |
| `uk-text-lead` | Larger, lighter paragraph text for introductions |
| `uk-text-meta` | Smaller muted text for metadata / labels |
| `uk-text-small` | Reduced font size |
| `uk-text-large` | Increased font size |
| `uk-text-muted` | Light grey text |
| `uk-text-emphasis` | Emphasized color text |
| `uk-text-primary` | Primary color text |
| `uk-text-secondary` | Secondary color text |
| `uk-text-success` | Green success text |
| `uk-text-warning` | Yellow warning text |
| `uk-text-danger` | Red danger text |
| `uk-text-truncate` | Truncates overflowing text with ellipsis |
| `uk-text-break` | Forces long words to break |
| `uk-text-nowrap` | Prevents text from wrapping |

---

### Headings

| Class | What it does |
|-------|-------------|
| `uk-heading-2xlarge` | Largest display heading |
| `uk-heading-xlarge` | Extra large display heading |
| `uk-heading-large` | Large display heading |
| `uk-heading-medium` | Medium display heading |
| `uk-heading-small` | Small display heading |
| `uk-heading-line` | Adds a horizontal line through the heading |
| `uk-heading-bullet` | Adds a colored bullet before the heading |
| `uk-heading-divider` | Adds a bottom border under the heading |
| `uk-h1` through `uk-h6` | Applies heading styles to any element |

---

### Spacing (Margin & Padding)

Use these instead of writing spacing in SCSS.

| Class | What it does |
|-------|-------------|
| `uk-margin` | Adds top margin |
| `uk-margin-small` | Small top margin |
| `uk-margin-medium` | Medium top margin |
| `uk-margin-large` | Large top margin |
| `uk-margin-xlarge` | Extra large top margin |
| `uk-margin-remove` | Removes all margins |
| `uk-margin-remove-top` | Removes top margin |
| `uk-margin-remove-bottom` | Removes bottom margin |
| `uk-margin-remove-left` | Removes left margin |
| `uk-margin-remove-right` | Removes right margin |
| `uk-margin-auto` | Centers element with `margin: auto` |
| `uk-margin-auto-left` | Pushes element to the right |
| `uk-margin-auto-right` | Pushes element to the left |
| `uk-margin-top` | Top margin only |
| `uk-margin-bottom` | Bottom margin only |
| `uk-margin-left` | Left margin only |
| `uk-margin-right` | Right margin only |
| `uk-padding` | Adds default padding |
| `uk-padding-small` | Small padding |
| `uk-padding-large` | Large padding |
| `uk-padding-remove` | Removes all padding |
| `uk-padding-remove-top` | Removes top padding |
| `uk-padding-remove-bottom` | Removes bottom padding |
| `uk-padding-remove-left` | Removes left padding |
| `uk-padding-remove-right` | Removes right padding |
| `uk-padding-remove-vertical` | Removes top and bottom padding |
| `uk-padding-remove-horizontal` | Removes left and right padding |

---

### Width

| Class | What it does |
|-------|-------------|
| `uk-width-1-1` | Full width (100%) |
| `uk-width-1-2` | 50% width |
| `uk-width-1-3` | 33.33% width |
| `uk-width-2-3` | 66.66% width |
| `uk-width-1-4` | 25% width |
| `uk-width-3-4` | 75% width |
| `uk-width-1-5` | 20% width |
| `uk-width-2-5` | 40% width |
| `uk-width-auto` | Shrinks to content width |
| `uk-width-expand` | Fills remaining space |
| `uk-width-small` | Fixed small width (~150px) |
| `uk-width-medium` | Fixed medium width (~300px) |
| `uk-width-large` | Fixed large width (~450px) |
| `uk-width-xlarge` | Fixed extra large width (~600px) |
| `uk-width-2xlarge` | Fixed 2x large width (~750px) |

All width classes support responsive suffixes: `@s`, `@m`, `@l`, `@xl`

```twig
{# Full width on mobile, half on tablet, third on desktop #}
<div class="uk-width-1-1 uk-width-1-2@s uk-width-1-3@m">
```

---

### Buttons

| Class | What it does |
|-------|-------------|
| `uk-button` | Base button class — required |
| `uk-button-default` | Default outlined button style |
| `uk-button-primary` | Primary filled button |
| `uk-button-secondary` | Secondary filled button |
| `uk-button-danger` | Red danger button |
| `uk-button-text` | Minimal text-only button with underline |
| `uk-button-link` | Styled like a plain link |
| `uk-button-small` | Small button size |
| `uk-button-large` | Large button size |

```twig
{% if content.cta_field %}
    <a href="{{ content.cta_field.url }}"
       class="uk-button uk-button-primary"
       target="{{ content.cta_field.target }}">
        {{ content.cta_field.title }}
    </a>
{% endif %}
```

---

### Visibility & Display

| Class | What it does |
|-------|-------------|
| `uk-visible@s` | Visible only on small screens and up |
| `uk-visible@m` | Visible only on medium screens and up |
| `uk-visible@l` | Visible only on large screens and up |
| `uk-hidden@s` | Hidden on small screens and up |
| `uk-hidden@m` | Hidden on medium screens and up |
| `uk-hidden@l` | Hidden on large screens and up |
| `uk-hidden` | Always hidden (display: none) |
| `uk-invisible` | Hidden but still takes up space (visibility: hidden) |

---

## SCSS Structure

### What Is Allowed

Custom SCSS should only handle what UIkit cannot:

```scss
.{module-name} {
    // Transitions
    .hover-overlay {
        opacity: 0;
        transition: opacity 0.3s ease;
    }

    // Hover states
    .card-wrapper:hover .hover-overlay {
        opacity: 1;
    }

    // Aspect ratios (when uk-cover canvas doesn't fit the design)
    .image-frame {
        aspect-ratio: 4 / 3;
    }

    // Custom positioning (only when UIkit positional classes don't work)
    .badge {
        position: absolute;
        top: 1rem;
        right: 1rem;
    }
}
```

### What Is NOT Allowed

| Category | Use instead |
|----------|-------------|
| Colors, backgrounds | `uk-overlay-primary`, `bg--*` classes |
| Typography | `uk-text-*`, `uk-heading-*` |
| Spacing | `uk-margin-*`, `uk-padding-*` |
| Borders | `uk-border-*` |
| Dimensions | UIkit width/height utilities |

If your SCSS file exceeds ~30 lines, you're likely not using enough UIkit.

---

## Module Coverage Checklist

Before finalising any module, verify:

- [ ] Field group is named `"Block: [Name-of-Block-Type]"`
- [ ] Field group contains exactly two groups: **Content** and **Styles**
- [ ] All fields use generic names — no BEM, no module-specific prefixes
- [ ] All fields have appropriate default values
- [ ] Twig template uses the mandatory wrapper structure
- [ ] UIkit classes are used for all layout, spacing, and typography (UI kit first)
- [ ] Responsive classes use mobile-first breakpoint suffixes (`@s`, `@m`, `@l`) — base styles target mobile
- [ ] SCSS is minimal and scoped to the module class
- [ ] No equivalent module already exists in `modules/`
- [ ] SCSS import is added to `assets/styles/app.scss`
