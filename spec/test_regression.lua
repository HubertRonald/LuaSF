local luaunit = require("luaunit")
local stats = require("luasf")

TestRegression = {}

function TestRegression:test_simple_linear_regression_perfect_line()
  local x = {1, 2, 3, 4, 5}
  local y = {2, 4, 6, 8, 10}

  local model = stats.simple_linear_regression(x, y)

  luaunit.assertAlmostEquals(model.slope, 2, 0.000001)
  luaunit.assertAlmostEquals(model.intercept, 0, 0.000001)
  luaunit.assertAlmostEquals(model.r, 1, 0.000001)
  luaunit.assertAlmostEquals(model.r_squared, 1, 0.000001)
  luaunit.assertAlmostEquals(model.sse, 0, 0.000001)
  luaunit.assertAlmostEquals(model.ssr, 40, 0.000001)
  luaunit.assertAlmostEquals(model.sst, 40, 0.000001)
  luaunit.assertEquals(model.n, 5)
  luaunit.assertEquals(model.degrees_freedom, 3)
end

function TestRegression:test_simple_linear_regression_with_intercept()
  local x = {1, 2, 3, 4, 5}
  local y = {3, 5, 7, 9, 11}

  local model = stats.simple_linear_regression(x, y)

  luaunit.assertAlmostEquals(model.slope, 2, 0.000001)
  luaunit.assertAlmostEquals(model.intercept, 1, 0.000001)
  luaunit.assertAlmostEquals(stats.predict(model, 6), 13, 0.000001)
end

function TestRegression:test_predict_accepts_array()
  local x = {1, 2, 3, 4, 5}
  local y = {3, 5, 7, 9, 11}

  local model = stats.simple_linear_regression(x, y)
  local predictions = stats.predict(model, {6, 7})

  luaunit.assertAlmostEquals(predictions[1], 13, 0.000001)
  luaunit.assertAlmostEquals(predictions[2], 15, 0.000001)
end

function TestRegression:test_non_perfect_regression_summary()
  local x = {1, 2, 3, 4, 5}
  local y = {2, 5, 5, 9, 10}

  local model = stats.simple_linear_regression(x, y)
  local fitted = stats.fitted_values(model)
  local residuals = stats.residuals(model)

  luaunit.assertEquals(#fitted, 5)
  luaunit.assertEquals(#residuals, 5)
  luaunit.assertTrue(model.r_squared > 0)
  luaunit.assertTrue(model.r_squared <= 1)
  luaunit.assertTrue(model.mse >= 0)
  luaunit.assertTrue(model.rmse >= 0)
  luaunit.assertEquals(model.anova.regression.df, 1)
  luaunit.assertEquals(model.anova.residual.df, 3)
  luaunit.assertEquals(model.anova.total.df, 4)
end

function TestRegression:test_requires_same_length_arrays()
  luaunit.assertError(function()
    stats.simple_linear_regression({1, 2, 3}, {1, 2})
  end)
end

function TestRegression:test_requires_at_least_three_values()
  luaunit.assertError(function()
    stats.simple_linear_regression({1, 2}, {2, 4})
  end)
end

function TestRegression:test_rejects_constant_x_values()
  luaunit.assertError(function()
    stats.simple_linear_regression({1, 1, 1}, {2, 3, 4})
  end)
end

function TestRegression:test_rejects_non_numeric_values()
  luaunit.assertError(function()
    stats.simple_linear_regression({1, 2, "x"}, {2, 4, 6})
  end)
end

os.exit(luaunit.LuaUnit.run())
