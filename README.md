# React Native Developer Skills

A collection of focused, vendor-neutral skills that help React Native developers practise **Spec/Skill-Driven Development (SSD)**: plan work as a spec before building, then use focused skills to guide and audit the implementation.

Each skill is a self-contained Markdown guide with a clear "when to use", a checklist, correct/incorrect examples, and pitfalls. They are written to be dropped into any RN project and consumed by a developer or an AI agent.

## What is Spec/Skill-Driven Development?

Instead of jumping straight to code, you:

1. **Spec it** — capture requirements, then design, then tasks (see the `spec-authoring` skill).
2. **Build it** — implement, using the focused skills (architecture, performance, state, etc.) as guidance.
3. **Review it** — audit the result with the `code-review` skill, which routes each concern to its focused skill.

The same skills inform all three stages: what guides the build also defines the review criteria.

## Skill Index

### Plan
| Skill | Description |
|---|---|
| [spec-authoring](skills/spec-authoring/SKILL.md) | Write a spec before building — requirements, design, and tasks in order, with traceability between them. |

### Build & review (focused areas)
| Skill | Description |
|---|---|
| [architecture](skills/architecture/SKILL.md) | Folder structure, navigation, deep linking, rendering safety, error boundaries, and code quality. |
| [performance](skills/performance/SKILL.md) | Re-renders, list virtualisation, images, animations, and memory/resource cleanup. |
| [accessibility](skills/accessibility/SKILL.md) | Labels, roles, touch targets, focus order, colour, and dynamic type. |
| [state-and-data](skills/state-and-data/SKILL.md) | Server state, caching, offline behaviour, network transitions, transactions, and loading/empty/error states. |
| [security](skills/security/SKILL.md) | Secrets, secure storage, transport security, PII in logs, deep-link validation, and privacy compliance. |
| [testing](skills/testing/SKILL.md) | Unit, component, and E2E coverage; edge cases; and test quality. |

### Baseline (apply to every change)
| Skill | Description |
|---|---|
| [critical-rules](skills/critical-rules/SKILL.md) | Non-negotiable rules that prevent crashes, data loss, security breaches, and compliance violations. |
| [conventions](skills/conventions/SKILL.md) | Project conventions for structure, TypeScript, naming, file size, and hygiene. |

### Audit
| Skill | Description |
|---|---|
| [code-review](skills/code-review/SKILL.md) | Entry point that routes each concern to its focused skill and defines the review output format. |

## Installation

These skills are plain Markdown, so you can adopt them in whichever way suits your workflow:

1. **Clone or copy** this repository (or just the `skills/` folder) into your project, for example under `.kiro/` or a `docs/` directory.
2. **Point your agent or team at them.** If you use an AI development tool that supports skills, place `skills/` where the tool expects them.
3. **Reference a skill when you work.** Open the relevant `SKILL.md` (or ask your agent to apply it) when planning, building, or reviewing.
4. **Run validation** (optional) to keep contributions consistent:
   ```bash
   node scripts/validate-skills.mjs
   ```

## Using a Skill

Each `SKILL.md` follows the same shape, so any skill is predictable to navigate:

- **When to Use** — the situations the skill applies to.
- **Guidance** — checklists and explanations, with correct/incorrect examples.
- **Anti-Patterns** *(where useful)* — a table of common mistakes and their fixes.
- **Pitfalls** — subtle gotchas the checklist alone does not catch.

Start with `spec-authoring` for a new feature, reach for the focused skills while building, and finish with `code-review`.

## Repository Layout

```
skills/            one folder per skill, each with a SKILL.md
templates/         starting points for new skills and specs
scripts/           validation tooling
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to propose a new skill or edit an existing one, including the required `SKILL.md` structure and frontmatter. New skills should pass `node scripts/validate-skills.mjs` and be added to the Skill Index above.

## License

[MIT](LICENSE)
