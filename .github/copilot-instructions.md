# Copilot instructions

This repo is a personal collection of **agent skills** for the Copilot CLI and Claude.
There is no application to build — the deliverable is the skills themselves.

## Layout

```
skills/<name>/SKILL.md   one skill per folder (pure markdown)
scripts/link-skills.sh   non-destructive symlink installer
```

A skill may add `REFERENCE.md` / `EXAMPLES.md` and a `scripts/` subfolder, but only when
warranted (see below).

## SKILL.md convention

- YAML frontmatter with `name` and `description`. The **description is the only thing the
  agent sees when deciding whether to load the skill** — write it in the third person,
  state what it does, then `Use when …` with concrete triggers/keywords. Keep it under
  1024 characters.
- Keep the body lean (aim < ~100 lines). Push rarely-needed detail into a sibling
  `REFERENCE.md` / `EXAMPLES.md` rather than bloating `SKILL.md`.
- Skills should be **exemplary-concise** — every line earns its place.

## Install / runtime model

- The Copilot CLI loads user skills from `~/.agents/skills/`. Skills are installed by
  **symlinking** each `skills/<name>/` into that directory via `scripts/link-skills.sh`.
- The installer never deletes or overwrites a colliding name unless `--force` is passed.
- **No npx / Node.** `skills.sh` (the `npx skills add …` ecosystem) is a Node installer
  for broad multi-agent public distribution; it is unrelated to a skill's own scripts and
  is not used here. Installation is plain bash symlinks.

## Pure-markdown first

- Most skills are **pure markdown** — no scripts. `grill-doc` is a reasoning/judgment task
  with no deterministic step, so it ships no code.
- Add a helper script only when an operation is **deterministic and repeated** (validation,
  formatting, indexing). **Python** is the established helper language for these skills
  (see the author's `brag-doc` repo). Reserve **Rust** for a genuine need for a fast,
  distributable binary — not yet warranted.

## Behavioural conventions for skills

- **Skills never run git.** The user drives all git operations.
- **Skills act only on material the user explicitly points them at** — never scan the repo
  and pick files on their own.
- **Edits require approval** and are applied in place; the skill reports what changed.

## Validating changes

No build or test suite. Syntax-check shell scripts before relying on them:

```bash
bash -n scripts/link-skills.sh        # parse check
shellcheck scripts/link-skills.sh     # if shellcheck is installed
```
