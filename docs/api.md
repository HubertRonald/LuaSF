# LuaSF API

LuaSF stands for **Lua Statistics Functions**.

This document describes the public LuaSF API after the compatibility revival and Phase 3 statistics/sampling additions.

LuaSF keeps the legacy public API available while adding clearer modern aliases.

---

## Module loading

Recommended compatibility entry point:

```lua
local stats = require("LuaSF")
```

README-compatible legacy entry point:

```lua
local stats = require("LuaStat")
```

Development/internal implementation module:

```lua
local stats = require("src.luasf")
```

Future LuaRocks package-style entry point:

```lua
local stats = require("luasf")
```

---

## Descriptive statistics

### `sumF(array)`

Returns the sum of numeric values in an array.

```lua
local stats = require("LuaSF")

print(stats.sumF({1, 2, 3})) -- 6
```

Modern alias:

```lua
stats.sum(array)
```

---

### `avF(array)`

Returns the arithmetic mean of numeric values in an array.

```lua
local stats = require("LuaSF")

print(stats.avF({2, 4, 6})) -- 4
```

Modern alias:

```lua
stats.mean(array)
```

---

### `stvF(array)`

Returns the sample standard deviation using `n - 1`.

```lua
local stats = require("LuaSF")

print(stats.stvF({2, 4, 6})) -- 2
```

Modern alias:

```lua
stats.stddev(array)
```

---

### `frecuencyF(array)`

Returns a frequency table.

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

Modern field aliases:

```lua
result.values -- groups / values
result.counts -- counts
```

Modern function alias:

```lua
stats.frequency(array)
```

> The name `frecuencyF` keeps its original spelling for backward compatibility.

---

## Additional statistics helpers

### `variance(array)`

Returns the sample variance using `n - 1`.

```lua
local stats = require("LuaSF")

print(stats.variance({2, 4, 6})) -- 4
```

---

### `median(array)`

Returns the median value.

```lua
local stats = require("LuaSF")

print(stats.median({3, 1, 2}))    -- 2
print(stats.median({4, 1, 2, 3})) -- 2.5
```

---

### `min(array)`

Returns the minimum value.

```lua
local stats = require("LuaSF")

print(stats.min({3, 1, 2})) -- 1
```

---

### `max(array)`

Returns the maximum value.

```lua
local stats = require("LuaSF")

print(stats.max({3, 1, 2})) -- 3
```

---

### `quantile(array, q)`

Returns the `q` quantile using linear interpolation.

`q` must be between `0` and `1`.

```lua
local stats = require("LuaSF")

print(stats.quantile({1, 2, 3, 4, 5}, 0.5)) -- 3
```

---

## Sampling utilities

### `choice(array)`

Returns one random item from an array.

```lua
local stats = require("LuaSF")

local names = {"Lua", "Python", "R"}

print(stats.choice(names))
```

---

### `shuffle(array)`

Returns a shuffled copy of an array.

This function does not modify the original array.

```lua
local stats = require("LuaSF")

local values = {1, 2, 3, 4}
local shuffled = stats.shuffle(values)

for i = 1, #shuffled do
  print(shuffled[i])
end
```

---

### `sample(array, n)`

Returns `n` random items without replacement.

```lua
local stats = require("LuaSF")

local values = {"a", "b", "c", "d"}
local selected = stats.sample(values, 2)

for i = 1, #selected do
  print(selected[i])
end
```

---

### `weighted_choice(items, weights)`

Returns one random item using weights.

`items` and `weights` must have the same length.

```lua
local stats = require("LuaSF")

local items = {"low", "medium", "high"}
local weights = {1, 2, 7}

print(stats.weighted_choice(items, weights))
```

---

### `set_rng(rng_function)`

Sets a custom random number generator.

The function should return a number between `0` and `1`.

```lua
local stats = require("LuaSF")

stats.set_rng(function()
  return 0.0
end)

print(stats.choice({"first", "second", "third"})) -- first

stats.reset_rng()
```

---

### `reset_rng()`

Restores Lua's default random number generator.

```lua
local stats = require("LuaSF")

stats.reset_rng()
```

---

## Random variables and distributions

LuaSF provides functions for discrete and continuous pseudo-random variables.

### `normalVA(mu, sig)`

Returns a normally distributed random value.

Parameters:

* `mu`: mean. Default: `0`
* `sig`: standard deviation. Default: `1`

```lua
local stats = require("LuaSF")

print(stats.normalVA(0, 1))
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

```lua
local stats = require("LuaSF")

print(stats.normal_inv_D(0.975, 0, 1))
```

Modern alias:

```lua
stats.inverse_normal(p, mu, sig)
```

---

### `bernoulliVA(p)`

Returns `1` with probability `p`, otherwise returns `0`.

```lua
local stats = require("LuaSF")

print(stats.bernoulliVA(0.5))
```

Modern alias:

```lua
stats.bernoulli(p)
```

---

### `unifVA(min, max)`

Returns a uniformly distributed random value between `min` and `max`.

```lua
local stats = require("LuaSF")

print(stats.unifVA(10, 20))
```

Modern alias:

```lua
stats.uniform(min, max)
```

---

### `expoVA(beta)`

Returns an exponentially distributed random value.

```lua
local stats = require("LuaSF")

print(stats.expoVA(1))
```

Modern alias:

```lua
stats.exponential(beta)
```

---

### `weibullVA(alpha, beta)`

Returns a Weibull-distributed random value.

```lua
local stats = require("LuaSF")

print(stats.weibullVA(1, 2))
```

Modern alias:

```lua
stats.weibull(alpha, beta)
```

---

### `erlangVA(n, lambda)`

Returns an Erlang-distributed random value.

```lua
local stats = require("LuaSF")

print(stats.erlangVA(3, 1))
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

```lua
local stats = require("LuaSF")

print(stats.trianVA(0, 0.5, 1))
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

```lua
local stats = require("LuaSF")

print(stats.binomialVA(10, 0.5))
```

Modern alias:

```lua
stats.binomial(n, p)
```

---

### `geometricVA(p)`

Returns a geometrically distributed random value.

```lua
local stats = require("LuaSF")

print(stats.geometricVA(0.5))
```

Modern alias:

```lua
stats.geometric(p)
```

---

### `poissonVA(lambda)`

Returns a Poisson-distributed random value.

```lua
local stats = require("LuaSF")

print(stats.poissonVA(2))
```

Modern alias:

```lua
stats.poisson(lambda)
```

---

### `chiSquareVA(n)`

Returns a chi-square-distributed random value with `n` degrees of freedom.

```lua
local stats = require("LuaSF")

print(stats.chiSquareVA(3))
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

```lua
local stats = require("LuaSF")

print(stats.gamVA(2, 1))
```

Modern alias:

```lua
stats.gamma(alpha, lambda)
```

---

### `lognoVA(m, s)`

Returns a log-normal random value.

```lua
local stats = require("LuaSF")

print(stats.lognoVA(1, 0.25))
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

Returns a random number using LuaSF's current random generator.

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

Sets Lua's random seed using `math.randomseed`.

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
stats.variance
stats.median
stats.min
stats.max
stats.quantile
stats.choice
stats.shuffle
stats.sample
stats.weighted_choice
stats.set_rng
stats.reset_rng
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

LuaSF preserves existing public names and adds modern aliases without removing legacy names.

Some legacy names intentionally keep their original spelling for backward compatibility, including:

```lua
stats.frecuencyF
stats.nomalVA
stats.lognoRandVA
```

These names should remain available even if newer documentation recommends clearer aliases.
