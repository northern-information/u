-- HTTPS://NOR.THE-RN.INFO
-- "REFERENCE" - U/REF
-- >> k1: exit
-- >> k2: back
-- >> k3: next
-- >> e1: scroll
-- >> e2: scroll
-- >> e3: scroll

function init()
  root = "/home/we/dust/data/u/REF/"
  max_width = 120
  word_wrap_symbol = " "
  files = {}
  lines = {}
  index = 3
  scroll = 0
  scroll_max = 0
  line_height = 8
  padding = 12
  copy_factory()
  scan_library()
  word_wrap(root .. files[index])
  screen_dirty = true
  redraw_clock_id = clock.run(redraw_clock)
end

-- only copies if the directory is empty
function copy_factory()
  local i, t, popen = 0, {}, io.popen
  local pfile = popen('ls -a ' .. root)
  for filename in pfile:lines() do
    if filename ~= "." and filename ~= ".." then
      i = i + 1
      t[i] = filename
    end
  end
  pfile:close()
  if #t == 0 then
    local handle = io.popen("cp /home/we/dust/code/u/_factory/REF/* " .. root)
    local result = handle:read("*a")
    handle:close()
  end
end

function scan_library()
  local scan = util.scandir(root)
  for k, file in pairs(scan) do
    local name = string.gsub(file, "/", "")
    files[#files + 1] = name
  end
end

function word_wrap(file_absolute_path)
  local file = io.open(file_absolute_path, "rb")
  local file_raw = file:read("*a")
  file:close()
  local file_into_lines = file_raw:gsub("\r\n?", "\n"):gmatch("(.-)\n")
  local line_number = 1
  while true do
    local line = file_into_lines()
    if line == nil then break end
    if screen.text_extents(line) <= max_width then
      -- this line is shorter than the max width
      -- no manipulation needed
      lines[line_number] = line
      line_number = line_number + 1
    else
      -- this line is longer than the max width, so let us figure out where to wrap
      local line_buffer, words, i, ii, is_first_word_of_wrapped_line = "", {}, 1, 1, false
      -- build a table with all the words in this line
      for this_word in line:gmatch("([^%s]+)") do
        words[i] = this_word
        i = i + 1
      end
      while true do
        local current_word = words[ii]
        local next_word = words[ii+1]
        if line_buffer == "" then
          -- always load the first word
          if is_first_word_of_wrapped_line then
            line_buffer =  word_wrap_symbol .. " " .. current_word
            is_first_word_of_wrapped_line = false
          else
            line_buffer = current_word
          end
        end
        if next_word == nil then
          -- the current_word is the final word in the line, so end
          lines[line_number] = line_buffer
          line_number = line_number + 1
          break
        else
          -- lookahead to test the new length
          local test = line_buffer .. " " .. next_word
          if screen.text_extents(word_wrap_symbol .. " " .. test) <= max_width then
            -- test passes (we are less than or equal to the max width) so continue
            line_buffer = test
          else
            -- test fails (we are over the max width) so commit this line and continue
            lines[line_number] = line_buffer
            line_buffer = ""
            is_first_word_of_wrapped_line = true -- setup for the next iteration
            line_number = line_number + 1
          end
        end
        ii = ii + 1
        if ii > #words then break end -- end of this line
      end
    end
  end
  scroll_max = get_scroll_end()
end

function redraw()
  screen.clear()
  screen.aa(1)
  screen.font_face(1)
  screen.font_size(8)
  local percentage = (scroll * -1) / scroll_max
  local scroll_y = (percentage * 64) + 1
  local end_y = scroll_max + (padding * 2)
  -- scrollbar
  if scroll_y < (scroll + end_y) then
    screen.level(4)
    screen.rect(127, scroll_y, 1, 3)
    screen.fill()
  end
  -- filename
  screen.level(15)
  screen.rect(0, scroll, 128, line_height + 1)
  screen.fill()
  screen.level(0)
  screen.pixel(0, scroll)
  screen.pixel(127, scroll)
  screen.move(2, (line_height + scroll) - 2)
  screen.text(files[index])
  screen.fill()
  -- contents
  screen.level(15)
  for i, line in ipairs(lines) do
    screen.move(0, (i * line_height) + scroll + padding)
    screen.text(line)
  end
  -- end indicator
  screen.level(15)
  screen.rect(0, scroll + end_y, 128, line_height + 1)
  screen.fill()
  screen.level(0)
  screen.pixel(0, scroll + line_height + end_y)
  screen.pixel(127, scroll + line_height + end_y)
  screen.move(2, (line_height + scroll + end_y) - 2)
  screen.fill()
  screen.update()
end


function page(i)
  if i == -1 then
    index = util.wrap(index - 1, 1, #files)
  else
    index = util.wrap(index + 1, 1, #files)
  end
  lines = {}
  scroll = 0
  word_wrap(root .. files[index])
end

function get_scroll_end()
  return (#lines * line_height)
end

function enc(e, d)
  scroll = scroll - d
  if scroll > 0 then scroll = 0 end
  local end_check = get_scroll_end() * -1
  if scroll < end_check then scroll = end_check end
  screen_dirty = true
end

function key(k, z)
  if z == 0 then return end
  if k == 2 then page(-1) end
  if k == 3 then page(1) end
  screen_dirty = true
end

function redraw_clock()
  while true do
    clock.sync(1/15)
    if screen_dirty then
      redraw()
      screen_dirty = false
    end
  end
end

function cleanup()
  clock.cancel(redraw_clock_id)
end

function r()
  norns.script.load(norns.state.script)
end