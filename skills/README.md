# Skills

Only self-authored skills that are reused across repos. Installed or marketplace skills stay with their installer; do not vendor them here.

A skill is a directory with a `SKILL.md`:

```
skills/
  my-skill/
    SKILL.md
```

Link it into the clients you use:

```bash
ln -s ~/proj/personal/home/skills/my-skill ~/.claude/skills/my-skill
```

Keep one copy in this repo; clients should point at it. Do not put credentials, private IPs, or customer names in a skill that lives here.
