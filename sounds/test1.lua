-- all timings in bpm unless otherwise noted

return {
  file = 'sounds/DJ Amuro - A (HQ)-JMV2qLTX1_g.mp3',
  bpm = 96,
  length = 30,
  starting_offset = 0, -- seconds
  players = 1,
  actions = {
    {
      player = 1,
      start_time = 1,
      hold_time = 1,
      rest_time = 0,
      gamepadaxis = Stick.UP,
      gamepadbutton = Button.A
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
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.None
    },
  }
}
