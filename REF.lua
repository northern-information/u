-- HTTPS://NOR.THE-RN.INFO
-- "REFERENCE" - U/REF
-- >> k1: exit
-- >> k2: back
-- >> k3: next
-- >> e1: scroll
-- >> e2: scroll
-- >> e3: scroll

tabutil = require("tabutil")

function init()
  root = "/home/we/dust/data/u/REF/"
  files, lines = {}, {}
  index, y = 1, 0
  scan_files()
  load_current()
  screen_dirty = true
  redraw_clock_id = clock.run(redraw_clock)
end

function redraw()
  screen.clear()
  screen.aa(1)
  screen.font_face(1)
  screen.font_size(8)
  show_file()
  screen.level(15)
  screen.pixel(0, 0)
  screen.pixel(127, 0)
  screen.pixel(0, 63)
  screen.pixel(127, 63)
  screen.fill()
  screen.update()
end

function cr_lines(s)
  return s:gsub('\r\n?', '\n'):gmatch('(.-)\n')
end

function cr_file_lines(filename)
  local f = io.open(root .. filename, 'rb')
  local s = f:read('*a')
  f:close()
  return s
end

function show_file()
  local line_height = 8
  local i = 1
  for line in cr_lines(lines) do
    screen.move(0, (i * line_height) + y)
    screen.text(line)
    i = i + 1
  end
end

function scan_files()
  local scan = util.scandir(root)
  for k, file in pairs(scan) do
    local name = string.gsub(file, "/", "")
    files[#files + 1] = name
  end
end

function load_current()
  y = 0
  lines = cr_file_lines(files[index])
end

function page(i)
  if i == -1 then
    index = util.wrap_max(index - 1, 1, #files)
  else
    index = util.wrap_max(index + 1, 1, #files)
  end
  load_current()
end

function enc(e, d)
  y = y - d
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