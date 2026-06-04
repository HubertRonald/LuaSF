local stats = require("src.luasf")

local alpha = 0.05

print("Lower limit:", stats.normal_inv_D(alpha / 2))
print("Upper limit:", stats.normal_inv_D(1 - alpha / 2))
