#!/usr/bin/env node
/**
 * validate-skills.mjs
 *
 * Verifies repository structure and skill metadata:
 *  - every SKILL.md lives at skills/{skill-name}/SKILL.md
 *  - every SKILL.md has frontmatter with non-empty `name` and `description`
 *  - the `name` value matches the containing directory name
 *  - every skill directory under skills/ appears in the README skill index
 *
 * Exits non-zero if any check fails; zero if all pass.
 */

import { readdir, readFile, stat } from 'node:fs/promises';
import { join, dirname, basename } from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');
const SKILLS_DIR = join(ROOT, 'skills');
const README = join(ROOT, 'README.md');
const REQUIRED_FIELDS = ['name', 'description'];

const failures = [];
const fail = (msg) => failures.push(msg);

/** Parse a minimal YAML frontmatter block into a flat key/value map. */
function parseFrontmatter(content) {
  const match = /^---\n([\s\S]*?)\n---/.exec(content);
  if (!match) return null;
  const fields = {};
  for (const line of match[1].split('\n')) {
    const m = /^([A-Za-z0-9_-]+):\s*(.*)$/.exec(line);
    if (m) fields[m[1]] = m[2].trim();
  }
  return fields;
}

async function findSkillFiles(dir) {
  const out = [];
  let entries = [];
  try {
    entries = await readdir(dir, { withFileTypes: true });
  } catch {
    return out;
  }
  for (const entry of entries) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) {
      out.push(...(await findSkillFiles(full)));
    } else if (entry.name === 'SKILL.md') {
      out.push(full);
    }
  }
  return out;
}

async function main() {
  let skillsExist = true;
  try {
    await stat(SKILLS_DIR);
  } catch {
    skillsExist = false;
  }

  if (!skillsExist) {
    console.log('No skills/ directory found — nothing to validate.');
    process.exit(0);
  }

  const skillFiles = await findSkillFiles(SKILLS_DIR);
  const indexedNames = new Set();

  let readmeContent = '';
  try {
    readmeContent = await readFile(README, 'utf8');
  } catch {
    fail('README.md not found at repository root.');
  }

  const skillDirNames = [];

  for (const file of skillFiles) {
    const dir = dirname(file);
    const dirName = basename(dir);
    const parent = basename(dirname(dir));

    // Structure: skills/{skill-name}/SKILL.md
    if (parent !== 'skills') {
      fail(`Misplaced skill file (expected skills/{name}/SKILL.md): ${file}`);
    } else {
      skillDirNames.push(dirName);
    }

    const content = await readFile(file, 'utf8');
    const fm = parseFrontmatter(content);

    if (!fm) {
      fail(`Missing frontmatter block: ${file}`);
      continue;
    }

    for (const field of REQUIRED_FIELDS) {
      if (!fm[field] || fm[field].length === 0) {
        fail(`Missing or empty required field "${field}": ${file}`);
      }
    }

    if (fm.name && fm.name !== dirName) {
      fail(`Frontmatter name "${fm.name}" does not match directory "${dirName}": ${file}`);
    }
  }

  // README skill index: each skill directory must be referenced.
  for (const name of skillDirNames) {
    const referenced =
      readmeContent.includes(`skills/${name}/SKILL.md`) ||
      readmeContent.includes(`${name}/SKILL.md`);
    if (referenced) {
      indexedNames.add(name);
    } else {
      fail(`Skill "${name}" is not listed in the README skill index.`);
    }
  }

  if (failures.length > 0) {
    console.error(`\nValidation failed with ${failures.length} issue(s):`);
    for (const f of failures) console.error(`  - ${f}`);
    process.exit(1);
  }

  console.log(`Validation passed: ${skillDirNames.length} skill(s) checked.`);
  process.exit(0);
}

main().catch((err) => {
  console.error('Undetermined failure during validation:', err?.message ?? err);
  process.exit(1);
});
