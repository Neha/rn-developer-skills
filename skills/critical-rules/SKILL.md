---
name: critical-rules
description: Non-negotiable React Native crash and secret checks. Use on every change, and only on lines the diff touches.
version: 2.1.0
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, safety, crashes, data-loss]
---

# Critical Rules

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- On every React Native change, on the lines the diff touches
- Before merging any code that renders text, calls hooks, or logs

Loading and error UI, form preservation, and network retries live in the focused skills. Open those only when the diff touches them.

## Severity

Every check below is merge-blocking, and only when the offending line is in the diff.

## Guidance

File a finding only on a line this diff adds or edits.

### Crashes

- [ ] Never render undefined, null, NaN, or objects as JSX text (crashes Android)
- [ ] `{count && <Text>}` avoided — a count of `0` is falsy and the text node is wrong; use `count > 0 &&`
- [ ] Hooks are not called conditionally or inside loops
- [ ] Components are not defined inside other components
- [ ] State is not updated after unmount

**Incorrect:**
```tsx
{count && <Text>{count} items</Text>}
```

**Correct:**
```tsx
{count > 0 && <Text>{count} items</Text>}
```

### Secrets

- [ ] No secrets, API keys, or tokens hardcoded in the diff
- [ ] No names, emails, or payment data logged to the console or a crash report from the diff

## Owned elsewhere

Open the other skill only when the diff touches that concern. Do not re-check it here.

- Unsaved input, duplicate submit: [forms-and-validation](../forms-and-validation/SKILL.md)
- POST retry, timeouts, offline mutations, server confirmation: [state-and-data](../state-and-data/SKILL.md)
- Loading, empty, and error UI for server data: [state-and-data](../state-and-data/SKILL.md). Boundaries and retry: [error-handling](../error-handling/SKILL.md)
- Storage, transport, link targets, consent: [security](../security/SKILL.md)
- Timezones for business deadlines: [i18n-and-localization](../i18n-and-localization/SKILL.md)
- Timers and listeners: [performance](../performance/SKILL.md)

## Pitfalls

- A pre-existing `{count && <Text>}` on a line the diff does not touch is not a must-fix for this change.
- Text rendered from `0` is owned by this skill. Do not file it again from another skill.
