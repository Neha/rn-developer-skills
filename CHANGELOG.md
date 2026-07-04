# Changelog

All notable changes to this repository are documented here. This project follows [semantic versioning](https://semver.org/).

Per-skill history lives in [`skills/CHANGELOG.md`](skills/CHANGELOG.md).

## Unreleased

### Added
- Cross-platform installation scripts for Codex and Claude (`scripts/install.sh`, `scripts/install.ps1`, and `scripts/install.cmd`).
- `docs/skill-authoring-guide.md` — worked example for adding a new skill (`error-handling`).
- `skills/CHANGELOG.md` — per-skill version history.
- `schemas/plugin.schema.json` and `scripts/validate-plugin.mjs` — Cursor plugin manifest validation.
- `platforms` and `react-native-version` frontmatter fields on all skills; `## Applicability` section in each skill.

### Changed
- Plugin logo in `.cursor-plugin/plugin.json` now points to `assets/logo.svg`.
- `scripts/validate-skills.mjs` validates skill metadata, README index, and plugin manifest.

## 1.0.0

Initial public release.

### Added
- `spec-authoring` skill teaching Spec/Skill-Driven Development (requirements → design → tasks).
- Focused skills: `architecture`, `performance`, `accessibility`, `testing`, `state-and-data`, `security`.
- Baseline skills: `critical-rules` (crash/data-loss/security/compliance safety) and `conventions` (structure and style).
- `code-review` skill reworked as an audit entry point that routes each concern to its focused skill.
- Standardised `SKILL.md` frontmatter (`name`, `description`, `version`, optional `tags`).
- `README.md` with a skill index and installation instructions.
- `templates/SKILL.md` and `templates/feature-spec.md`.
- `scripts/validate-skills.mjs` to validate repository structure and skill metadata.
- `CONTRIBUTING.md` and `LICENSE` (MIT).

### Changed
- Skills consolidated under a single canonical `skills/` location.
