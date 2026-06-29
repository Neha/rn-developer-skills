---
name: testing
description: Guidance for testing React Native code — unit tests for logic, component tests for behaviour, E2E for critical paths, and edge-case coverage. Use when adding tests, reviewing test quality, or setting a coverage bar.
version: 1.0.0
tags: [react-native, testing, quality]
---

# Testing Skill

## When to Use

- Adding tests for a new feature, hook, or utility
- Reviewing whether a change is adequately tested before merge
- Deciding what to test and at which level
- Investigating a regression that tests should have caught

## Guidance

### What to Test

- [ ] Unit tests for hooks and utility functions
- [ ] Component tests for user-facing behaviour, not implementation details
- [ ] End-to-end flow for each critical path (e.g. with Maestro), where applicable
- [ ] Edge cases covered: empty data, error state, offline, large data sets

### How to Test

- [ ] Mocks are minimal — prefer real implementations where practical
- [ ] No snapshot tests as a primary assertion (brittle, low signal)
- [ ] Tests assert observable behaviour and outputs, not internal calls
- [ ] Each test is independent and does not rely on execution order

**Incorrect:**
```tsx
// Asserts an implementation detail — breaks on harmless refactors
expect(component.find('useFetchUsers')).toHaveBeenCalled();
```

**Correct:**
```tsx
// Asserts what the user sees
render(<UserList />);
expect(await screen.findByText('Ada Lovelace')).toBeOnTheScreen();
```

## Pitfalls

- Snapshot tests fail on every harmless markup change, training the team to update them without reading — they catch little and erode trust.
- Over-mocking produces tests that pass while the real integration is broken; mock only what you must (network, native modules).
- Testing implementation details (which hook ran, internal state) makes refactoring painful even when behaviour is unchanged.
- Skipping edge cases (empty, error, offline) leaves the exact states users hit in production untested.
