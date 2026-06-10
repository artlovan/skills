#!/usr/bin/env bash
set -euo pipefail

# Symlinks every skill in this repo into the agent skills directory so the local
# Copilot / Claude CLI can load them.
#
# Non-destructive by design: a skill is linked only when its name is free, or when
# an existing symlink already points into this repo. A real file/dir or a foreign
# symlink with the same name is skipped with a warning — never deleted. Pass --force
# to replace such collisions.
#
# Override the destination with AGENTS_SKILLS_DIR (default: ~/.agents/skills).

FORCE=0
[ "${1:-}" = "--force" ] && FORCE=1

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"
mkdir -p "$DEST"

linked=0 skipped=0
for skill_md in "$REPO"/skills/*/SKILL.md; do
  [ -e "$skill_md" ] || continue
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"
  target="$DEST/$name"

  if [ -L "$target" ]; then
    cur="$(readlink "$target")"
    case "$cur" in
      "$REPO"/*)
        ln -sfn "$src" "$target"; echo "updated  $name"; linked=$((linked + 1)) ;;
      *)
        if [ "$FORCE" = 1 ]; then
          ln -sfn "$src" "$target"; echo "forced   $name (was -> $cur)"; linked=$((linked + 1))
        else
          echo "skip     $name: symlink exists -> $cur (not ours; use --force)"; skipped=$((skipped + 1))
        fi ;;
    esac
  elif [ -e "$target" ]; then
    if [ "$FORCE" = 1 ]; then
      rm -rf "$target"; ln -s "$src" "$target"; echo "forced   $name (replaced real path)"; linked=$((linked + 1))
    else
      echo "skip     $name: real file/dir at $target (not overwriting; use --force)"; skipped=$((skipped + 1))
    fi
  else
    ln -s "$src" "$target"; echo "linked   $name"; linked=$((linked + 1))
  fi
done

echo "---"
echo "$linked linked, $skipped skipped → $DEST"
