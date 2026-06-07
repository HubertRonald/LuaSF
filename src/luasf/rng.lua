local module_name = ... or "luasf.rng"
local prefix = module_name:match("^src%.") and "src.luasf." or "luasf."

local validation = require(prefix .. "validation")

local floor = math.floor
local os_time = os.time

local default_rand = math.random
local rand = default_rand
local randomseed = math.randomseed

local M = {}

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

local function random()
  return rand()
end

local function safe_random_open()
  local r = rand()

  while r <= 0 or r >= 1 do
    r = rand()
  end

  return r
end

local function randF(a, b)
  local r = rand()

  if a == nil and b == nil then
    return r
  elseif b == nil then
    validation.assert_number(a, "max")
    assert(a >= 1, "max must be greater than or equal to 1")
    return floor(r * a) + 1
  else
    validation.assert_number(a, "min")
    validation.assert_number(b, "max")
    assert(b >= a, "max must be greater than or equal to min")
    return floor(r * (b - a + 1)) + a
  end
end

M.seed = seed
M.set_rng = set_rng
M.reset_rng = reset_rng

M.random = random
M.safe_random_open = safe_random_open

M.rand = randF
M.random_integer = randF

return M