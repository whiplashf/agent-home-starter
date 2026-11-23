# Repo pointers

One row per local working copy. `repos/INDEX.md` is the map; each area gets its own file so the map stays readable.

Start with one file. Split an area when it passes about 20 rows.

## Row format

```markdown
| Repo | What | Path | Remote | Notes |
|---|---|---|---|---|
| example | one-line purpose | `~/proj/work/example` | `git@host:org/example.git` | — |
```

- `Path` is absolute or `~/...`; no trailing slash.
- `Remote` is `—` when there is no origin.
- `Notes` is one short phrase, or `—`.
- Sort by path.

## Rules

- One row per working copy. Use `.worktrees/<branch>` for parallel branches; do not list each worktree.
- Do not list archives, dependency caches, nested clones, or generated repos. Put them in `INDEX.md`'s short out-of-scope section if they keep causing confusion.
- Do not put credentials, private IPs, customer names, or tokens in this folder. The remote URL is enough.
- This home repo is not listed in its own map.

The optional `scripts/home-check.sh --scan <root>` reports git repos that exist on disk but are missing here.
