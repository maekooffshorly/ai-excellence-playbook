#!/bin/bash
# docs-nudge.sh
# Event: Stop
#
# At session end, checks whether source files were modified this session.
# If modified files exist, surfaces a non-blocking reminder to run /docs.
# Always exits 0 — never blocks Claude from stopping.
#
# Source file types checked: .py .js .ts .jsx .tsx .php .go .rs .rb .java
# Excludes: .claude/ directory, documentation files, config files

INPUT=$(cat)

# Require git
command -v git &>/dev/null || exit 0

# Get modified source files (staged or unstaged, not untracked)
MODIFIED=$(git status --porcelain 2>/dev/null \
  | grep -v "^??" \
  | awk '{print $2}' \
  | grep -v "^\.claude/" \
  | grep -E "\.(py|js|ts|jsx|tsx|php|go|rs|rb|java)$" \
  | head -5)

if [ -n "$MODIFIED" ]; then
  echo "Source files changed this session — consider running /docs before closing:"
  echo "$MODIFIED" | while read -r f; do echo "  - $f"; done
fi

exit 0
