#!/usr/bin/env luajit
local input_file_name = arg[1]
assert(input_file_name,
  "You must enter an input file (its name will be the title).")

print("Author (YouTube channel): ")
local author = io.read("*line")
print("Link (paste the video URL; optional): ")
local link = io.read("*line")

local title = input_file_name:sub(1, -5)   -- assumes .txt extension
local output_file_name = title .. ".md"

local output_file = io.open(output_file_name, "w")
assert(output_file, "Could not open \"" .. output_file_name .. "\"")

local frontmatter = {
  "---",
  "title: \"" .. title .. "\"",
  "author: \"" .. author .. "\"",
  "publisher: \"yt-transcript-tools v0.1\"",
  "---",
  "",
}

if link and #link > 0 then
  frontmatter[#frontmatter + 1] = "From [" .. link .. "](" .. link .. ")\n"
end

for _, line in ipairs(frontmatter) do
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

os.execute("pandoc --from markdown+hard_line_breaks \""
  .. output_file_name .. "\" -o \"" .. title .. ".epub\"")
