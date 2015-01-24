local Stick = {
  UP = {lefty=-1, leftx=0},
  None = {lefty=0, leftx=0},
}

local Button = {
  A = 'a',
  B = 'b',
  X = 'x',
  Y = 'y'
}

-- all timings in bpm

return {
  file = 'sounds/DJ Amuro - A (HQ)-JMV2qLTX1_g.mp3',
  bpm = 120,
  players = 2,
  actions = {
    {
      player = 1,
      start_time = 1,
      hold_time = 1,
      rest_time = 0,
      gamepadaxis = Stick.UP,
    },
    {
      player = 1,
      start_time = 12,
      hold_time = 2,
      rest_time = 2,
      gamepadbutton = Button.B,
    },
    {
      player = 1,
      start_time = 26,
      hold_time = 0,
      rest_time = 0,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.None
    },
  }
}
