---
name: performance
description: Review React Native code for rendering performance, list virtualisation, memoisation, image handling, animations, and memory/resource cleanup. Use when a screen feels janky, before merging UI-heavy code, or when profiling.
version: 1.0.0
tags: [react-native, performance, memory, rendering]
---

# Performance Skill

## When to Use

- A screen drops frames, stutters, or feels slow
- Reviewing UI-heavy code or long lists before merge
- Profiling re-renders or memory growth over a session
- Adding animations or large images

## Guidance

### Rendering

- [ ] No inline functions passed as props to memoised children (breaks `React.memo`)
- [ ] Heavy computations wrapped in `useMemo`
- [ ] Callbacks passed as props wrapped in `useCallback`
- [ ] Inline styles extracted to `StyleSheet.create` (no new object per render)
- [ ] No unnecessary re-renders (verify with a tool such as why-did-you-render)

**Incorrect:**
```tsx
// New function every render, breaks React.memo on the child
<UserCard onPress={() => handlePress(user.id)} />
```

**Correct:**
```tsx
const handleUserPress = useCallback((id: string) => {
  handlePress(id);
}, [handlePress]);

<UserCard onPress={handleUserPress} userId={user.id} />
```

### Lists

- [ ] Long lists use a virtualised, high-performance list (e.g. FlashList), not a plain `FlatList`
- [ ] Large data sets paginate or use infinite scroll, never render the full array
- [ ] List items are memoised where appropriate

### Images

- [ ] Images lazy loaded below the fold
- [ ] Images use a modern compressed format (e.g. WebP) at correct dimensions (no oversized assets)

### Animations

- [ ] Complex animations run on the UI thread (e.g. Reanimated), not the JS thread
- [ ] No animation work blocking interaction

### Loading & Imports

- [ ] Screens lazy loaded per navigation stack
- [ ] No full-library imports for a single function (import only what is used)
- [ ] No synchronous storage reads on mount that block the first render

### Memory & Resources

- [ ] Async operations cancelled on unmount
- [ ] Timers and intervals cleared on unmount
- [ ] Event listeners removed on cleanup
- [ ] Caches have a max size and an eviction policy

**Incorrect:**
```tsx
useEffect(() => {
  const interval = setInterval(pollStatus, 5000);
  // No cleanup — keeps running after unmount
}, []);
```

**Correct:**
```tsx
useEffect(() => {
  const interval = setInterval(pollStatus, 5000);
  return () => clearInterval(interval);
}, []);
```

## Anti-Patterns

| Anti-Pattern | Risk | Fix |
|---|---|---|
| `FlatList` for long lists | Frame drops | Use FlashList or equivalent |
| Frequent reads from slow storage | Blocks JS thread | Use a fast key-value store (e.g. MMKV) |
| `Animated` API for complex animations | JS-thread jank | Use Reanimated |
| Inline styles in render | New object each render, breaks memo | `StyleSheet.create` |
| Over-memoising trivial components | Adds overhead with no benefit | Measure first, memoise hotspots |

## Pitfalls

- Over-memoising simple components costs more than it saves — measure before optimising.
- `useMemo` or `useCallback` with the wrong dependency array silently returns stale values.
- Memory leaks compound over a long session (users keep apps open for hours), so cleanup matters even for short-lived screens.
- An `AbortController` must be created per request, not shared across calls.
