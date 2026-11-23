# Home Repo

Machine-level baseline for coding agents on this computer. Shared skills, cross-repo docs, repo pointers. No product code, dependencies, build output, or repo-specific rules.

> If the setup prompt has not been run yet, the paths below are defaults. Adjust them once here and in `docs/placement.md`.

## Priority

1. The repo's own `AGENTS.md` / `CLAUDE.md` (closest to the code).
2. This file (machine-level baseline).
3. Client defaults.

Repo rules may be stricter, but they must not weaken the red lines below.

## Repo map

Start at `repos/INDEX.md`. One file per area, one row per working copy:

- `repos/work.md` — paid work
- `repos/personal.md` — own projects
- `repos/knowledge.md` — notes, wikis, research

Rules:

- Use the existing local copy; do not clone again.
- One copy per repo. Parallel work uses `git worktree add <repo>/.worktrees/<branch>`.
- Read a repo's own `AGENTS.md` before changing it.
- This home repo is not listed in its own map.

## Where things go

Default code root: `~/proj/<area>/<repo>`. If you use a different root, change it here and in `docs/placement.md`.

- runtime data, state, uploads: `~/runtime/<name>`
- venvs: `~/runtime/venvs/<name>`
- small stable scripts: `~/bin`
- cross-repo notes and reports: `~/docs`
- archives: `~/archives/<year>/`
- temporary work: `/tmp/<topic>/` or `<repo>/.scratch/`
- parallel work: `<repo>/.worktrees/<branch>`
- standalone plugins/products: `~/proj/personal/<name>`
- machine wiring (installers, services, credentials): separate private repo

Do not create a new top-level directory under `$HOME`. Ask first.

Full table: `docs/placement.md`.

## Red lines

1. Don't change a repo outside the current working directory without a plan and confirmation.
2. Don't merge, push, rebase, or rewrite another repo's history unless explicitly asked.
3. No tokens, keys, passwords, or private endpoints in any repo.
4. Read-only repos stay read-only.
5. After changing generated client files or machine wiring, run the check; zero drift before calling it done.
6. Don't restart the service that hosts your current session. Hand the command to the user, or run it outside that service's process tree.

## Client entry points

`AGENTS.md` is the only source of truth. Link it into the clients you actually use:

- Claude Code: `~/.claude/CLAUDE.md`
- Codex: `~/.codex/AGENTS.md`
- OpenCode: `~/.config/opencode/AGENTS.md`
- other clients: whatever path they read

Prefer symlinks. If a client needs extra machine-only instructions, keep the extra in your private machine repo and append it at install time; don't fork this file.

## Skills and docs

- `skills/` only for self-authored, cross-repo skills.
- Installed or marketplace skills stay with their installer; don't vendor them.
- `docs/` for cross-repo notes and decisions. Repo-specific docs stay in the repo.
- Machine control (installers, systemd/launchd units, credentials) is out of scope here.

## Structure

| Path | Content |
|---|---|
| `AGENTS.md` | this baseline |
| `repos/` | repo pointers by area |
| `docs/` | placement rules and decisions |
| `skills/` | optional shared skills |
| `scripts/` | optional checks |

## Check

`./scripts/home-check.sh` checks this repo's invariants. It is read-only and has no dependencies beyond Bash and git.
