# agent-home-starter

A small, portable **Home Repo** for one developer's computer.

It gives every coding agent the same three answers:

- which repos exist on this machine
- where new files belong
- which rules apply

No daemon, no provisioning framework, no Python. A handful of Markdown files, one optional Bash check, and a setup prompt you can paste into your agent.

## Why

Coding agents are good at code and bad at machine context. Every new session re-derives where repos live, which copy is canonical, and whether `~/scratch` is allowed. A home repo fixes that with plain text: one repo that points at all the others.

This starter is the thin version:

- knowledge lives in git
- machine wiring stays out
- the agent does the inventory once, then reads the result

Inspired by the Home Repo Pattern popularized by Matt Pocock.

## Quick start (10 minutes)

1. Create your copy:
   - on GitHub: **Use this template** → create `<you>/home`
   - or locally: `git clone https://github.com/whiplashf/agent-home-starter ~/proj/personal/home`
2. Open the folder in your coding agent and paste [`SETUP_PROMPT.md`](SETUP_PROMPT.md).
3. Review the plan, let it write, run the check, commit.

The setup prompt inventories your repos, fills `AGENTS.md`, creates `repos/`, and proposes client wiring. It asks before deleting or pushing anything.

## What's in the box

Minimal path: copy `AGENTS.md` and `SETUP_PROMPT.md`. Everything else is scaffolding you can add later.

| Path | Purpose |
|---|---|
| `AGENTS.md` | machine-level baseline; the only agent-facing source of truth |
| `SETUP_PROMPT.md` | copy-paste setup task for an agent |
| `repos/` | one line per working copy, split by area |
| `docs/placement.md` | where files go |
| `docs/decisions/` | optional ADRs |
| `skills/` | optional self-authored shared skills |
| `scripts/home-check.sh` | optional invariant check |

## The design in five rules

1. **One source.** `AGENTS.md` is the only source of truth. Client files are symlinks or generated copies.
2. **Pointers, not copies.** `repos/` says where a repo is; it does not mirror its content.
3. **Knowledge and wiring are separate.** This repo is portable. Your systemd units, install scripts, and credentials belong in a private machine repo.
4. **Check invariants, not file diffs.** The optional script checks that entry points resolve, that listed repos exist, and that no git repo is missing from the map.
5. **No delete, no push by default.** The setup prompt writes locally and stops.

## Wiring your clients

Use symlinks when the client accepts a file path; use a generated copy when it doesn't.

```bash
# Claude Code
ln -s ~/proj/personal/home/AGENTS.md ~/.claude/CLAUDE.md

# Codex
ln -s ~/proj/personal/home/AGENTS.md ~/.codex/AGENTS.md

# OpenCode
ln -s ~/proj/personal/home/AGENTS.md ~/.config/opencode/AGENTS.md
```

Back up existing files first. If a client needs extra machine-only instructions, keep an `extra.md` in your private machine repo and append it; don't fork the shared file.

## Optional check

```bash
./scripts/home-check.sh --entry ~/.claude/CLAUDE.md
./scripts/home-check.sh --scan ~/proj
```

`--scan` is opt-in; it walks the roots you name and reports git repos missing from `repos/*.md`. It skips `.worktrees`, `node_modules`, and venvs.

## What this is not

- Not Ansible, Nix, or a provisioning system.
- Not a backup tool.
- Not a place for product code, dependencies, or secrets.
- Not a replacement for each repo's own `AGENTS.md`.

If you need reproducible machine setup, keep that in a separate private repo and let this one stay thin.

## Requirements

Linux or macOS, `git`, Bash 3.2+. No Python, no network calls.

## License

MIT
