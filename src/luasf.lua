--[[
LuaSF : Lua Statistics Functions

A lightweight, pure-Lua library for basic statistics and random variables.

MIT License

Copyright (c) 2017 Hubert Ronald

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files, to deal in the Software
without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, subject to the conditions in the LICENSE file.


Public facade module.

This file keeps the public LuaSF API stable while delegating implementation
to smaller internal modules under src/luasf/.
]]

local module_name = ... or "luasf"
local prefix = module_name:match("^src%.") and "src.luasf." or "luasf."

local function merge(target, source)
  for key, value in pairs(source) do
    target[key] = value
  end
end

local M = {}

merge(M, require(prefix .. "rng"))
merge(M, require(prefix .. "core"))
merge(M, require(prefix .. "descriptive"))
merge(M, require(prefix .. "shape"))
merge(M, require(prefix .. "sampling"))
merge(M, require(prefix .. "distributions"))
merge(M, require(prefix .. "bivariate"))
merge(M, require(prefix .. "probability"))

return M
