local module_name = ... or "luasf.sampling"
local prefix = module_name:match("^src%.") and "src.luasf." or "luasf."

local validation = require(prefix .. "validation")
local core = require(prefix .. "core")
local rng = require(prefix .. "rng")

local floor = math.floor

local M = {}

local function choice(array)
  validation.assert_non_empty_array(array)
  return array[rng.rand(1, #array)]
end

local function shuffle(array)
  local shuffled = core.copy_array(array)

  for i = #shuffled, 2, -1 do
    local j = rng.rand(1, i)
    shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
  end

  return shuffled
end

local function sample(array, n)
  validation.assert_non_empty_array(array)
  validation.assert_number(n, "n")
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
  validation.assert_non_empty_array(items, "items")
  validation.assert_non_empty_array(weights, "weights")
  assert(#items == #weights, "items and weights must have the same length")

  local total_weight = 0

  for _, weight in ipairs(weights) do
    validation.assert_number(weight, "weight")
    assert(weight >= 0, "weights must be greater than or equal to 0")
    total_weight = total_weight + weight
  end

  assert(total_weight > 0, "total weight must be greater than 0")

  local threshold = rng.random() * total_weight
  local cumulative = 0

  for i = 1, #items do
    cumulative = cumulative + weights[i]

    if threshold <= cumulative then
      return items[i]
    end
  end

  return items[#items]
end

M.choice = choice
M.shuffle = shuffle
M.sample = sample
M.weighted_choice = weighted_choice

return M