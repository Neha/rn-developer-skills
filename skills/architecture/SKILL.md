---
name: architecture
description: Review and structure React Native features for correct folder layout, navigation, deep linking, error boundaries, rendering safety, and code quality. Use when designing a new feature, reviewing structure, or isolating crashes.
version: 1.0.0
tags: [react-native, architecture, navigation, structure]
---

# Architecture Skill

## When to Use

- Designing the folder and module structure for a new feature
- Reviewing a pull request for structural or navigation issues
- Adding deep links or wiring screens into navigation
- Isolating crashes so one feature cannot take down the whole app
- Checking general code quality before merge

## Guidance

### Feature Structure

- [ ] Feature sits in its own folder (`src/features/{name}/`)
- [ ] No cross-feature imports (share only through a `shared/` module)
- [ ] Barrel export (`index.ts`) only exposes the feature's public API
- [ ] No business logic in components — extract to hooks and utilities
- [ ] Clear separation: screen (layout) vs components (reusable UI) vs hooks (logic)

### Navigation & Deep Linking

- [ ] Screen registered in navigation with type-safe params
- [ ] Deep link configured for every navigable screen
- [ ] Deep link handles both cold start and background resume (different lifecycles)
- [ ] Deep links to authenticated screens check auth state first
- [ ] Expired or invalid deep link content handled gracefully
- [ ] Navigation params treated as optional and validated
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

- [ ] Conditional rendering handles falsy values correctly
- [ ] Components return `null`, not `undefined`, for an empty render
- [ ] List items have stable, unique keys (not array index)

**Incorrect:**
```tsx
{count && <Text>{count} items</Text>}        // renders "0" when count is 0
<Text>Hello {user.name}</Text>               // crashes on Android if name is undefined
```

**Correct:**
```tsx
{count > 0 && <Text>{count} items</Text>}
<Text>Hello {user?.name ?? 'Guest'}</Text>
```

### Resilience & Error Boundaries

- [ ] Error boundary at the app root and one per feature (crash isolated to feature)
- [ ] Graceful degradation: disable a feature rather than crash the app
- [ ] Errors are never swallowed silently
- [ ] Fallback UI is simple enough to never crash itself (no API calls, no complex state)

**Incorrect:**
```tsx
export default function App() {
  return <Navigator />; // one crash anywhere kills the entire app
}
```

**Correct:**
```tsx
export default function App() {
  return (
    <ErrorBoundary fallback={<AppCrashScreen />}>
      <Navigator />
    </ErrorBoundary>
  );
}

function SearchScreen() {
  return (
    <ErrorBoundary fallback={<SearchUnavailable />}>
      <SearchContent />
    </ErrorBoundary>
  );
}
```

### Code Quality

- [ ] TypeScript: no `any`, no `@ts-ignore` without an explanation
- [ ] No `console.log` left in (use a proper logging utility)
- [ ] No commented-out code committed
- [ ] No `TODO` without a linked ticket
- [ ] Component props have a named TypeScript interface (not inline)
- [ ] Files stay under ~300 lines; functions under ~50 lines (split when larger)

## Anti-Patterns

| Anti-Pattern | Why It's Bad | Fix |
|---|---|---|
| Cross-feature imports | Tight coupling, hard to move or delete features | Share through `shared/` only |
| `navigate` called during render | Infinite loop | Move to `useEffect` or an event handler |
| Components defined inside components | Re-mounts every render, loses state | Define at module scope |
| Platform checks scattered everywhere | Hard to follow, easy to miss a case | Use `.ios.ts` / `.android.ts` files |
| `any` type | Defeats TypeScript, hides bugs | Use proper types or `unknown` |
| Missing error boundary | One crash takes down the whole app | Error boundary per feature |

## Pitfalls

- Error boundaries only catch render and lifecycle errors — not errors in event handlers or async code. Handle those explicitly.
- Deep links fire on both cold start and background resume; the two paths have different lifecycles and both need testing.
- `undefined` rendered inside `<Text>` crashes on Android but silently works on iOS, so iOS-only testing misses it.
- Using array index as a list key causes the wrong items to re-render on reorder or delete.
