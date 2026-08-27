#!/usr/bin/env luajit
local a, b = arg[1], arg[2]

local file = io.open(b, "w")
assert(file, "Couldn't open \"" .. b .. "\"")

for line in io.lines(a) do
  file:write("`")
  file:write(line)
  file:write("`")
  file:write("\n")
end

file:close()
