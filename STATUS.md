# Fix Status: GitHub Actions Workflow

## Issue
Homebrew tap installation was failing with exit code 1 due to invalid GitHub Actions context in `.github/workflows/publish.yml`.

## Root Cause
The workflow used `github.user`, which is not available in the container-based GitHub Actions environment (`ghcr.io/homebrew/brew:main`). This caused two errors:
1. `property "user" is not defined in object type`
2. `expecting a single ${{...}} expression or mapping value for "env" section, but found plain text node`

## Fix Applied
Replaced all 3 occurrences of `github.user` with `github.repository_owner`:

- Line 32: `GITHUB_REPOSITORY_OWNER: ${{ github.user }}` → `${{ github.repository_owner }}`
- Line 49: `GITHUB_REPOSITORY_OWNER: ${{ github.user }}` → `${{ github.repository_owner }}`
- Line 89: `GITHUB_REPOSITORY_OWNER: ${{ github.user }}` → `${{ github.repository_owner }}`

## Verification
- YAML validated successfully with `python3 -c "import yaml; yaml.safe_load(open(...))"`
- No remaining references to `github.user` in the workflow file
- All GitHub context references now use valid expressions (`github.repository_owner`, `github.token`)