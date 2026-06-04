local stats = require("luasf")

local trials = 100000
local inside = 0

for _ = 1, trials do
  local x = stats.uniform(-1, 1)
  local y = stats.uniform(-1, 1)

  if x * x + y * y <= 1 then
    inside = inside + 1
  end
end

local pi_estimate = 4 * inside / trials

print("Pi estimate:", pi_estimate)