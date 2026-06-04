local stats = require("luasf")

local flips = 10
local probability_heads = 0.5
local experiments = 20

for i = 1, experiments do
  local heads = stats.binomial(flips, probability_heads)
  print("Experiment:", i, "Heads:", heads)
end