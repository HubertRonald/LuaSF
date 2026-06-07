local module_name = ... or "luasf.core"
local prefix = module_name:match("^src%.") and "src.luasf." or "luasf."

local validation = require(prefix .. "validation")

local M = {}

function M.copy_array(array)
  validation.assert_non_empty_array(array)

  local copied = {}

  for i = 1, #array do
    copied[i] = array[i]
  end

  return copied
end

function M.copy_table(source)
  assert(type(source) == "table", "source must be a table")

  local copied = {}

  for key, value in pairs(source) do
    copied[key] = value
  end

  return copied
end

return M