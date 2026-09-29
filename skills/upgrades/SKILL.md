---
name: upgrades
description: Upgrade React Native, adopt the New Architecture, and keep native dependencies aligned. Use when bumping React Native, enabling the New Architecture, or updating a native module.
version: 1.0.0
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, upgrades, new-architecture]
---

# Upgrades Skill

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- Bumping React Native, React, or the native toolchain
- Turning the New Architecture on, or adding a native module to an app that already uses it
- A native dependency release forces an app upgrade

## Guidance

### Version jump

- [ ] The target version's changelog is read for breaking changes before the bump
- [ ] A jump across several minors is split so each step boots, instead of one unreviewed leap
- [ ] JS dependencies that ship native code are upgraded in the same change as the React Native bump
- [ ] Both iOS and Android build and launch on the new version before the change is merged

**Incorrect:**
```text
react-native 0.72 → 0.78 in one pull request, Android left for a follow-up
```

**Correct:**
```text
One minor at a time, each step building and launching on iOS and Android, with native modules upgraded in the same step
```

### New Architecture

- [ ] New native modules use the New Architecture interop; a new bridge module is not added without a written reason
- [ ] Modules that do not support the New Architecture are listed, and the feature is hidden or replaced until they do
- [ ] The app is exercised on a New Architecture build for any screen that touches a native module changed in the upgrade

### After the bump

- [ ] A smoke pass covers launch, sign-in, and the critical path this app cannot ship without
- [ ] Release build settings still point at the right environment (see [release-and-updates](../release-and-updates/SKILL.md))
- [ ] Source maps or debug symbols still upload so crashes from the new version can be read (see [observability](../observability/SKILL.md))

## Anti-Patterns

| Anti-Pattern | Risk | Fix |
|---|---|---|
| Editing generated native projects by hand during an upgrade | The next bump overwrites the fix | Put the change in config the upgrade keeps |
| Pinning an old native module "for now" with a patch that skips its install | Crashes on the New Architecture | Upgrade or replace the module in the same change |

## Pitfalls

- A JS-only bump can still break when a dependency's native pod or gradle version moved.
- Hermes and the JS engine flags change between versions; a crash that exists only in release is easy to miss on a debug smoke test.
