---
name: code-review
description: Audit entry point for reviewing React Native code. Routes each concern to a focused skill and defines the review output format. Use when reviewing a PR, auditing a screen, or running a pre-merge quality gate.
version: 2.0.0
tags: [react-native, code-review, audit]
---

# Code Review Skill

## When to Use

- Reviewing a pull request or code change
- Auditing an existing screen or feature for issues
- Running a pre-merge quality gate
- Investigating the root cause of a production bug

This skill is the entry point for a full review. It does not restate every check — each concern lives in its own focused skill. Work through the relevant skills below, then report findings in the output format.

## Prerequisites

- Access to the code being reviewed
- An understanding of the feature's intended behaviour
- Knowledge of which data is user-sensitive or business-critical

## How to Conduct a Review

Review each concern using its focused skill. Each link resolves to that skill's checklist, examples, and pitfalls — apply those there rather than duplicating them here.

| Concern | Focused Skill | What it covers |
|---|---|---|
| Architecture | [architecture](../architecture/SKILL.md) | Folder structure, navigation, deep linking, rendering safety, error boundaries, code quality |
| Performance | [performance](../performance/SKILL.md) | Re-renders, list virtualisation, images, animations, memory and resource cleanup |
| Accessibility | [accessibility](../accessibility/SKILL.md) | Labels, roles, touch targets, focus order, colour, dynamic type |
| Testing | [testing](../testing/SKILL.md) | Unit, component, and E2E coverage; edge cases; test quality |
| State & Data | [state-and-data](../state-and-data/SKILL.md) | Server state, caching, offline, network transitions, transactions, loading/empty/error states |
| Security | [security](../security/SKILL.md) | Secrets, secure storage, transport, PII in logs, deep-link validation, privacy compliance |

For each concern: open the focused skill, apply its checklist to the code under review, and collect anything that fails into the output format below. If a concern does not apply to the change, note it as not applicable.

## Output Format

Structure every review as:

1. **Summary** — overall assessment (solid / needs work / significant issues)
2. **Must-Fix** — crashes, data loss, security or compliance issues (block merge)
3. **Should-Fix** — performance problems, architecture violations, missing tests
4. **Consider** — alternative approaches, future-proofing, style
5. **What's Good** — well-implemented patterns worth reinforcing

## Pitfalls

- Reviewing only the happy path — the focused skills exist to make sure offline, error, empty, and accessibility states get checked too.
- Restating a focused skill's checklist here instead of linking to it causes drift; keep the detail in one place.
- Skipping the "What's Good" section removes the positive reinforcement that makes reviews land well.
