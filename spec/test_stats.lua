local luaunit = require("luaunit")
local stats = require("src.luasf")

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

os.exit(luaunit.LuaUnit.run())
