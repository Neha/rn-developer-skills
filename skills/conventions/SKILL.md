---
name: conventions
description: Baseline React Native project conventions for structure, TypeScript, naming, file size, and hygiene. Use when setting up a project, writing new code, or reviewing for consistency.
version: 1.1.0
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, conventions, structure, style]
---

# Conventions

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- Setting up a new React Native project or feature
- Writing new code that should match the project's structure and style
- Reviewing a change for consistency with project conventions

These conventions are intended to apply across all work rather than to one activity. See also [architecture](../architecture/SKILL.md), [testing](../testing/SKILL.md), and [code-review](../code-review/SKILL.md).

## Guidance

### Project Structure

- [ ] One feature per folder under `src/features/{name}/`
- [ ] Features share code only through a `shared/` module — no cross-feature imports
- [ ] Each feature exposes its public API through a barrel `index.ts`
- [ ] Concerns separated: screens (layout), components (reusable UI), hooks (logic), utils (pure functions)

### TypeScript

- [ ] No `any` — use a precise type or `unknown` and narrow

**Incorrect:**
```tsx
function Profile({ user }: { user: any }) {
  return <Text>{user.name}</Text>;
}
```

**Correct:**
```tsx
interface ProfileProps {
  user: { name: string };
}

function Profile({ user }: ProfileProps) {
  return <Text>{user.name}</Text>;
}
```
- [ ] No `@ts-ignore` without an inline explanation of why
- [ ] Component props use a named interface, not an inline object type

### Naming

- [ ] Skill and feature directories use kebab-case (`state-and-data`, not `StateAndData`)
- [ ] Components use PascalCase; hooks use `useCamelCase`; constants use `UPPER_SNAKE_CASE`

### File Size

- [ ] Files kept under ~300 lines and functions under ~50 lines (split when larger)

### Hygiene

- [ ] No `console.log` left in committed code — use a logging utility
- [ ] No commented-out code in commits
- [ ] No `TODO` without a linked ticket

### Commits & Reviews

- [ ] Changes kept focused — one logical change per pull request where practical
- [ ] Focused-skill checklists run before requesting review (see the [code-review](../code-review/SKILL.md) skill)

## Pitfalls

- Conventions only help if applied consistently; one feature that ignores the structure makes the whole codebase harder to navigate.
- Treating file-size limits as hard rules rather than signals leads to awkward splits — use them as a prompt to reconsider, not a strict cutoff.
