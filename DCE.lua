-- HTTPS://NOR.THE-RN.INFO
-- "DICE" - U/DCE
-- >> k1: exit
-- >> k2: roll
-- >> k3: roll
-- >> e1: dice 
-- >> e2: dice 
-- >> e3: dice 


function init()
  dice = {}
  sum, frame, count, animation, fps = 0, 0, 2, 15, 15
  redraw_clock_id = clock.run(redraw_clock)
  roll()
end

function roll()
  dice = {}
  sum = 0
  animation = frame + fps
  for i = 1, count do
    local die = {}
    die.x, die.y = get_x_and_y()
    die.n = math.random(1, 6)
    table.insert(dice, die)
    sum = sum + die.n
  end
  screen_dirty = true
end

function get_x_and_y()
  local collisions, x, y = true, 0, 0
  while collisions do
    x = math.random(9, 120)
    y = math.random(9, 56)
    local collide = false
    for k, die in pairs(dice) do
      if x < die.x + 17 and x > die.x - 17
      and y < die.y + 17 and y > die.y - 17 then
        collide = true
      end
    end
    if collide == false then
      collisions = false
    end
  end
  return x, y
end

function redraw_clock()
  while true do
    clock.sync(1/fps)
    frame = frame + 1
    if screen_dirty then
      redraw()
      if animation < frame then
        screen_dirty = false
      end
    end
  end
end

function redraw()
  screen.clear()
  if animation < frame then
    if count > 2 then draw_sum() end
    for k, die in pairs(dice) do  
      draw_die(die.x, die.y, die.n)
    end
  else
    for k, die in pairs(dice) do
      draw_die(die.x + math.random(-4, 4), die.y + math.random(-4, 4), math.random(1, 6))
    end
  end
  screen.update()
end

function enc(e, d)
  count = util.clamp(count + d, 1, 6)
  roll()
end

function key(k, z)
  if z == 0 then return end
  roll()
end

function cleanup()
  clock.cancel(redraw_clock_id)
end

function draw_sum()
  screen.level(5)
  screen.aa(1)
  screen.font_face(22)
  screen.font_size(48)
  screen.move(64, 48)
  screen.text_center(sum)
end

function draw_die(x, y, n)
  x = x - 8
  y = y - 8
  screen.rect(x + 1, y - 1, 14, 18)
  screen.rect(x, y, 16, 16)
  screen.rect(x - 1, y + 1, 18, 14)
  screen.level(0)
  screen.fill()
  screen.rect(x + 2, y, 12, 16)
  screen.rect(x + 1, y + 1, 14, 14)
  screen.rect(x, y + 2, 16, 12)
  screen.level(15)
  screen.fill()
  screen.level(0)
  if n == 1 then
    screen.circle(x + 8, y + 8, 2)      screen.fill()
  elseif n == 2 then
    if math.random(1, 2) == 1 then
      screen.circle(x + 4, y + 12, 2)   screen.fill()
      screen.circle(x + 12, y + 4, 2)   screen.fill()
    else
      screen.circle(x + 4, y + 4, 2)    screen.fill()
      screen.circle(x + 12, y + 12, 2)  screen.fill()
    end
  elseif n == 3 then
    screen.circle(x + 8, y + 8, 2)      screen.fill()
    if math.random(1, 2) == 1 then
      screen.circle(x + 4, y + 12, 2)   screen.fill()
      screen.circle(x + 12, y + 4, 2)   screen.fill()
    else
      screen.circle(x + 4, y + 4, 2)    screen.fill()
      screen.circle(x + 12, y + 12, 2)  screen.fill()
    end
  elseif n == 4 then
    screen.circle(x + 4, y + 4, 2)      screen.fill()
    screen.circle(x + 4, y + 12, 2)     screen.fill()
    screen.circle(x + 12, y + 4, 2)     screen.fill()
    screen.circle(x + 12, y + 12, 2)    screen.fill()
  elseif n == 5 then 
    screen.circle(x + 4, y + 4, 2)      screen.fill()
    screen.circle(x + 4, y + 12, 2)     screen.fill()
    screen.circle(x + 8, y + 8, 2)      screen.fill()
    screen.circle(x + 12, y + 4, 2)     screen.fill()
    screen.circle(x + 12, y + 12, 2)    screen.fill()
  elseif n == 6 then
    if math.random(1, 2) == 1 then
      screen.circle(x + 4, y + 3, 2)    screen.fill()
      screen.circle(x + 4, y + 8, 2)    screen.fill()
      screen.circle(x + 4, y + 13, 2)   screen.fill()
      screen.circle(x + 12, y + 3, 2)   screen.fill()
      screen.circle(x + 12, y + 8, 2)   screen.fill()
      screen.circle(x + 12, y + 13, 2)  screen.fill()
    else
      screen.circle(x + 3, y + 4, 2)    screen.fill()
      screen.circle(x + 8, y + 4, 2)    screen.fill()
      screen.circle(x + 13, y + 4, 2)   screen.fill()
      screen.circle(x + 3, y + 12, 2)   screen.fill()
      screen.circle(x + 8, y + 12, 2)   screen.fill()
      screen.circle(x + 13, y + 12, 2)  screen.fill()
    end
  end
end