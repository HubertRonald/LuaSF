local module_name = ... or "luasf.bivariate"
local prefix = module_name:match("^src%.") and "src.luasf." or "luasf."

local validation = require(prefix .. "validation")
local descriptive = require(prefix .. "descriptive")

local sqrt = math.sqrt

local M = {}

local function covariance(x, y)
  validation.assert_same_length_numeric_arrays(x, y, "x", "y")
  assert(#x >= 2, "x and y must contain at least two values")

  local mean_x = descriptive.mean(x)
  local mean_y = descriptive.mean(y)
  local total = 0

  for i = 1, #x do
    total = total + (x[i] - mean_x) * (y[i] - mean_y)
  end

  return total / (#x - 1)
end

local function pearson_correlation(x, y)
  validation.assert_same_length_numeric_arrays(x, y, "x", "y")
  assert(#x >= 2, "x and y must contain at least two values")

  local std_x = descriptive.stddev(x)
  local std_y = descriptive.stddev(y)

  assert(std_x > 0, "x standard deviation must be greater than 0")
  assert(std_y > 0, "y standard deviation must be greater than 0")

  return covariance(x, y) / (std_x * std_y)
end

M.covariance = covariance
M.correlation = pearson_correlation
M.pearson = pearson_correlation
M.pearson_correlation = pearson_correlation

return M