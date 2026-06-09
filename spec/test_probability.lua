local luaunit = require("luaunit")
local stats = require("luasf")

TestProbability = {}

function TestProbability:test_factorial_zero()
  luaunit.assertEquals(stats.factorial(0), 1)
end

function TestProbability:test_factorial_positive_integer()
  luaunit.assertEquals(stats.factorial(5), 120)
end

function TestProbability:test_factorial_rejects_negative_values()
  luaunit.assertError(function()
    stats.factorial(-1)
  end)
end

function TestProbability:test_factorial_rejects_non_integer_values()
  luaunit.assertError(function()
    stats.factorial(3.5)
  end)
end

function TestProbability:test_permutations_requires_r_less_than_or_equal_to_n()
  luaunit.assertError(function()
    stats.permutations(3, 4)
  end)
end

function TestProbability:test_combinations_requires_r_less_than_or_equal_to_n()
  luaunit.assertError(function()
    stats.combinations(3, 4)
  end)
end

function TestProbability:test_combinations_with_repetition_requires_positive_n()
  luaunit.assertError(function()
    stats.combinations_with_repetition(0, 2)
  end)
end

function TestProbability:test_permutations_without_repetition()
  luaunit.assertEquals(stats.permutations(5, 2), 20)
end

function TestProbability:test_permutations_without_repetition_all_items()
  luaunit.assertEquals(stats.permutations(5, 5), 120)
end

function TestProbability:test_combinations_without_repetition()
  luaunit.assertEquals(stats.combinations(5, 2), 10)
  luaunit.assertEquals(stats.combinations_without_repetition(5, 2), 10)
  luaunit.assertEquals(stats.combinations(5, 0), 1)
  luaunit.assertEquals(stats.combinations(5, 5), 1)
end

function TestProbability:test_permutations_without_repetition_zero_selected()
  luaunit.assertEquals(stats.permutations(5, 0), 1)
end

function TestProbability:test_permutations_without_repetition_rejects_r_greater_than_n()
  luaunit.assertError(function()
    stats.permutations(3, 4)
  end)
end

function TestProbability:test_combinations_without_repetition_symmetric_case()
  luaunit.assertEquals(stats.combinations(10, 3), 120)
  luaunit.assertEquals(stats.combinations(10, 7), 120)
end

function TestProbability:test_combinations_without_repetition_zero_selected()
  luaunit.assertEquals(stats.combinations(5, 0), 1)
end

function TestProbability:test_combinations_without_repetition_all_items()
  luaunit.assertEquals(stats.combinations(5, 5), 1)
end

function TestProbability:test_combinations_without_repetition_rejects_r_greater_than_n()
  luaunit.assertError(function()
    stats.combinations(3, 4)
  end)
end

function TestProbability:test_permutations_with_repetition()
  luaunit.assertEquals(stats.permutations_with_repetition(4, 3), 64)
end

function TestProbability:test_permutations_with_repetition_zero_selected()
  luaunit.assertEquals(stats.permutations_with_repetition(4, 0), 1)
end

function TestProbability:test_permutations_with_repetition_empty_set_zero_selected()
  luaunit.assertEquals(stats.permutations_with_repetition(0, 0), 1)
end

function TestProbability:test_permutations_with_repetition_empty_set_positive_selection()
  luaunit.assertEquals(stats.permutations_with_repetition(0, 3), 0)
end

function TestProbability:test_combinations_with_repetition()
  luaunit.assertEquals(stats.combinations_with_repetition(5, 3), 35)
end

function TestProbability:test_combinations_with_repetition_zero_selected()
  luaunit.assertEquals(stats.combinations_with_repetition(4, 0), 1)
end

function TestProbability:test_combinations_with_repetition_single_item()
  luaunit.assertEquals(stats.combinations_with_repetition(1, 5), 1)
end

function TestProbability:test_combinations_with_repetition_rejects_zero_items()
  luaunit.assertError(function()
    stats.combinations_with_repetition(0, 2)
  end)
end

function TestProbability:test_multiset_permutations()
  luaunit.assertEquals(stats.multiset_permutations({3, 2, 1}), 60)
  luaunit.assertEquals(stats.multiset_permutations({2, 2}), 6)
end

function TestProbability:test_nPr_alias()
  luaunit.assertEquals(stats.nPr(5, 2), 20)
end

function TestProbability:test_nCr_alias()
  luaunit.assertEquals(stats.nCr(5, 2), 10)
end

os.exit(luaunit.LuaUnit.run())
