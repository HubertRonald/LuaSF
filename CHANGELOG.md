# Changelog

All notable changes to this project will be documented in this file.

This project follows a lightweight changelog format inspired by [Keep a Changelog](https://keepachangelog.com/), while keeping the process simple for a small Lua library.

---

## [Unreleased]

### Added

* Added `mode(array)`.
* Added `range(array)`.
* Added `iqr(array)`.
* Added `percentile(array, p)`.
* Added `summary(array)`.
* Added `examples/weighted_loot_drop.lua`.
* Added `examples/monte_carlo_pi.lua`.
* Added `examples/poisson_arrivals.lua`.
* Added `examples/binomial_coin_flips.lua`.
* Added `examples/bootstrap_mean.lua`.

### Planned

* Improve GitHub Actions CI with optional automatic checks for pull requests.
* Improve LuaRocks validation and publishing workflows.
* Add more distribution examples and simulation-oriented examples.
* Explore a lightweight cross-reference with LuaHMF as a related pure-Lua math helper project.
* Evaluate future combinatorics helpers such as `factorial`, `combinations`, and `permutations`.

---

## [0.3.0] - 2026-06-04

### Added

* Added `variance(array)`.
* Added `median(array)`.
* Added `min(array)` and `max(array)`.
* Added `quantile(array, q)`.
* Added `choice(array)`.
* Added `shuffle(array)`.
* Added `sample(array, n)`.
* Added `weighted_choice(items, weights)`.
* Added `set_rng(rng_function)` and `reset_rng()`.
* Added sampling tests.
* Published LuaSF to LuaRocks as `luasf`.

### Fixed

* Fixed `seed()` to use `math.randomseed`.
* Improved random helper behavior for sampling utilities.
* Preserved compatibility with existing LuaSF public function names.

### Acknowledgements

Special thanks to previous community contributors whose pull requests helped identify important stabilization points during the LuaSF revival:

* `@xujinzheng`, for proposing a fix related to the log-normal random function.
* `@hig3r`, for proposing fixes related to module return values and exported names.

Although those older pull requests were not merged directly because the project structure changed significantly during the revival, their feedback pointed to real issues that are now addressed in the current codebase.

---

## [0.2.0] - 2026-06-04

### Added

* Added `src/luasf.lua` as the main implementation module.
* Added compatibility entry point `LuaSF.lua`.
* Added compatibility entry point `LuaStat.lua`.
* Added modern aliases for the existing public API.
* Added initial tests under `spec/`.
* Added runnable examples under `examples/`.
* Added initial API documentation under `docs/api.md`.
* Added `CHANGELOG.md`.
* Added `CONTRIBUTING.md`.
* Added draft LuaRocks rockspec file.

### Fixed

* Fixed broken public export for `normalVA` through the legacy `nomalVA` compatibility alias.
* Fixed broken public export for `lognoVA` through the legacy `lognoRandVA` compatibility alias.
* Fixed triangular random variable implementation by defining the missing random value.
* Reviewed chi-square random variable behavior to return a non-negative chi-square-style value.
* Added safer validation for several statistics and random variable functions.

### Changed

* Reorganized the project structure for maintainability.
* Preserved the existing public API to avoid breaking older usage.
* Improved README documentation.
* Added compatibility notes for legacy module loading.

---

## [0.1.0] - Historical

### Added

* Initial LuaSF implementation.
* Basic descriptive statistics functions.
* Pseudo-random variable generators.
* MIT License.
