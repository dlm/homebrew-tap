# Homebrew Formula Testing

Single entrypoint: auto-detects whether to use host Homebrew or a clean container.

## Quick start

```bash
./scripts/run-tests.sh
```

If Homebrew is available on the host, it will be used. Otherwise it falls back to the official `homebrew/brew` container (repo mounted at `/repo`).

Prereqs: either Homebrew installed locally, or Docker/Podman available to pull/run `homebrew/brew:latest`.

## Options

- `USE_CONTAINER=1 ./scripts/run-tests.sh` — force container mode (Docker/Podman required).
- `USE_CONTAINER=0 ./scripts/run-tests.sh` — force host Homebrew.
- `CONTAINER_ENGINE=podman ./scripts/run-tests.sh` — swap the container runtime.

## What the tests do

- Ensure Homebrew is available (host or container image)
- Install from source via the local `code-hiit.rb` (as a formula)
- Run `code-hiit --version` and `brew test code-hiit`
