local module_name = ... or "luasf.shape"
local prefix = module_name:match("^src%.") and "src.luasf." or "luasf."

local validation = require(prefix .. "validation")
local descriptive = require(prefix .. "descriptive")

local M = {}

local function central_moment(array, order)
  validation.assert_min_length(array, 2)
  validation.assert_numeric_array(array)
  validation.assert_number(order, "order")
  assert(order >= 1, "order must be greater than or equal to 1")

  local mean = descriptive.mean(array)
  local total = 0

  for i = 1, #array do
    total = total + (array[i] - mean) ^ order
  end

  return total / #array
end

local function skewness(array)
  local m2 = central_moment(array, 2)
  assert(m2 > 0, "array variance must be greater than 0")

  local m3 = central_moment(array, 3)

  return m3 / (m2 ^ 1.5)
end

local function kurtosis(array)
  local m2 = central_moment(array, 2)
  assert(m2 > 0, "array variance must be greater than 0")

  local m4 = central_moment(array, 4)

  return m4 / (m2 * m2)
end

local function excess_kurtosis(array)
  return kurtosis(array) - 3
end

M.central_moment = central_moment
M.skewness = skewness
M.kurtosis = kurtosis
M.excess_kurtosis = excess_kurtosis

return M
