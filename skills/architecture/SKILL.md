---
name: architecture
description: Review and structure React Native features for correct folder layout, navigation, deep linking, error boundaries, rendering safety, and code quality. Use when designing a new feature, reviewing structure, or isolating crashes.
version: 1.1.0
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, architecture, navigation, structure]
---

# Architecture Skill

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- Designing the folder and module structure for a new feature
- Reviewing a pull request for structural or navigation issues
- Adding deep links or wiring screens into navigation
- Isolating crashes so one feature cannot take down the whole app
- Checking general code quality before merge

## Guidance

### Feature Structure

Follow the folder layout the app already uses. Use the feature-folder layout when the project has no structure yet, or when it already uses feature folders.

- [ ] New code matches the existing folder layout
- [ ] When using feature folders: one feature per `src/features/{name}/`, shared code only through `shared/`, and a barrel `index.ts` exposes the public API
- [ ] No business logic in components — extract to hooks and utilities
- [ ] Clear separation: screen (layout) vs components (reusable UI) vs hooks (logic)

### Navigation & Deep Linking

- [ ] Screen registered in navigation with type-safe params
- [ ] Deep link configured for every navigable screen
- [ ] Deep link handles both cold start and background resume (different lifecycles)
- [ ] Deep links to authenticated screens check auth state first
- [ ] Expired or invalid deep link content handled gracefully
- [ ] Navigation params treated as optional so a missing param does not crash. Whether the link target is allowed is owned by [security](../security/SKILL.md)
- [ ] Back button goes to the expected screen
- [ ] Navigation stack reset on sign-out (no deep-linking back into authenticated content)

**Incorrect:**
```tsx
const { itemId } = route.params; // crashes if params undefined
const item = useItem(itemId);
```

**Correct:**
```tsx
const itemId = route.params?.itemId;
if (!itemId) return <ErrorScreen message="Invalid link" />;
const item = useItem(itemId);
```

### Rendering Safety

Falsy text such as `{count && <Text>}` is owned by [critical-rules](../critical-rules/SKILL.md). Do not file that finding again from this skill.

- [ ] Components return `null`, not `undefined`, for an empty render
- [ ] List items have stable, unique keys (not array index)

### Resilience

Crash isolation, fallback UI, and retry belong to [error-handling](../error-handling/SKILL.md).

- [ ] A feature crash does not leave the rest of the app blank

### Code Quality

TypeScript, naming, file size, and hygiene are owned by [conventions](../conventions/SKILL.md).

## Anti-Patterns

| Anti-Pattern | Why It's Bad | Fix |
|---|---|---|
| Cross-feature imports in a feature-folder app | Tight coupling, hard to move or delete features | Share through `shared/` only |
| `navigate` called during render | Infinite loop | Move to `useEffect` or an event handler |
| Components defined inside components | Re-mounts every render, loses state | Define at module scope |
| Platform checks scattered everywhere | Hard to follow, easy to miss a case | Use `.ios.ts` / `.android.ts` files |
| Missing crash isolation | One crash takes down the whole app | See `error-handling` |

## Pitfalls

- Error boundaries only catch render and lifecycle errors — not errors in event handlers or async code. Handle those explicitly.
- Deep links fire on both cold start and background resume; the two paths have different lifecycles and both need testing.
- Text crashes from rendering `undefined` are owned by `critical-rules`. iOS-only testing misses the Android crash.
- Using array index as a list key causes the wrong items to re-render on reorder or delete.
