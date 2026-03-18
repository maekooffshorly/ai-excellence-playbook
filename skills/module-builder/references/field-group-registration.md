# Field Group Registration

Use this guide to create or version-control the ACF field group that powers a block's editable fields.

---

## field-group.json (ACF Export Format)

Field groups are exported from ACF and version-controlled alongside the block. The export is a JSON **array** wrapping one or more field group objects. Template:

```json
[
    {
        "key": "group_{unique_id}",
        "title": "Block: {Human Readable Block Name}",
        "fields": [
            {
                "key": "field_{unique_id}",
                "label": "Content",
                "name": "content",
                "aria-label": "",
                "type": "group",
                "instructions": "",
                "required": 0,
                "conditional_logic": 0,
                "wrapper": {
                    "width": "",
                    "class": "",
                    "id": ""
                },
                "layout": "block",
                "acfe_seamless_style": 0,
                "acfe_group_modal": 0,
                "sub_fields": [
                    {
                        "key": "field_{unique_id}",
                        "label": "Items",
                        "name": "items",
                        "aria-label": "",
                        "type": "repeater",
                        "instructions": "",
                        "required": 0,
                        "conditional_logic": 0,
                        "wrapper": {
                            "width": "",
                            "class": "",
                            "id": ""
                        },
                        "acfe_repeater_stylised_button": 0,
                        "layout": "block",
                        "pagination": 0,
                        "min": 0,
                        "max": 0,
                        "collapsed": "",
                        "button_label": "Add Row",
                        "rows_per_page": 20,
                        "sub_fields": [
                            {
                                "key": "field_{unique_id}",
                                "label": "{Field Label}",
                                "name": "{field_name}",
                                "aria-label": "",
                                "type": "{field_type}",
                                "instructions": "",
                                "required": 0,
                                "conditional_logic": 0,
                                "wrapper": {
                                    "width": "",
                                    "class": "",
                                    "id": ""
                                },
                                "parent_repeater": "field_{items_field_id}"
                            }
                        ]
                    }
                ],
                "acfe_group_modal_close": 0,
                "acfe_group_modal_button": "",
                "acfe_group_modal_size": "large"
            },
            {
                "key": "field_{unique_id}",
                "label": "Styles",
                "name": "styles",
                "aria-label": "",
                "type": "group",
                "instructions": "",
                "required": 0,
                "conditional_logic": 0,
                "wrapper": {
                    "width": "",
                    "class": "",
                    "id": ""
                },
                "layout": "block",
                "acfe_seamless_style": 0,
                "acfe_group_modal": 0,
                "sub_fields": [
                    {
                        "key": "field_{unique_id}",
                        "label": "Background Color",
                        "name": "background_color",
                        "aria-label": "",
                        "type": "radio",
                        "instructions": "",
                        "required": 0,
                        "conditional_logic": 0,
                        "wrapper": {
                            "width": "",
                            "class": "",
                            "id": ""
                        },
                        "choices": {
                            "white": "White",
                            "neutral": "Neutral",
                            "dark": "Dark",
                            "primary": "Primary"
                        },
                        "default_value": "",
                        "return_format": "value",
                        "allow_null": 0,
                        "other_choice": 0,
                        "allow_in_bindings": 0,
                        "layout": "vertical",
                        "save_other_choice": 0
                    }
                ],
                "acfe_group_modal_close": 0,
                "acfe_group_modal_button": "",
                "acfe_group_modal_size": "large"
            }
        ],
        "location": [
            [
                {
                    "param": "block",
                    "operator": "==",
                    "value": "acf\/{module-name}"
                }
            ]
        ],
        "menu_order": 0,
        "position": "normal",
        "style": "default",
        "label_placement": "left",
        "instruction_placement": "label",
        "hide_on_screen": "",
        "active": true,
        "description": "",
        "show_in_rest": 0,
        "display_title": "",
        "acfe_autosync": "",
        "acfe_form": 0,
        "acfe_meta": "",
        "acfe_note": ""
    }
]
```

**Key conventions:**
- `"key"` values (`group_*`, `field_*`) — auto-generated by ACF; do not invent them manually. Export from ACF/ACFE to get real keys.
- `"title"` — use the `"Block: {Name}"` prefix convention to keep field groups identifiable in the ACF admin.
- **Two top-level groups** are the standard pattern: `content` (holds repeaters and text fields) and `styles` (holds presentation options like background color).
- `"location"` `"value"` — must be `acf/{module-name}`, matching the block type name with the `acf/` prefix.
- `"parent_repeater"` — each sub-field inside a repeater must carry the repeater field's key here.
- `"label_placement": "left"` — project default; keeps the admin UI compact.
