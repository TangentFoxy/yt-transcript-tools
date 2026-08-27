#!/usr/bin/env luajit
local version = "0.2.0"

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
for index, line in ipairs(input_lines) do
  if not (line:sub(3, 3) == ":") then
    local previous_line = input_lines[index - 1]
    if previous_line and previous_line:sub(3, 3) == ":" then
      output_lines[#output_lines] = "```\n" .. previous_line
      output_lines[#output_lines + 1] = string.rep(" ", 6) .. line .. "\n```"
    else
      output_lines[#output_lines + 1] = "`" .. line .. "`"
    end
  else
    output_lines[#output_lines + 1] = "`" .. line .. "`"
  end
end

local output_file = io.open(output_file_name, "w")
assert(output_file, "Could not open \"" .. output_file_name .. "\"")

-- TODO redo with a concat
for _, line in ipairs(frontmatter) do
  output_file:write(line)
  output_file:write("\n")
end

output_file:write(table.concat(output_lines, "\n"))
output_file:write("\n")
output_file:close()

os.execute("pandoc --from markdown+hard_line_breaks \""
  .. output_file_name .. "\" -o \"" .. title .. ".epub\"")
