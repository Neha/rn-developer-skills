---
name: security
description: Review React Native code for secret handling, secure storage, transport security, PII in logs, deep-link validation, input validation, and privacy compliance. Use when handling auth, payments, personal data, or before a security review.
version: 1.0.0
tags: [react-native, security, privacy, compliance]
---

# Security Skill

## When to Use

- Handling authentication, tokens, or payments
- Storing or transmitting personal or sensitive data
- Adding or reviewing deep links
- Preparing for a security or privacy review

## Guidance

### Secrets & Storage

- [ ] No secrets, API keys, or tokens hardcoded (use environment variables)
- [ ] Sensitive data stored in the Keychain (iOS) / Keystore (Android), not plain storage
- [ ] Payment credentials never stored locally (PCI)

### Transport

- [ ] Critical endpoints (payments, auth) use SSL pinning
- [ ] Client-side validation is never trusted alone — the server validates too

### Logging & PII

- [ ] No PII (names, emails, payment info) logged to console or crash reports
- [ ] Third-party SDK log output audited (SDKs may log sensitive data internally)

**Incorrect:**
```tsx
console.log('Payment response:', JSON.stringify(paymentResult));
// Logs a card token to console; ends up in crash reports
```

**Correct:**
```tsx
logger.info('Payment completed', {
  transactionId: paymentResult.id,
  status: paymentResult.status,
});
// Only non-sensitive identifiers
```

### Deep Links & Input

- [ ] Deep-link params validated before navigation (prevent open redirect)
- [ ] Input validated on the client (in addition to, not instead of, the server)

### Auth Lifecycle

- [ ] Token refresh handled silently on 401, without losing form state
- [ ] Auth state and navigation reset on sign-out

### Privacy & Compliance

- [ ] No analytics or device-data collection before user consent (ATT on iOS, GDPR)
- [ ] Data export and deletion supported (GDPR right to erasure)
- [ ] User data not retained beyond the retention policy
- [ ] Permissions (camera, location) requested explicitly, with graceful denial handling

## Pitfalls

- Crash and analytics tools often capture `console.log` by default — disable or filter them so PII does not leak.
- Third-party SDKs may log sensitive payloads internally; verify their output, not just your own.
- Client validation is a UX nicety, not a security control — the server is the source of truth.
- An unvalidated deep link can redirect users into unintended or authenticated content; validate params first.
