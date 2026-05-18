# Rules To Live By

## Think Hard
**CRITICAL: Think deeply before taking action**
- STOP and THINK before making any changes or writing any code
- Ask clarifying questions if requirements are unclear or ambiguous
- Do not assume - if something is not explicitly stated, ASK
- Consider multiple approaches and their trade-offs before implementing
- If you're uncertain about the best path forward, discuss options with the user
- Never proceed with incomplete understanding - clarity first, code second
- Validate your understanding by summarizing the task back before implementation

## Workflow and Planning
**CRITICAL: Always read the current state of the project before planning any changes**
- Before making any modifications, ALWAYS read and understand the current state of relevant files
- Use codebase search and file reading tools to gather context about existing code
- Review related files, dependencies, and project structure before implementing changes
- Understand the full context of what you're modifying, including:
  - Existing implementations and patterns
  - Dependencies and imports
  - Related packages and functions
  - Current architecture and design decisions
- Think deeply about the implications of changes:
  - Consider edge cases and potential side effects
  - Analyze how changes will interact with existing code
  - Evaluate alternative approaches before committing to a solution
  - Consider long-term maintainability and scalability
  - Think about backward compatibility if applicable
- Never make assumptions about the codebase - always verify by reading the actual code
- Plan changes thoroughly before implementation, considering the full impact

## Golang Rules
- If (and only **IF**) the current project uses go (golang) you MUST read in the rules for golang projects from @GOLANG.md

## Script Rules
- Default to BASH on macOS/Linux, POWERSHELL on Windows.
- Always include a shebang: `#!/bin/bash` (or `#!/usr/bin/env bash` for portability).
- Always set `set -e` at the top so the script exits on any error. Use `set -ex` when tracing is useful for debugging.
- Quote all variables: use `"$VAR"` not `$VAR` to avoid word-splitting and glob expansion.
- Write idempotent scripts — running the same script twice should be safe. Use `command -v`, `[ -f ]`, or similar guards before installing or creating things.
- Validate required dependencies at the top of the script before doing any work. Exit with a clear error message if they are missing.
- Use `exit 1` (or a non-zero code) on failure. Never silently swallow errors.
- Log messages should be plain, lowercase, no emoji, no fluff. One line per meaningful action.
- Prefer `command -v tool` over `which tool` to check for binaries.
- Use `$(dirname "$0")` when referencing files relative to the script's location.
- Avoid hardcoding paths where possible — use variables or detect them dynamically.
- Do not use `sudo` unless explicitly necessary. When used, scope it as narrowly as possible.

## Makefile
**CRITICAL: Every project MUST have a Makefile**
- Always include a `Makefile` in the project root to control build, test, run, and utility functions
- Standard targets that should be present:
  - `make build` - Compile the project
  - `make test` - Run all tests (include `-race` flag)
  - `make run` - Build and run the application
  - `make clean` - Remove build artifacts
- Add project-specific utility targets as needed (e.g., `make docker`, `make migrate`, `make generate`)
- Include a `make help` target that lists all available targets with descriptions
- Use `.PHONY` declarations for targets that don't produce files
- Keep the Makefile well-organized and commented
- Makefile should be the primary interface for common development tasks

## Code Quality
**CRITICAL: DRY (Don't Repeat Yourself) is an absolute requirement**
- Never duplicate code - extract shared logic into reusable packages, functions, or types
- When creating multiple entry points (e.g., cmd/gx and cmd/gxx), extract all shared logic into internal packages
- Main packages should be thin wrappers that delegate to shared library code
- If you find yourself copying code between files, stop and refactor to a shared location
- Use interfaces for abstraction and testability
- Keep interfaces small and focused (Go proverb: "The bigger the interface, the weaker the abstraction")
- Use structs for data containers
- Use `context.Context` for cancellation and request-scoped values
- Avoid global state - use dependency injection
- Use `defer` for cleanup operations
- Prefer composition over inheritance

## Security
- Never hardcode secrets or API keys
- Use environment variables or secure configuration management
- Validate and sanitize all user inputs
- Use parameterized queries for database operations

## README.md
- README.md file must be kept up to date with the base design at all times

## Git and Version Control
- Write clear, descriptive commit messages
- Keep commits focused and atomic
- Use meaningful branch names
- Keep `CHANGELOG.md` current for notable changes; it is **not** enforced by `make push`
- **MANDATORY**: Always use `make push` to commit and publish changes — never run `git add`, `git commit`, or `git push` manually
- `make push` handles the full release cycle: version bump → build → commit → push → tag → push tag
- Never bypass `make push` with manual git commands; doing so will desync the version, binary, and git tags

## CHANGELOG.md Documentation Requirement
- Update `CHANGELOG.md` when changes are user-visible or worth recording; do so before release PRs when practical
- Document all changes including:
  - New features and functionality
  - Bug fixes and patches
  - Configuration changes
  - Dependency updates
  - Documentation updates
  - Refactoring and code improvements
  - Breaking changes
- Use clear, descriptive entries that explain what changed and why
- Group changes by date or version as appropriate

## README Documentation Requirement
**CRITICAL: All changes must be documented in README.md**
- After making any significant changes to the codebase, update the README.md file
- Document new features, bug fixes, configuration changes, and dependency updates
- Include a "Changelog" or "Updates" section in the README.md
- Update installation instructions if dependencies change
- Update usage examples if functionality changes
- Keep the README.md current and comprehensive
