--[[
LuaSF : Lua Statistics Functions

A lightweight, pure-Lua library for basic statistics and random variables.

MIT License

Copyright (c) 2017 Hubert Ronald

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files, to deal in the Software
without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, subject to the conditions in the LICENSE file.

Phase 1 compatibility notes:
- Keeps legacy function names from the original LuaSF API.
- Adds modern aliases without breaking existing references.
- Keeps require("LuaSF") as the main compatibility entry point.
]]

local M = {}

local default_rand = math.random
local rand = default_rand
local randomseed = math.randomseed
local ln = math.log
local sqrt = math.sqrt
local exp = math.exp
local floor = math.floor
local ceil = math.ceil
local ipairs = ipairs
local table_sort = table.sort
local os_time = os.time

local function assert_number(value, name)
  assert(type(value) == "number", name .. " must be a number")
end

local function assert_probability(p, name)
  name = name or "p"
  assert_number(p, name)
  assert(p >= 0 and p <= 1, name .. " must be between 0 and 1")
end

local function assert_non_empty_array(array, name)
  name = name or "array"
  assert(type(array) == "table", name .. " must be a table")
  assert(#array > 0, name .. " must not be empty")
end

local function safe_random_open()
  -- Avoid exact 0 or 1 because logarithms and inverse transforms can fail there.
  local r = rand()
  while r <= 0 or r >= 1 do
    r = rand()
  end
  return r
end

-- Seed helper
local function seed(value)
  randomseed(value or os_time())
end

local function set_rng(rng_function)
  assert(type(rng_function) == "function", "rng_function must be a function")
  rand = rng_function
end

local function reset_rng()
  rand = default_rand
end

-- Legacy-compatible integer/random helper.
-- Supports:
--   rand()
--   rand(max)
--   rand(min, max)
local function randF(a, b)
  local r = rand()

  if a == nil and b == nil then
    return r
  elseif b == nil then
    assert_number(a, "max")
    assert(a >= 1, "max must be greater than or equal to 1")
    return floor(r * a) + 1
  else
    assert_number(a, "min")
    assert_number(b, "max")
    assert(b >= a, "max must be greater than or equal to min")
    return floor(r * (b - a + 1)) + a
  end
end

-- Sum array
local function sumF(array)
  assert(type(array) == "table", "array must be a table")

  local s = 0
  for _, value in ipairs(array) do
    assert_number(value, "array value")
    s = s + value
  end

  return s
end

-- Average array
local function avF(array)
  assert_non_empty_array(array)
  return sumF(array) / #array
end

-- Sample standard deviation, using n - 1
local function stvF(array)
  assert_non_empty_array(array)
  assert(#array >= 2, "array must contain at least two values")

  local average = avF(array)
  local squared_sum = 0

  for _, value in ipairs(array) do
    squared_sum = squared_sum + (value - average) ^ 2
  end

  return sqrt(squared_sum / (#array - 1))
end

local function variance(array)
  assert_non_empty_array(array)
  assert(#array >= 2, "array must contain at least two values")

  local average = avF(array)
  local squared_sum = 0

  for _, value in ipairs(array) do
    assert_number(value, "array value")
    squared_sum = squared_sum + (value - average) ^ 2
  end

  return squared_sum / (#array - 1)
end

local function min_value(array)
  assert_non_empty_array(array)

  local current_min = array[1]
  assert_number(current_min, "array value")

  for i = 2, #array do
    assert_number(array[i], "array value")
    if array[i] < current_min then
      current_min = array[i]
    end
  end

  return current_min
end

local function max_value(array)
  assert_non_empty_array(array)

  local current_max = array[1]
  assert_number(current_max, "array value")

  for i = 2, #array do
    assert_number(array[i], "array value")
    if array[i] > current_max then
      current_max = array[i]
    end
  end

  return current_max
end

local function copy_array(array)
  assert_non_empty_array(array)

  local copied = {}

  for i = 1, #array do
    copied[i] = array[i]
  end

  return copied
end

local function quantile(array, q)
  assert_non_empty_array(array)
  assert_number(q, "q")
  assert(q >= 0 and q <= 1, "q must be between 0 and 1")

  local list = copy_array(array)
  table_sort(list)

  if #list == 1 then
    return list[1]
  end

  local position = 1 + (#list - 1) * q
  local lower_index = floor(position)
  local upper_index = ceil(position)

  if lower_index == upper_index then
    return list[lower_index]
  end

  local weight = position - lower_index
  return list[lower_index] * (1 - weight) + list[upper_index] * weight
end

local function median(array)
  return quantile(array, 0.5)
end

-- Frequency distribution.
-- Keeps legacy fields:
--   g = groups
--   c = counts
-- Adds readable aliases:
--   values = groups
--   counts = counts
local function frecuencyF(array)
  assert_non_empty_array(array)

  local list = {}
  local groups = {}
  local counts = {}

  for index, value in ipairs(array) do
    list[index] = value
  end

  table_sort(list)

  groups[1] = list[1]
  counts[1] = 1

  for i = 2, #list do
    if groups[#groups] == list[i] then
      counts[#counts] = counts[#counts] + 1
    else
      groups[#groups + 1] = list[i]
      counts[#counts + 1] = 1
    end
  end

  return {
    g = groups,
    c = counts,
    values = groups,
    counts = counts
  }
end

-- Normal random variable.
-- Original approximation method kept for compatibility.
local function normalVA(mu, sig)
  mu = mu or 0
  sig = sig or 1

  assert_number(mu, "mu")
  assert_number(sig, "sig")
  assert(sig > 0, "sig must be greater than 0")

  local r = safe_random_open()
  local z = (r ^ 0.135 - (1 - r) ^ 0.135) / 0.1975

  return z * sig + mu
end

-- Approximate inverse normal distribution.
local function normal_inv_D(p, mu, sig)
  p = p or 0.5
  mu = mu or 0
  sig = sig or 1

  assert_number(p, "p")
  assert_number(mu, "mu")
  assert_number(sig, "sig")
  assert(p > 0 and p < 1, "p must be greater than 0 and less than 1")
  assert(sig > 0, "sig must be greater than 0")

  local z = (p ^ 0.135 - (1 - p) ^ 0.135) / 0.1975

  return z * sig + mu
end

local function bernoulliVA(p)
  p = p or 0.5
  assert_probability(p, "p")

  if rand() <= p then
    return 1
  end

  return 0
end

local function unifVA(min, max)
  min = min or 0
  max = max or 1

  assert_number(min, "min")
  assert_number(max, "max")
  assert(max >= min, "max must be greater than or equal to min")

  return (max - min) * rand() + min
end

-- Exponential random variable.
-- beta is treated as the rate parameter.
local function expoVA(beta)
  beta = beta or 1

  assert_number(beta, "beta")
  assert(beta > 0, "beta must be greater than 0")

  return (-1 / beta) * ln(1 - safe_random_open())
end

local function weibullVA(alpha, beta)
  alpha = alpha or 1
  beta = beta or 1

  assert_number(alpha, "alpha")
  assert_number(beta, "beta")
  assert(alpha > 0, "alpha must be greater than 0")
  assert(beta > 0, "beta must be greater than 0")

  return alpha * (-ln(1 - safe_random_open())) ^ (1 / beta)
end

local function erlangVA(n, lambda)
  n = n or 1
  lambda = lambda or 1

  assert_number(n, "n")
  assert_number(lambda, "lambda")
  assert(n >= 1, "n must be greater than or equal to 1")
  assert(lambda > 0, "lambda must be greater than 0")

  local value = 0

  for _ = 1, floor(n) do
    value = value + expoVA(lambda)
  end

  return value
end

local function trianVA(a, b, c)
  a = a or 0
  b = b or 0.5
  c = c or 1

  assert_number(a, "a")
  assert_number(b, "b")
  assert_number(c, "c")
  assert(a <= b and b <= c, "parameters must satisfy a <= b <= c")
  assert(c > a, "c must be greater than a")

  local r = safe_random_open()
  local threshold = (b - a) / (c - a)

  if r <= threshold then
    return a + sqrt(r * (b - a) * (c - a))
  end

  return c - sqrt((1 - r) * (c - b) * (c - a))
end

local function binomialVA(n, p)
  n = n or 1
  p = p or 0.5

  assert_number(n, "n")
  assert_probability(p, "p")
  assert(n >= 0, "n must be greater than or equal to 0")

  local value = 0

  for _ = 1, floor(n) do
    value = value + bernoulliVA(p)
  end

  return value
end

local function geometricVA(p)
  p = p or 0.5

  assert_probability(p, "p")
  assert(p > 0 and p < 1, "p must be greater than 0 and less than 1")

  local u = safe_random_open()

  -- Number of failures before first success.
  return floor(ln(u) / ln(1 - p))
end

local function poissonVA(lambda)
  lambda = lambda or 1

  assert_number(lambda, "lambda")
  assert(lambda > 0, "lambda must be greater than 0")

  local elapsed = 0
  local value = 0

  while true do
    elapsed = elapsed + expoVA(lambda)

    if elapsed <= 1 then
      value = value + 1
    else
      break
    end
  end

  return value
end

local function chiSquareVA(n)
  n = n or 1

  assert_number(n, "n")
  assert(n >= 1, "n must be greater than or equal to 1")

  local value = 0

  for _ = 1, floor(n) do
    local z = normalVA()
    value = value + z * z
  end

  return value
end

-- Gamma random variable.
-- alpha = shape
-- lambda = rate
local function gamVA(alpha, lambda)
  alpha = alpha or 1
  lambda = lambda or 1

  assert_number(alpha, "alpha")
  assert_number(lambda, "lambda")
  assert(alpha > 0, "alpha must be greater than 0")
  assert(lambda > 0, "lambda must be greater than 0")

  local value

  if alpha >= 1 then
    local d = alpha - 1 / 3
    local c = 1 / sqrt(9 * d)

    while true do
      local z = normalVA()
      local v = 1 + c * z

      if v > 0 then
        v = v ^ 3

        local u = safe_random_open()

        if ln(u) < 0.5 * z * z + d - d * v + d * ln(v) then
          value = d * v / lambda
          break
        end
      end
    end
  else
    value = gamVA(alpha + 1, lambda) * safe_random_open() ^ (1 / alpha)
  end

  return value
end

-- Log-normal random variable from arithmetic mean and standard deviation.
local function lognoVA(m, s)
  m = m or 1
  s = s or 1

  assert_number(m, "m")
  assert_number(s, "s")
  assert(m > 0, "m must be greater than 0")
  assert(s > 0, "s must be greater than 0")

  local mean = ln((m * m) / sqrt((m * m) + (s * s)))
  local sd = sqrt(ln(1 + ((s * s) / (m * m))))

  return exp(normalVA(mean, sd))
end

local function choice(array)
  assert_non_empty_array(array)
  return array[randF(1, #array)]
end

local function shuffle(array)
  local shuffled = copy_array(array)

  for i = #shuffled, 2, -1 do
    local j = randF(1, i)
    shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
  end

  return shuffled
end

local function sample(array, n)
  assert_non_empty_array(array)
  assert_number(n, "n")
  assert(n >= 0, "n must be greater than or equal to 0")
  assert(n <= #array, "n must be less than or equal to array length")

  local shuffled = shuffle(array)
  local result = {}

  for i = 1, floor(n) do
    result[i] = shuffled[i]
  end

  return result
end

local function weighted_choice(items, weights)
  assert_non_empty_array(items, "items")
  assert_non_empty_array(weights, "weights")
  assert(#items == #weights, "items and weights must have the same length")

  local total_weight = 0

  for _, weight in ipairs(weights) do
    assert_number(weight, "weight")
    assert(weight >= 0, "weights must be greater than or equal to 0")
    total_weight = total_weight + weight
  end

  assert(total_weight > 0, "total weight must be greater than 0")

  local threshold = rand() * total_weight
  local cumulative = 0

  for i = 1, #items do
    cumulative = cumulative + weights[i]

    if threshold <= cumulative then
      return items[i]
    end
  end

  return items[#items]
end

-- Legacy/public API
M.rand = randF
M.sumF = sumF
M.avF = avF
M.stvF = stvF
M.frecuencyF = frecuencyF
M.nomalVA = normalVA
M.normalVA = normalVA
M.normal_inv_D = normal_inv_D
M.bernoulliVA = bernoulliVA
M.unifVA = unifVA
M.expoVA = expoVA
M.weibullVA = weibullVA
M.erlangVA = erlangVA
M.trianVA = trianVA
M.binomialVA = binomialVA
M.geometricVA = geometricVA
M.poissonVA = poissonVA
M.chiSquareVA = chiSquareVA
M.gamVA = gamVA
M.lognoVA = lognoVA
M.lognoRandVA = lognoVA

-- Modern aliases
M.seed = seed
M.random_integer = randF
M.sum = sumF
M.mean = avF
M.stddev = stvF
M.frequency = frecuencyF
M.normal = normalVA
M.inverse_normal = normal_inv_D
M.bernoulli = bernoulliVA
M.uniform = unifVA
M.exponential = expoVA
M.weibull = weibullVA
M.erlang = erlangVA
M.triangular = trianVA
M.binomial = binomialVA
M.geometric = geometricVA
M.poisson = poissonVA
M.chi_square = chiSquareVA
M.gamma = gamVA
M.lognormal = lognoVA

M.set_rng = set_rng
M.reset_rng = reset_rng

M.variance = variance
M.median = median
M.min = min_value
M.max = max_value
M.quantile = quantile

M.choice = choice
M.shuffle = shuffle
M.sample = sample
M.weighted_choice = weighted_choice

return M
