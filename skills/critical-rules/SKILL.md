---
name: critical-rules
description: Non-negotiable React Native rules that prevent crashes, data loss, security breaches, and compliance violations. Use on every change as a baseline safety check, regardless of the task.
version: 1.0.0
tags: [react-native, safety, crashes, security, compliance]
---

# Critical Rules

## When to Use

- On every React Native change, as a baseline safety check
- Before merging any code that touches rendering, data, auth, or storage
- When reviewing a change for crash, data-loss, security, or compliance risk

These rules are intended to apply broadly rather than to one activity. The detailed guidance behind them lives in the related skills: [architecture](../architecture/SKILL.md), [state-and-data](../state-and-data/SKILL.md), and [security](../security/SKILL.md).

## Guidance

### Crashes

- [ ] Optional chaining used for nested access (`user?.profile?.name`)
- [ ] Fallbacks provided for API data (`data?.items ?? []`)
- [ ] Never render undefined/null/NaN/objects directly in JSX text (crashes Android)
- [ ] `{count && <Text>}` avoided — renders "0" when count is 0; use `count > 0 &&`
- [ ] Array indices never accessed without a length check
- [ ] Empty, loading, and error states handled for every data-driven screen
- [ ] State never updated after unmount (cancel async work, clean up in `useEffect`)
- [ ] Components never defined inside other components (re-mounts every render)
- [ ] Hooks never called conditionally or inside loops

### Data Loss

- [ ] Form state preserved when navigating back
- [ ] Transaction interruption handled (user kills the app mid-operation)
- [ ] Critical actions confirmed server-side, not from the client alone
- [ ] POST requests never auto-retried on network restore (avoids duplicate submissions)
- [ ] Destructive offline mutations never queued without user confirmation

### Security

- [ ] No secrets, API keys, or tokens hardcoded
- [ ] Sensitive data stored only in Keychain (iOS) / Keystore (Android)
- [ ] SSL pinning on critical API endpoints (payments, auth)
- [ ] No PII (names, emails, payment info) logged to console or crash reports
- [ ] Deep-link params validated before navigating (prevent open redirect)
- [ ] Auth state and navigation reset on sign-out
- [ ] Payment credentials never stored locally (PCI)

### Compliance

- [ ] No analytics or device-data collection before user consent (ATT on iOS, GDPR)
- [ ] Data export and deletion supported (GDPR right to erasure)
- [ ] User data not retained beyond the retention policy
- [ ] Permissions (camera, location) requested explicitly, with graceful denial handling

### Network

- [ ] Network timeouts handled (never hang forever)
- [ ] 401 handled with silent token refresh, not a crash
- [ ] Client-side validation never trusted alone
- [ ] In-progress requests cancelled on screen unmount

### Dates

- [ ] Time-sensitive data never displayed or calculated without explicit timezone handling
- [ ] Device local time never used for business logic (server time is the source of truth)

## Pitfalls

- These are baseline rules, not the full picture — the focused skills (`architecture`, `state-and-data`, `security`) explain the *why* and show correct/incorrect examples.
- A rule that "usually" holds is still worth checking every time; crashes and leaks come from the one case that was skipped.
