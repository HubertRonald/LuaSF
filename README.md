# LuaSF: Lua Statistics Functions

<p align="left">
    <a href="https://www.lua.org/" target="_blank">
        <img src="https://img.shields.io/badge/Lua-5.1%2B-2C2D72?style=flat-square&logo=lua&logoColor=white" alt="Lua 5.1+" />
    </a>
    <a href="https://luarocks.org/modules/HubertRonald/luasf" target="_blank">
        <img src="https://img.shields.io/badge/LuaRocks-published-0B63CE?style=flat-square&logo=lua&logoColor=white" alt="LuaRocks published" />
    </a>
    <a href="https://github.com/HubertRonald/LuaSF/blob/master/LICENSE" target="_blank">
        <img src="https://img.shields.io/badge/license-MIT-success?style=flat-square" alt="MIT License" />
    </a>
    <a href="https://github.com/HubertRonald/LuaSF/stargazers" target="_blank">
        <img src="https://img.shields.io/badge/stars-6-blue?style=flat-square&logo=github" alt="GitHub stars" />
    </a>
    <a href="https://github.com/HubertRonald/LuaSF/forks" target="_blank">
        <img src="https://img.shields.io/badge/forks-3-blue?style=flat-square&logo=github" alt="GitHub forks" />
    </a>
    <a href="https://github.com/HubertRonald/LuaSF/graphs/contributors" target="_blank">
        <img src="https://img.shields.io/badge/contributors-2-yellow?style=flat-square&logo=github" alt="GitHub contributors" />
    </a>
    <a href="https://github.com/HubertRonald/LuaSF/issues" target="_blank">
        <img src="https://img.shields.io/badge/issues-open-green?style=flat-square&logo=github" alt="GitHub issues" />
    </a>
    <a href="https://github.com/HubertRonald/LuaSF/pulls" target="_blank">
        <img src="https://img.shields.io/badge/pull%20requests-open-yellow?style=flat-square&logo=github" alt="GitHub pull requests" />
    </a>
    <img src="https://img.shields.io/badge/status-active-brightgreen?style=flat-square" alt="Project status" />
    <img src="https://img.shields.io/badge/pure%20Lua-no%20native%20deps-blueviolet?style=flat-square" alt="Pure Lua" />
</p>

**LuaSF** stands for **Lua Statistics Functions**.

LuaSF is a small, lightweight, pure-Lua library for descriptive statistics, sampling utilities, and pseudo-random variable generation.

The project started around 2014 and was later published under the MIT License. It has now been revived with compatibility improvements, tests, examples, documentation, a cleaner module structure, additional statistics helpers, sampling utilities, and LuaRocks packaging while preserving the existing public API.

---

## Why LuaSF?

* Pure Lua implementation
* No native dependencies
* Lua 5.1+ friendly
* Single-file friendly public API
* Modular internal source layout
* Basic descriptive statistics
* Summary statistics helpers
* Bivariate statistics helpers
* Sampling utilities
* Discrete and continuous pseudo-random variables
* Compatible with the existing public LuaSF API
* Useful for simulations, teaching, small scripts, game/mod scripting, and lightweight statistical utilities

---

## Installation

### Option 1: LuaRocks

```bash
luarocks install luasf
```

Then use:

```lua
local stats = require("luasf")

print(stats.sum({1, 2, 3})) -- 6
```

### Option 2: Copy the file

Copy `LuaSF.lua` into your project and load it with:

```lua
local stats = require("LuaSF")
```

### Option 3: Use the compatibility entry point

Older examples may use:

```lua
local stats = require("LuaStat")
```

This remains supported for compatibility.

### Option 4: Use the source module directly

During development, load the implementation from `src/`:

```lua
local stats = require("src.luasf")
```

---

## Quick start

```lua
local stats = require("luasf")

local values = {1, 2, 3, 4, 5}

print(stats.sum(values))      -- 15
print(stats.mean(values))     -- 3
print(stats.stddev(values))   -- sample standard deviation
print(stats.median(values))   -- 3
print(stats.variance(values)) -- sample variance
print(stats.summary(values).count) -- 5
```

Legacy names are still available:

```lua
local stats = require("LuaSF")

local values = {1, 2, 3, 4, 5}

print(stats.sumF(values)) -- 15
print(stats.avF(values))  -- 3
print(stats.stvF(values)) -- sample standard deviation
```

---

## API Overview

### Descriptive statistics

| Legacy name         | Modern alias       | Description                             |
| ------------------- | ------------------ | --------------------------------------- |
| `sumF(array)`       | `sum(array)`       | Sum of numeric values                   |
| `avF(array)`        | `mean(array)`      | Arithmetic mean                         |
| `stvF(array)`       | `stddev(array)`    | Sample standard deviation using `n - 1` |
| `frecuencyF(array)` | `frequency(array)` | Frequency distribution                  |

> `frecuencyF` keeps the original spelling for backward compatibility.

### Additional descriptive statistics

| Function               | Description                                                            |
| ---------------------- | ---------------------------------------------------------------------- |
| `variance(array)`      | Sample variance using `n - 1`                                          |
| `median(array)`        | Median value                                                           |
| `min(array)`           | Minimum value                                                          |
| `max(array)`           | Maximum value                                                          |
| `quantile(array, q)`   | Quantile using linear interpolation                                    |
| `mode(array)`          | Most frequent value                                                    |
| `range(array)`         | Difference between maximum and minimum                                 |
| `iqr(array)`           | Interquartile range                                                    |
| `percentile(array, p)` | Percentile where `p` is between `0` and `100`                          |
| `summary(array)`       | Summary table with count, min, max, mean, median, variance, and stddev |

### Bivariate statistics

| Function | Description |
|---|---|
| `covariance(x, y)` | Sample covariance using `n - 1` |
| `correlation(x, y)` | Pearson correlation coefficient |
| `pearson(x, y)` | Alias for `correlation(x, y)` |

### Sampling utilities

| Function                          | Description                                    |
| --------------------------------- | ---------------------------------------------- |
| `choice(array)`                   | Returns one random item from an array          |
| `shuffle(array)`                  | Returns a shuffled copy of an array            |
| `sample(array, n)`                | Returns `n` random items without replacement   |
| `weighted_choice(items, weights)` | Returns one random item using weights          |
| `set_rng(rng_function)`           | Sets a custom random number generator          |
| `reset_rng()`                     | Restores Lua's default random number generator |

### Random variables and distributions

| Legacy name                | Modern alias                 | Description                      |
| -------------------------- | ---------------------------- | -------------------------------- |
| `nomalVA(mu, sig)`         | `normal(mu, sig)`            | Normal random variable           |
| `normalVA(mu, sig)`        | `normal(mu, sig)`            | Normal random variable           |
| `normal_inv_D(p, mu, sig)` | `inverse_normal(p, mu, sig)` | Approximate inverse normal value |
| `bernoulliVA(p)`           | `bernoulli(p)`               | Bernoulli random variable        |
| `unifVA(min, max)`         | `uniform(min, max)`          | Uniform random variable          |
| `expoVA(beta)`             | `exponential(beta)`          | Exponential random variable      |
| `weibullVA(alpha, beta)`   | `weibull(alpha, beta)`       | Weibull random variable          |
| `erlangVA(n, lambda)`      | `erlang(n, lambda)`          | Erlang random variable           |
| `trianVA(a, b, c)`         | `triangular(a, b, c)`        | Triangular random variable       |
| `binomialVA(n, p)`         | `binomial(n, p)`             | Binomial random variable         |
| `geometricVA(p)`           | `geometric(p)`               | Geometric random variable        |
| `poissonVA(lambda)`        | `poisson(lambda)`            | Poisson random variable          |
| `chiSquareVA(n)`           | `chi_square(n)`              | Chi-square random variable       |
| `gamVA(alpha, lambda)`     | `gamma(alpha, lambda)`       | Gamma random variable            |
| `lognoVA(m, s)`            | `lognormal(m, s)`            | Log-normal random variable       |
| `lognoRandVA(m, s)`        | `lognormal(m, s)`            | Log-normal random variable       |

> `nomalVA` and `lognoRandVA` are preserved as compatibility aliases.

---

## Examples

### Summary statistics

```lua
local stats = require("luasf")

local values = {10, 12, 14, 15, 18, 20}
local result = stats.summary(values)

print("Count:", result.count)
print("Min:", result.min)
print("Max:", result.max)
print("Mean:", result.mean)
print("Median:", result.median)
print("Variance:", result.variance)
print("Stddev:", result.stddev)
```

### Covariance and correlation

```lua
local stats = require("luasf")

local study_hours = {1, 2, 3, 4, 5}
local exam_scores = {50, 55, 65, 70, 80}

print(stats.covariance(study_hours, exam_scores))
print(stats.correlation(study_hours, exam_scores))
```


### Twice two dice simulation

```lua
local stats = require("luasf")

local rolls = {}

for i = 1, 10000 do
  rolls[i] = stats.rand(1, 6) + stats.rand(1, 6)
end

local frequencies = stats.frequency(rolls)

for i = 1, #frequencies.counts do
  print("Frequency - Sum Number:", frequencies.values[i], frequencies.counts[i])
end
```

### Normal distribution quality control sample

```lua
local stats = require("luasf")

local alpha = 5 / 100

print(stats.normal_inv_D(alpha / 2))
print(stats.normal_inv_D(1 - alpha / 2))
```

Expected output:

```text
-1.9688213737864
1.9688213737864
```

### Random choice and sampling

```lua
local stats = require("luasf")

local names = {"Lua", "Python", "R"}

print(stats.choice(names))

local selected = stats.sample(names, 2)

for i = 1, #selected do
  print(selected[i])
end
```

### Weighted choice

```lua
local stats = require("luasf")

local items = {"low", "medium", "high"}
local weights = {1, 2, 7}

print(stats.weighted_choice(items, weights))
```

### Deterministic custom RNG

```lua
local stats = require("luasf")

stats.set_rng(function()
  return 0.0
end)

print(stats.choice({"first", "second", "third"})) -- first

stats.reset_rng()
```

---

## Project structure

```text
LuaSF/
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
  spec/
    test_stats.lua
    test_distributions.lua
    test_sampling.lua
    test_bivariate.lua
  examples/
    dice_simulation.lua
    normal_quality_control.lua
    gamma_distribution.lua
    weighted_loot_drop.lua
    monte_carlo_pi.lua
    poisson_arrivals.lua
    binomial_coin_flips.lua
    bootstrap_mean.lua
    covariance_correlation.lua
  docs/
    api.md
  .github/
    workflows/
      ci.yml
      publish-luarocks.yml
  rockspec/
    luasf-0.2.0-1.rockspec
    luasf-0.3.0-1.rockspec
    luasf-0.4.0-1.rockspec
    luasf-0.5.0-1.rockspec
  LuaSF.lua
  LuaStat.lua
  README.md
  CHANGELOG.md
  CONTRIBUTING.md
  LICENSE
```

---

## Running tests

Install `luaunit`:

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

---

## Running examples

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

## Roadmap

### Completed

* Compatibility-safe project revival
* Cleaner modular source structure
* Legacy API preservation
* Modern aliases
* Basic tests
* Examples
* API documentation
* Additional statistics helpers
* Summary statistics helpers
* Bivariate statistics helpers
* Sampling utilities
* Deterministic simulation support
* LuaRocks publishing

### Planned

* Shape statistics helpers such as `skewness(array)` and `kurtosis(array)`
* Future probability helpers such as `factorial`, `combinations`, and `permutations`
* Lightweight cross-reference with LuaHMF
* More distribution and simulation examples
* Optional simple formula-based regression summaries, without turning LuaSF into a machine learning framework

---

## Scope

LuaSF is focused on lightweight statistics, probability, random variables, and simulation helpers.

Optimization-based modeling, machine learning workflows, model training pipelines, and non-linear regression are intentionally outside the current scope of LuaSF.

---

## Author and Maintainer

**Hubert Ronald** — Creator, author, and maintainer of LuaSF.

GitHub: [HubertRonald](https://github.com/HubertRonald)

---

## Contributors

Thanks to the contributors who have helped improve LuaSF.

See the full list of contributors on GitHub:

[LuaSF contributors](https://github.com/HubertRonald/LuaSF/graphs/contributors?all=1)

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
