# Setup prompt

Copy everything below the line into a coding agent opened at the root of your new home repo. Review its plan before letting it write.

---

You are setting up a Home Repo for one developer's computer. The repo already contains a template: `AGENTS.md`, `repos/`, `docs/placement.md`, `skills/`, and `scripts/home-check.sh`. Turn it into the real map of this machine with minimal changes and no surprises.

## Contract

- Inspect first, then present a plan. Do not write until the user approves.
- Never delete a repo, a file, or a git remote.
- Never push, merge, rebase, or rewrite history.
- Never print or commit secrets. If a remote URL contains a token, strip it and tell the user.
- Ask at most five questions, in one batch. If the user says "just do it", use the defaults below and record the assumptions.
- Prefer existing local copies. Do not clone anything unless the user asks.

## Defaults

- Home repo: the current directory.
- Code roots: `~/proj`, `~/src`, `~/code`, `~/dev`; use the ones that exist.
- Client entries: `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.config/opencode/AGENTS.md`, `~/.agents/AGENTS.md`; only wire clients that are installed.
- Areas: derive from the first path segment under the code root (`work`, `personal`, `github`, ...). If unclear, use `work` and `personal`.

## Step 1 — Inventory

Find git working copies under the code roots:

```bash
find <root> -type d -name .git -prune -print
```

Skip `.worktrees`, `node_modules`, `.venv`, `venv`, and `vendor`. For each copy, record:

- absolute path
- `git remote get-url origin` with credentials stripped
- last commit date: `git log -1 --format=%cs`
- whether it is a working copy, a bare repo, or a nested clone

Classify each as `in` (belongs in the map), `out` (archive, dependency, generated, empty `.git`), or `ask` (uncertain). Show the table before writing anything.

Do not scan `/`, network mounts, or other users' directories.

## Step 2 — Fill `AGENTS.md`

Keep the structure. Replace the defaults that do not match this machine:

- the code root, if it is not `~/proj`
- the repo-area list, to match Step 1

Keep it under about 100 lines. Do not add repo-specific rules; those belong in each repo. If the user has a private machine repo, add one line:

`Machine wiring: <path> (private).`

Do not copy credentials, internal hostnames, customer names, or private IPs into this file.

## Step 3 — Build the repo map

Create or replace `repos/INDEX.md` with one row per area file:

```markdown
| Area | File | What |
|---|---|---|
| work | `work.md` | paid work |
| personal | `personal.md` | own projects |
| knowledge | `knowledge.md` | notes and wikis |
```

For each area, create `repos/<area>.md` using this header:

```markdown
| Repo | What | Path | Remote | Notes |
|---|---|---|---|---|
| example | one-line purpose | `~/proj/work/example` | `git@host:org/example.git` | — |
```

One row per repo, sorted by path. Use `—` for a missing remote. Do not list:

- this home repo
- `.worktrees/*`
- nested clones under another repo's `tmp/` or `vendor/`
- archives and dependency caches

If a repo is `out`, put it in a short `## Out of scope` section in `repos/INDEX.md` with the reason. Keep that list short; it is a map, not an audit log.

## Step 4 — Skills

List the user's self-authored skills (directories with `SKILL.md`) outside this repo. Do not copy installed or marketplace skills. For each candidate, show:

- name, path, and one-line purpose
- whether it contains credentials, private IPs, or customer names

Ask which ones to vendor. Default: none. If vendored, copy to `skills/<name>/` and add a symlink from the client's skill directory; keep a backup. If the user has no self-authored skills, leave `skills/README.md` and move on.

## Step 5 — Placement

Read `docs/placement.md`. Adjust only what differs on this machine: code root, runtime directory, archive directory. Keep the "do not create a new top-level directory" rule.

## Step 6 — Wire clients (plan only)

For each installed client, compare its entry file with `AGENTS.md`:

- missing → propose a symlink
- symlink to this file → ok
- regular file identical → ok, note that it will drift
- regular file different → propose backup + symlink; show a diff summary

Do not touch a client the user does not use. Do not overwrite without a backup. If a client needs extra machine-only instructions, propose `<client>.extra.md` in the private machine repo and a small append step; do not fork `AGENTS.md`.

## Step 7 — Verify and commit

Run:

```bash
./scripts/home-check.sh --scan <each code root> --entry <each wired entry>
```

Fix errors; report warnings. Then show:

```bash
git status
git diff --stat
```

Commit locally with a message like `chore: map this machine`. Do not push.

## Output

Return:

1. inventory summary: in / out / ask counts
2. files changed, one line each
3. check result
4. what you did not do: unwired clients, skipped skills, unpushed commit
5. one concrete next step for the user

## Definition of done

- A new agent can answer "where is repo X", "where does a new script go", and "which rules apply" by reading this repo.
- Every `in` repo appears once in `repos/`.
- The AGENTS entry points the user uses point at this file, or the difference is documented.
- `home-check.sh` passes, or every warning has a stated reason.
- Nothing was pushed, deleted, or rewritten.
