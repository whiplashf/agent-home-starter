#!/usr/bin/env bash
# Read-only invariant check for a portable home repo.
# No dependencies beyond Bash 3.2+ and git.

set -u

usage() {
  cat <<'EOF'
Usage: scripts/home-check.sh [options]

  --repo DIR     Home repo root (default: parent of this script)
  --scan DIR     Report git repos under DIR that are missing from repos/*.md
                 (repeatable; opt-in)
  --entry PATH   Check a client entry file (repeatable)
  --strict       Exit 1 when there are warnings too
  --quiet        Only print warnings and errors
  -h, --help     Show this help

Examples:
  ./scripts/home-check.sh --entry ~/.claude/CLAUDE.md
  ./scripts/home-check.sh --scan ~/proj --strict
EOF
}

REPO_DIR=""
SCAN_DIRS=()
ENTRIES=()
STRICT=0
QUIET=0
ERRORS=0
WARNINGS=0
OKS=0

while [ $# -gt 0 ]; do
  case "$1" in
    --repo)
      [ $# -ge 2 ] || { echo "missing value for --repo" >&2; exit 2; }
      REPO_DIR=$2
      shift 2
      ;;
    --scan)
      [ $# -ge 2 ] || { echo "missing value for --scan" >&2; exit 2; }
      SCAN_DIRS+=("$2")
      shift 2
      ;;
    --entry)
      [ $# -ge 2 ] || { echo "missing value for --entry" >&2; exit 2; }
      ENTRIES+=("$2")
      shift 2
      ;;
    --strict) STRICT=1; shift ;;
    --quiet) QUIET=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

say() { [ "$QUIET" -eq 1 ] && return 0; printf '%s\n' "$*"; }
ok() { OKS=$((OKS + 1)); say "ok   $*"; }
warn() { WARNINGS=$((WARNINGS + 1)); printf 'warn %s\n' "$*"; }
fail() { ERRORS=$((ERRORS + 1)); printf 'fail %s\n' "$*"; }

expand_home() {
  case "$1" in
    "~/"*) printf '%s/%s\n' "$HOME" "${1#\~/}" ;;
    "~") printf '%s\n' "$HOME" ;;
    *) printf '%s\n' "$1" ;;
  esac
}

resolve_path() {
  # Absolute path without requiring GNU realpath (macOS has no -f).
  ( cd "$(dirname "$1")" 2>/dev/null && printf '%s/%s\n' "$(pwd -P)" "$(basename "$1")" )
}

if [ -z "$REPO_DIR" ]; then
  script_dir=$(cd "$(dirname "$0")" 2>/dev/null && pwd -P) || {
    echo "cannot locate script directory" >&2
    exit 2
  }
  REPO_DIR=$(cd "$script_dir/.." && pwd -P) || exit 2
fi

REPO_DIR=$(cd "$REPO_DIR" 2>/dev/null && pwd -P) || {
  echo "not a directory: $REPO_DIR" >&2
  exit 2
}

say "home-check: $REPO_DIR"

if [ -f "$REPO_DIR/AGENTS.md" ]; then
  lines=$(wc -l < "$REPO_DIR/AGENTS.md" | tr -d ' ')
  ok "AGENTS.md ($lines lines)"
  if [ "$lines" -gt 120 ]; then
    warn "AGENTS.md is $lines lines; keep it under about 120"
  fi
  if ! grep -q '^## ' "$REPO_DIR/AGENTS.md"; then
    warn "AGENTS.md has no section headings"
  fi
else
  fail "AGENTS.md missing"
fi

if [ -f "$REPO_DIR/repos/INDEX.md" ]; then
  ok "repos/INDEX.md"
else
  fail "repos/INDEX.md missing"
fi

if [ -f "$REPO_DIR/docs/placement.md" ]; then
  ok "docs/placement.md"
else
  warn "docs/placement.md missing"
fi

if [ -d "$REPO_DIR/repos" ]; then
  for pointer_file in "$REPO_DIR"/repos/*.md; do
    [ -f "$pointer_file" ] || continue
    case "$(basename "$pointer_file")" in
      README.md|INDEX.md) continue ;;
    esac
    while IFS= read -r pointer_path; do
      [ -n "$pointer_path" ] || continue
      expanded=$(expand_home "$pointer_path")
      if [ -e "$expanded" ]; then
        ok "listed path: $pointer_path"
      else
        warn "listed path missing: $pointer_path"
      fi
    done < <(awk -F'|' '/^\|/ { p=$4; gsub(/^[ \t]+|[ \t]+$/, "", p); gsub(/`/, "", p); if (p == "" || p == "Path" || p ~ /^-+$/) next; print p }' "$pointer_file")
  done
fi

if [ ${#ENTRIES[@]} -gt 0 ]; then
  for entry_arg in "${ENTRIES[@]}"; do
    entry=$(expand_home "$entry_arg")
    if [ ! -e "$entry" ] && [ ! -L "$entry" ]; then
      fail "entry missing: $entry"
      continue
    fi
    if [ -L "$entry" ]; then
      target=$(readlink "$entry")
      case "$target" in
        /*) ;;
        *) target=$(dirname "$entry")/$target ;;
      esac
      resolved=$(resolve_path "$target")
      if [ -n "$resolved" ] && [ "$resolved" = "$REPO_DIR/AGENTS.md" ]; then
        ok "entry symlink: $entry"
      else
        warn "entry points elsewhere: $entry -> ${resolved:-$target}"
      fi
    elif cmp -s "$entry" "$REPO_DIR/AGENTS.md"; then
      warn "entry is a copy (will drift): $entry"
    else
      fail "entry differs from AGENTS.md: $entry"
    fi
  done
fi

scan_root() {
  root=$(expand_home "$1")
  if [ ! -d "$root" ]; then
    warn "scan root missing: $root"
    return
  fi
  say "scan $root"
  while IFS= read -r gitdir; do
    case "$gitdir" in
      */.git) repo=${gitdir%/.git} ;;
      *) continue ;;
    esac
    [ "$repo" = "$REPO_DIR" ] && continue

    display=$repo
    case "$repo" in
      "$HOME"/*) display="~/${repo#"$HOME"/}" ;;
    esac

    if grep -R -F -q -- "$display" "$REPO_DIR/repos" 2>/dev/null ||
       grep -R -F -q -- "$repo" "$REPO_DIR/repos" 2>/dev/null; then
      ok "listed: $display"
    else
      warn "repo not listed: $display"
    fi
  done < <(find "$root" -type d \
    \( -name node_modules -o -name .venv -o -name venv -o -name .worktrees -o -name vendor \) -prune -o \
    -type d -name .git -prune -print 2>/dev/null)
}

if [ ${#SCAN_DIRS[@]} -gt 0 ]; then
  for scan_arg in "${SCAN_DIRS[@]}"; do
    scan_root "$scan_arg"
  done
fi

say ""
say "$ERRORS error / $WARNINGS warning / $OKS ok"

if [ "$ERRORS" -gt 0 ]; then
  exit 1
fi
if [ "$STRICT" -eq 1 ] && [ "$WARNINGS" -gt 0 ]; then
  exit 1
fi
exit 0
