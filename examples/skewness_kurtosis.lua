local stats = require("luasf")

local symmetric_values = {1, 2, 3, 4, 5}
local right_skewed_values = {1, 1, 2, 2, 10}

local function print_shape_summary(label, values)
  print(label)
  print("Skewness:", stats.skewness(values))
  print("Kurtosis:", stats.kurtosis(values))
  print("Excess kurtosis:", stats.excess_kurtosis(values))
  print("")
end

print_shape_summary("Symmetric values", symmetric_values)
print_shape_summary("Right-skewed values", right_skewed_values)
