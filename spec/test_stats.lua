local luaunit = require("luaunit")
local stats = require("luasf")

TestStats = {}

function TestStats:test_sum_legacy_name()
  luaunit.assertEquals(stats.sumF({1, 2, 3}), 6)
end

function TestStats:test_sum_modern_alias()
  luaunit.assertEquals(stats.sum({1, 2, 3}), 6)
end

function TestStats:test_mean_legacy_name()
  luaunit.assertEquals(stats.avF({2, 4, 6}), 4)
end

function TestStats:test_mean_modern_alias()
  luaunit.assertEquals(stats.mean({2, 4, 6}), 4)
end

function TestStats:test_sample_standard_deviation()
  local result = stats.stvF({2, 4, 6})
  luaunit.assertAlmostEquals(result, 2, 0.000001)
end

function TestStats:test_frequency_legacy_and_modern_fields()
  local freq = stats.frecuencyF({2, 1, 2, 3, 3, 3})

  luaunit.assertEquals(freq.g[1], 1)
  luaunit.assertEquals(freq.c[1], 1)

  luaunit.assertEquals(freq.g[2], 2)
  luaunit.assertEquals(freq.c[2], 2)

  luaunit.assertEquals(freq.g[3], 3)
  luaunit.assertEquals(freq.c[3], 3)

  luaunit.assertEquals(freq.values[3], 3)
  luaunit.assertEquals(freq.counts[3], 3)
end

function TestStats:test_module_entry_points()
  local luasf_root = require("LuaSF")
  local luastat_root = require("LuaStat")
  local luasf_src = require("src.luasf")

  luaunit.assertEquals(type(luasf_root), "table")
  luaunit.assertEquals(type(luastat_root), "table")
  luaunit.assertEquals(type(luasf_src), "table")
end

function TestStats:test_variance()
  luaunit.assertAlmostEquals(stats.variance({2, 4, 6}), 4, 0.000001)
end

function TestStats:test_median_odd_length()
  luaunit.assertEquals(stats.median({3, 1, 2}), 2)
end

function TestStats:test_median_even_length()
  luaunit.assertEquals(stats.median({4, 1, 2, 3}), 2.5)
end

function TestStats:test_min()
  luaunit.assertEquals(stats.min({3, 1, 2}), 1)
end

function TestStats:test_max()
  luaunit.assertEquals(stats.max({3, 1, 2}), 3)
end

function TestStats:test_quantile()
  luaunit.assertEquals(stats.quantile({1, 2, 3, 4, 5}, 0.5), 3)
end

function TestStats:test_mode()
  luaunit.assertEquals(stats.mode({1, 2, 2, 3}), 2)
end

function TestStats:test_range()
  luaunit.assertEquals(stats.range({3, 1, 10, 2}), 9)
end

function TestStats:test_iqr()
  luaunit.assertEquals(stats.iqr({1, 2, 3, 4, 5}), 2)
end

function TestStats:test_percentile()
  luaunit.assertEquals(stats.percentile({1, 2, 3, 4, 5}, 50), 3)
end

function TestStats:test_summary()
  local result = stats.summary({1, 2, 3, 4, 5})

  luaunit.assertEquals(result.count, 5)
  luaunit.assertEquals(result.min, 1)
  luaunit.assertEquals(result.max, 5)
  luaunit.assertEquals(result.mean, 3)
  luaunit.assertEquals(result.median, 3)
  luaunit.assertAlmostEquals(result.variance, 2.5, 0.000001)
end

os.exit(luaunit.LuaUnit.run())
