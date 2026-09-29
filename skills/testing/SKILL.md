---
name: testing
description: Guidance for testing React Native code — unit tests for logic, component tests for behaviour, E2E for critical paths, and edge-case coverage. Use when adding tests, reviewing test quality, or setting a coverage bar.
version: 1.2.0
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, testing, quality]
---

# Testing Skill

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- Adding tests for a new feature, hook, or utility
- Reviewing whether a change is adequately tested before merge
- Deciding what to test and at which level
- Investigating a regression that tests should have caught

## Severity

A missing test is should-fix. It blocks a merge only when the project's own policy says so.

## Guidance

### What to Test

A critical path is a flow the user cannot finish the job without: sign-in, pay, or the submit this change adds. Cover that path. Do not require an end-to-end test for a colour or copy tweak.

- [ ] Unit tests for hooks and utility functions
- [ ] Component tests for user-facing behaviour, not implementation details
- [ ] An end-to-end test for the critical path this change affects, where the project already has an end-to-end runner
- [ ] Edge cases the screen can actually hit: empty data, error, permission denied, offline, and a killed app if the feature must survive one

### How to Test

- [ ] Mocks sit at the boundary (network, native module), not around the screen's own hooks
- [ ] A native module mock returns the statuses the screen handles, including denied and unavailable
- [ ] No snapshot tests as a primary assertion (brittle, low signal)
- [ ] Tests assert observable behaviour and outputs, not internal calls
- [ ] Each test is independent and does not rely on execution order

**Incorrect:**
```tsx
expect(component.find('useFetchUsers')).toHaveBeenCalled();
```

**Correct:**
```tsx
render(<UserList />);
expect(await screen.findByText('Ada Lovelace')).toBeOnTheScreen();
```

**Incorrect:**
```tsx
jest.mock('camera', () => ({ request: () => 'granted' }));
```

**Correct:**
```tsx
jest.mock('camera', () => ({ request: () => 'denied' }));
render(<ScanScreen />);
expect(await screen.findByText('Camera access is off')).toBeOnTheScreen();
```

## Pitfalls

- Snapshot tests fail on every harmless markup change, training the team to update them without reading — they catch little and erode trust.
- Over-mocking produces tests that pass while the real integration is broken; mock only what you must (network, native modules).
- Testing implementation details (which hook ran, internal state) makes refactoring painful even when behaviour is unchanged.
- A native mock that only returns success hides the denied and unavailable branches users hit.
- Skipping a killed-app case leaves persistence untested for features that claim to survive a restart.
