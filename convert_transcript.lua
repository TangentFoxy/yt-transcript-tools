#!/usr/bin/env luajit
local version = "0.4.0"

local input_file_name = arg[1]
assert(input_file_name,
  "You must enter an input file (its name will be the title).")

print("Author (YouTube channel): ")
local author = io.read("*line")
print("Link (paste the video URL; optional): ")
local link = io.read("*line")

local title = input_file_name:sub(1, -5)   -- assumes .txt extension
local output_file_name = title .. ".md"

local frontmatter = {
  "---",
  "title: \"" .. title .. "\"",
  "author: \"" .. author .. "\"",
  "publisher: \"yt-transcript-tools v" .. version .. "\"",
  "---",
  "",
}

if link and #link > 0 then
  frontmatter[#frontmatter + 1] = "From [" .. link .. "](" .. link .. ")\n"
end

local input_lines = {}
for line in io.lines(input_file_name) do
  input_lines[#input_lines + 1] = line
end

local output_lines = {}
local timecode_free_lines = {}

if arg[2] == "--tube" then   -- transcript from https://tubetranscript.com/
  for i = 4, #input_lines do
    local line = input_lines[i]
    output_lines[#output_lines + 1] = line

    line = line:sub(9)
    if line:sub(1, 1) == ")" then   -- handle very long videos
      line = line:sub(3)
    end
    timecode_free_lines[#timecode_free_lines + 1] = line
  end
else
  for index, line in ipairs(input_lines) do
    if not (line:sub(3, 3) == ":") then
      local previous_line = input_lines[index - 1]
      if previous_line and previous_line:sub(3, 3) == ":" then
        output_lines[#output_lines] = "```\n" .. previous_line
        output_lines[#output_lines + 1] = string.rep(" ", 6) .. line .. "\n```"
      else
        output_lines[#output_lines + 1] = "`" .. string.rep(" ", 6) .. line .. "`"   -- pandoc will ignore this margin
      end
      timecode_free_lines[#timecode_free_lines + 1] = line
    else
      output_lines[#output_lines + 1] = "`" .. line .. "`"
      timecode_free_lines[#timecode_free_lines + 1] = line:sub(7)
    end
  end
end

local output_file = io.open(output_file_name, "w")
assert(output_file, "Could not open \"" .. output_file_name .. "\"")

output_file:write(table.concat(frontmatter, "\n"))
output_file:write("\n")

output_file:write("# Raw Transcript\n\n")
output_file:write(table.concat(timecode_free_lines, "\n"))
output_file:write("\n\n")

output_file:write("# Timecoded Transcript\n\n")
output_file:write(table.concat(output_lines, "\n"))
output_file:write("\n")
output_file:close()

os.execute("pandoc --from markdown+hard_line_breaks \""
  .. output_file_name .. "\" --toc=true -o \"" .. title .. ".epub\"")
