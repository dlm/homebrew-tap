#!/usr/bin/env bash
set -euo pipefail

# Single entrypoint to test the formula.
# Default: auto-detect. If Homebrew exists on the host, use it; otherwise run in a clean container.
# Set USE_CONTAINER=1 to force container, USE_CONTAINER=0 to force host Homebrew.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
USE_CONTAINER=${USE_CONTAINER:-}
CONTAINER_ENGINE=${CONTAINER_ENGINE:-docker}

pick_mode() {
  case "${USE_CONTAINER}" in
    0) echo "host" ;;
    1) echo "container" ;;
    "")
      if command -v brew >/dev/null 2>&1; then
        echo "host"
      elif command -v "${CONTAINER_ENGINE}" >/dev/null 2>&1; then
        echo "container"
      else
        echo "none"
      fi
      ;;
    *)
      echo "host"
      ;;
  esac
}

MODE="$(pick_mode)"

if [[ "${MODE}" == "container" ]]; then
  if ! command -v "${CONTAINER_ENGINE}" >/dev/null 2>&1; then
    echo "Error: ${CONTAINER_ENGINE} not found. Install it or set USE_CONTAINER=0 to use host Homebrew." >&2
    exit 1
  fi
  echo "Running tests in container via ${CONTAINER_ENGINE}..."
  ${CONTAINER_ENGINE} run --rm \
    -v "${REPO_DIR}:/repo" \
    -w /repo \
    homebrew/brew:latest \
    bash -lc 'export HOMEBREW_DEVELOPER=1 HOMEBREW_NO_AUTO_UPDATE=1; ./scripts/test-formula.sh'
elif [[ "${MODE}" == "host" ]]; then
  echo "Running tests using existing Homebrew on host..."
  export HOMEBREW_DEVELOPER=${HOMEBREW_DEVELOPER:-1}
  export HOMEBREW_NO_AUTO_UPDATE=1
  exec "${SCRIPT_DIR}/test-formula.sh"
else
  cat >&2 <<'EOF'
Error: No Homebrew found on host and no container engine available.

Install Homebrew (https://brew.sh) or install Docker/Podman and re-run.
You can also force a mode with USE_CONTAINER=1 or USE_CONTAINER=0.
EOF
  exit 1
fi
