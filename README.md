<p align="left">
    <a href="https://www.lua.org/" target="_blank">
        <img src="https://img.shields.io/badge/Lua-5.1%2B-2C2D72?style=flat-square&logo=lua&logoColor=white" alt="Lua 5.1+" />
    </a>
    <a href="https://luarocks.org/" target="_blank">
        <img src="https://img.shields.io/badge/LuaRocks-planned-lightgrey?style=flat-square&logo=lua&logoColor=white" alt="LuaRocks planned" />
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
    <img src="https://img.shields.io/badge/status-revival%20phase-orange?style=flat-square" alt="Project status" />
    <img src="https://img.shields.io/badge/pure%20Lua-no%20native%20deps-blueviolet?style=flat-square" alt="Pure Lua" />
</p>

# LuaSF: Lua Statistics Functions

**LuaSF** stands for **Lua Statistics Functions**.

LuaSF is a small, lightweight, pure-Lua library for basic descriptive statistics and pseudo-random variable generation.

The project started around 2014 and was later published under the MIT License. It is now being revived with compatibility improvements, tests, examples, documentation, and a cleaner module structure while preserving the existing public API.

---

## Features

* Pure Lua implementation
* No native dependencies
* Basic descriptive statistics
* Discrete and continuous pseudo-random variables
* Single-file friendly
* Compatible with the existing public LuaSF API
* Suitable for simulations, teaching, small scripts, game/mod scripting, and lightweight statistical utilities

---

## Installation

### Option 1: Copy the file

Copy `LuaSF.lua` into your project and load it with:

```lua
local stats = require("LuaSF")
```

### Option 2: Use the compatibility entry point

Older examples may use:

```lua
local stats = require("LuaStat")
```

This is still supported for compatibility.

### Option 3: Use the source module directly

During development, you can also load the implementation from `src/`:

```lua
local stats = require("src.luasf")
```

After LuaRocks packaging is completed, the preferred package-style usage will be:

```lua
local stats = require("luasf")
```

---

## Quick start

```lua
local stats = require("LuaSF")

local values = {1, 2, 3, 4, 5}

print(stats.sumF(values)) -- 15
print(stats.avF(values))  -- 3
print(stats.stvF(values)) -- sample standard deviation
```

Modern aliases are also available:

```lua
local stats = require("LuaSF")

local values = {1, 2, 3, 4, 5}

print(stats.sum(values))    -- 15
print(stats.mean(values))   -- 3
print(stats.stddev(values)) -- sample standard deviation
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

> Note: `frecuencyF` keeps the original spelling for backward compatibility.

---

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

> Note: `nomalVA` and `lognoRandVA` are preserved as compatibility aliases.

---

## Examples

### Twice two dice simulation

```lua
local stats = require("LuaSF")

local rolls = {}

for i = 1, 10000 do
  rolls[i] = stats.rand(1, 6) + stats.rand(1, 6)
end

local frequencies = stats.frecuencyF(rolls)

for i = 1, #frequencies.c do
  print("Frequency - Sum Number:", frequencies.g[i], frequencies.c[i])
end
```

---

### Normal distribution quality control sample

```lua
local stats = require("LuaSF")

local alpha = 5 / 100

print(stats.normal_inv_D(alpha / 2))
print(stats.normal_inv_D(1 - alpha / 2))
```

Expected output:

```text
-1.9688213737864
1.9688213737864
```

---

## Project structure

```text
LuaSF/
  src/
    luasf.lua
  spec/
    test_stats.lua
    test_distributions.lua
  examples/
    dice_simulation.lua
    normal_quality_control.lua
    gamma_distribution.lua
  docs/
    api.md
  LuaSF.lua
  LuaStat.lua
  README.md
  CHANGELOG.md
  CONTRIBUTING.md
  LICENSE
  luasf-0.2.0-1.rockspec
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
```

---

## Running examples

```bash
lua examples/dice_simulation.lua
lua examples/normal_quality_control.lua
lua examples/gamma_distribution.lua
```

---

## Roadmap

### Phase 1 — Compatibility stabilization

* Preserve the current public API
* Add compatibility module entry points
* Fix broken exports
* Fix obvious random variable issues
* Add smoke tests
* Add examples
* Add initial API documentation
* Prepare LuaRocks packaging

### Future phases

* Improve documentation
* Add more examples
* Add continuous integration
* Publish a tagged release
* Publish to LuaRocks
* Add additional statistical helpers

---

## Author and Maintainer

**Hubert Ronald** — Creator, author, and maintainer of LuaSF.

GitHub: [HubertRonald](https://github.com/HubertRonald)

## Contributors

Thanks to the contributors who have helped improve LuaSF.

See the full list of contributors on GitHub:
[LuaSF contributors](https://github.com/HubertRonald/LuaSF/graphs/contributors?all=1)

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
