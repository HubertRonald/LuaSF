local module_name = ... or "luasf.regression"
local prefix = module_name:match("^src%.") and "src.luasf." or "luasf."

local validation = require(prefix .. "validation")
local descriptive = require(prefix .. "descriptive")
local core = require(prefix .. "core")

local sqrt = math.sqrt

local M = {}

local function clamp_near_zero(value)
  if value < 0 and value > -1e-12 then
    return 0
  end

  if value > 0 and value < 1e-12 then
    return 0
  end

  return value
end

local function divide_or_nil(numerator, denominator)
  if denominator == nil or denominator == 0 then
    return nil
  end

  return numerator / denominator
end

local function validate_model(model)
  assert(type(model) == "table", "model must be a table")
  validation.assert_number(model.slope, "model.slope")
  validation.assert_number(model.intercept, "model.intercept")
end

local function simple_linear_regression(x, y)
  validation.assert_same_length_numeric_arrays(x, y, "x", "y")
  assert(#x >= 3, "x and y must contain at least three values")

  local n = #x
  local mean_x = descriptive.mean(x)
  local mean_y = descriptive.mean(y)
  local sxx = 0
  local syy = 0
  local sxy = 0

  for i = 1, n do
    local dx = x[i] - mean_x
    local dy = y[i] - mean_y

    sxx = sxx + dx * dx
    syy = syy + dy * dy
    sxy = sxy + dx * dy
  end

  assert(sxx > 0, "x values must not be constant")

  local slope = sxy / sxx
  local intercept = mean_y - slope * mean_x
  local fitted = {}
  local residual_values = {}
  local sse = 0
  local ssr = 0

  for i = 1, n do
    local y_hat = intercept + slope * x[i]
    local residual = y[i] - y_hat

    fitted[i] = y_hat
    residual_values[i] = residual

    sse = sse + residual * residual
    ssr = ssr + (y_hat - mean_y) * (y_hat - mean_y)
  end

  local sst = syy

  sse = clamp_near_zero(sse)
  ssr = clamp_near_zero(ssr)
  sst = clamp_near_zero(sst)

  local degrees_freedom = n - 2
  local mse = sse / degrees_freedom
  local rmse = sqrt(mse)
  local residual_standard_error = rmse

  local r
  local r_squared
  local adjusted_r_squared

  if sst > 0 then
    r = sxy / sqrt(sxx * syy)
    r_squared = 1 - (sse / sst)
    r_squared = clamp_near_zero(r_squared)
    adjusted_r_squared = 1 - ((1 - r_squared) * (n - 1) / degrees_freedom)
  else
    r = nil
    r_squared = nil
    adjusted_r_squared = nil
  end

  local standard_error_slope = sqrt(mse / sxx)
  local standard_error_intercept = sqrt(mse * ((1 / n) + ((mean_x * mean_x) / sxx)))

  local t_slope = divide_or_nil(slope, standard_error_slope)
  local t_intercept = divide_or_nil(intercept, standard_error_intercept)

  local ms_regression = ssr
  local ms_residual = mse
  local f_statistic = divide_or_nil(ms_regression, ms_residual)

  return {
    n = n,
    degrees_freedom = degrees_freedom,

    slope = slope,
    intercept = intercept,
    coefficients = {
      intercept = intercept,
      slope = slope
    },

    mean_x = mean_x,
    mean_y = mean_y,

    r = r,
    r_squared = r_squared,
    adjusted_r_squared = adjusted_r_squared,

    sxx = sxx,
    syy = syy,
    sxy = sxy,

    sst = sst,
    ssr = ssr,
    sse = sse,
    mse = mse,
    rmse = rmse,
    residual_standard_error = residual_standard_error,

    standard_error_slope = standard_error_slope,
    standard_error_intercept = standard_error_intercept,
    t_slope = t_slope,
    t_intercept = t_intercept,

    fitted_values = fitted,
    residuals = residual_values,

    anova = {
      regression = {
        df = 1,
        ss = ssr,
        ms = ms_regression,
        f = f_statistic
      },
      residual = {
        df = degrees_freedom,
        ss = sse,
        ms = ms_residual
      },
      total = {
        df = n - 1,
        ss = sst
      }
    }
  }
end

local function predict(model, x)
  validate_model(model)

  if type(x) == "table" then
    local result = {}

    for i = 1, #x do
      validation.assert_number(x[i], "x value")
      result[i] = model.intercept + model.slope * x[i]
    end

    return result
  end

  validation.assert_number(x, "x")

  return model.intercept + model.slope * x
end

local function fitted_values(model)
  assert(type(model) == "table", "model must be a table")
  assert(type(model.fitted_values) == "table", "model.fitted_values must be a table")

  return core.copy_array(model.fitted_values)
end

local function residuals(model)
  assert(type(model) == "table", "model must be a table")
  assert(type(model.residuals) == "table", "model.residuals must be a table")

  return core.copy_array(model.residuals)
end

M.simple_linear_regression = simple_linear_regression
M.predict = predict
M.fitted_values = fitted_values
M.residuals = residuals

return M
