local luaunit = require("luaunit")
local stats = require("luasf")

TestDistributions = {}

function TestDistributions:test_rand_integer_range()
  local value = stats.rand(1, 6)
  luaunit.assertTrue(value >= 1)
  luaunit.assertTrue(value <= 6)
end

function TestDistributions:test_bernoulli_range()
  local value = stats.bernoulliVA(0.5)
  luaunit.assertTrue(value == 0 or value == 1)
end

function TestDistributions:test_uniform_range()
  local value = stats.unifVA(10, 20)
  luaunit.assertTrue(value >= 10)
  luaunit.assertTrue(value <= 20)
end

function TestDistributions:test_binomial_range()
  local value = stats.binomialVA(10, 0.5)
  luaunit.assertTrue(value >= 0)
  luaunit.assertTrue(value <= 10)
end

function TestDistributions:test_geometric_is_non_negative()
  local value = stats.geometricVA(0.5)
  luaunit.assertTrue(value >= 0)
end

function TestDistributions:test_poisson_is_non_negative()
  local value = stats.poissonVA(2)
  luaunit.assertTrue(value >= 0)
end

function TestDistributions:test_chi_square_is_non_negative()
  local value = stats.chiSquareVA(3)
  luaunit.assertTrue(value >= 0)
end

function TestDistributions:test_gamma_is_positive()
  local value = stats.gamVA(2, 1)
  luaunit.assertTrue(value > 0)
end

function TestDistributions:test_lognormal_is_positive()
  local value = stats.lognoRandVA(1, 0.25)
  luaunit.assertTrue(value > 0)
end

function TestDistributions:test_legacy_typo_aliases_exist()
  luaunit.assertEquals(type(stats.nomalVA), "function")
  luaunit.assertEquals(type(stats.normalVA), "function")
  luaunit.assertEquals(type(stats.lognoRandVA), "function")
  luaunit.assertEquals(type(stats.lognoVA), "function")
end

os.exit(luaunit.LuaUnit.run())
