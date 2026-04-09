# Test Page Generation

Use this guide when the user requests a test page or sample preview for a module. The goal is a WordPress page pre-loaded with the block and realistic sample data so the user can preview it immediately.

---

## When to Use

Generate a test page when the user says:
- "create a test page"
- "add sample data"
- "I want to preview it"
- "set up a demo page"

---

## Script Location and Execution

Save the script to:
```
web/app/themes/{theme_name}/scripts/create-{module-name}-test-page.php
```

Run with:
```bash
cd /path/to/your/project && lando wp eval-file web/app/themes/{theme_name}/scripts/create-{module-name}-test-page.php --path=web/wp
```

---

## Script Template

```php
<?php
/**
 * Script to create a test page with {Module Name} blocks.
 *
 * Run with: lando wp eval-file web/app/themes/boilerplate/scripts/create-{module-name}-test-page.php --path=web/wp
 *
 * @package Starter_Theme
 */

// Bootstrap WordPress.
$wp_load_path = dirname( __DIR__, 4 ) . '/wp/wp-load.php';
if ( ! file_exists( $wp_load_path ) ) {
    echo "Error: Could not find wp-load.php at {$wp_load_path}\n";
    exit( 1 );
}
require_once $wp_load_path;


// --- 1. Sample data (human-readable) ---

$block_data = array(
    'content' => array(
        'header'    => 'Sample Header Text',
        'body_text' => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        'cta_field' => array(
            'url'    => '#',
            'title'  => 'Learn More',
            'target' => '',
        ),
        // Repeater example — remove if module has no repeater
        'items' => array(
            array(
                'title'     => 'Item One',
                'body_text' => 'Description for item one.',
                'image'     => array( 'ID' => 1 ), // Replace with real attachment ID
            ),
            array(
                'title'     => 'Item Two',
                'body_text' => 'Description for item two.',
                'image'     => array( 'ID' => 1 ),
            ),
        ),
    ),
    'styles' => array(
        'background_color' => 'light',
        'columns'          => '3',
    ),
);


// --- 2. Generate a unique block ID ---

$block_id = 'block_' . wp_generate_password( 13, false );


// --- 3. Build field data using actual ACF field keys ---
// Get field keys from field-groups/{module-name}.php

$content_data = array(
    'field_{prefix}_header'    => $block_data['content']['header'],
    'field_{prefix}_body_text' => $block_data['content']['body_text'],
    'field_{prefix}_cta_field' => $block_data['content']['cta_field'],
);

// Repeater fields — keyed by unique row ID
if ( ! empty( $block_data['content']['items'] ) ) {
    $items_data = array();
    foreach ( $block_data['content']['items'] as $item ) {
        $row_id                = uniqid();
        $items_data[ $row_id ] = array(
            'field_{prefix}_item_title'     => $item['title'],
            'field_{prefix}_item_body_text' => $item['body_text'],
            'field_{prefix}_item_image'     => $item['image']['ID'] ?? '',
        );
    }
    $content_data['field_{prefix}_items'] = $items_data;
}

$styles_data = array(
    'field_{prefix}_bg_color' => $block_data['styles']['background_color'],
    'field_{prefix}_columns'  => $block_data['styles']['columns'],
);

$block_field_data = array(
    'field_{prefix}_content' => $content_data,
    'field_{prefix}_styles'  => $styles_data,
);


// --- 4. Build Gutenberg block markup ---

$blocks = array(
    array(
        'blockName' => 'acf/{module-name}',
        'attrs'     => array(
            'id'   => $block_id,
            'name' => 'acf/{module-name}',
            'data' => $block_field_data,
            'mode' => 'preview',
        ),
    ),
);

$page_content = serialize_blocks( $blocks );


// --- 5. Create or update the test page ---

$page_title = 'Test {Module Name}';
$query      = new WP_Query(
    array(
        'post_type'      => 'page',
        'title'          => $page_title,
        'posts_per_page' => 1,
    )
);
$page = $query->have_posts() ? $query->posts[0] : null;

$page_data = array(
    'post_title'   => $page_title,
    'post_content' => $page_content,
    'post_status'  => 'publish',
    'post_type'    => 'page',
);

if ( $page ) {
    $page_data['ID'] = $page->ID;
    $page_id         = wp_update_post( $page_data );
    echo "Page updated (ID: {$page_id}).\n";
} else {
    $page_id = wp_insert_post( $page_data );
    echo "Page created (ID: {$page_id}).\n";
}

if ( is_wp_error( $page_id ) ) {
    echo 'Error: ' . $page_id->get_error_message() . "\n";
    exit( 1 );
}

echo "\nSuccess! Page '{$page_title}' is ready.\n";
echo 'View at: ' . get_permalink( $page_id ) . "\n";
```

---

## Critical Rules

1. **Bootstrap WordPress** — always include `wp-load.php` at the start
2. **Use actual field keys** — get them from `field-groups/{module-name}.php`, not guessed names
3. **Field key structure**:
   - Content group key wraps all content fields: `field_{prefix}_content`
   - Styles group key wraps all style fields: `field_{prefix}_styles`
4. **Repeater rows** — store as an associative array keyed by `uniqid()`:
   ```php
   $row_id = uniqid();
   $repeater_data[ $row_id ] = array( 'field_key' => $value );
   ```
5. **Image fields** — store as the attachment integer ID, not an array
6. **Link fields** — store as array with `url`, `title`, `target` keys
7. **Block IDs** — generate with `wp_generate_password( 13, false )`
8. **Page lookup** — use `WP_Query`, not the deprecated `get_page_by_title()`
9. **Error handling** — always check `is_wp_error()` after post operations

---

## Debugging a Blank Block

If the block renders blank on the test page, the most common cause is a mismatch between the field keys in the script and the keys in the field group registration. Cross-check:

1. Open `field-groups/{module-name}.php`
2. Find the `'key'` value for each field (e.g. `'field_herogrid_header'`)
3. Make sure the script uses those exact keys — not guessed or derived names
