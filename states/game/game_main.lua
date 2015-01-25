local Main = Game:addState('Main')

function Main:enteredState(song)
  Collider = HC(100, self.on_start_collide, self.on_stop_collide)

  local Camera = require("lib/camera")
  self.camera = Camera:new()

  g.setFont(self.preloaded_fonts["04b03_16"])

  -- self.song = song
  self.song = Song:new(require('sounds.test1'))
end

function Main:update(dt)
  self.song:update(dt)
end

function Main:draw()
  self.camera:set()

  local x = 35
  for i=0,2 do
    g.draw(self.preloaded_images["bg_p0.png"], x, 0)
    x = x + 380 + 35
  end

  x = 35
  for index, player in ipairs(self.song.players) do
    local pos = player.position
    local pos_x = x + (380 + 35) * pos
    g.draw(self.preloaded_images["bg_p" .. index .. ".png"], pos_x, 0)

    for beat, action in ipairs(player.state_sequence) do
      local y = g.getHeight() - 90 - ((self.song.time * -self.song.bpm) + beat * 60)
      g.print(action.button, pos_x + 20, y)
      if action.button ~= Button.None then
        g.print(action.stick.name, pos_x + 20 + 20, y)
      end
    end
  end

  g.line(0, g.getHeight() - 60, g.getWidth(), g.getHeight() - 60)
  g.print(self.song.current_beat, g.getWidth() / 2 - 20, g.getHeight() - 75)
  local player = self.song.players[1]


  self.camera:unset()
end

function Main:mousepressed(x, y, button)
end

function Main:mousereleased(x, y, button)
end

function Main:keypressed(key, unicode)
end

function Main:keyreleased(key, unicode)
end

function Main:gamepadpressed(joystick, button)
  self.song:gamepadpressed(joystick, button)
end

function Main:gamepadreleased(joystick, button)
end

function Main:focus(has_focus)
end

-- shape_one and shape_two are the colliding shapes. mtv_x and mtv_y define the minimum translation vector,
-- i.e. the direction and magnitude shape_one has to be moved so that the collision will be resolved.
-- Note that if one of the shapes is a point shape, the translation vector will be invalid.
function Main.on_start_collide(dt, shape_one, shape_two, mtv_x, mtv_y)
  local object_one, object_two = shape_one.parent, shape_two.parent

  if object_one and is_func(object_one.on_collide) then
    object_one:on_collide(dt, object_two, mtv_x, mtv_y)
  end

  if object_two and is_func(object_two.on_collide) then
    object_two:on_collide(dt, object_one, -mtv_x, -mtv_y)
  end
end

function Main.on_stop_collide(dt, shape_one, shape_two)
end

function Main:exitedState()
  Collider:clear()
  Collider = nil
end

return Main
