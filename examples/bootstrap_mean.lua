local stats = require("luasf")

local values = {10, 12, 14, 15, 18, 20}
local bootstrap_means = {}
local bootstrap_runs = 1000

for run = 1, bootstrap_runs do
  local sample = {}

  for i = 1, #values do
    sample[i] = stats.choice(values)
  end

  bootstrap_means[run] = stats.mean(sample)
end

local result = stats.summary(bootstrap_means)

print("Bootstrap mean summary")
print("Count:", result.count)
print("Min:", result.min)
print("Max:", result.max)
print("Mean:", result.mean)
print("Median:", result.median)
print("Stddev:", result.stddev)