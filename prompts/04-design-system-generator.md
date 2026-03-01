# Prompt: Design System Generator

## What This Does

This prompt generates a `design-system.md` file from a Figma design system page (or a provided PDF/brief when Figma is not available). It captures tokens, components, layout rules, and handoff constraints for AI-friendly design-to-code workflows.

---

## When to Run It

| Situation | Action |
|-----------|--------|
| Starting a new Figma-driven project | Generate a fresh `design-system.md` from the design system page |
| Design system page changes | Re-run to refresh tokens, components, and rules |
| Only PDF available | Generate a minimal design system (typography + colors + basic layout) |

---

## How to Use

1. Open your project in VS Code with Claude Code
2. Open the Claude Code panel
3. Provide the Figma design system page URL or node ID
4. Paste the prompt below
5. Review the output and confirm any missing information

---

## What to Expect Back

After running the prompt, you will get:

1. A complete `design-system.md` file formatted to the structure below
2. A list of missing or unclear items (if any) that require confirmation
3. Clear notes about any assumptions or inferred values

---

## The Prompt

````markdown
You are generating or updating `design-system.md`.

Your goal is to create a **clear, structured, and AI-friendly design system**
that can be used by developers and AI tools to implement consistent UI.

Use the design system page in Figma as the primary source of truth.
If Figma is unavailable, use the provided PDF or brief and mark the output
as "limited".

---

## INPUTS REQUIRED

- Figma URL or node ID for the design system page
- Project name
- UI framework (e.g., UIkit)
- Any explicit constraints (grid width, breakpoints, asset rules)

If any inputs are missing, list them explicitly under "Open Questions".

---

## OUTPUT STRUCTURE (MANDATORY)

Your output MUST follow this exact structure and order:

# Design System

## Overview
- Project name
- Source of truth (Figma URL/node or PDF)
- UI framework
- Notes on scope (full vs. limited)

## Typography
- Font families (primary, secondary)
- Type scale (H1-H6, body, captions)
- Line height and letter spacing (if specified)

## Color Palette
- Primary, secondary, neutral, and semantic colors
- Hex values or tokens
- Usage notes (buttons, backgrounds, borders, text)

## Spacing and Layout
- Spacing scale
- Section padding and margin rules
- Max width and container rules

## Grid and Breakpoints
- Column count and gutter size
- Breakpoints and responsive rules
- Header/footer layout rules

## Components
- Buttons (variants, states)
- Forms (inputs, labels, error states)
- Cards, navigation, tabs, etc.
- Component constraints and variants

## Icons and Assets
- Approved icon sets
- SVG handling rules (never generate new SVGs)
- Naming conventions for assets

## Interaction and Motion
- Hover states
- Animation rules
- Do-not-use patterns (if any)

## Do and Don't
- Required practices
- Prohibited practices

## Figma References
- Design system page link
- Key component or token nodes

## Open Questions
- Missing values that require confirmation

---

## EXTRA RULES

- Do NOT invent tokens or values not present in the source
- If values are missing, list them under "Open Questions"
- Use concise bullet points and tables where helpful
- Keep it implementation-ready for developers and AI tools

---

After generating `design-system.md`, ask:
"Please review this design system. Are any tokens, components, or rules missing or incorrect?"
````

---

## Output Structure Reference

The generated `design-system.md` will always follow this structure:

```
# Design System
## Overview
## Typography
## Color Palette
## Spacing and Layout
## Grid and Breakpoints
## Components
## Icons and Assets
## Interaction and Motion
## Do and Don't
## Figma References
## Open Questions
```
