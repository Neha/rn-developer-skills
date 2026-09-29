---
name: observability
description: Review React Native crash reporting, breadcrumbs, performance traces, and analytics for PII-safe production debugging. Use when adding monitoring or reviewing observability in a change.
version: 1.0.1
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, observability, crashes, analytics, privacy]
---

# Observability Skill

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- Adding crash reporting, analytics, performance traces, or a logging strategy
- Reviewing what a change records about the user or the session
- Debugging a production failure that cannot be reproduced on a device

## Severity

- **Merge-blocking:** a new event or log in this diff includes a name, email, token, or payment data.
- **Should-fix:** missing traces and breadcrumb wording.

## Guidance

Names, emails, and payment data in logs are also merge-blocking under [critical-rules](../critical-rules/SKILL.md). File that finding once, from `critical-rules`, when the line is in the diff.

### Crashes and errors

- [ ] Uncaught JavaScript errors, unhandled promise rejections, and native crashes are reported, and release builds can be symbolicated
- [ ] An error boundary reports the screen it failed on and still shows a recovery UI
- [ ] Caught errors that the user can retry are not also reported as crashes
- [ ] Dev and debug builds do not send events to the production project

### Context

- [ ] Breadcrumbs record the action (screen opened, request failed) without the payload
- [ ] A correlation id is attached to the client event and the matching server request
- [ ] User id, when set, is an internal id, not an email, name, or phone number
- [ ] Events are separated by environment (dev, staging, production)

**Incorrect:**
```tsx
logger.error('checkout failed', { email, cardLast4, token });
```

**Correct:**
```tsx
logger.error('checkout failed', {
  correlationId,
  screen: 'Checkout',
  status: error.status,
});
```

### Performance

- [ ] Screen-load and API-latency traces exist for the flows that matter, with a start and an end
- [ ] A trace is cancelled or dropped when the screen unmounts before it finishes
- [ ] JS-thread stalls are sampled; they are not logged on every frame

### Analytics and privacy

- [ ] Event names are stable and documented; properties follow one schema
- [ ] No names, emails, payment data, tokens, or free-text user content are in events or logs
- [ ] Collection starts only after the required consent (see `security`)
- [ ] Offline events are queued with a cap and are not sent with a payload captured before consent

## Anti-Patterns

| Anti-Pattern | Risk | Fix |
|---|---|---|
| Logging the request body | PII and tokens land in a vendor log | Log status, route template, and correlation id |
| A catch that reports and also swallows | The user sees a success while the crash tool fills with noise | Show the error, and report only unexpected failures |
| One analytics name reused for different actions | Funnels lie | One name per action, with a written schema |
| Sending debug logs to the production project | Dev traffic hides real crashes | Split the project or the environment tag and drop dev |

## Pitfalls

- Release crashes without source maps or native symbols point at minified frames. Confirm symbol upload for the build that shipped.
- A high sample rate on a chatty trace (scroll, animation) can drain battery and blow the quota. Sample those; keep crashes unsampled.
- Offline queues replay old events after the user logs out. Drop or re-key the queue on sign-out.
- Breadcrumbs that include search text or form values become a second store of personal data. Keep them to navigation and outcomes.
