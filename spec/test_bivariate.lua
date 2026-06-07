local luaunit = require("luaunit")
local stats = require("src.luasf")

TestBivariate = {}

function TestBivariate:test_covariance_positive_relationship()
  local x = {1, 2, 3, 4, 5}
  local y = {2, 4, 6, 8, 10}

  luaunit.assertAlmostEquals(stats.covariance(x, y), 5, 0.000001)
end

function TestBivariate:test_correlation_positive_relationship()
  local x = {1, 2, 3, 4, 5}
  local y = {2, 4, 6, 8, 10}

  luaunit.assertAlmostEquals(stats.correlation(x, y), 1, 0.000001)
end

function TestBivariate:test_correlation_negative_relationship()
  local x = {1, 2, 3, 4, 5}
  local y = {10, 8, 6, 4, 2}

  luaunit.assertAlmostEquals(stats.correlation(x, y), -1, 0.000001)
end

function TestBivariate:test_pearson_alias()
  local x = {1, 2, 3, 4, 5}
  local y = {2, 4, 6, 8, 10}

  luaunit.assertAlmostEquals(stats.pearson(x, y), 1, 0.000001)
end

function TestBivariate:test_covariance_requires_same_length()
  luaunit.assertError(function()
    stats.covariance({1, 2, 3}, {1, 2})
  end)
end

function TestBivariate:test_correlation_requires_non_constant_x()
  luaunit.assertError(function()
    stats.correlation({1, 1, 1}, {1, 2, 3})
  end)
end

function TestBivariate:test_correlation_requires_non_constant_y()
  luaunit.assertError(function()
    stats.correlation({1, 2, 3}, {1, 1, 1})
  end)
end

os.exit(luaunit.LuaUnit.run())