-- HTTPS://NOR.THE-RN.INFO
-- "CALCULATOR" - U/CLC
-- >> k1: exit     
-- >> k2: enter    
-- >> k3: calculate
-- >> e1: none 
-- >> e2: x
-- >> e3: y

function init()
  keymap = {}

  keymap[1]  = { view = "MOD",  fn = function() return nil end }
  keymap[2]  = { view = "7",    fn = function() return 7 end }
  keymap[3]  = { view = "8",    fn = function() return 8 end }
  keymap[4]  = { view = "9",    fn = function() return 9 end }
  keymap[5]  = { view = "÷",    fn = function() return nil end }

  keymap[6]  = { view = "SQR",  fn = function() return nil end }
  keymap[7]  = { view = "4",    fn = function() return 4 end }
  keymap[8]  = { view = "5",    fn = function() return 5 end }
  keymap[9]  = { view = "6",    fn = function() return 6 end }
  keymap[10] = { view = "x",    fn = function() return nil end }

  keymap[11] = { view = "%",    fn = function() return nil end }
  keymap[12] = { view = "1",    fn = function() return 1 end }
  keymap[13] = { view = "2",    fn = function() return 2 end }
  keymap[14] = { view = "3",    fn = function() return 3 end }
  keymap[15] = { view = "-",    fn = function() return nil end }

  keymap[16] = { view = "CLR",  fn = function() return nil end }
  keymap[17] = { view = "+/-",  fn = function() return nil end }
  keymap[18] = { view = "0",    fn = function() return 0 end }
  keymap[19] = { view = ".",    fn = function() return nil end }
  keymap[20] = { view = "+",    fn = function() return nil end }

  focus_x, focus_y = 3, 2
  buffer = {}
  screen_dirty = true
  redraw_clock_id = clock.run(redraw_clock)
end

function redraw()
  screen.clear()
  -- buttons
  screen.aa(1)
  screen.font_face(1)
  screen.font_size(8)
  local start_x, start_y, w, h, i = 1, 16, 24, 11, 1
  for y = 1, 4 do
    for x = 1, 5 do
      local this_x = start_x + (((x - 1) * w) + x)
      local this_y = start_y + (((y - 1) * h) + y)
      local text, background, border = 0, 15, 2
      if x == focus_x and y == focus_y then
        text, background, border = 15, 0, 15
      end
      -- border
      screen.rect(this_x, this_y, w, h)
      screen.level(border)
      screen.fill()
      -- background
      screen.rect(this_x + 1, this_y + 1, w - 2, h - 2)
      screen.level(background)
      screen.fill()
      -- text
      screen.move(this_x + (w / 2), this_y + (h - 3))
      screen.level(text)
      screen.text_center(keymap[i].view)
      -- iterate
      i = i + 1
    end
  end

  -- screen.level(15)
  -- screen.pixel(0, 0)
  -- screen.pixel(127, 0)
  -- screen.pixel(0, 63)
  -- screen.pixel(127, 63)
  -- screen.fill()
  
  -- buffer
  screen.aa(0)
  screen.font_face(3)
  screen.font_size(16)
  screen.move(64, 14)
  screen.level(15)
  local buffer_string = ""
  for k, v in ipairs(buffer) do
    buffer_string = buffer_string .. keymap[v].view
  end
  screen.text_center(buffer_string)
  screen.update()
end

function get_index(at_x, at_y)
  local i = 1
  for y = 1, 4 do
    for x = 1, 5 do
      if at_x == x and at_y == y then
        return i
      else
        i = i + 1
      end
    end
  end
  return 0
end

function enc(e, d)
  if e == 2 then
    focus_x = util.clamp(focus_x + d, 1, 5)
  elseif e == 3 then
    focus_y = util.clamp(focus_y + d, 1, 4)
  end
  screen_dirty = true
end

function key(k, z)
  if z == 0 then return end
  if k == 2 then 
    buffer[#buffer + 1] = get_index(focus_x, focus_y)
  end
  if k == 3 then execute() end
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