# Changelog

All notable changes to this project will be documented in this file.

This project follows a lightweight changelog format inspired by [Keep a Changelog](https://keepachangelog.com/), while keeping the process simple for a small Lua library.

---

## [Unreleased]

### Added

* Added `src/luasf.lua` as the main implementation module.
* Added compatibility entry point `LuaSF.lua`.
* Added compatibility entry point `LuaStat.lua`.
* Added modern aliases for the existing public API.
* Added initial tests under `spec/`.
* Added runnable examples under `examples/`.
* Added initial API documentation under `docs/api.md`.
* Added draft LuaRocks rockspec file.

### Fixed

* Fixed broken public export for `normalVA` through the legacy `nomalVA` compatibility alias.
* Fixed broken public export for `lognoVA` through the legacy `lognoRandVA` compatibility alias.
* Fixed triangular random variable implementation by defining the missing random value.
* Reviewed chi-square random variable behavior to return a non-negative chi-square-style value.

### Changed

* Reorganized the project structure for maintainability.
* Preserved the existing public API to avoid breaking older usage.

---

## [0.2.0] - Planned

### Added

* Compatibility stabilization release.
* Documentation improvements.
* Smoke tests.
* LuaRocks packaging preparation.

---

## [0.1.0] - Historical

### Added

* Initial LuaSF implementation.
* Basic descriptive statistics functions.
* Pseudo-random variable generators.
* MIT License.
