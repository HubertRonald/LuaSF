local luaunit = require("luaunit")
local stats = require("luasf")

TestSampling = {}

function TestSampling:test_choice_returns_item_from_array()
  stats.seed(123)

  local items = {"a", "b", "c"}
  local value = stats.choice(items)

  luaunit.assertTrue(value == "a" or value == "b" or value == "c")
end

function TestSampling:test_shuffle_preserves_length()
  stats.seed(123)

  local items = {1, 2, 3, 4}
  local shuffled = stats.shuffle(items)

  luaunit.assertEquals(#shuffled, #items)
end

function TestSampling:test_shuffle_does_not_modify_original_array()
  stats.seed(123)

  local items = {1, 2, 3, 4}
  stats.shuffle(items)

  luaunit.assertEquals(items[1], 1)
  luaunit.assertEquals(items[2], 2)
  luaunit.assertEquals(items[3], 3)
  luaunit.assertEquals(items[4], 4)
end

function TestSampling:test_sample_returns_requested_size()
  stats.seed(123)

  local items = {1, 2, 3, 4, 5}
  local result = stats.sample(items, 3)

  luaunit.assertEquals(#result, 3)
end

function TestSampling:test_weighted_choice_returns_item()
  stats.seed(123)

  local items = {"low", "medium", "high"}
  local weights = {1, 2, 7}

  local value = stats.weighted_choice(items, weights)

  luaunit.assertTrue(value == "low" or value == "medium" or value == "high")
end

function TestSampling:test_custom_rng()
  stats.set_rng(function()
    return 0.0
  end)

  local value = stats.choice({"first", "second", "third"})

  luaunit.assertEquals(value, "first")

  stats.reset_rng()
end

os.exit(luaunit.LuaUnit.run())
