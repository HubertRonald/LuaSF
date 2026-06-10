local luaunit = require("luaunit")
local stats = require("luasf")

TestStudentT = {}

function TestStudentT:tearDown()
  stats.reset_rng()
end

function TestStudentT:test_student_t_returns_number()
  stats.seed(1234)

  local value = stats.student_t(5)

  luaunit.assertEquals(type(value), "number")
end

function TestStudentT:test_student_t_legacy_name_returns_number()
  stats.seed(1234)

  local value = stats.studentTVA(5)

  luaunit.assertEquals(type(value), "number")
end

function TestStudentT:test_t_student_alias_returns_number()
  stats.seed(1234)

  local value = stats.t_student(5)

  luaunit.assertEquals(type(value), "number")
end

function TestStudentT:test_student_t_rejects_zero_degrees_of_freedom()
  luaunit.assertError(function()
    stats.student_t(0)
  end)
end

function TestStudentT:test_student_t_rejects_non_integer_degrees_of_freedom()
  luaunit.assertError(function()
    stats.student_t(2.5)
  end)
end

os.exit(luaunit.LuaUnit.run())
