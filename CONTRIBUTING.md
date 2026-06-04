# Contributing to LuaSF

Thank you for your interest in contributing to LuaSF.

LuaSF is a small, pure-Lua statistics library. The project values simplicity, compatibility, readability, and practical examples.

---

## Project goals

LuaSF aims to provide:

* Basic descriptive statistics
* Pseudo-random variable generation
* A small and readable Lua codebase
* Compatibility with the existing public API
* Useful examples for simulations, teaching, small scripts, and game/mod scripting

---

## Compatibility first

Please avoid breaking the existing public API.

The following legacy names should remain available:

```lua
sumF
avF
stvF
frecuencyF
nomalVA
normalVA
normal_inv_D
bernoulliVA
unifVA
expoVA
weibullVA
erlangVA
trianVA
binomialVA
geometricVA
poissonVA
chiSquareVA
gamVA
lognoVA
lognoRandVA
```

Modern aliases can be added, but legacy names should not be removed.

---

## Development setup

Clone the repository:

```bash
git clone https://github.com/HubertRonald/LuaSF.git
cd LuaSF
```

Install test dependency:

```bash
luarocks install --local luaunit
eval "$(luarocks path --local)"
```

Run tests:

```bash
lua spec/test_stats.lua
lua spec/test_distributions.lua
```

Run examples:

```bash
lua examples/dice_simulation.lua
lua examples/normal_quality_control.lua
lua examples/gamma_distribution.lua
```

---

## Branch naming

Recommended branch names:

```text
feature/short-description
fix/short-description
docs/short-description
test/short-description
```

Examples:

```text
feature/add-median
fix/triangular-random-variable
docs/improve-api
test/add-distribution-ranges
```

---

## Commit messages

Use clear and direct commit messages.

Examples:

```text
Fix triangular random variable implementation
Add frequency table tests
Improve README examples
Add LuaRocks rockspec draft
```

---

## Pull request checklist

Before opening a pull request, please check:

* The existing public API remains compatible.
* Tests pass locally.
* Examples still run.
* New functions include simple documentation.
* New behavior includes at least one test.
* Code remains readable and dependency-light.

---

## Code style

Prefer:

* Simple Lua
* Clear function names
* Small functions
* Minimal dependencies
* Compatibility with Lua 5.1+

Avoid:

* Large rewrites without tests
* Breaking legacy names
* Adding native dependencies
* Overcomplicating the API

---

## License

By contributing to LuaSF, you agree that your contributions will be licensed under the MIT License.
