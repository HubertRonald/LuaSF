local stats = require("luasf")

local lambda = 3
local periods = 20

for period = 1, periods do
  local arrivals = stats.poisson(lambda)
  print("Period:", period, "Arrivals:", arrivals)
end