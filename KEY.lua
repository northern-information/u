-- HTTPS://NOR.THE-RN.INFO
-- "KEYBOARD" - U/KEY
-- >> k1: exit
-- >> k2: -
-- >> k3: -
-- >> e1: -
-- >> e2: -
-- >> e3: -

function init()
  screen.aa(1)
  screen.font_face(1)
  screen.font_size(16)
  down = 0
  buffer = "PRESS A KEY"
  screen_dirty = true
  redraw_clock_id = clock.run(redraw_clock)
end

function keyboard.code(code, value)
  down = value > 0
  if down then
    buffer = code
  end
  screen_dirty = true
end

function keyboard.char(ch)
  buffer = string.upper(ch)
  screen_dirty = true
end

function redraw()
  screen.clear()
  screen.level(down and 0 or 15)
  screen.rect(0, 0, 127, 63)
  screen.fill()
  screen.level(down and 15 or 0)
  screen.move(64, 36)
  screen.text_center(buffer)
  screen.fill()
  screen.update()
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
