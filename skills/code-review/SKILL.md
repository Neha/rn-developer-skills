---
name: code-review
description: Audit entry point for reviewing React Native code. Applies crash and data-loss rules on every change, and opens a focused skill only when the diff touches that concern.
version: 3.1.0
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

1. Always apply [critical-rules](../critical-rules/SKILL.md), and only to lines this diff adds or edits. A crash on a line the diff does not touch is out of scope. Put a pre-existing issue in Consider only when it sits on a line the diff edits.
2. Apply [conventions](../conventions/SKILL.md) when the diff adds or renames files, or changes structure or types. Skip it for a behaviour-only edit inside an existing file. Conventions findings are should-fix, not merge-blocking.
3. Open another skill only when the diff touches that concern. Read that skill's Severity section before you promote a finding to Must-Fix.
4. List the skills you did not open in one line under **Not applicable**. Do not write a line per skill, and do not paste a checklist.

| Concern | Open it when the diff… | Focused Skill |
|---|---|---|
| Spec | is a new feature and the spec is part of the review. A missing spec is Consider, not a merge block | [spec-authoring](../spec-authoring/SKILL.md) |
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

**Incorrect:** a review that files `{count && <Text>}` when that line is not in the diff, or that writes a "not applicable" line for every skill.

**Correct:** a review that runs `critical-rules` on the changed lines, opens `forms-and-validation` because the diff changes a form, and ends with one line: "Not applicable: performance, notifications, upgrades, release."

## Output Format

Structure every review as:

1. **Summary** — overall assessment (solid / needs work / significant issues)
2. **Must-Fix** — crashes, data loss, or a security issue in code this diff touches (block merge)
3. **Should-Fix** — performance, architecture, or missing tests for the behaviour this diff changes
4. **Consider** — alternative approaches, future-proofing, style
5. **What's Good** — well-implemented patterns worth reinforcing

Name the skill each finding comes from. Say which concerns are not applicable.

## Worked Example

Diff, and only these lines:

```tsx
{password.length && <Text>{password.length} characters</Text>}
<Button
  disabled={password.length === 0}
  title="Log in"
  onPress={submit}
/>
```

No test was added. The button already had a visible label.

**Summary:** Needs work. The disabled check is right. The new character count uses `&&`.

**Must-Fix:**
- `critical-rules`: `{password.length && <Text>}` is in the diff. A length of `0` is falsy. Use `password.length > 0 &&`.

**Should-Fix:**
- `accessibility`: this diff sets `disabled` and does not set `accessibilityState={{ disabled: password.length === 0 }}`.
- `testing`: this diff changes when the button enables and adds no test for that.

**Not applicable:** spec-authoring, architecture, performance, state-and-data, security, native-integration, observability, i18n-and-localization, error-handling, notifications, theming, upgrades, release-and-updates.

**Consider:** none. The empty-password message on an unchanged line stays out of this review.

**What's Good:** `disabled` uses `password.length === 0`, so an empty password cannot submit.

## Pitfalls

- Opening every focused skill on a small diff produces noise, and the real crash gets lost.
- Restating a focused skill's checklist here causes drift. Keep the detail in that skill.
- Skipping "What's Good" removes the part of a review people remember.
