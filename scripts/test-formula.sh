#!/usr/bin/env bash
set -euo pipefail

# Get the tap directory (parent of scripts directory)
TAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FORMULA_PATH="${TAP_DIR}/code-hiit.rb"

echo "Testing code-hiit formula from: ${FORMULA_PATH}"

# Ensure Homebrew is in PATH
if ! command -v brew &> /dev/null; then
    if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
        echo "Error: Homebrew not found. Install it or run via container (USE_CONTAINER=1 ./scripts/run-tests.sh)." >&2
        exit 1
    fi
fi

# Ensure we can install from a local path without manual DEVELOPER_MODE
export HOMEBREW_DEVELOPER="${HOMEBREW_DEVELOPER:-1}"
export HOMEBREW_NO_AUTO_UPDATE=1

# Check if formula file exists
if [ ! -f "${FORMULA_PATH}" ]; then
    echo "Error: Formula not found at ${FORMULA_PATH}"
    exit 1
fi

echo ""
echo "Step 1: Installing from local formula..."
brew uninstall --force code-hiit >/dev/null 2>&1 || true
brew install --formula --build-from-source "${FORMULA_PATH}"

echo ""
echo "Step 2: Testing installation..."
if command -v code-hiit &> /dev/null; then
    echo "✓ code-hiit is installed"
    echo ""
    echo "Version output:"
    code-hiit --version
else
    echo "✗ code-hiit command not found"
    exit 1
fi

echo ""
echo "Step 3: Running brew test..."
brew test code-hiit

echo ""
echo "✓ All tests passed!"
echo ""
echo "To uninstall: brew uninstall code-hiit"
