local luaunit = require("luaunit")
local stats = require("luasf")

TestShape = {}

function TestShape:test_skewness_symmetric_data()
  local values = {1, 2, 3, 4, 5}

  luaunit.assertAlmostEquals(stats.skewness(values), 0, 0.000001)
end

function TestShape:test_skewness_positive_data()
  local values = {1, 1, 2, 2, 10}

  luaunit.assertTrue(stats.skewness(values) > 0)
end

function TestShape:test_skewness_negative_data()
  local values = {1, 9, 10, 10, 10}

  luaunit.assertTrue(stats.skewness(values) < 0)
end

function TestShape:test_kurtosis_for_simple_sequence()
  local values = {1, 2, 3, 4, 5}

  luaunit.assertAlmostEquals(stats.kurtosis(values), 1.7, 0.000001)
end

function TestShape:test_excess_kurtosis_for_simple_sequence()
  local values = {1, 2, 3, 4, 5}

  luaunit.assertAlmostEquals(stats.excess_kurtosis(values), -1.3, 0.000001)
end

function TestShape:test_central_moment_second_order()
  local values = {1, 2, 3, 4, 5}

  luaunit.assertAlmostEquals(stats.central_moment(values, 2), 2, 0.000001)
end

function TestShape:test_skewness_requires_non_constant_array()
  luaunit.assertError(function()
    stats.skewness({1, 1, 1})
  end)
end

function TestShape:test_kurtosis_requires_non_constant_array()
  luaunit.assertError(function()
    stats.kurtosis({1, 1, 1})
  end)
end

os.exit(luaunit.LuaUnit.run())
