#!/bin/bash
# guard-destructive.sh
# Event: PreToolUse | Matcher: Bash
#
# Blocks Bash commands that match known destructive patterns.
# Claude receives the reason as feedback and can ask the user to confirm before retrying.
#
# Exit 2 = block the command (stderr message fed back to Claude)
# Exit 0 = allow the command

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

# No command to check — allow
[ -z "$COMMAND" ] && exit 0

# Patterns to flag as destructive
# Add or remove patterns here to tune for your project
PATTERNS=(
  "rm -rf"
  "rm -r /"
  "git reset --hard"
  "git push --force"
  "git push -f "
  "git push -f$"
  "git clean -f"
  "git clean -fd"
  "DROP TABLE"
  "DROP DATABASE"
  "TRUNCATE TABLE"
  "DELETE FROM"
)

for pattern in "${PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qi -- "$pattern"; then
    echo "Destructive command blocked: matches pattern '${pattern}'" >&2
    echo "Command: $COMMAND" >&2
    echo "" >&2
    echo "If this is intentional, confirm with the user before proceeding." >&2
    exit 2
  fi
done

exit 0
