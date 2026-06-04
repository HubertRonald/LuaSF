# LuaSF API

LuaSF stands for **Lua Statistics Functions**.

This document describes the public API preserved during **Phase 1 — Compatibility Stabilization**.

Phase 1 focuses on keeping the existing public API working while adding clearer aliases, basic validation, tests, examples, and documentation.

---

## Module loading

The recommended compatibility entry point is:

```lua
local stats = require("LuaSF")
```

The README-compatible entry point is:

```lua
local stats = require("LuaStat")
```

The internal implementation module is:

```lua
local stats = require("src.luasf")
```

After LuaRocks packaging is completed, the preferred package-style entry point will be:

```lua
local stats = require("luasf")
```

---

## Descriptive statistics

### `sumF(array)`

Returns the sum of numeric values in an array.

Example:

```lua
local stats = require("LuaSF")

local result = stats.sumF({1, 2, 3})

print(result) -- 6
```

Modern alias:

```lua
stats.sum(array)
```

---

### `avF(array)`

Returns the arithmetic mean of numeric values in an array.

Example:

```lua
local stats = require("LuaSF")

local result = stats.avF({2, 4, 6})

print(result) -- 4
```

Modern alias:

```lua
stats.mean(array)
```

---

### `stvF(array)`

Returns the sample standard deviation using `n - 1`.

Example:

```lua
local stats = require("LuaSF")

local result = stats.stvF({2, 4, 6})

print(result) -- 2
```

Modern alias:

```lua
stats.stddev(array)
```

---

### `frecuencyF(array)`

Returns a frequency table for the given array.

> Note: the legacy function name keeps the original spelling `frecuencyF` for compatibility.

Example:

```lua
local stats = require("LuaSF")

local result = stats.frecuencyF({2, 1, 2, 3, 3, 3})

for i = 1, #result.g do
  print(result.g[i], result.c[i])
end
```

Legacy fields:

```lua
result.g -- groups / values
result.c -- counts
```

Modern aliases:

```lua
result.values -- groups / values
result.counts -- counts
```

Modern function alias:

```lua
stats.frequency(array)
```

---

## Random variables and distributions

LuaSF provides functions for discrete and continuous pseudo-random variables.

### `normalVA(mu, sig)`

Returns a normally distributed random value.

Parameters:

* `mu`: mean. Default: `0`
* `sig`: standard deviation. Default: `1`

Example:

```lua
local stats = require("LuaSF")

local value = stats.normalVA(0, 1)

print(value)
```

Compatibility alias:

```lua
stats.nomalVA(mu, sig)
```

Modern alias:

```lua
stats.normal(mu, sig)
```

---

### `normal_inv_D(p, mu, sig)`

Returns an approximate inverse normal value.

Parameters:

* `p`: probability value between `0` and `1`
* `mu`: mean. Default: `0`
* `sig`: standard deviation. Default: `1`

Example:

```lua
local stats = require("LuaSF")

local value = stats.normal_inv_D(0.975, 0, 1)

print(value)
```

Modern alias:

```lua
stats.inverse_normal(p, mu, sig)
```

---

### `bernoulliVA(p)`

Returns `1` with probability `p`, otherwise returns `0`.

Example:

```lua
local stats = require("LuaSF")

local value = stats.bernoulliVA(0.5)

print(value)
```

Modern alias:

```lua
stats.bernoulli(p)
```

---

### `unifVA(min, max)`

Returns a uniformly distributed random value between `min` and `max`.

Example:

```lua
local stats = require("LuaSF")

local value = stats.unifVA(10, 20)

print(value)
```

Modern alias:

```lua
stats.uniform(min, max)
```

---

### `expoVA(beta)`

Returns an exponentially distributed random value.

Example:

```lua
local stats = require("LuaSF")

local value = stats.expoVA(1)

print(value)
```

Modern alias:

```lua
stats.exponential(beta)
```

---

### `weibullVA(alpha, beta)`

Returns a Weibull-distributed random value.

Example:

```lua
local stats = require("LuaSF")

local value = stats.weibullVA(1, 2)

print(value)
```

Modern alias:

```lua
stats.weibull(alpha, beta)
```

---

### `erlangVA(n, lambda)`

Returns an Erlang-distributed random value.

Example:

```lua
local stats = require("LuaSF")

local value = stats.erlangVA(3, 1)

print(value)
```

Modern alias:

```lua
stats.erlang(n, lambda)
```

---

### `trianVA(a, b, c)`

Returns a triangular-distributed random value.

Parameters:

* `a`: lower limit
* `b`: mode
* `c`: upper limit

Example:

```lua
local stats = require("LuaSF")

local value = stats.trianVA(0, 0.5, 1)

print(value)
```

Modern alias:

```lua
stats.triangular(a, b, c)
```

---

### `binomialVA(n, p)`

Returns a binomially distributed random value.

Parameters:

* `n`: number of trials
* `p`: success probability

Example:

```lua
local stats = require("LuaSF")

local value = stats.binomialVA(10, 0.5)

print(value)
```

Modern alias:

```lua
stats.binomial(n, p)
```

---

### `geometricVA(p)`

Returns a geometrically distributed random value.

Example:

```lua
local stats = require("LuaSF")

local value = stats.geometricVA(0.5)

print(value)
```

Modern alias:

```lua
stats.geometric(p)
```

---

### `poissonVA(lambda)`

Returns a Poisson-distributed random value.

Example:

```lua
local stats = require("LuaSF")

local value = stats.poissonVA(2)

print(value)
```

Modern alias:

```lua
stats.poisson(lambda)
```

---

### `chiSquareVA(n)`

Returns a chi-square-distributed random value with `n` degrees of freedom.

Example:

```lua
local stats = require("LuaSF")

local value = stats.chiSquareVA(3)

print(value)
```

Modern alias:

```lua
stats.chi_square(n)
```

---

### `gamVA(alpha, lambda)`

Returns a gamma-distributed random value.

Parameters:

* `alpha`: shape parameter
* `lambda`: rate parameter

Example:

```lua
local stats = require("LuaSF")

local value = stats.gamVA(2, 1)

print(value)
```

Modern alias:

```lua
stats.gamma(alpha, lambda)
```

---

### `lognoVA(m, s)`

Returns a log-normal random value.

Example:

```lua
local stats = require("LuaSF")

local value = stats.lognoVA(1, 0.25)

print(value)
```

Compatibility alias:

```lua
stats.lognoRandVA(m, s)
```

Modern alias:

```lua
stats.lognormal(m, s)
```

---

## Utility functions

### `rand()`

Returns a random number using Lua's built-in `math.random`.

Examples:

```lua
local stats = require("LuaSF")

print(stats.rand())      -- random decimal
print(stats.rand(6))     -- random integer from 1 to 6
print(stats.rand(1, 6))  -- random integer from 1 to 6
```

Modern alias:

```lua
stats.random_integer(min, max)
```

---

### `seed(value)`

Sets the random seed.

Example:

```lua
local stats = require("LuaSF")

stats.seed(1234)

print(stats.rand())
```

---

## Legacy API summary

The following public names are preserved for compatibility:

```lua
stats.rand
stats.sumF
stats.avF
stats.stvF
stats.frecuencyF
stats.nomalVA
stats.normalVA
stats.normal_inv_D
stats.bernoulliVA
stats.unifVA
stats.expoVA
stats.weibullVA
stats.erlangVA
stats.trianVA
stats.binomialVA
stats.geometricVA
stats.poissonVA
stats.chiSquareVA
stats.gamVA
stats.lognoVA
stats.lognoRandVA
```

---

## Modern aliases summary

The following aliases are available for clearer usage:

```lua
stats.seed
stats.random_integer
stats.sum
stats.mean
stats.stddev
stats.frequency
stats.normal
stats.inverse_normal
stats.bernoulli
stats.uniform
stats.exponential
stats.weibull
stats.erlang
stats.triangular
stats.binomial
stats.geometric
stats.poisson
stats.chi_square
stats.gamma
stats.lognormal
```

---

## Compatibility notes

Phase 1 preserves existing public names and adds modern aliases without removing legacy names.

Some legacy names intentionally keep their original spelling for backward compatibility, including:

```lua
stats.frecuencyF
stats.nomalVA
stats.lognoRandVA
```

These names should remain available even if newer documentation recommends clearer aliases.
