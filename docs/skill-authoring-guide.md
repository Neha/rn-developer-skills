# Skill Authoring Guide

Worked example of the steps for adding a skill. [`error-handling`](../skills/error-handling/SKILL.md) is that skill now. Follow the same steps for the next one. The snippets below show the shape; do not create a second `error-handling` directory.

For required structure and frontmatter fields, see [CONTRIBUTING.md](../CONTRIBUTING.md).

---

## 1. Pick a name and scope

- **Directory name:** `error-handling` (kebab-case, matches frontmatter `name`)
- **Scope:** How RN apps catch, surface, recover from, and log errors — without duplicating `observability` (logging/analytics) or `critical-rules` (safety baseline)
- **When to use:** Building error boundaries, API error UI, retry flows, global handlers

---

## 2. Create the skill file

```bash
mkdir -p skills/error-handling
cp templates/SKILL.md skills/error-handling/SKILL.md
```

Edit frontmatter:

```yaml
---
name: error-handling
description: Guide error boundaries, API failure UI, retry flows, and global handlers in React Native. Use when adding error recovery, reviewing failure states, or preventing silent failures.
version: 1.0.0
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, errors, recovery]
---
```

Add the **Applicability** section immediately after the title:

```markdown
# Error Handling Skill

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use
...
```

---

## 3. Write the body

Follow the section order from CONTRIBUTING:

1. **When to Use** — bullet list of trigger situations
2. **Guidance** — checklists with **Incorrect** / **Correct** pairs where helpful
3. **Anti-Patterns** *(optional)* — table of mistakes
4. **Pitfalls** — subtle gotchas

Example checklist item:

```markdown
### API and async errors

- [ ] Every async screen handles loading, success, empty, and error states
- [ ] Errors show actionable copy (retry, contact support) — not raw server messages
- [ ] Global unhandled rejection handler registered at app root
- [ ] Error boundaries wrap feature subtrees so one crash does not blank the app

**Incorrect:**
```tsx
const { data } = useQuery(['items'], fetchItems);
return <List data={data} />; // undefined while loading; crash on error
```

**Correct:**
```tsx
const { data, isLoading, isError, refetch } = useQuery(['items'], fetchItems);
if (isLoading) return <Loading />;
if (isError) return <ErrorView onRetry={refetch} />;
return <List data={data ?? []} />;
```
```

Keep guidance **vendor-neutral** — describe capabilities ("a query library", "an error boundary") rather than mandating one library.

---

## 4. Wire the skill into the repo

| Step | File | Action |
|---|---|---|
| Index | `README.md` | Add row to Skill Index table with link to `skills/error-handling/SKILL.md` |
| Review router | `skills/code-review/SKILL.md` | Add row to the concern routing table if reviews should cover errors |
| Changelog | `skills/CHANGELOG.md` | Add `### 1.0.0` entry under `## error-handling` |
| Repo changelog | `CHANGELOG.md` | Note the new skill under the next release heading |

---

## 5. Validate

```bash
node scripts/validate-skills.mjs
node scripts/validate-plugin.mjs   # optional standalone plugin check
```

Validation checks:

- Frontmatter required fields (`name`, `description`, `version`, `platforms`, `react-native-version`)
- `name` matches directory name
- `platforms` contains only `ios` and/or `android`
- `## Applicability` section exists
- Skill appears in README index
- `.cursor-plugin/plugin.json` is valid and paths resolve

---

## 6. Open a pull request

Use the PR template. Example summary:

> Add `error-handling` skill covering error boundaries, API failure UI, and global handlers. Updates README index, code-review router, and skills changelog.

Checklist from the PR template:

- [ ] Frontmatter `name` matches directory
- [ ] `version` set for new skill (`1.0.0`)
- [ ] README Skill Index updated
- [ ] `node scripts/validate-skills.mjs` passes
- [ ] `skills/CHANGELOG.md` updated

---

## Frontmatter reference

| Field | Required | Example |
|---|---|---|
| `name` | Yes | `error-handling` |
| `description` | Yes | What + when (under 500 chars) |
| `version` | Yes | `1.0.0` |
| `platforms` | Yes | `[ios, android]` |
| `react-native-version` | Yes | `0.76+` |
| `tags` | No | `[react-native, errors]` |

When editing an existing skill, bump **PATCH** for typos, **MINOR** for new checklist items, **MAJOR** for restructuring — and record the change in `skills/CHANGELOG.md`.
