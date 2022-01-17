-- HTTPS://NOR.THE-RN.INFO
-- "REFERENCE" - U/REF
-- >> k1: exit
-- >> k2: back
-- >> k3: next
-- >> e1: none 
-- >> e2: x
-- >> e3: y

function init()
  screen_dirty = true
  redraw_clock_id = clock.run(redraw_clock)
  x, y = 0, 0
end

function redraw()
  screen.clear()
  screen.aa(1)
  screen.font_face(1)
  screen.font_size(8)
end


function page(i)
  if i == -1 then
    print("back")
  else
    print("next")
  end
end

function enc(e, d)
  if e == 2 then
    x = util.clamp(x + d, 0, 9) -- provisional
  elseif e == 3 then
    y = util.clamp(y + d, 0, 9)
  end
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