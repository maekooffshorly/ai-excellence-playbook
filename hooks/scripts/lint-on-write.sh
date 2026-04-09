#!/bin/bash
# lint-on-write.sh
# Event: PostToolUse | Matcher: Edit|Write
#
# Runs the project's linter on the file Claude just wrote or edited.
# Output is surfaced to Claude so lint issues can be fixed in the same turn.
# Exits silently if no supported linter is installed for the file type.
#
# Supported linters:
#   .js .jsx .ts .tsx .vue  ->  ESLint (via npx)
#   .py                     ->  ruff, then flake8
#   .php                    ->  phpcs

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")

# No file path or file doesn't exist — skip
[ -z "$FILE_PATH" ] && exit 0
[ ! -f "$FILE_PATH" ] && exit 0

EXT="${FILE_PATH##*.}"

case "$EXT" in
  js|jsx|ts|tsx|vue|mjs|cjs)
    if command -v npx &>/dev/null; then
      echo "ESLint: $FILE_PATH"
      npx --no eslint "$FILE_PATH" 2>&1 | head -40
    fi
    ;;
  py)
    if command -v ruff &>/dev/null; then
      echo "ruff: $FILE_PATH"
      ruff check "$FILE_PATH" 2>&1 | head -40
    elif command -v flake8 &>/dev/null; then
      echo "flake8: $FILE_PATH"
      flake8 "$FILE_PATH" 2>&1 | head -40
    fi
    ;;
  php)
    if command -v phpcs &>/dev/null; then
      echo "phpcs: $FILE_PATH"
      phpcs "$FILE_PATH" 2>&1 | head -40
    fi
    ;;
esac

exit 0
