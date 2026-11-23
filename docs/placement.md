# Where things go

One table, one decision per path. The default is a suggestion; consistency matters more than the exact name.

| Thing | Default | Notes |
|---|---|---|
| Working repo | `~/proj/<area>/<repo>` | Use the existing copy; one copy only. |
| Personal repo | `~/proj/personal/<repo>` | Own projects and experiments. |
| Runtime data | `~/runtime/<name>` | State, uploads, local databases. |
| Python venv | `~/runtime/venvs/<name>` | Never inside a repo. |
| Small stable script | `~/bin/<name>` | Reusable across repos. |
| Cross-repo doc | `~/docs/<topic>` | Notes, reports, decisions. |
| Archive | `~/archives/<year>/` | Cold storage; not a workspace. |
| Temporary work | `/tmp/<topic>/` or `<repo>/.scratch/` | Delete when done. |
| Parallel work | `<repo>/.worktrees/<branch>` | Do not make a second clone. |
| Standalone plugin | `~/proj/personal/<name>` | Its own repo. |
| Machine wiring | separate private repo | Installers, services, credentials. |
| New `$HOME` top-level | don't | Ask first. |

## Three rules

1. If a local copy exists, use it; don't clone again.
2. One repo, one copy; use worktrees for parallel branches.
3. If you cannot classify something, ask instead of inventing a directory.

## Machine wiring

This repo is portable. Service definitions, install scripts, secrets, and host-specific paths belong in a separate private repo. Keep this table generic so it can be shared.
