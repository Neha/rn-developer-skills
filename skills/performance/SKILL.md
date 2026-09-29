---
name: performance
description: Review React Native code for rendering performance, list virtualisation, memoisation, image handling, animations, and memory/resource cleanup. Use when a screen feels janky, before merging UI-heavy code, or when profiling.
version: 1.1.0
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, performance, memory, rendering]
---

# Performance Skill

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- A screen drops frames, stutters, or feels slow
- Reviewing UI-heavy code or long lists before merge
- Profiling re-renders or memory growth over a session
- Adding animations or large images

## Guidance

### Rendering

Measure before adding memoisation. If the React Compiler is enabled for the file, do not add `useMemo` or `useCallback` only to satisfy this list.

- [ ] A hot child that is already wrapped in `React.memo` does not receive a new function or object on every render
- [ ] A computation that shows up in a profile is cached; trivial work is left as is
- [ ] Styles in a list row are not new objects on every render

**Incorrect:**
```tsx
<UserCard onPress={() => handlePress(user.id)} />
```

**Correct:**
```tsx
<UserCard onPress={handlePress} userId={user.id} />
```

### Lists

- [ ] A list that can grow past one screen is virtualised. A short, bounded list may use a plain list
- [ ] Large data sets paginate or use infinite scroll, never render the full array
- [ ] List items are memoised when a profile shows the row re-rendering unnecessarily

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
| Plain list for a list that can grow without bound | Frame drops | Virtualise (a virtualised list such as FlashList when the default list is not enough) |
| Frequent reads from slow storage | Blocks JS thread | Use a fast key-value store (e.g. MMKV) |
| `Animated` API for complex animations | JS-thread jank | Use Reanimated |
| New style object on every row render | Extra work in a long list | Stable styles, for example `StyleSheet.create` or a module-level object |
| Over-memoising trivial components | Adds overhead with no benefit | Measure first, memoise hotspots |

## Pitfalls

- Over-memoising simple components costs more than it saves — measure before optimising.
- `useMemo` or `useCallback` with the wrong dependency array silently returns stale values.
- Memory leaks compound over a long session (users keep apps open for hours), so cleanup matters even for short-lived screens.
- An `AbortController` must be created per request, not shared across calls.
