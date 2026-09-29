# Skills Changelog

Per-skill change history. When you edit a skill, bump its `version` in frontmatter and add an entry under that skill below.

Format: **MAJOR.MINOR.PATCH** — brief description of what changed and why.

---

## spec-authoring

### 1.2.0
- Point design at the newer skills, and only the ones the feature touches.

### 1.1.0
- Added a correct/incorrect example so requirements stay ahead of tasks.

### 1.0.1
- Added `platforms` and `react-native-version` frontmatter; added Applicability section.

### 1.0.0
- Initial skill: requirements → design → tasks workflow for Spec/Skill-Driven Development.

## architecture

### 1.1.0
- Follow the app's existing layout. Text crashes point at `critical-rules`. Failure UI points at `error-handling`.

### 1.0.1
- Added `platforms` and `react-native-version` frontmatter; added Applicability section.

### 1.0.0
- Initial skill: feature structure, navigation, deep linking, rendering safety, error boundaries.

## performance

### 1.1.0
- Virtualise lists that can grow, and skip memoisation that the React Compiler or a profile does not ask for.

### 1.0.1
- Added `platforms` and `react-native-version` frontmatter; added Applicability section.

### 1.0.0
- Initial skill: rendering, lists, images, animations, memory cleanup.

## accessibility

### 1.0.1
- Added `platforms` and `react-native-version` frontmatter; added Applicability section.

### 1.0.0
- Initial skill: labels, roles, touch targets, focus, colour, dynamic type.

## state-and-data

### 1.1.0
- Form preservation is owned by `forms-and-validation`.

### 1.0.1
- Added `platforms` and `react-native-version` frontmatter; added Applicability section.

### 1.0.0
- Initial skill: server state, caching, offline, network transitions, loading/empty/error states.

## security

### 1.1.0
- Pin transport only when the threat model requires it. Open-redirect checks stay here; missing-param crashes stay in `architecture`.

### 1.0.1
- Added `platforms` and `react-native-version` frontmatter; added Applicability section.

### 1.0.0
- Initial skill: secrets, secure storage, transport, PII, deep links, privacy compliance.

## testing

### 1.1.0
- Define a critical path, and cover permission denied, offline, and native-module mocks.

### 1.0.1
- Added `platforms` and `react-native-version` frontmatter; added Applicability section.

### 1.0.0
- Initial skill: unit, component, and E2E testing guidance.

## critical-rules

### 2.0.0
- Keep crash and data-loss checks on every change. Point security and compliance detail at `security`.

### 1.1.0
- Added a correct/incorrect example for rendering a count in text.

### 1.0.1
- Added `platforms` and `react-native-version` frontmatter; added Applicability section.

### 1.0.0
- Initial skill: non-negotiable crash, data-loss, security, and compliance rules.

## conventions

### 1.2.0
- Apply the feature-folder layout only when the project uses it or has no layout yet.

### 1.1.0
- Added a correct/incorrect example for avoiding `any` on component props.

### 1.0.1
- Added `platforms` and `react-native-version` frontmatter; added Applicability section.

### 1.0.0
- Initial skill: project structure, TypeScript, naming, file size, hygiene.

## native-integration

### 1.0.0
- Initial skill: permissions, native modules, platform APIs, background tasks, and listener cleanup.

## forms-and-validation

### 1.0.1
- Note that this skill owns dirty form input. `critical-rules` only checks that it is not discarded silently.

### 1.0.0
- Initial skill: form state, validation timing, keyboard handling, error focus, and submit safety.

## observability

### 1.0.0
- Initial skill: crash reporting, breadcrumbs, performance traces, analytics, and PII-safe logging.

## i18n-and-localization

### 1.0.0
- Initial skill: extracted strings, plurals, locale-aware formatting, RTL layout, and fallback locales.

## release-and-updates

### 1.0.0
- Initial skill: store builds, versioning, and over-the-air JavaScript updates.

## theming

### 1.0.0
- Initial skill: colour tokens, dark mode, and system appearance.

## upgrades

### 1.0.0
- Initial skill: React Native upgrades and the New Architecture.

## notifications

### 1.0.0
- Initial skill: push and local notifications, permission timing, tap routing, and payload privacy.

## error-handling

### 1.0.0
- Initial skill: error boundaries, failure UI, retry, and global handlers.

## code-review

### 3.0.0
- Scope a review to the diff, and include a worked example of the output.

### 2.5.0
- Route baseline safety and conventions on every review, and show a correct/incorrect review shape.

### 2.4.0
- Route localization concerns to the new focused skill.

### 2.3.0
- Route observability concerns to the new focused skill.

### 2.2.0
- Route form concerns to the new focused skill.

### 2.1.0
- Route native-integration concerns to the new focused skill.

### 2.0.1
- Added `platforms` and `react-native-version` frontmatter; added Applicability section.

### 2.0.0
- Reworked as audit entry point routing each concern to a focused skill.

### 1.0.0
- Initial monolithic review checklist (superseded by 2.0.0).
