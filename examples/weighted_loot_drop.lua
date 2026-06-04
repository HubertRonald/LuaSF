local stats = require("luasf")

local items = {"common", "rare", "epic", "legendary"}
local weights = {80, 15, 4, 1}

local drops = {}

for i = 1, 1000 do
  drops[i] = stats.weighted_choice(items, weights)
end

local frequencies = stats.frequency(drops)

for i = 1, #frequencies.values do
  print(frequencies.values[i], frequencies.counts[i])
end