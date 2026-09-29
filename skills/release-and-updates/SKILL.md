---
name: release-and-updates
description: Ship React Native release builds, store binaries, and over-the-air JavaScript updates safely. Use when cutting a release, publishing to a store, or shipping an OTA bundle.
version: 1.0.1
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, release, ota, store]
---

# Release and Updates Skill

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- Cutting a build for TestFlight, Play testing, or a store
- Changing version or build numbers, API environments, or signing
- Shipping JavaScript over the air without a store binary

## Severity

- **Merge-blocking:** a release binary this diff configures still talks to staging, or an over-the-air bundle ships a change that needs new native code.
- **Should-fix:** listing copy and rollout notes.

## Guidance

### Store binary

- [ ] The release build talks to the production API and does not include dev-only menus or logs
- [ ] Secrets and tokens are not embedded in the JS bundle or the native project (see [security](../security/SKILL.md))
- [ ] Version name and build number both increase, and the store listing matches the binary that was tested
- [ ] Debug symbols or source maps for this build are retained so crashes can be read (see [observability](../observability/SKILL.md))
- [ ] The privacy disclosure matches what the binary actually collects

**Incorrect:**
```text
Release scheme still uses the staging API host baked in at build time
```

**Correct:**
```text
The release configuration selects the production host, and a smoke test on the release binary confirms it
```

### Over-the-air updates

- [ ] An OTA bundle is published only for native binaries it is compatible with
- [ ] A native change (new module, permission, or SDK) ships in a store binary, not only in an OTA bundle
- [ ] A bad bundle can be rolled back, and the client does not apply a bundle from a different app or environment
- [ ] An update is not forced in the middle of a payment, form submit, or other non-idempotent action

## Anti-Patterns

| Anti-Pattern | Risk | Fix |
|---|---|---|
| One OTA channel for staging and production | Staging JS runs against production users | Separate channels per environment |
| Shipping a new native module as JavaScript only | Crash on launch for users who have not updated the binary | Gate the feature on a native version check and ship a store build |

## Pitfalls

- A debug build hiding a release-only crash (Hermes, minification, missing env var) is the usual surprise. Smoke the release binary.
- Users on an old binary keep receiving OTAs until the compatibility range excludes them. Exclude them when the JS expects new native code.
