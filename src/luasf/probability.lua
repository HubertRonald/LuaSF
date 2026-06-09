local module_name = ... or "luasf.probability"
local prefix = module_name:match("^src%.") and "src.luasf." or "luasf."

local validation = require(prefix .. "validation")

local min = math.min

local M = {}

local function factorial(n)
    validation.assert_non_negative_integer(n, "n")

    local result = 1

    for i = 2, n do
      result = result * i
    end

    return result
  end

-- Ordered selections without repetition.
-- Equivalent to nPr = n! / (n - r)!.
-- If r is omitted, this returns n!.
local function permutations(n, r)
    validation.assert_non_negative_integer(n, "n")
    r = r == nil and n or r
    validation.assert_non_negative_integer(r, "r")
    assert(r <= n, "r must be less than or equal to n")

    local result = 1

    for i = n - r + 1, n do
      result = result * i
    end

    return result
  end


-- Ordered selections with repetition.
-- Equivalent to n^r.
local function permutations_with_repetition(n, r)
    validation.assert_non_negative_integer(n, "n")
    validation.assert_non_negative_integer(r, "r")

    return n ^ r
  end

-- Unordered selections without repetition.
-- Equivalent to nCr = n! / (r! * (n - r)!).
local function combinations(n, r)
    validation.assert_non_negative_integer(n, "n")
    validation.assert_non_negative_integer(r, "r")
    assert(r <= n, "r must be less than or equal to n")

    r = min(r, n - r)

    local result = 1

    for i = 1, r do
      result = result * (n - r + i) / i
    end

    return result
  end

-- Unordered selections with repetition.
-- Equivalent to C(n + r - 1, r).
local function combinations_with_repetition(n, r)
    validation.assert_non_negative_integer(n, "n")
    validation.assert_non_negative_integer(r, "r")
    assert(n >= 1, "n must be greater than or equal to 1")

    return combinations(n + r - 1, r)
  end

-- Distinct permutations of a multiset represented by repeated counts.
-- Example: counts {3, 2, 1} -> 6! / (3! * 2! * 1!) = 60.
local function multiset_permutations(counts)
    validation.assert_non_empty_array(counts, "counts")

    local total = 0
    local denominator = 1

    for _, count in ipairs(counts) do
      validation.assert_non_negative_integer(count, "count")
      total = total + count
      denominator = denominator * factorial(count)
    end

    return factorial(total) / denominator
  end

  M.factorial = factorial
  M.permutations = permutations -- without_repetition
  M.combinations = combinations -- without_repetition
  M.permutations_with_repetition = permutations_with_repetition
  M.combinations_with_repetition = combinations_with_repetition
  M.permutations_without_repetition = permutations
  M.combinations_without_repetition = combinations
  M.multiset_permutations = multiset_permutations

  -- Common combinatorics aliases.
  M.nPr = permutations
  M.nCr = combinations



return M