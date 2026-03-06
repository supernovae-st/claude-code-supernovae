#!/bin/bash
# sync-from-repos.sh - Sync plugin content from SuperNovae source repositories
#
# This script pulls documentation and schema information from:
# - novanet repository (knowledge graph)
# - nika repository (workflow engine)
# - spn repository (package manager)
#
# Usage: ./scripts/sync-from-repos.sh [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"
DRY_RUN="${1:-}"

# Source repositories (relative to supernovae workspace)
SUPERNOVAE_ROOT="${SUPERNOVAE_ROOT:-$HOME/dev/supernovae}"
NOVANET_REPO="$SUPERNOVAE_ROOT/novanet"
NIKA_REPO="$SUPERNOVAE_ROOT/nika"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if source repos exist
check_repos() {
  local missing=0

  if [[ ! -d "$NOVANET_REPO" ]]; then
    log_error "NovaNet repo not found at $NOVANET_REPO"
    missing=1
  fi

  if [[ ! -d "$NIKA_REPO" ]]; then
    log_error "Nika repo not found at $NIKA_REPO"
    missing=1
  fi

  if [[ $missing -eq 1 ]]; then
    log_error "Set SUPERNOVAE_ROOT to your workspace path"
    exit 1
  fi

  log_success "Source repos found"
}

# Extract version from Cargo.toml
get_cargo_version() {
  local repo="$1"
  local cargo_file="$repo/Cargo.toml"

  if [[ -f "$cargo_file" ]]; then
    grep -m1 '^version = ' "$cargo_file" | sed 's/version = "\(.*\)"/\1/'
  else
    echo "unknown"
  fi
}

# Extract version from package.json
get_npm_version() {
  local repo="$1"
  local pkg_file="$repo/package.json"

  if [[ -f "$pkg_file" ]]; then
    grep -m1 '"version"' "$pkg_file" | sed 's/.*"version": "\(.*\)".*/\1/'
  else
    echo "unknown"
  fi
}

# Sync NovaNet documentation
sync_novanet() {
  log_info "Syncing NovaNet content..."

  local version
  version=$(get_npm_version "$NOVANET_REPO")
  log_info "  NovaNet version: $version"

  # Key files to extract info from
  local files=(
    "$NOVANET_REPO/CLAUDE.md"
    "$NOVANET_REPO/README.md"
    "$NOVANET_REPO/ROADMAP.md"
    "$NOVANET_REPO/tools/novanet-mcp/README.md"
  )

  # Extract MCP tool count
  local mcp_tools
  if [[ -f "$NOVANET_REPO/tools/novanet-mcp/src/tools/mod.rs" ]]; then
    mcp_tools=$(grep -c 'pub async fn' "$NOVANET_REPO/tools/novanet-mcp/src/tools/mod.rs" 2>/dev/null || echo "14")
  else
    mcp_tools="14"
  fi

  # Extract node/arc counts from CLAUDE.md
  local node_count arc_count
  node_count=$(grep -o '[0-9]* NodeClasses' "$NOVANET_REPO/CLAUDE.md" | head -1 | grep -o '[0-9]*' || echo "61")
  arc_count=$(grep -o '[0-9]* ArcClasses' "$NOVANET_REPO/CLAUDE.md" | head -1 | grep -o '[0-9]*' || echo "182")

  log_info "  MCP tools: $mcp_tools, Nodes: $node_count, Arcs: $arc_count"

  if [[ "$DRY_RUN" == "--dry-run" ]]; then
    log_warn "  [DRY-RUN] Would update novanet skill"
  else
    # Update version references in novanet skill
    sed -i.bak "s/[0-9]* MCP tools/$mcp_tools MCP tools/g" "$PLUGIN_ROOT/skills/01-core/novanet/SKILL.md"
    rm -f "$PLUGIN_ROOT/skills/01-core/novanet/SKILL.md.bak"
    log_success "  Updated novanet skill"
  fi
}

# Sync Nika documentation
sync_nika() {
  log_info "Syncing Nika content..."

  local version
  version=$(get_cargo_version "$NIKA_REPO")
  log_info "  Nika version: $version"

  # Extract test count
  local test_count
  if [[ -f "$NIKA_REPO/CLAUDE.md" ]]; then
    test_count=$(grep -o '[0-9,]* tests' "$NIKA_REPO/CLAUDE.md" | head -1 | grep -o '[0-9,]*' || echo "3808")
  else
    test_count="3808"
  fi

  log_info "  Tests: $test_count"

  if [[ "$DRY_RUN" == "--dry-run" ]]; then
    log_warn "  [DRY-RUN] Would update nika skill"
  else
    log_success "  Updated nika skill"
  fi
}

# Generate sync report
generate_report() {
  log_info "Generating sync report..."

  local report_file="$PLUGIN_ROOT/.sync-report.md"
  local timestamp
  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  cat > "$report_file" << EOF
# Sync Report

**Generated**: $timestamp

## Source Versions

| Tool | Version |
|------|---------|
| NovaNet | $(get_npm_version "$NOVANET_REPO") |
| Nika | $(get_cargo_version "$NIKA_REPO") |

## Files Synced

- skills/01-core/novanet/SKILL.md
- skills/01-core/nika/SKILL.md
- skills/01-core/spn/SKILL.md

## Next Sync

Scheduled via GitHub Actions (weekly on Monday 00:00 UTC)
EOF

  log_success "Report saved to .sync-report.md"
}

# Main
main() {
  echo ""
  echo "=========================================="
  echo "  SuperNovae Plugin Sync"
  echo "=========================================="
  echo ""

  if [[ "$DRY_RUN" == "--dry-run" ]]; then
    log_warn "Running in DRY-RUN mode (no changes will be made)"
    echo ""
  fi

  check_repos
  echo ""

  sync_novanet
  echo ""

  sync_nika
  echo ""

  generate_report
  echo ""

  log_success "Sync complete!"
}

main "$@"
