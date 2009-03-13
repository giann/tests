print('testing scanner')

local function dostring (x) return assert(loadstring(x))() end

dostring("x = 'a\0a'")
assert(x == 'a\0a' and string.len(x) == 3)

-- escape sequences
assert('\n\"\'\\' == [[

"'\]])

assert(string.find("\a\b\f\n\r\t\v", "^%c%c%c%c%c%c%c$"))

-- assume ASCII just for tests:
assert("\09912" == 'c12')
assert("\99ab" == 'cab')
assert("\099" == '\99')
assert("\099\n" == 'c\10')
assert('\0\0\0alo' == '\0' .. '\0\0' .. 'alo')

assert(010 .. 020 .. -030 == "1020-30")

-- valid characters in variable names
for i = 0, 255 do
  local s = string.char(i)
  assert(not string.find(s, "[a-zA-Z_]") == not loadstring(s .. "=1"))
  assert(not string.find(s, "[a-zA-Z_0-9]") ==
         not loadstring("a" .. s .. "1 = 1"))
end


-- long variable names

var = string.rep('a', 15000)
prog = string.format("%s = 5", var)
dostring(prog)
assert(_G[var] == 5)
var = nil
print('+')

-- escapes --
assert("\n\t" == [[

	]])
assert([[

 $debug]] == "\n $debug")
assert([[ [ ]] ~= [[ ] ]])
-- long strings --
b = "001234567890123456789012345678901234567891234567890123456789012345678901234567890012345678901234567890123456789012345678912345678901234567890123456789012345678900123456789012345678901234567890123456789123456789012345678901234567890123456789001234567890123456789012345678901234567891234567890123456789012345678901234567890012345678901234567890123456789012345678912345678901234567890123456789012345678900123456789012345678901234567890123456789123456789012345678901234567890123456789001234567890123456789012345678901234567891234567890123456789012345678901234567890012345678901234567890123456789012345678912345678901234567890123456789012345678900123456789012345678901234567890123456789123456789012345678901234567890123456789001234567890123456789012345678901234567891234567890123456789012345678901234567890012345678901234567890123456789012345678912345678901234567890123456789012345678900123456789012345678901234567890123456789123456789012345678901234567890123456789"
assert(string.len(b) == 960)
prog = [=[
print('+')

a1 = [["isto e' um string com v�rias 'aspas'"]]
a2 = "'aspas'"

assert(string.find(a1, a2) == 31)
print('+')

a1 = [==[temp = [[um valor qualquer]]; ]==]
assert(loadstring(a1))()
assert(temp == 'um valor qualquer')
-- long strings --
b = "001234567890123456789012345678901234567891234567890123456789012345678901234567890012345678901234567890123456789012345678912345678901234567890123456789012345678900123456789012345678901234567890123456789123456789012345678901234567890123456789001234567890123456789012345678901234567891234567890123456789012345678901234567890012345678901234567890123456789012345678912345678901234567890123456789012345678900123456789012345678901234567890123456789123456789012345678901234567890123456789001234567890123456789012345678901234567891234567890123456789012345678901234567890012345678901234567890123456789012345678912345678901234567890123456789012345678900123456789012345678901234567890123456789123456789012345678901234567890123456789001234567890123456789012345678901234567891234567890123456789012345678901234567890012345678901234567890123456789012345678912345678901234567890123456789012345678900123456789012345678901234567890123456789123456789012345678901234567890123456789"
assert(string.len(b) == 960)
print('+')

a = [[00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
00123456789012345678901234567890123456789123456789012345678901234567890123456789
]]
assert(string.len(a) == 1863)
assert(string.sub(a, 1, 40) == string.sub(b, 1, 40))
x = 1
]=]

print('+')
x = nil
dostring(prog)
assert(x)

prog = nil
a = nil
b = nil


-- testing line ends
prog = [[
a = 1        -- a comment
b = 2


x = [=[
hi
]=]
y = "\
hello\r\n\
"
return debug.getinfo(1).currentline
]]

for _, n in pairs{"\n", "\r", "\n\r", "\r\n"} do
  local prog, nn = string.gsub(prog, "\n", n)
  assert(dostring(prog) == nn)
  assert(_G.x == "hi\n" and _G.y == "\nhello\r\n\n")
end


-- testing comments and strings with long brackets
a = [==[]=]==]
assert(a == "]=")

a = [==[[===[[=[]]=][====[]]===]===]==]
assert(a == "[===[[=[]]=][====[]]===]===")

a = [====[[===[[=[]]=][====[]]===]===]====]
assert(a == "[===[[=[]]=][====[]]===]===")

a = [=[]]]]]]]]]=]
assert(a == "]]]]]]]]")


--[===[
x y z [==[ blu foo
]==
]
]=]==]
error error]=]===]

-- generate all strings of four of these chars
local x = {"=", "[", "]", "\n"}
local len = 4
local function gen (c, n)
  if n==0 then coroutine.yield(c)
  else
    for _, a in pairs(x) do
      gen(c..a, n-1)
    end
  end
end

for s in coroutine.wrap(function () gen("", len) end) do
  assert(s == loadstring("return [====[\n"..s.."]====]")())
end


-- testing decimal point locale
if os.setlocale("pt_BR") or os.setlocale("ptb") then
  assert(tonumber("3,4") == 3.4 and tonumber"3.4" == nil)
  assert(assert(loadstring("return 3.4"))() == 3.4)
  assert(assert(loadstring("return .4,3"))() == .4)
  assert(assert(loadstring("return 4."))() == 4.)
  assert(assert(loadstring("return 4.+.5"))() == 4.5)
  local a,b = loadstring("return 4.5.")
  assert(string.find(b, "'4%.5%.'"))
  assert(os.setlocale("C"))
else
  (Message or print)(
   '\a\n >>> pt_BR locale not available: skipping decimal point tests <<<\n\a')
end


-- testing %q x line ends
local s = "a string with \r and \n and \r\n and \n\r"
local c = string.format("return %q", s)
assert(assert(loadstring(c))() == s)

-- testing errors
assert(not loadstring"a = 'non-ending string")
assert(not loadstring"a = 'non-ending string\n'")
assert(not loadstring"a = '\\345'")
assert(not loadstring"a = [=x]")

print('OK')
