local module_name = ... or "luasf.descriptive"
local prefix = module_name:match("^src%.") and "src.luasf." or "luasf."

local validation = require(prefix .. "validation")
local core = require(prefix .. "core")

local sqrt = math.sqrt
local floor = math.floor
local ceil = math.ceil
local table_sort = table.sort

local M = {}

local function sumF(array)
  assert(type(array) == "table", "array must be a table")

  local s = 0

  for _, value in ipairs(array) do
    validation.assert_number(value, "array value")
    s = s + value
  end

  return s
end

local function avF(array)
  validation.assert_non_empty_array(array)
  return sumF(array) / #array
end

local function stvF(array)
  validation.assert_min_length(array, 2)

  local average = avF(array)
  local squared_sum = 0

  for _, value in ipairs(array) do
    validation.assert_number(value, "array value")
    squared_sum = squared_sum + (value - average) ^ 2
  end

  return sqrt(squared_sum / (#array - 1))
end

local function variance(array)
  validation.assert_min_length(array, 2)

  local average = avF(array)
  local squared_sum = 0

  for _, value in ipairs(array) do
    validation.assert_number(value, "array value")
    squared_sum = squared_sum + (value - average) ^ 2
  end

  return squared_sum / (#array - 1)
end

local function min_value(array)
  validation.assert_non_empty_array(array)

  local current_min = array[1]
  validation.assert_number(current_min, "array value")

  for i = 2, #array do
    validation.assert_number(array[i], "array value")

    if array[i] < current_min then
      current_min = array[i]
    end
  end

  return current_min
end

local function max_value(array)
  validation.assert_non_empty_array(array)

  local current_max = array[1]
  validation.assert_number(current_max, "array value")

  for i = 2, #array do
    validation.assert_number(array[i], "array value")

    if array[i] > current_max then
      current_max = array[i]
    end
  end

  return current_max
end

local function quantile(array, q)
  validation.assert_non_empty_array(array)
  validation.assert_number(q, "q")
  assert(q >= 0 and q <= 1, "q must be between 0 and 1")

  local list = core.copy_array(array)
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

local function frecuencyF(array)
  validation.assert_non_empty_array(array)

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

local function mode(array)
  validation.assert_non_empty_array(array)

  local freq = frecuencyF(array)
  local best_value = freq.g[1]
  local best_count = freq.c[1]

  for i = 2, #freq.g do
    if freq.c[i] > best_count then
      best_value = freq.g[i]
      best_count = freq.c[i]
    end
  end

  return best_value
end

local function range_value(array)
  return max_value(array) - min_value(array)
end

local function iqr(array)
  return quantile(array, 0.75) - quantile(array, 0.25)
end

local function percentile(array, p)
  validation.assert_number(p, "p")
  assert(p >= 0 and p <= 100, "p must be between 0 and 100")

  return quantile(array, p / 100)
end

local function summary(array)
  validation.assert_non_empty_array(array)

  local result = {
    count = #array,
    min = min_value(array),
    max = max_value(array),
    mean = avF(array),
    median = median(array)
  }

  if #array >= 2 then
    result.variance = variance(array)
    result.stddev = stvF(array)
  else
    result.variance = nil
    result.stddev = nil
  end

  return result
end

M.sumF = sumF
M.avF = avF
M.stvF = stvF
M.frecuencyF = frecuencyF

M.sum = sumF
M.mean = avF
M.stddev = stvF
M.frequency = frecuencyF

M.variance = variance
M.median = median
M.min = min_value
M.max = max_value
M.quantile = quantile

M.mode = mode
M.range = range_value
M.iqr = iqr
M.percentile = percentile
M.summary = summary

return M