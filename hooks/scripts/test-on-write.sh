#!/bin/bash
# test-on-write.sh
# Event: PostToolUse | Matcher: Edit|Write (async: true)
#
# After Claude writes a source file, finds and runs the corresponding test file.
# Does NOT run the full test suite — only the paired test file for the changed file.
# Exits silently if no paired test file is found.
#
# Test file lookup order (example: src/auth.ts):
#   src/auth.test.ts
#   src/auth.spec.ts
#   src/__tests__/auth.test.ts
#   src/__tests__/auth.spec.ts
#   tests/test_auth.ts
#   src/tests/test_auth.ts
#
# Supported runners:
#   .py   ->  python -m pytest
#   .js .jsx .ts .tsx  ->  npx jest

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")

# No file path or file doesn't exist — skip
[ -z "$FILE_PATH" ] && exit 0
[ ! -f "$FILE_PATH" ] && exit 0

BASENAME=$(basename "$FILE_PATH")
DIR=$(dirname "$FILE_PATH")
NAME="${BASENAME%.*}"
EXT="${BASENAME##*.}"

# Skip if this file is itself a test file
case "$BASENAME" in
  *.test.*|*.spec.*|test_*|*_test.*) exit 0 ;;
esac
case "$FILE_PATH" in
  */__tests__/*|*/tests/*|*/test/*) exit 0 ;;
esac

# Candidate test file locations (checked in priority order)
CANDIDATES=(
  "${DIR}/${NAME}.test.${EXT}"
  "${DIR}/${NAME}.spec.${EXT}"
  "${DIR}/__tests__/${NAME}.test.${EXT}"
  "${DIR}/__tests__/${NAME}.spec.${EXT}"
  "${DIR}/../tests/test_${NAME}.${EXT}"
  "${DIR}/tests/test_${NAME}.${EXT}"
  "tests/test_${NAME}.${EXT}"
)

for TEST_FILE in "${CANDIDATES[@]}"; do
  if [ -f "$TEST_FILE" ]; then
    echo "Running: $TEST_FILE"
    echo "---"
    case "$EXT" in
      py)
        python -m pytest "$TEST_FILE" -v --no-header --tb=short 2>&1 | tail -40
        ;;
      js|jsx|ts|tsx)
        if command -v npx &>/dev/null; then
          npx --no jest "$TEST_FILE" --no-coverage --no-color 2>&1 | tail -40
        fi
        ;;
    esac
    exit 0
  fi
done

# No test file found — silent exit
exit 0
