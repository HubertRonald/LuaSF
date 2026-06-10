# Contributing to LuaSF

Thank you for your interest in contributing to LuaSF.

LuaSF is a small, pure-Lua statistics library. The project values simplicity, compatibility, readability, and practical examples.

---

## Project goals

LuaSF aims to provide:

* Basic descriptive statistics
* Summary statistics helpers
* Shape statistics helpers such as skewness and kurtosis
* Bivariate statistics helpers such as covariance and correlation
* Probability and combinatorics helpers
* Pseudo-random variable generation
* Sampling utilities
* Formula-based simple regression summaries
* A small and readable Lua codebase
* Compatibility with the existing public API
* Useful examples for simulations, teaching, small scripts, and game/mod scripting

---

## Scope boundaries

LuaSF should remain lightweight and dependency-free.

Good fits for LuaSF:

* Descriptive statistics
* Shape statistics
* Bivariate statistics
* Probability helpers
* Random variable generation
* Sampling and simulation utilities
* Formula-based statistical summaries
* Small examples and tests

Currently out of scope:

* Large machine learning workflows
* Optimization-based model training
* Non-linear regression engines
* Multiple regression requiring a full matrix algebra subsystem
* Native dependencies
* Big integer dependencies
* Full statistical inference engines with p-value/CDF approximations unless carefully scoped and tested

For simple regression, LuaSF may report coefficients, R and R², sums of squares, standard errors, t statistics, and ANOVA-style summaries. Full p-values and confidence intervals are intentionally outside the current scope.


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
studentTVA
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
    regression.lua
    shape.lua
    validation.lua
    rng.lua
```

When adding new functionality, prefer placing it in the most relevant internal module instead of growing `src/luasf.lua`.

Recommended module ownership:

* `descriptive.lua`: univariate descriptive statistics
* `bivariate.lua`: two-variable statistics such as covariance and correlation
* `sampling.lua`: sampling helpers
* `distributions.lua`: random variable generators
* `probability.lua`: probability/combinatorics helpers
* `regression.lua`: simple regression
* `validation.lua`: reusable input validation helpers
* `shape.lua`: skewness and kurtosis helpers
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

If needed for local development, configure Lua to load the local `src/` module path:

```bash
export LUA_PATH="./src/?.lua;./?.lua;$LUA_PATH"
```

Run tests:

```bash
lua spec/test_stats.lua
lua spec/test_distributions.lua
lua spec/test_sampling.lua
lua spec/test_bivariate.lua
lua spec/test_shape.lua
lua spec/test_probability.lua
lua spec/test_student_t.lua
lua spec/test_regression.lua
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
lua examples/skewness_kurtosis.lua
lua examples/probability_helpers.lua
lua examples/student_t_distribution.lua
lua examples/simple_linear_regression.lua
```

---

## Probability helper guidelines

Probability and combinatorics helpers should live in:

```text
src/luasf/probability.lua
```

Tests should live in:

```text
spec/test_probability.lua
```

Examples should live in:

```text
examples/probability_helpers.lua
```

Probability and combinatorics helpers should remain lightweight and formula-based.

For combinatorics helpers, please be explicit about whether order matters and whether repetition is allowed:

* `permutations(n, r)` for ordered selections without repetition.
* `combinations(n, r)` for unordered selections without repetition.
* `permutations_with_repetition(n, r)` for ordered selections with repetition.
* `combinations_with_repetition(n, r)` for unordered selections with repetition.
* `multiset_permutations(counts)` for arrangements of repeated item groups.

Please keep in mind that Lua numbers may lose precision for very large combinatorial values. LuaSF should remain dependency-free and should not add big integer libraries unless the project scope changes significantly.

---

## LuaRocks packaging

Rockspec files are kept under:

```text
rockspec/
```

When adding new internal modules, update the next rockspec draft so LuaRocks knows how to package them.

Before publishing, validate locally or through GitHub Actions:

```bash
luarocks lint rockspec/luasf-0.7.0-1.rockspec
luarocks make rockspec/luasf-0.7.0-1.rockspec
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
* LuaRocks rockspec files are updated when preparing a package release.
* Rockspec modules are updated when new source files are added.
* CI workflows are updated when new tests or examples are added.


---

## Code style

Prefer:

* Simple Lua
* Clear function names
* Small functions
* Minimal dependencies
* Compatibility with Lua 5.1+
* Explicit validation for public helpers
* Small, focused modules
* Formula-based helpers when appropriate

Avoid:

* Large rewrites without tests
* Breaking legacy names
* Adding native dependencies
* Overcomplicating the API
* Turning LuaSF into a machine learning framework
* Hidden behavior that makes examples harder to understand

---

## Future scope

* Explore carefully scoped confidence interval or critical value helpers.
* Explore a lightweight cross-reference with LuaHMF as a related pure-Lua math helper project.
* Add more distribution and simulation-oriented examples.

---

## License

By contributing to LuaSF, you agree that your contributions will be licensed under the MIT License.
