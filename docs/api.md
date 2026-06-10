# LuaSF API

LuaSF stands for **Lua Statistics Functions**.

This document describes the public LuaSF API after the compatibility revival, modularization, statistics/sampling additions, probability helpers, and simple regression summaries.

LuaSF keeps the legacy public API available while adding clearer modern aliases.

---

## Module loading

### Recommended LuaRocks entry point

```lua
local stats = require("luasf")
```

### Compatibility entry point

```lua
local stats = require("LuaSF")
```

### Legacy README-compatible entry point

```lua
local stats = require("LuaStat")
```

### Development/internal implementation module

```lua
local stats = require("src.luasf")
```

---

## Internal module layout

LuaSF exposes a single public facade through:

```lua
local stats = require("luasf")
```

Internally, the implementation is split into smaller modules:

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
    validation.lua
    rng.lua
```

This keeps the public API stable while making the source code easier to maintain.

---

## Descriptive statistics

### `sumF(array)`

Returns the sum of numeric values in an array.

```lua
local stats = require("luasf")

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
local stats = require("luasf")

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
local stats = require("luasf")

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
local stats = require("luasf")

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
local stats = require("luasf")

print(stats.variance({2, 4, 6})) -- 4
```

---

### `median(array)`

Returns the median value.

```lua
local stats = require("luasf")

print(stats.median({3, 1, 2}))    -- 2
print(stats.median({4, 1, 2, 3})) -- 2.5
```

---

### `min(array)`

Returns the minimum value.

```lua
local stats = require("luasf")

print(stats.min({3, 1, 2})) -- 1
```

---

### `max(array)`

Returns the maximum value.

```lua
local stats = require("luasf")

print(stats.max({3, 1, 2})) -- 3
```

---

### `quantile(array, q)`

Returns the `q` quantile using linear interpolation.

`q` must be between `0` and `1`.

```lua
local stats = require("luasf")

print(stats.quantile({1, 2, 3, 4, 5}, 0.5)) -- 3
```

---

### `mode(array)`

Returns the most frequent value in an array.

If multiple values have the same frequency, LuaSF returns the first mode found after sorting the values.

```lua
local stats = require("luasf")

print(stats.mode({1, 2, 2, 3})) -- 2
```

---

### `range(array)`

Returns the difference between the maximum and minimum values.

```lua
local stats = require("luasf")

print(stats.range({3, 1, 10, 2})) -- 9
```

---

### `iqr(array)`

Returns the interquartile range.

It is calculated as:

```text
quantile(array, 0.75) - quantile(array, 0.25)
```

Example:

```lua
local stats = require("luasf")

print(stats.iqr({1, 2, 3, 4, 5})) -- 2
```

---

### `percentile(array, p)`

Returns the `p` percentile.

`p` must be between `0` and `100`.

```lua
local stats = require("luasf")

print(stats.percentile({1, 2, 3, 4, 5}, 50)) -- 3
```

---

### `summary(array)`

Returns a summary table with common descriptive statistics.

The returned table includes:

```lua
{
  count = number,
  min = number,
  max = number,
  mean = number,
  median = number,
  variance = number or nil,
  stddev = number or nil
}
```

Example:

```lua
local stats = require("luasf")

local result = stats.summary({1, 2, 3, 4, 5})

print(result.count)    -- 5
print(result.min)      -- 1
print(result.max)      -- 5
print(result.mean)     -- 3
print(result.median)   -- 3
print(result.variance) -- 2.5
```


---

## Shape statistics

Shape statistics describe the asymmetry and tail behavior of a numeric array.

LuaSF implements moment-based shape helpers.

### `central_moment(array, order)`

Returns the central moment of a numeric array using denominator `n`.

The central moment of order `k` is computed as the average of `(x_i - mean)^k`.

```lua
local stats = require("luasf")

print(stats.central_moment({1, 2, 3, 4, 5}, 2)) -- 2
```

---

### `skewness(array)`

Returns the standardized third central moment.

Values near `0` indicate approximate symmetry. Positive values suggest right skew, while negative values suggest left skew.

```lua
local stats = require("luasf")

print(stats.skewness({1, 2, 3, 4, 5})) -- approximately 0
print(stats.skewness({1, 1, 2, 2, 10})) -- positive
```

---

### `kurtosis(array)`

Returns Pearson kurtosis.

```lua
local stats = require("luasf")

print(stats.kurtosis({1, 2, 3, 4, 5})) -- 1.7
```

---

### `excess_kurtosis(array)`

Returns Fisher-style excess kurtosis:

```text
kurtosis(array) - 3
```

```lua
local stats = require("luasf")

print(stats.excess_kurtosis({1, 2, 3, 4, 5})) -- -1.3
```

---

## Bivariate statistics

### `covariance(x, y)`

Returns the sample covariance between two numeric arrays.

LuaSF uses the sample covariance formula with `n - 1`.

Both arrays must:

* be tables
* contain numeric values
* have the same length
* contain at least two values

Example:

```lua
local stats = require("luasf")

local x = {1, 2, 3, 4, 5}
local y = {2, 4, 6, 8, 10}

print(stats.covariance(x, y)) -- 5
```

### `correlation(x, y)`

Returns the Pearson correlation coefficient between two numeric arrays.

Both arrays must have the same length and non-zero sample standard deviation.

Example:

```lua
local stats = require("luasf")

local x = {1, 2, 3, 4, 5}
local y = {2, 4, 6, 8, 10}

print(stats.correlation(x, y)) -- 1
```

### `pearson(x, y)`

Alias for:

```lua
stats.correlation(x, y)
```

---

## Probability helpers

Probability helpers are lightweight combinatorics utilities useful for counting cases in probability, simulation, teaching, and small scripts.

LuaSF distinguishes helpers without repetition and with repetition where appropriate.

> Lua numbers may lose precision for very large combinatorial values. LuaSF intentionally avoids big integer dependencies to remain small and pure Lua.

### `factorial(n)`

Returns the factorial of a non-negative integer.

```lua
local stats = require("luasf")

print(stats.factorial(0)) -- 1
print(stats.factorial(5)) -- 120
```

---

### `permutations(n, r)`

Returns the number of ordered selections of `r` elements from `n` distinct elements without repetition.

This is commonly known as `nPr`.

```text
nPr = n! / (n - r)!
```

If `r` is omitted, LuaSF treats it as `n` and returns `n!`.

```lua
local stats = require("luasf")

print(stats.permutations(5, 3)) -- 60
print(stats.nPr(5, 3))          -- 60
```

Requirements:

* `n` must be a non-negative integer.
* `r` must be a non-negative integer.
* `r <= n`.


Alias:

```lua
stats.permutations_without_repetition(n, r)
```

---

### `combinations(n, r)`

Returns the number of unordered selections of `r` elements from `n` distinct elements without repetition.

This is commonly known as `nCr`.

```text
nCr = n! / (r! * (n - r)!)
```

```lua
local stats = require("luasf")

print(stats.combinations(5, 3)) -- 10
print(stats.nCr(5, 3))          -- 10
```

Requirements:

* `n` must be a non-negative integer.
* `r` must be a non-negative integer.
* `r <= n`.


Alias:

```lua
stats.combinations_without_repetition(n, r)
```


---

### `permutations_with_repetition(n, r)`

Returns the number of ordered selections of `r` elements from `n` possible values with repetition allowed.

This is equivalent to:

```text
n^r
```

```lua
local stats = require("luasf")

print(stats.permutations_with_repetition(5, 3)) -- 125
print(stats.permutations_with_repetition(10, 4)) -- 10000
```

Requirements:

* `n` must be a non-negative integer.
* `r` must be a non-negative integer.


This is useful for cases such as PIN-like sequences, codes, or ordered choices where values can repeat.

---

### `combinations_with_repetition(n, r)`

Returns the number of unordered selections of `r` elements from `n` possible values with repetition allowed.

This is equivalent to:

```text
C(n + r - 1, r)
```

```lua
local stats = require("luasf")

print(stats.combinations_with_repetition(5, 3)) -- 35
```

Requirements:

* `n` must be a positive integer.
* `r` must be a non-negative integer.

---

### `multiset_permutations(counts)`

Returns the number of distinct arrangements of repeated item groups.

`counts` is an array containing how many times each repeated group appears.

This is equivalent to:

```text
n! / (a! * b! * c! * ...)
```

where `n` is the sum of all counts.

```lua
local stats = require("luasf")

print(stats.multiset_permutations({3, 2, 1})) -- 60
```

---

## Sampling utilities

### `choice(array)`

Returns one random item from an array.

```lua
local stats = require("luasf")

local names = {"Lua", "Python", "R"}

print(stats.choice(names))
```

---

### `shuffle(array)`

Returns a shuffled copy of an array.

This function does not modify the original array.

```lua
local stats = require("luasf")

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
local stats = require("luasf")

local values = {"a", "b", "c", "d"}
local selected = stats.sample(values, 2)

for i = 1, #selected do
  print(selected[i])
end
```

---

### `weighted_choice(items, weights)`

Returns one random item using the given weights.

`items` and `weights` must have the same length.

```lua
local stats = require("luasf")

local items = {"low", "medium", "high"}
local weights = {1, 2, 7}

print(stats.weighted_choice(items, weights))
```

---

### `set_rng(rng_function)`

Sets a custom random number generator.

The function should return a number between `0` and `1`.

```lua
local stats = require("luasf")

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
local stats = require("luasf")

stats.reset_rng()
```

---

## Random variables and distributions

LuaSF provides functions for discrete and continuous pseudo-random variables.

| Legacy name | Modern alias | Description |
|---|---|---|
| `nomalVA(mu, sig)` | `normal(mu, sig)` | Normal random variable |
| `normalVA(mu, sig)` | `normal(mu, sig)` | Normal random variable |
| `normal_inv_D(p, mu, sig)` | `inverse_normal(p, mu, sig)` | Approximate inverse normal value |
| `bernoulliVA(p)` | `bernoulli(p)` | Bernoulli random variable |
| `unifVA(min, max)` | `uniform(min, max)` | Uniform random variable |
| `expoVA(beta)` | `exponential(beta)` | Exponential random variable |
| `weibullVA(alpha, beta)` | `weibull(alpha, beta)` | Weibull random variable |
| `erlangVA(n, lambda)` | `erlang(n, lambda)` | Erlang random variable |
| `trianVA(a, b, c)` | `triangular(a, b, c)` | Triangular random variable |
| `binomialVA(n, p)` | `binomial(n, p)` | Binomial random variable |
| `geometricVA(p)` | `geometric(p)` | Geometric random variable |
| `poissonVA(lambda)` | `poisson(lambda)` | Poisson random variable |
| `chiSquareVA(n)` | `chi_square(n)` | Chi-square random variable |
| `studentTVA(df)` | `student_t(df)` or `t_student(df)` | Student's t-distributed random variable |
| `gamVA(alpha, lambda)` | `gamma(alpha, lambda)` | Gamma random variable |
| `lognoVA(m, s)` | `lognormal(m, s)` | Log-normal random variable |
| `lognoRandVA(m, s)` | `lognormal(m, s)` | Log-normal random variable |


### `normalVA(mu, sig)`

Returns a normally distributed random value.

Parameters:

* `mu`: mean. Default: `0`
* `sig`: standard deviation. Default: `1`

```lua
local stats = require("luasf")

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
local stats = require("luasf")

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
local stats = require("luasf")

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
local stats = require("luasf")

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
local stats = require("luasf")

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
local stats = require("luasf")

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
local stats = require("luasf")

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
local stats = require("luasf")

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
local stats = require("luasf")

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
local stats = require("luasf")

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
local stats = require("luasf")

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
local stats = require("luasf")

print(stats.chiSquareVA(3))
```

Modern alias:

```lua
stats.chi_square(n)
```

---

### `studentTVA(df)`

Returns a Student's t-distributed random value with `df` degrees of freedom.

LuaSF generates it from a standard normal random variable and an independent chi-square random variable:

```text
T = Z / sqrt(V / df)
```

where `Z` is approximately standard normal and `V` is chi-square with `df` degrees of freedom.

Modern aliases:

```lua
stats.student_t(df)
stats.t_student(df)
```

---

### `gamVA(alpha, lambda)`

Returns a gamma-distributed random value.

Parameters:

* `alpha`: shape parameter
* `lambda`: rate parameter

```lua
local stats = require("luasf")

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
local stats = require("luasf")

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

## Simple regression summaries

LuaSF provides formula-based simple linear regression summaries.

These helpers are intended for lightweight statistics, teaching, small scripts, and simulation-style analysis. They are not a machine learning framework and do not perform iterative optimization.

### `simple_linear_regression(x, y)`

Returns a table with a formula-based simple linear regression summary.

```lua
local stats = require("luasf")

local x = {1, 2, 3, 4, 5}
local y = {3, 5, 7, 9, 11}

local model = stats.simple_linear_regression(x, y)

print(model.intercept) -- 1
print(model.slope)     -- 2
print(model.r_squared) -- 1
```

The returned table includes:

```lua
{
  n = number,
  degrees_freedom = number,

  slope = number,
  intercept = number,
  coefficients = {
    intercept = number,
    slope = number
  },

  r = number or nil,
  r_squared = number or nil,
  adjusted_r_squared = number or nil,

  sst = number,
  ssr = number,
  sse = number,
  mse = number,
  rmse = number,
  residual_standard_error = number,

  standard_error_slope = number,
  standard_error_intercept = number,
  t_slope = number or nil,
  t_intercept = number or nil,

  fitted_values = table,
  residuals = table,

  anova = {
    regression = { df = 1, ss = number, ms = number, f = number or nil },
    residual = { df = number, ss = number, ms = number },
    total = { df = number, ss = number }
  }
}
```

### `predict(model, x)`

Predicts one value or a list of values using a regression model.

```lua
local prediction = stats.predict(model, 6)
local predictions = stats.predict(model, {6, 7, 8})
```

### `fitted_values(model)`

Returns a copy of the model fitted values.

### `residuals(model)`

Returns a copy of the model residuals.

### Scope note

LuaSF reports simple regression coefficients, R and R², sums of squares, MSE, RMSE, residual standard error, standard errors, t statistics, and an ANOVA-style summary.

LuaSF does not compute regression p-values, confidence intervals, critical values, multiple regression, non-linear regression, optimization-based modeling, or machine learning training pipelines.

---

## Utility functions

### `rand()`

Returns a random number using LuaSF's current random generator.

```lua
local stats = require("luasf")

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
local stats = require("luasf")

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
stats.studentTVA
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
stats.mode
stats.range
stats.iqr
stats.percentile
stats.summary
stats.central_moment
stats.skewness
stats.kurtosis
stats.excess_kurtosis
stats.covariance
stats.correlation
stats.pearson
stats.factorial
stats.permutations
stats.combinations
stats.permutations_with_repetition
stats.combinations_with_repetition
stats.permutations_without_repetition
stats.combinations_without_repetition
stats.multiset_permutations
stats.nPr
stats.nCr
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
stats.student_t
stats.t_student
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
