# 0001 Keep knowledge and machine wiring separate

Status: accepted
Date: 2026-11-23

## Context

A home repo can be either a knowledge map or a machine provisioning system. Combining them makes the portable part depend on one OS, one service manager, and one set of credentials. That is how a "share your setup" repo becomes impossible to share.

## Decision

This repo owns the portable knowledge: `AGENTS.md`, repo pointers, placement rules, optional skills, and a read-only check. Machine wiring — installers, systemd or launchd units, service contracts, credentials — lives in a separate private repo.

## Consequences

- The public repo can be forked and read by anyone without leaking host details.
- A new machine needs two repos: this one and the private wiring repo.
- Client entry points can be symlinks (simple) or generated copies (when a client needs extra machine instructions).
- The check script validates knowledge invariants, not service state.
- If the portable repo disappears, the machine still runs; if the wiring repo disappears, the map is still useful.
