package = "luasf"
version = "0.2.0-1"

source = {
  url = "git://github.com/HubertRonald/LuaSF.git",
  tag = "v0.2.0"
}

description = {
  summary = "Lua Statistics Functions",
  detailed = [[
LuaSF is a lightweight, pure-Lua library for basic descriptive statistics
and random variable generation.
  ]],
  homepage = "https://github.com/HubertRonald/LuaSF",
  license = "MIT",
  maintainer = "Hubert Ronald"
}

dependencies = {
  "lua >= 5.1"
}

build = {
  type = "builtin",
  modules = {
    luasf = "src/luasf.lua",
    LuaSF = "LuaSF.lua",
    LuaStat = "LuaStat.lua"
  }
}