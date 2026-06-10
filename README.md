# skills

A personal collection of [agent skills](https://docs.claude.com/en/docs/claude-code/skills)
for the Copilot CLI and Claude. Each skill is a folder under `skills/` containing a
`SKILL.md` — portable markdown the agent loads on demand.

## Install

Symlink every skill in this repo into your agent skills directory (`~/.agents/skills`,
where the Copilot CLI loads user skills):

```bash
./scripts/link-skills.sh
```

The installer is **non-destructive**: it links a skill only when the name is free or the
existing symlink already points into this repo. A real directory or a foreign symlink with
the same name is **skipped with a warning, never deleted** (pass `--force` to override).
Set `AGENTS_SKILLS_DIR` to target a different directory.

Prefer to do it by hand? Symlink one skill:

```bash
ln -s "$PWD/skills/grill-doc" ~/.agents/skills/grill-doc
```

## Skills

- **[grill-doc](skills/grill-doc/SKILL.md)** — Ruthlessly tighten a prose document until
  every word earns its place: decompose paragraph → sentence → word, validate each cut or
  swap upward to the whole doc, and loop to a fixed point.

## Adding a skill

1. Create `skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description`).
2. Run `./scripts/link-skills.sh`.

See [.github/copilot-instructions.md](.github/copilot-instructions.md) for conventions.

## License

[MIT](LICENSE)
