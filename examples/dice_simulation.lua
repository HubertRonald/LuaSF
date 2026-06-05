local stats = require("luasf")

local rolls = {}

for i = 1, 10000 do
  rolls[i] = stats.rand(1, 6) + stats.rand(1, 6)
end

local frequencies = stats.frecuencyF(rolls)

for i = 1, #frequencies.c do
  print("Sum:", frequencies.g[i], "Frequency:", frequencies.c[i])
end