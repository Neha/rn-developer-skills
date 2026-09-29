---
name: error-handling
description: Guide error boundaries, API failure UI, retry flows, and global handlers in React Native. Use when adding error recovery, reviewing failure states, or preventing silent failures.
version: 1.1.0
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, errors, recovery]
---

# Error Handling Skill

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- Adding an error boundary or a fallback when a feature fails
- Designing what the user sees when an API call, mutation, or native call fails
- Adding retry, or deciding that a request must not be retried
- Reviewing a screen that can fail and currently only handles the happy path

Reporting the failure to a crash or analytics tool belongs to [observability](../observability/SKILL.md). Crash rules that apply to every render belong to [critical-rules](../critical-rules/SKILL.md).

## Severity

- **Merge-blocking:** a feature this diff adds can throw during render and take the app down with it, or a submit this diff adds swallows the error.
- **Should-fix:** error copy and retry wording.

## Guidance

### Isolation

- [ ] An error boundary wraps the app root and each feature that can fail on its own
- [ ] The fallback UI renders without network calls or the state that just threw
- [ ] A feature failure disables or replaces that feature and leaves the rest of the app usable
- [ ] Errors in event handlers and async work are caught where they happen (a boundary does not catch them)

**Incorrect:**
```tsx
export default function App() {
  return <Navigator />;
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
```

### What the user sees

Loading, empty, and error states for server data are owned by [state-and-data](../state-and-data/SKILL.md).

- [ ] The error copy says what happened and what to do next, not the raw server or native message
- [ ] A caught error the user can retry is not also shown as a full-screen crash

### Retry

- [ ] Retry is an explicit button or a single bounded attempt, not an unbounded loop
- [ ] Retrying a POST when the network returns is owned by [state-and-data](../state-and-data/SKILL.md)
- [ ] A retry uses the same idempotency key as the original attempt when the server supports one

## Anti-Patterns

| Anti-Pattern | Risk | Fix |
|---|---|---|
| Empty `catch` | The user sees a spinner or a success state for a failed action | Surface an error state and log a non-sensitive reason |
| Fallback that fetches data | The fallback throws and replaces itself | Static fallback with a retry action |
| Alert for every failed background refresh | Interrupts the user for a failure they did not start | Inline error on the screen that owns the data |

## Pitfalls

- Error boundaries catch render errors. They do not catch `onPress` handlers, timers, or rejected promises.
- A global unhandled-rejection handler is a backstop for reporting. It is not a substitute for an error state on the screen that started the work.
- Resetting the boundary on every render remounts the broken tree and can loop.
