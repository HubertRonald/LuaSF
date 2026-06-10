local stats = require("luasf")

local study_hours = {1, 2, 3, 4, 5, 6}
local exam_scores = {52, 55, 61, 66, 72, 75}

local model = stats.simple_linear_regression(study_hours, exam_scores)
local prediction = stats.predict(model, 7)

print("Simple linear regression example")
print("Formula: y = intercept + slope * x")
print("Intercept:", model.intercept)
print("Slope:", model.slope)
print("R:", model.r)
print("R squared:", model.r_squared)
print("Adjusted R squared:", model.adjusted_r_squared)
print("SSE:", model.sse)
print("SSR:", model.ssr)
print("SST:", model.sst)
print("MSE:", model.mse)
print("RMSE:", model.rmse)
print("Residual standard error:", model.residual_standard_error)
print("Standard error slope:", model.standard_error_slope)
print("Standard error intercept:", model.standard_error_intercept)
print("T slope:", model.t_slope)
print("T intercept:", model.t_intercept)
print("ANOVA F statistic:", model.anova.regression.f)
print("Prediction for 7 study hours:", prediction)
