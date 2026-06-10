local stats = require("luasf")

local degrees_of_freedom = 10
local draws = {}

for i = 1, 10 do
  draws[i] = stats.student_t(degrees_of_freedom)
end

print("Student's t random values")
print("Degrees of freedom:", degrees_of_freedom)

for i = 1, #draws do
  print(i, draws[i])
end
