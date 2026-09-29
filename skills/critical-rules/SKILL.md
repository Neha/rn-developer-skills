---
name: critical-rules
description: Non-negotiable React Native rules that prevent crashes and data loss. Use on every change as a baseline safety check, regardless of the task.
version: 2.0.0
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, safety, crashes, data-loss]
---

# Critical Rules

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- On every React Native change, as a baseline safety check
- Before merging any code that touches rendering or user data

These checks block a merge. Deeper security, privacy, and compliance checks live in [security](../security/SKILL.md) and block a merge only when the diff touches that area. Form preservation in detail lives in [forms-and-validation](../forms-and-validation/SKILL.md). Failure UI lives in [error-handling](../error-handling/SKILL.md).

## Guidance

### Crashes

- [ ] Optional chaining used for nested access (`user?.profile?.name`)
- [ ] Fallbacks provided for API data (`data?.items ?? []`)
- [ ] Never render undefined/null/NaN/objects directly in JSX text (crashes Android)
- [ ] `{count && <Text>}` avoided — renders "0" when count is 0; use `count > 0 &&`

**Incorrect:**
```tsx
{count && <Text>{count} items</Text>}
```

**Correct:**
```tsx
{count > 0 && <Text>{count} items</Text>}
```
- [ ] Array indices never accessed without a length check
- [ ] Empty, loading, and error states handled for every data-driven screen
- [ ] State never updated after unmount (cancel async work, clean up in `useEffect`)
- [ ] Components never defined inside other components (re-mounts every render)
- [ ] Hooks never called conditionally or inside loops

### Data Loss

- [ ] Unsaved user input is not discarded silently (the form rules live in [forms-and-validation](../forms-and-validation/SKILL.md))
- [ ] Transaction interruption handled (user kills the app mid-operation)
- [ ] Critical actions confirmed server-side, not from the client alone
- [ ] POST requests never auto-retried on network restore (avoids duplicate submissions)
- [ ] Destructive offline mutations never queued without user confirmation

### Secrets on every change

- [ ] No secrets, API keys, or tokens hardcoded
- [ ] No PII (names, emails, payment info) logged to console or crash reports

Storage, transport, deep-link targets, auth reset, consent, and retention are checked with [security](../security/SKILL.md) when the diff touches them. They are not re-checked on an unrelated change.

### Network

- [ ] Network timeouts handled (never hang forever)
- [ ] In-progress requests cancelled on screen unmount

Token refresh on 401, and trusting the client as the only validator, are checked with [security](../security/SKILL.md) when the diff touches auth or a request.

### Dates

- [ ] Time-sensitive data never displayed or calculated without explicit timezone handling
- [ ] Device local time never used for business logic (server time is the source of truth)

## Pitfalls

- A copy or style change still runs the crash and data-loss checks. It does not need the full security or compliance list.
- Text rendered from a value of `0` is owned by this skill. Do not file the same finding from another skill.
