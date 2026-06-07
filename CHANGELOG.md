# Changelog

All notable changes to this project will be documented in this file.

This project follows a lightweight changelog format inspired by [Keep a Changelog](https://keepachangelog.com/), while keeping the process simple for a small Lua library.

---

## [Unreleased]

### Added

* Added modular internal source layout under `src/luasf/`.
* Added `src/luasf/core.lua`.
* Added `src/luasf/validation.lua`.
* Added `src/luasf/rng.lua`.
* Added `src/luasf/descriptive.lua`.
* Added `src/luasf/sampling.lua`.
* Added `src/luasf/distributions.lua`.
* Added `src/luasf/bivariate.lua`.
* Added `src/luasf/probability.lua` as a placeholder for future probability helpers.
* Added `covariance(x, y)`.
* Added `correlation(x, y)`.
* Added `pearson(x, y)` as an alias for `correlation(x, y)`.
* Added `spec/test_bivariate.lua`.
* Added `examples/covariance_correlation.lua`.
* Added `rockspec/luasf-0.5.0-1.rockspec` as the next LuaRocks release draft.

### Changed

* Kept `src/luasf.lua` as the public facade module.
* Preserved the existing public API while moving implementation details into smaller internal modules.
* Moved LuaRocks specification files into the `rockspec/` directory.
* Updated documentation to describe the modular layout and bivariate statistics helpers.
* Updated CI expectations to include bivariate tests and the covariance/correlation example.

### Planned

* Add shape statistics helpers such as `skewness(array)` and `kurtosis(array)`.
* Explore future probability helpers such as `factorial(n)`, `combinations(n, r)`, and `permutations(n, r)`.
* Explore a lightweight cross-reference with LuaHMF as a related pure-Lua math helper project.
* Consider simple formula-based regression summaries later, without turning LuaSF into a machine learning framework.
* Add more distribution examples and simulation-oriented examples.

---

## [0.4.0] - 2026-06-04

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
* Added `luasf-0.4.0-1.rockspec`.

### Documentation

* Updated `README.md`.
* Updated `docs/api.md`.
* Updated `CHANGELOG.md`.

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
