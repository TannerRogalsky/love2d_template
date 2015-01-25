-- all timings in bpm unless otherwise noted

return {
  file = 'sounds/ddr_59-psX1hLeUDFA.mp3',
  bpm = 135,
  length = 235,
  starting_offset = 0.279, -- seconds
  players = 2,

  actions = {
    {
      -- dummy for beat 1 must be present
      player = 1,
      start_time = 1,
      hold_time = 1,
      rest_time = 10,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.None
    },
    {
      -- dummy for beat 1 must be present
      player = 2,
      start_time = 1,
      hold_time = 1,
      rest_time = 10,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.None
    },
    {
      -- dummy for beat 1 must be present
      player = 3,
      start_time = 1,
      hold_time = 1,
      rest_time = 10,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.None
    },

    --learning
    {
      player = 1,
      start_time = 17,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.A,
      gamepadaxis = Stick.Up
    },
    {
      player = 2,
      start_time = 17,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.A,
      gamepadaxis = Stick.None
    },
    {
      player = 1,
      start_time = 25,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.X,
    },
    {
      player = 2,
      start_time = 25,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.B,
    },

    --start beat
    {
      player = 1,
      start_time = 33,
      hold_time = 1,
      rest_time = 3,
      gamepadbutton = Button.B,
      gamepadaxis = Stick.None,
    },
    {
      player = 2,
      start_time = 33,
      hold_time = 1,
      rest_time = 1,
      gamepadbutton = Button.B,
      gamepadaxis = Stick.Up,
    },

    --first switch
    {
      player = 3,
      start_time = 49,
      hold_time = 1,
      rest_time = 3,
      gamepadbutton = Button.Y,
      gamepadaxis = Stick.None,
    },
    {
      player = 2,
      start_time = 49,
      hold_time = 1,
      rest_time = 1,
      gamepadbutton = Button.Y,
      gamepadaxis = Stick.Left,
    },
    {
      player = 3,
      start_time = 65,
      hold_time = 1,
      rest_time = 3,
      gamepadbutton = Button.X,
      gamepadaxis = Stick.None,
    },
    {
      player = 2,
      start_time = 65,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.X,
      gamepadaxis = Stick.Right,
    },
    {
      player = 1,
      start_time = 69,
      hold_time = 1,
      rest_time = 3,
      gamepadbutton = Button.Y,
      gamepadaxis = Stick.None,
    },
    {
      player = 1,
      start_time = 73,
      hold_time = 1,
      rest_time = 1,
      gamepadbutton = Button.B,
      gamepadaxis = Stick.None,
    },
    {
      player = 1,
      start_time = 99,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.Left,
    },
    {
      player = 2,
      start_time = 101,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.Right,
    },
    {
      player = 3,
      start_time = 103,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.Up,
    },
    {
      player = 1,
      start_time = 105,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.Down,
    },
    {
      player = 1,
      start_time = 109,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.A,
      gamepadaxis = Stick.None,
    },
    {
      player = 3,
      start_time = 113,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.B,
      gamepadaxis = Stick.None,
    },
    {
      player = 3,
      start_time = 118,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.A,
      gamepadaxis = Stick.None,
    },
    {
      player = 2,
      start_time = 125,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.X,
    },

    --together!
    {
      player = 1,
      start_time = 133,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.Y,
      gamepadaxis = Stick.Up,
    },
    {
      player = 3,
      start_time = 133,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.Y,
      gamepadaxis = Stick.Up,
    },
    {
      player = 1,
      start_time = 138,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.Y,
      gamepadaxis = Stick.Down,
    },
    {
      player = 3,
      start_time = 138,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.Y,
      gamepadaxis = Stick.Down,
    },


    {
      player = 1,
      start_time = 138,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.A,
      gamepadaxis = Stick.None,
    },
    {
      player = 3,
      start_time = 138,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.B,
      gamepadaxis = Stick.None,
    },

    --cymbal hit switch
    {
      player = 2,
      start_time = 149,
      hold_time = 1,
      rest_time = 20,
      gamepadbutton = Button.X,
      gamepadaxis = Stick.Up,
    },
    {
      player = 2,
      start_time = 152,
      hold_time = 1,
      rest_time = 20,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.None,
    },

    {
      player = 1,
      start_time = 165,
      hold_time = 1,
      rest_time = 1,
      gamepadbutton = Button.B,
    },
    {
      player = 2,
      start_time = 166,
      hold_time = 1,
      rest_time = 1,
      gamepadbutton = Button.B,
    },
    {
      player = 3,
      start_time = 165,
      hold_time = 1,
      rest_time = 3,
      gamepadbutton = Button.B,
    },

    --awkward switchup
    {
      player = 1,
      start_time = 180,
      hold_time = 1,
      rest_time = 1,
      gamepadbutton = Button.X,
    },
    {
      player = 1,
      start_time = 181,
      hold_time = 1,
      rest_time = 1,
      gamepadbutton = Button.None,
    },
    {
      player = 2,
      start_time = 181,
      hold_time = 1,
      rest_time = 1,
      gamepadbutton = Button.X,
    },
    {
      player = 3,
      start_time = 183,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.Y,
    },

    --finishing line
    {
      player = 1,
      start_time = 197,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.X,
      gamepadaxis = Stick.Up,
    },
    {
      player = 2,
      start_time = 197,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.None,
    },
    {
      player = 3,
      start_time = 197,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.Y,
      gamepadaxis = Stick.Down,
    },

    {
      player = 1,
      start_time = 199,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.X,
      gamepadaxis = Stick.Left,
    },
    {
      player = 3,
      start_time = 199,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.Y,
      gamepadaxis = Stick.Right,
    },

    {
      player = 1,
      start_time = 201,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.X,
      gamepadaxis = Stick.Down,
    },
    {
      player = 3,
      start_time = 201,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.X,
      gamepadaxis = Stick.Up,
    },
    {
      player = 1,
      start_time = 203,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.X,
      gamepadaxis = Stick.Right,
    },
    {
      player = 3,
      start_time = 203,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.X,
      gamepadaxis = Stick.Left,
    },





    {
      player = 1,
      start_time = 213,
      hold_time = 1,
      rest_time = 21,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.Left
    },
  }
}
