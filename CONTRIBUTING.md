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

## Source layout

LuaSF exposes a stable public facade:

```lua
local stats = require("luasf")
```

The implementation is modularized under `src/luasf/`:

```text
src/
  luasf.lua
  luasf/
    core.lua
    descriptive.lua
    sampling.lua
    distributions.lua
    bivariate.lua
    probability.lua
    validation.lua
    rng.lua
```

When adding new functionality, prefer placing it in the most relevant internal module instead of growing `src/luasf.lua`.

Recommended module ownership:

* `descriptive.lua`: univariate descriptive statistics
* `bivariate.lua`: two-variable statistics such as covariance and correlation
* `sampling.lua`: sampling helpers
* `distributions.lua`: random variable generators
* `probability.lua`: future probability/combinatorics helpers
* `validation.lua`: reusable input validation helpers
* `rng.lua`: random generator and seed helpers
* `core.lua`: small reusable internal utilities

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
lua spec/test_sampling.lua
lua spec/test_bivariate.lua
```

Run examples:

```bash
lua examples/dice_simulation.lua
lua examples/normal_quality_control.lua
lua examples/gamma_distribution.lua
lua examples/weighted_loot_drop.lua
lua examples/monte_carlo_pi.lua
lua examples/poisson_arrivals.lua
lua examples/binomial_coin_flips.lua
lua examples/bootstrap_mean.lua
lua examples/covariance_correlation.lua
```

---

## LuaRocks packaging

Rockspec files are kept under:

```text
rockspec/
```

When adding new internal modules, update the next rockspec draft so LuaRocks knows how to package them.

Before publishing, validate locally or through GitHub Actions:

```bash
luarocks lint rockspec/luasf-0.5.0-1.rockspec
luarocks make rockspec/luasf-0.5.0-1.rockspec
```

Publishing should remain manual and intentional.

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
feature/modular-bivariate-stats
feature/add-skewness-kurtosis
fix/triangular-random-variable
docs/improve-api
test/add-distribution-ranges
```

---

## Commit messages

Use clear and direct commit messages.

Examples:

```text
Modularize LuaSF source layout
Add bivariate statistics helpers
Add bivariate statistics tests
Add covariance and correlation example
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
* New modules are included in the rockspec draft when needed.
* Code remains readable and dependency-light.

---

## Code style

Prefer:

* Simple Lua
* Clear function names
* Small functions
* Minimal dependencies
* Compatibility with Lua 5.1+
* Formula-based helpers when appropriate

Avoid:

* Large rewrites without tests
* Breaking legacy names
* Adding native dependencies
* Overcomplicating the API
* Turning LuaSF into a machine learning framework

---

## Future scope

Potential future additions include:

* `skewness(array)`
* `kurtosis(array)`
* `factorial(n)`
* `combinations(n, r)`
* `permutations(n, r)`

Simple formula-based regression summaries may be considered later, but optimization-based models and ML workflows are outside the current scope.

---

## License

By contributing to LuaSF, you agree that your contributions will be licensed under the MIT License.
