local M = {}

local floor = math.floor

function M.assert_number(value, name)
  name = name or "value"
  assert(type(value) == "number", name .. " must be a number")
end

function M.assert_probability(p, name)
  name = name or "p"
  M.assert_number(p, name)
  assert(p >= 0 and p <= 1, name .. " must be between 0 and 1")
end

function M.assert_non_empty_array(array, name)
  name = name or "array"
  assert(type(array) == "table", name .. " must be a table")
  assert(#array > 0, name .. " must not be empty")
end

function M.assert_min_length(array, minimum, name)
  name = name or "array"
  M.assert_non_empty_array(array, name)
  assert(#array >= minimum, name .. " must contain at least " .. minimum .. " values")
end

function M.assert_numeric_array(array, name)
  name = name or "array"
  M.assert_non_empty_array(array, name)

  for _, value in ipairs(array) do
    M.assert_number(value, name .. " value")
  end
end

function M.assert_same_length_arrays(x, y, x_name, y_name)
  x_name = x_name or "x"
  y_name = y_name or "y"

  M.assert_non_empty_array(x, x_name)
  M.assert_non_empty_array(y, y_name)

  assert(#x == #y, x_name .. " and " .. y_name .. " must have the same length")
end

function M.assert_same_length_numeric_arrays(x, y, x_name, y_name)
  x_name = x_name or "x"
  y_name = y_name or "y"

  M.assert_same_length_arrays(x, y, x_name, y_name)
  M.assert_numeric_array(x, x_name)
  M.assert_numeric_array(y, y_name)
end

function M.assert_integer(value, name)
  name = name or "value"
  M.assert_number(value, name)
  assert(value == floor(value), name .. " must be an integer")
end

function M.assert_non_negative_integer(value, name)
  M.assert_integer(value, name)
  assert(value >= 0, name .. " must be greater than or equal to 0")
end

function M.assert_positive_integer(value, name)
  M.assert_integer(value, name)
  assert(value >= 1, name .. " must be greater than or equal to 1")
end

return M