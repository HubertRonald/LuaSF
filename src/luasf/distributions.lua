local module_name = ... or "luasf.distributions"
local prefix = module_name:match("^src%.") and "src.luasf." or "luasf."

local validation = require(prefix .. "validation")
local rng = require(prefix .. "rng")

local ln = math.log
local sqrt = math.sqrt
local exp = math.exp
local floor = math.floor

local M = {}

local function normalVA(mu, sig)
  mu = mu or 0
  sig = sig or 1

  validation.assert_number(mu, "mu")
  validation.assert_number(sig, "sig")
  assert(sig > 0, "sig must be greater than 0")

  local r = rng.safe_random_open()
  local z = (r ^ 0.135 - (1 - r) ^ 0.135) / 0.1975

  return z * sig + mu
end

local function normal_inv_D(p, mu, sig)
  p = p or 0.5
  mu = mu or 0
  sig = sig or 1

  validation.assert_number(p, "p")
  validation.assert_number(mu, "mu")
  validation.assert_number(sig, "sig")
  assert(p > 0 and p < 1, "p must be greater than 0 and less than 1")
  assert(sig > 0, "sig must be greater than 0")

  local z = (p ^ 0.135 - (1 - p) ^ 0.135) / 0.1975

  return z * sig + mu
end

local function bernoulliVA(p)
  p = p or 0.5
  validation.assert_probability(p, "p")

  if rng.random() <= p then
    return 1
  end

  return 0
end

local function unifVA(min, max)
  min = min or 0
  max = max or 1

  validation.assert_number(min, "min")
  validation.assert_number(max, "max")
  assert(max >= min, "max must be greater than or equal to min")

  return (max - min) * rng.random() + min
end

local function expoVA(beta)
  beta = beta or 1

  validation.assert_number(beta, "beta")
  assert(beta > 0, "beta must be greater than 0")

  return (-1 / beta) * ln(1 - rng.safe_random_open())
end

local function weibullVA(alpha, beta)
  alpha = alpha or 1
  beta = beta or 1

  validation.assert_number(alpha, "alpha")
  validation.assert_number(beta, "beta")
  assert(alpha > 0, "alpha must be greater than 0")
  assert(beta > 0, "beta must be greater than 0")

  return alpha * (-ln(1 - rng.safe_random_open())) ^ (1 / beta)
end

local function erlangVA(n, lambda)
  n = n or 1
  lambda = lambda or 1

  validation.assert_number(n, "n")
  validation.assert_number(lambda, "lambda")
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

  validation.assert_number(a, "a")
  validation.assert_number(b, "b")
  validation.assert_number(c, "c")
  assert(a <= b and b <= c, "parameters must satisfy a <= b <= c")
  assert(c > a, "c must be greater than a")

  local r = rng.safe_random_open()
  local threshold = (b - a) / (c - a)

  if r <= threshold then
    return a + sqrt(r * (b - a) * (c - a))
  end

  return c - sqrt((1 - r) * (c - b) * (c - a))
end

local function binomialVA(n, p)
  n = n or 1
  p = p or 0.5

  validation.assert_number(n, "n")
  validation.assert_probability(p, "p")
  assert(n >= 0, "n must be greater than or equal to 0")

  local value = 0

  for _ = 1, floor(n) do
    value = value + bernoulliVA(p)
  end

  return value
end

local function geometricVA(p)
  p = p or 0.5

  validation.assert_probability(p, "p")
  assert(p > 0 and p < 1, "p must be greater than 0 and less than 1")

  local u = rng.safe_random_open()

  return floor(ln(u) / ln(1 - p))
end

local function poissonVA(lambda)
  lambda = lambda or 1

  validation.assert_number(lambda, "lambda")
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

  validation.assert_number(n, "n")
  assert(n >= 1, "n must be greater than or equal to 1")

  local value = 0

  for _ = 1, floor(n) do
    local z = normalVA()
    value = value + z * z
  end

  return value
end

local function gamVA(alpha, lambda)
  alpha = alpha or 1
  lambda = lambda or 1

  validation.assert_number(alpha, "alpha")
  validation.assert_number(lambda, "lambda")
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

        local u = rng.safe_random_open()

        if ln(u) < 0.5 * z * z + d - d * v + d * ln(v) then
          value = d * v / lambda
          break
        end
      end
    end
  else
    value = gamVA(alpha + 1, lambda) * rng.safe_random_open() ^ (1 / alpha)
  end

  return value
end

local function lognoVA(m, s)
  m = m or 1
  s = s or 1

  validation.assert_number(m, "m")
  validation.assert_number(s, "s")
  assert(m > 0, "m must be greater than 0")
  assert(s > 0, "s must be greater than 0")

  local mean = ln((m * m) / sqrt((m * m) + (s * s)))
  local sd = sqrt(ln(1 + ((s * s) / (m * m))))

  return exp(normalVA(mean, sd))
end

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

return M