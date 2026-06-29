# Changelog

All notable changes to this repository are documented here. This project follows [semantic versioning](https://semver.org/).

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

