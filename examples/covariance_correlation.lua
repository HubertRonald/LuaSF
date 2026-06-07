local stats = require("luasf")

local study_hours = {1, 2, 3, 4, 5}
local exam_scores = {50, 55, 65, 70, 80}

local cov = stats.covariance(study_hours, exam_scores)
local corr = stats.correlation(study_hours, exam_scores)

print("Study hours and exam scores")
print("Covariance:", cov)
print("Correlation:", corr)

if corr > 0 then
  print("Interpretation: positive relationship")
elseif corr < 0 then
  print("Interpretation: negative relationship")
else
  print("Interpretation: no linear relationship")
end