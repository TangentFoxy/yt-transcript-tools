#!/usr/bin/env luajit
local input_file_name, output_file_name = arg[1], arg[2]
assert(input_file_name and output_file_name,
  "You must enter an input file and output file."
  .. "(This is for the intermediate file before an EPUB is output.)")

print("Author (YouTube channel): ")
local author = io.read("*line")
print("Link (paste the video URL): ")
local link = io.read("*line")

local title = input_file_name:sub(1, -5)   -- assumes .txt extension

local output_file = io.open(output_file_name, "w")
assert(output_file, "Could not open \"" .. output_file_name .. "\"")

for _, line in ipairs{
  "---",
  "title: \"" .. title .. "\"",
  "author: \"" .. author .. "\"",
  "publisher: \"yt-transcript-tools v0.1\"",
  "---",
  "",
  "From [" .. link .. "](" .. link .. ")",
  "",
} do
  output_file:write(line)
  output_file:write("\n")
end

for line in io.lines(input_file_name) do
  output_file:write("`") -- make this line a code block on its own

  -- if not appearing to start with a timecode,
  -- indent by the width of a timecode
  if not (line:sub(3, 3) == ":") then
    output_file:write(string.rep(" ", 6))
  end

  output_file:write(line)
  output_file:write("`") -- close the code block
  output_file:write("\n")
end

output_file:close()
