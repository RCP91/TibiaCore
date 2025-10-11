# Engineering Guide — Tibia 7.4 Server

This document captures the project’s engineering standards and working agreements. It’s written for a professional C++ Tibia developer who values high test coverage, containerization, and best practices—and aims to refactor toward “the best code in the world.”

## Principles

- Modern C++ done right: readable, safe, and maintainable code, prioritizing clarity over cleverness.
- High confidence: unit tests, integration tests, and measurable coverage guiding changes.
- Container-first: reproducible dev and prod via Docker/Compose.
- Refactor with safety nets: CI, static analysis, sanitizers, and a crisp checklist.
- Small, incremental improvements: prefer small PRs with clear intent and solid tests.

## Project Targets

- Platform: Tibia 7.4 compatible open Tibia server.
- Language: C++ (use the standard configured in CMake; if not set, prefer C++17 or newer).
- Build: CMake + your platform toolchain; support containerized builds.
- Storage: MySQL/MariaDB with SQL scripts in this repo (e.g., `tibiacore.sql`, `tibiacore-empty.sql`).

## Development Workflow

1. Local build
   - Use your system toolchain or a dev container. Favor CMake out-of-source builds.
   - Treat warnings as errors for CI; locally you can iterate with fewer flags if needed.
2. Containers
   - Use the provided `Dockerfile` and `docker-compose.yaml` for reproducible runs.
   - Keep image size small (multi-stage builds, strip symbols, no dev tools in runtime image).
3. Database
   - Apply schema from `tibiacore.sql` or bootstrap with `tibiacore-empty.sql` as needed.
   - Keep changes as forward-only migrations; never rewrite existing migrations.

Tip: Consult `docker-compose.yaml` for service names. Typical flow: build images, start stack, watch logs, and exec into the server container for interactive tasks.

## Coding Standards (C++)

- Language features
  - Prefer RAII, strong types, and value semantics; avoid raw owning pointers.
  - Use `std::unique_ptr`/`std::shared_ptr` consciously; default to unique ownership.
  - Avoid exceptions for control flow; reserve for truly exceptional conditions.
  - Prefer `std::span`, `string_view`, and `gsl::not_null`-like concepts where appropriate.
- Error handling
  - Return `expected<T, E>`-style outcomes (or a simple status + value) for predictable failures.
  - Log with context; include IDs (player, creature, account) and map positions when relevant.
- APIs and boundaries
  - Separate domain logic from I/O; keep networking, DB, and filesystem behind interfaces.
  - Favor small, composable functions; keep cyclomatic complexity low.
- Names and layout
  - Names reflect intent: nouns for types, verbs for functions, UPPER_SNAKE_CASE for constants.
  - One header per class/module; use `#pragma once`.
  - Organized includes: local first, then project, then system; avoid transitive include reliance.
- Performance
  - Optimize after measuring; add micro-benchmarks where hotspots are suspected.

Recommended tooling

- Formatting: clang-format (consistent across the repo).
- Linting: clang-tidy with a curated ruleset; run on changed files in CI.
- Sanitizers: ASan/UBSan in debug CI jobs; consider TSAN for concurrency-sensitive code.
- Static analysis: cppcheck is a helpful complement.

## Testing and Coverage

- Unit tests: Use GoogleTest or Catch2. Place tests under `tests/` mirroring source layout.
- Integration tests: Exercise command handlers, combat, and map mechanics via thin harnesses.
- Coverage: Use `llvm-cov` or `gcovr` to produce reports. Track a threshold and trend in CI.

Minimal CMake sketch for tests (illustrative):

```cmake
# tests/CMakeLists.txt
add_executable(unit_tests
  test_main.cpp
  # add test_*.cpp files here
)
target_link_libraries(unit_tests PRIVATE project_lib gtest gtest_main)
add_test(NAME unit_tests COMMAND unit_tests)
```

Coverage example (LLVM toolchain):

```sh
# Build with coverage flags
cmake -B build -S . -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="-fprofile-instr-generate -fcoverage-mapping"
cmake --build build -j
LLVM_PROFILE_FILE="coverage-%p.profraw" ctest --test-dir build --output-on-failure
# Merge and show
llvm-profdata merge -sparse coverage-*.profraw -o coverage.profdata
llvm-cov report build/<your-binary> -instr-profile=coverage.profdata
```

## Refactor Checklist

Before
- Add or extend tests covering current behavior (happy path + 1–2 edge cases).
- Snapshot performance if relevant (simple benchmark or timing).

During
- Keep changes small and focused; avoid mixing formatting and logic.
- Maintain behavior unless explicitly changing it (then document and test it).

After
- Run linters, sanitizers, and tests locally.
- Check DB migrations if schema touched; confirm container still builds and runs.
- Update docs and comments; ensure names and responsibilities are crisp.

## Pull Request Checklist

- [ ] Clear title and description; link issues.
- [ ] Tests added/updated; coverage does not regress materially.
- [ ] clang-format applied; clang-tidy warnings addressed or justified.
- [ ] No TODOs or commented-out code without tracking tickets.
- [ ] Docker image builds; container stack starts; basic smoke test passes.
- [ ] Backwards compatibility considered (config, DB, scripts).

## Database and Data Files

- SQL sources: `tibiacore.sql` (full) and `tibiacore-empty.sql` (minimal) exist in repo.
- Apply with your preferred client or via container startup scripts.
- Use migrations for incremental changes; avoid editing historical SQL files directly.

## Containerization Notes

- Favor multi-stage builds to keep runtime images lean.
- Parameterize runtime behavior with environment variables (no secrets baked into images).
- Persist data volumes for DB and any server state that must survive container restarts.

## CI Suggestions (optional)

- Jobs: lint (clang-format/tidy), build (Debug+ASan, Release), test, coverage, docker build, smoke run.
- Cache toolchains and dependencies for speed.
- Fail fast on style/lint; gate merges on tests and coverage threshold.

## Repository Hygiene

- Pre-commit hooks: format, lint, and basic checks.
- Keep `README.md` focused on running and using; keep deeper engineering details here.
- Use CHANGELOG and semantic commits where feasible.

---

If something here conflicts with actual project configuration (CMake standard, service names, etc.), prefer the project’s current settings and update this document accordingly.