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
      start_time = 16,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.A,
    },
    {
      player = 2,
      start_time = 16,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.A,
      gamepadaxis = Stick.Up
    },
    {
      player = 1,
      start_time = 23,
      hold_time = 1,
      rest_time = 9,
      gamepadbutton = Button.None,
    },
    {
      player = 2,
      start_time = 23,
      hold_time = 1,
      rest_time = 9,
      gamepadbutton = Button.B,
    },
    {
      player = 3,
      start_time = 23,
      hold_time = 1,
      rest_time = 9,
      gamepadbutton = Button.Y,
    },
    {
      player = 3,
      start_time = 24,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.None,
    },

    --start beat
    {
      player = 1,
      start_time = 31,
      hold_time = 1,
      rest_time = 3,
      gamepadbutton = Button.B,
      gamepadaxis = Stick.None,
    },
    {
      player = 2,
      start_time = 31,
      hold_time = 1,
      rest_time = 1,
      gamepadbutton = Button.B,
      gamepadaxis = Stick.Up,
    },

    --first switch
    {
      player = 1,
      start_time = 47,
      hold_time = 1,
      rest_time = 3,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.None,
    },
    {
      player = 3,
      start_time = 47,
      hold_time = 1,
      rest_time = 3,
      gamepadbutton = Button.Y,
      gamepadaxis = Stick.None,
    },
    {
      player = 2,
      start_time = 47,
      hold_time = 1,
      rest_time = 1,
      gamepadbutton = Button.Y,
      gamepadaxis = Stick.Left,
    },
    {
      player = 3,
      start_time = 63,
      hold_time = 1,
      rest_time = 3,
      gamepadbutton = Button.X,
      gamepadaxis = Stick.None,
    },
    {
      player = 2,
      start_time = 64,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.Right,
    },
    {
      player = 1,
      start_time = 68,
      hold_time = 1,
      rest_time = 3,
      gamepadbutton = Button.Y,
      gamepadaxis = Stick.None,
    },
    {
      player = 1,
      start_time = 72,
      hold_time = 1,
      rest_time = 1,
      gamepadbutton = Button.B,
      gamepadaxis = Stick.None,
    },
    {
      player = 1,
      start_time = 98,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.None,
    },
    {
      player = 2,
      start_time = 100,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.Right,
    },
    {
      player = 3,
      start_time = 102,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.Up,
    },
    {
      player = 1,
      start_time = 104,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.Down,
    },
    {
      player = 1,
      start_time = 108,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.A,
      gamepadaxis = Stick.None,
    },
    {
      player = 3,
      start_time = 111,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.B,
      gamepadaxis = Stick.None,
    },
    {
      player = 3,
      start_time = 114,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.A,
      gamepadaxis = Stick.None,
    },
    {
      player = 2,
      start_time = 124,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.X,
    },

    --together!
    {
      player = 1,
      start_time = 127,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.Y,
      gamepadaxis = Stick.Up,
    },
    {
      player = 3,
      start_time = 127,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.Y,
      gamepadaxis = Stick.Up,
    },
    {
      player = 1,
      start_time = 132,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.None,
    },
    {
      player = 3,
      start_time = 132,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.None,
    },


    {
      player = 1,
      start_time = 137,
      hold_time = 1,
      rest_time = 1,
      gamepadbutton = Button.A,
      gamepadaxis = Stick.None,
    },
    {
      player = 3,
      start_time = 137,
      hold_time = 1,
      rest_time = 7,
      gamepadbutton = Button.B,
      gamepadaxis = Stick.None,
    },

    --cymbal hit switch
    {
      player = 2,
      start_time = 148,
      hold_time = 1,
      rest_time = 20,
      gamepadbutton = Button.X,
      gamepadaxis = Stick.Up,
    },
    {
      player = 2,
      start_time = 151,
      hold_time = 1,
      rest_time = 20,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.None,
    },

    {
      player = 1,
      start_time = 163,
      hold_time = 1,
      rest_time = 1,
      gamepadbutton = Button.B,
    },
    {
      player = 2,
      start_time = 164,
      hold_time = 1,
      rest_time = 1,
      gamepadbutton = Button.B,
    },
    {
      player = 3,
      start_time = 163,
      hold_time = 1,
      rest_time = 3,
      gamepadbutton = Button.B,
    },

    --awkward switchup
    {
      player = 1,
      start_time = 179,
      hold_time = 1,
      rest_time = 1,
      gamepadbutton = Button.X,
    },
    {
      player = 1,
      start_time = 180,
      hold_time = 1,
      rest_time = 1,
      gamepadbutton = Button.None,
    },
    {
      player = 2,
      start_time = 180,
      hold_time = 1,
      rest_time = 1,
      gamepadbutton = Button.X,
    },
    {
      player = 3,
      start_time = 182,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.Y,
    },

    --finishing line
    {
      player = 1,
      start_time = 196,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.X,
      gamepadaxis = Stick.Up,
    },
    {
      player = 2,
      start_time = 196,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.None,
      gamepadaxis = Stick.None,
    },
    {
      player = 3,
      start_time = 196,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.Y,
      gamepadaxis = Stick.Down,
    },

    {
      player = 1,
      start_time = 198,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.X,
      gamepadaxis = Stick.Left,
    },
    {
      player = 3,
      start_time = 198,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.Y,
      gamepadaxis = Stick.Right,
    },

    {
      player = 1,
      start_time = 200,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.X,
      gamepadaxis = Stick.Down,
    },
    {
      player = 3,
      start_time = 200,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.X,
      gamepadaxis = Stick.Up,
    },
    {
      player = 1,
      start_time = 202,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.X,
      gamepadaxis = Stick.Right,
    },
    {
      player = 3,
      start_time = 202,
      hold_time = 1,
      rest_time = 0,
      gamepadbutton = Button.X,
      gamepadaxis = Stick.Left,
    },





    {
      player = 1,
      start_time = 213,
      hold_time = 1,
      rest_time = 3,
      gamepadbutton = Button.Y,
      },
    {
      player = 3,
      start_time = 213,
      hold_time = 1,
      rest_time = 3,
      gamepadbutton = Button.B
    },
  }
}
