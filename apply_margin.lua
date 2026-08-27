#!/usr/bin/env luajit
local a, b = arg[1], arg[2]

local file = io.open(b, "w")
assert(file, "Couldn't open \"" .. b .. "\"")

for line in io.lines(a) do
  if not (line:sub(3, 3) == ":") then
    file:write(string.rep(" ", 6))
  end

  file:write(line)
  file:write("\n")
end

file:close()
