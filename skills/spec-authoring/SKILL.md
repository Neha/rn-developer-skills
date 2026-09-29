---
name: spec-authoring
description: Write a spec before building — capturing requirements, design, and tasks in order, with traceability between them. Use when starting any non-trivial feature so work is planned before code is written (Spec/Skill-Driven Development).
version: 1.3.0
platforms: [ios, android]
react-native-version: 0.76+
tags: [spec, planning, ssd, requirements, design]
---

# Spec Authoring Skill

## Applicability

- **Platforms:** iOS and Android
- **React Native:** 0.76+ (New Architecture interop assumed unless a checklist item says otherwise)

## When to Use

- Starting any non-trivial feature or change
- Turning a vague request into a concrete, reviewable plan
- Aligning a team on scope and acceptance criteria before coding
- Whenever you would otherwise jump straight to code and risk rework

This is the entry point for Spec/Skill-Driven Development (SSD): plan the work as a spec, then use the focused skills to guide and review the build.

## Severity

This skill is a planning step. It is not a merge gate.

## Guidance

A spec has three sections, authored in order. Each section builds on the one before it.

### 1. Requirements (first, before any design or code)

Capture *what* must be true, not *how* to build it.

- Write each requirement as a **user story**: "As a {role}, I want {capability}, so that {benefit}."
- Under each story, list **acceptance criteria** in EARS format. Common patterns:
  - `THE {system} SHALL {behaviour}` — ubiquitous rule
  - `WHEN {trigger}, THE {system} SHALL {behaviour}` — event-driven
  - `WHERE {condition}, THE {system} SHALL {behaviour}` — feature-conditional
  - `IF {unwanted condition}, THEN THE {system} SHALL {behaviour}` — error handling
- Record requirements **before** writing any design or implementation detail.

**Incorrect:** a task list with no user story or acceptance criteria.

**Correct:** one user story, EARS acceptance criteria, then the design and tasks that trace back to that story.

### 2. Design (derived from requirements)

Describe *how* the system meets the requirements: components, data flow, screens, state, and key decisions. Every design element should trace back to at least one requirement.

### 3. Tasks (derived from design)

Break the design into ordered, implementable tasks. Every task should trace back to at least one design element, and every design element should be covered by at least one task.

### Traceability

Keep the chain intact: **each requirement → one or more design elements → one or more tasks.** If a task maps to no requirement, either the spec is missing a requirement or the task is out of scope.

### Focused Skills as Inputs

Name the skills this feature touches. Three or four is typical. Do not paste the full catalog into the spec.

Open a skill when the feature does that kind of work: navigation (`architecture`), a list or animation (`performance`), a control (`accessibility`), server data (`state-and-data`), auth or a link target (`security`), inputs (`forms-and-validation`), a permission (`native-integration`), analytics (`observability`), new copy (`i18n-and-localization`), a failure path (`error-handling`), push (`notifications`), colours (`theming`), a React Native bump (`upgrades`), a store or over-the-air build (`release-and-updates`). Finish with `testing` and `code-review`.

If a skill you named is not in `skills/`, say it is unavailable rather than dropping it silently.

## Worked Example

A spec for "Save an item to favourites".

**Skills used:** `state-and-data`, `accessibility`, `error-handling`, `testing`. No forms, notifications, or upgrades.

### Requirements

**Requirement 1: Add to favourites**

*User Story:* As a user, I want to save an item to my favourites, so that I can find it again quickly.

Acceptance Criteria:
1. WHEN the user taps the favourite control on an item card, THE app SHALL mark that item as favourited and reflect it in the UI within one frame.
2. THE app SHALL persist favourites so they survive an app restart.
3. IF the persistence write fails, THEN THE app SHALL revert the control to its previous state and show a non-blocking error.

**Requirement 2: View favourites offline**

*User Story:* As a user, I want to view my saved favourites without a connection, so that I can browse while offline.

Acceptance Criteria:
1. WHERE the device is offline, THE app SHALL display the cached list of favourites.
2. WHERE the list is empty, THE app SHALL display an empty state rather than a blank screen.

### Design

- **Storage:** favourites stored in a fast key-value store, keyed by item id; read on app start into the query cache.
- **State:** server-synced favourites live in the app's existing cache, with an optimistic toggle that rolls back when the write fails (satisfies R1.1, R1.3). The failure UI comes from `error-handling`.
- **Screens:** `FavouritesScreen` (list + empty state) and a reusable `FavouriteButton` (accessible control). `FavouriteButton` carries an `accessibilityLabel` and `accessibilityState` (R-a11y).
- **Offline:** list reads come from cache first; an offline indicator is shown when disconnected (satisfies R2.1).
- **Traceability:** R1 → optimistic mutation + storage; R2 → cached read + empty state.

### Tasks

1. Add the key-value store wrapper and a `useFavourites` query hook. (design: storage, state)
2. Build `FavouriteButton` with optimistic toggle, rollback, and accessibility props. (design: state, screens)
3. Build `FavouritesScreen` with list, empty state, and offline indicator. (design: screens, offline)
4. Add tests: hook unit tests, button behaviour (toggle + rollback), empty/offline states. (review: testing)

## Pitfalls

- Writing design or tasks before requirements leads to building the wrong thing precisely.
- Acceptance criteria that describe implementation ("use a query library") instead of behaviour ("survive an app restart") lock in decisions too early.
- Skipping error-path criteria (the `IF ... THEN` cases) leaves the states users actually hit unplanned.
- A task with no parent requirement is a signal to either add the missing requirement or cut the task.
