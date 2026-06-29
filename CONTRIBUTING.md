# Contributing

Thanks for helping improve these React Native skills. This guide covers how to propose a new skill and how to edit an existing one.

## Proposing a New Skill

1. Pick a kebab-case name for the skill (e.g. `error-handling`). This becomes the directory name.
2. Create `skills/{skill-name}/SKILL.md`. Copy [`templates/SKILL.md`](templates/SKILL.md) as a starting point.
3. Fill in the frontmatter and the required sections (see below).
4. Add the skill to the **Skill Index** table in [`README.md`](README.md), with its name, description, and a relative link to its `SKILL.md`.
5. If the skill includes supporting example files, place them in `skills/{skill-name}/examples/`.
6. Run validation and make sure it passes:
   ```bash
   node scripts/validate-skills.mjs
   ```
7. Add a note to [`CHANGELOG.md`](CHANGELOG.md) under the unreleased/next version heading.

## Editing an Existing Skill

1. Make your change in the skill's `SKILL.md`.
2. Bump the `version` field in the frontmatter (semantic versioning — see below).
3. If you changed the description, update the matching entry in the README Skill Index.
4. Run `node scripts/validate-skills.mjs`.
5. Record the change in [`CHANGELOG.md`](CHANGELOG.md).

## Required `SKILL.md` Frontmatter

Every `SKILL.md` begins with a YAML frontmatter block, delimited by `---`, on the first line.

| Field | Type | Required | Notes |
|---|---|---|---|
| `name` | string | Yes | Must match the skill's directory name exactly (kebab-case). |
| `description` | string | Yes | 1–500 characters. States what the skill covers and when to use it. |
| `version` | string | Yes | Semantic version `MAJOR.MINOR.PATCH` (e.g. `1.0.0`). |
| `tags` | list of strings | No | Lowercase letters, digits, and hyphens. |

Example:

```yaml
---
name: performance
description: Review React Native code for rendering performance, lists, images, and memory. Use before merging UI-heavy code.
version: 1.0.0
tags: [react-native, performance]
---
```

## Required `SKILL.md` Structure

Every skill follows this section order:

1. **`# Title`** — a heading naming the skill.
2. **`## When to Use`** — a non-empty list of situations where the skill applies.
3. **`## Guidance`** — the body: checklists and explanations of how to apply the skill.
4. **`## Anti-Patterns`** — *(optional)* a table of common anti-patterns.
5. **`## Pitfalls`** — *(optional, recommended)* a single section listing subtle mistakes and edge cases.

### Examples

- When you show contrasting usage, present it as a pair where each example is explicitly labelled **Correct** or **Incorrect**.
- When a contrast does not aid understanding, other formats (step-by-step walkthroughs, before/after demonstrations) are fine.

## Versioning

- **PATCH** — wording fixes, clarifications, typos.
- **MINOR** — new checklist items, examples, or sections (backward-compatible).
- **MAJOR** — restructuring or removing guidance that changes how the skill is used.

## Content Guidelines

- Keep content vendor-neutral. Recommend capabilities ("a virtualised list") and cite tools as examples, not mandates.
- Never include secrets, credentials, internal endpoints, or proprietary schemas.
