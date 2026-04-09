# Block Registration in Code

Use this guide **only when the user explicitly asks** to register a block in code (e.g. "register in code", "add block.json", "don't use the admin"). By default, blocks are registered through the WordPress admin UI — this file covers the code-based alternative.

---

## When Code Registration Is Used

- The project uses version-controlled block definitions
- The block needs to be deployed consistently across environments
- The user wants to avoid manual admin setup per environment

---

## block.json (ACFE Export Format)

This project uses ACF Extended (ACFE). Block types are registered via ACFE's export format. Create or export this file at `modules/{module-name}/block.json`:

```json
[
    {
        "name": "{module-name}",
        "title": "{Human Readable Block Name}",
        "active": true,
        "description": "{Short description of what this block does}",
        "category": "{Block Category}",
        "icon": "",
        "keywords": ["{keyword1}", "{keyword2}"],
        "post_types": [],
        "mode": "edit",
        "align": "",
        "align_text": "",
        "align_content": "top",
        "render_template": "modules.php",
        "render_callback": "",
        "enqueue_style": "",
        "enqueue_script": "",
        "enqueue_assets": "",
        "supports": {
            "anchor": false,
            "align": true,
            "align_text": false,
            "align_content": false,
            "full_height": false,
            "mode": true,
            "multiple": true,
            "example": [],
            "jsx": false
        }
    }
]
```

**Key fields:**
- `"name"` — slug only, no `acf/` prefix (e.g. `"pill-button-grid"`)
- `"category"` — check existing ACFE block exports for the correct category string
- `"render_template"` — typically `"modules.php"` (the project's module dispatcher)
- `"mode": "edit"` — ACFE default; use `"preview"` if the block should render a preview in the editor
- `"active": true` — must be `true` for the block to appear in the editor
- The entire file is a JSON **array** wrapping one or more block type objects

---

## PHP Registration

If the project registers blocks via PHP instead of (or alongside) `block.json`, add this to `functions.php` or a dedicated blocks registration file:

```php
/**
 * Register ACF block: {Module Name}
 */
function register_{module_name}_block() {
    if ( function_exists( 'acf_register_block_type' ) ) {
        acf_register_block_type(
            array(
                'name'            => '{module-name}',
                'title'           => '{Human Readable Name}',
                'description'     => '{Short description}',
                'render_template' => 'modules/{module-name}/module.twig',
                'category'        => 'offshorly-blocks',
                'icon'            => 'layout',
                'keywords'        => array( '{keyword1}', '{keyword2}' ),
                'mode'            => 'preview',
                'supports'        => array(
                    'align' => false,
                    'mode'  => false,
                ),
            )
        );
    }
}
add_action( 'acf/init', 'register_{module_name}_block' );
```

---

## Determining Which Approach to Use

Check how existing blocks in the project are registered before choosing:

```
Glob: modules/*/block.json         ← if these exist, use block.json approach
Grep: acf_register_block_type      ← if this appears in PHP files, use PHP approach
```

Match the pattern already used in the project. Don't mix both approaches for new modules.

---

## Field Group Location Rule

Whether using `block.json` or PHP registration, the ACF field group must be configured to show when the block is active. In the field group PHP file:

```php
'location' => array(
    array(
        array(
            'param'    => 'block',
            'operator' => '==',
            'value'    => 'acf/{module-name}',
        ),
    ),
),
```

The `value` must exactly match the block's `name` field in `block.json` or the `name` passed to `acf_register_block_type()`.
