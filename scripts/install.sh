#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
SKILLS_DIR="$ROOT_DIR/skills"
DIST_DIR="$ROOT_DIR/dist/claude"

MODE="all"
FORCE=0
DRY_RUN=0
CODEX_DIR="${CODEX_SKILLS_DIR:-$HOME/.agents/skills}"
CLAUDE_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

usage() {
  cat <<'EOF'
Install React Native Developer Skills for local agents.

Usage:
  scripts/install.sh [all|codex|claude] [options]

Options:
  --codex-dir DIR   Codex skills directory (default: $HOME/.agents/skills)
  --claude-dir DIR  Claude local skills directory (default: $HOME/.claude/skills)
  --force           Replace existing installed skill folders
  --dry-run         Print actions without copying files
  -h, --help        Show this help

Notes:
  Codex user skills default to $HOME/.agents/skills per current Codex docs.
  Claude ZIP packages are written to dist/claude/ for upload in Claude.
  Claude direct-copy installs can be overridden with --claude-dir or CLAUDE_SKILLS_DIR.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    all|codex|claude)
      MODE="$1"
      shift
      ;;
    --codex-dir)
      CODEX_DIR="${2:?Missing value for --codex-dir}"
      shift 2
      ;;
    --claude-dir)
      CLAUDE_DIR="${2:?Missing value for --claude-dir}"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [ ! -d "$SKILLS_DIR" ]; then
  echo "Skills directory not found: $SKILLS_DIR" >&2
  exit 1
fi

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

install_skill_dirs() {
  target_root="$1"
  label="$2"

  echo "Installing $label skills to $target_root"
  run mkdir -p "$target_root"

  count=0
  for skill_dir in "$SKILLS_DIR"/*; do
    [ -d "$skill_dir" ] || continue
    [ -f "$skill_dir/SKILL.md" ] || continue
    name=$(basename "$skill_dir")
    target="$target_root/$name"

    if [ -e "$target" ]; then
      if [ "$FORCE" -eq 1 ]; then
        run rm -rf "$target"
      else
        echo "Skipping existing $label skill: $name (use --force to replace)"
        continue
      fi
    fi

    run cp -R "$skill_dir" "$target_root/"
    count=$((count + 1))
  done

  echo "Installed $count $label skill(s)."
}

package_claude_zips() {
  echo "Packaging Claude ZIP files in $DIST_DIR"
  run mkdir -p "$DIST_DIR"

  if command -v zip >/dev/null 2>&1; then
    packer="zip"
  elif command -v ditto >/dev/null 2>&1; then
    packer="ditto"
  else
    echo "Warning: neither zip nor ditto is available; skipping Claude ZIP packaging." >&2
    return 0
  fi

  count=0
  for skill_dir in "$SKILLS_DIR"/*; do
    [ -d "$skill_dir" ] || continue
    [ -f "$skill_dir/SKILL.md" ] || continue
    name=$(basename "$skill_dir")
    zip_path="$DIST_DIR/$name.zip"

    if [ -e "$zip_path" ] && [ "$FORCE" -ne 1 ]; then
      echo "Skipping existing Claude ZIP: $zip_path (use --force to replace)"
      continue
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
      echo "[dry-run] create $zip_path"
    else
      rm -f "$zip_path"
      if [ "$packer" = "zip" ]; then
        (cd "$SKILLS_DIR" && zip -qr "$zip_path" "$name")
      else
        ditto -c -k --sequesterRsrc --keepParent "$skill_dir" "$zip_path"
      fi
    fi
    count=$((count + 1))
  done

  echo "Packaged $count Claude ZIP file(s)."
}

case "$MODE" in
  all)
    install_skill_dirs "$CODEX_DIR" "Codex"
    install_skill_dirs "$CLAUDE_DIR" "Claude"
    package_claude_zips
    ;;
  codex)
    install_skill_dirs "$CODEX_DIR" "Codex"
    ;;
  claude)
    install_skill_dirs "$CLAUDE_DIR" "Claude"
    package_claude_zips
    ;;
esac

echo "Done. Restart Codex or Claude Code if the skills do not appear immediately."
