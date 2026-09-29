---
name: code-review
description: Audit entry point for reviewing React Native code. Applies crash and data-loss rules on every change, and opens a focused skill only when the diff touches that concern.
version: 3.0.0
platforms: [ios, android]
react-native-version: 0.76+
tags: [react-native, code-review, audit]
---

# Code Review Skill

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- Reviewing a pull request or code change
- Auditing an existing screen or feature for issues
- Running a pre-merge quality gate
- Investigating the root cause of a production bug

This skill is the entry point for a review. It does not restate every check. Apply the steps below, then report findings in the output format.

## Prerequisites

- Access to the code being reviewed
- An understanding of the feature's intended behaviour
- Knowledge of which data is user-sensitive or business-critical

## How to Conduct a Review

1. Always apply [critical-rules](../critical-rules/SKILL.md). Those checks block a merge.
2. Apply [conventions](../conventions/SKILL.md) when the diff adds or renames files, or changes structure or types. Skip it for a behaviour-only edit inside an existing file.
3. Open another skill only when the diff touches that concern. A one-line copy change does not need the forms, list, or notification checklist.
4. When a concern does not apply, write "not applicable" in one line. Do not paste that skill's checklist.

| Concern | Open it when the diff… | Focused Skill |
|---|---|---|
| Architecture | adds a screen, changes navigation, layout, or deep-link lifecycle | [architecture](../architecture/SKILL.md) |
| Performance | changes a list, image, animation, or a screen that drops frames | [performance](../performance/SKILL.md) |
| Accessibility | adds or changes an interactive control, label, or focus | [accessibility](../accessibility/SKILL.md) |
| Testing | changes behaviour a user or caller can observe | [testing](../testing/SKILL.md) |
| State & Data | changes a request, cache, offline path, or transaction | [state-and-data](../state-and-data/SKILL.md) |
| Security | touches auth, secrets, PII, payments, consent, or which link target is allowed | [security](../security/SKILL.md) |
| Native integration | touches permissions, native modules, or background work | [native-integration](../native-integration/SKILL.md) |
| Forms | touches inputs, validation, the keyboard, or submit | [forms-and-validation](../forms-and-validation/SKILL.md) |
| Observability | touches logging, analytics, or crash reporting | [observability](../observability/SKILL.md) |
| Localization | adds user-facing copy, locale formatting, or RTL layout | [i18n-and-localization](../i18n-and-localization/SKILL.md) |
| Error handling | adds a screen, a failure path, or retry | [error-handling](../error-handling/SKILL.md) |
| Notifications | touches push or local notifications | [notifications](../notifications/SKILL.md) |
| Theming | changes colours, dark mode, or theme tokens | [theming](../theming/SKILL.md) |
| Upgrades | bumps React Native or a native dependency | [upgrades](../upgrades/SKILL.md) |
| Release | changes a store build, version, or over-the-air bundle | [release-and-updates](../release-and-updates/SKILL.md) |

**Incorrect:** a review of a button label that opens every skill and files a finding for each unchecked box.

**Correct:** a review that runs `critical-rules`, opens `forms-and-validation` because the diff changes a form, and marks lists, notifications, and upgrades as not applicable.

## Output Format

Structure every review as:

1. **Summary** — overall assessment (solid / needs work / significant issues)
2. **Must-Fix** — crashes, data loss, or a security issue in code this diff touches (block merge)
3. **Should-Fix** — performance, architecture, or missing tests for the behaviour this diff changes
4. **Consider** — alternative approaches, future-proofing, style
5. **What's Good** — well-implemented patterns worth reinforcing

Name the skill each finding comes from. Say which concerns are not applicable.

## Worked Example

Diff: the login button stays disabled until the password field has text. No new request, list, permission, or string catalog.

**Summary:** Needs work. The disabled state is fine. A falsy count is rendered as text, and the new disabled state has no test.

**Must-Fix:**
- `critical-rules`: `{attempts && <Text>}` renders `0` and can crash Android text. Use `attempts > 0 &&`.

**Should-Fix:**
- `testing`: no test that the button is disabled until a password is entered.
- `forms-and-validation`: the failed-login error is colour only.

**Not applicable:** performance, native integration, notifications, theming, upgrades, release, localization.

**Consider:** keep the password rule next to the other field checks.

**What's Good:** a second press is ignored while submit is in flight.

## Pitfalls

- Opening every focused skill on a small diff produces noise, and the real crash gets lost.
- Restating a focused skill's checklist here causes drift. Keep the detail in that skill.
- Skipping "What's Good" removes the part of a review people remember.
