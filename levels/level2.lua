local width, height = g.getWidth(), g.getHeight()
local trap_width, trap_height = height / 16, height / 16
local obstruction_width, obstruction_height = height / 25, height / 25

return {
  width = width,
  height = height,
  players = {
    {
      {
        pressed = {},
        update = {
          up = Player.on_update_up,
          right = Player.on_update_right,
          down = Player.on_update_down,
          left = Player.on_update_left
        }
      },
      COLORS.red,
      Direction.WEST,
      love.joystick.getJoysticks()[1]
    },
    {
      {
        pressed = {},
        update = {
          w = Player.on_update_up,
          d = Player.on_update_right,
          s = Player.on_update_down,
          a = Player.on_update_left
        }
      },
      COLORS.green,
      Direction.EAST,
      love.joystick.getJoysticks()[2]
    }
  },
  traps = {
    {
      geometry = {width / 4, height / 4, trap_width, trap_height}
    },
    {
      geometry = {width / 4, height / 4 * 3, trap_width, trap_height}
    },
    {
      geometry = {width / 4 * 3, height / 4 * 3, trap_width, trap_height}
    },
    {
      geometry = {width / 4 * 3, height / 4, trap_width, trap_height}
    },
  },
  obstructions = {
    {
      geometry = {width / 2, height / 8 * 3, obstruction_width, obstruction_height}
    },
    {
      geometry = {width / 2, height / 8 * 5, obstruction_width, obstruction_height}
    },
    {
      geometry = {width / 8 * 3, height / 2, obstruction_width, obstruction_height}
    },
    {
      geometry = {width / 8 * 5, height / 2, obstruction_width, obstruction_height}
    },
  },
  bounds = {
    {
      geometry = {width / 6, 0, width / 6 * 5, 0}
    },
    {
      geometry = {0, height / 6, 0, height / 6 * 5}
    },
    {
      geometry = {width, height / 6, width, height / 6 * 5}
    },
    {
      geometry = {width / 6, height, width / 6 * 5, height}
    },
    -- diagonals
    {
      geometry = {0, height / 6, width / 6, 0}
    },
    {
      geometry = {width / 6 * 5, 0, width, height / 6}
    },
    {
      geometry = {0, height / 6 * 5, width / 6, height}
    },
    {
      geometry = {width / 6 * 5, height, width, height / 6 * 5}
    },
  },
  player_positions = {
    [Direction.EAST] = {
      goal = {width - 25, height / 5 * 2, 25, height / 4},
      goal_draw_hints = {
        orientation = 0,
        scale = {
          x = 3,
          y = 2
        },
        offset = {
          x = 40 / 2,
          y = 150 / 2
        }
      },
      spawn_point = {x = width / 4, y = height / 2},
      score_text_position = {x = width - 60, y = 0}
    },
    [Direction.WEST] = {
      goal = {0, height / 5 * 2, 25, height / 4},
      goal_draw_hints = {
        orientation = 180,
        scale = {
          x = 3,
          y = 2
        },
        offset = {
          x = 40 / 2,
          y = 150 / 2
        }
      },
      spawn_point = {x = width / 4 * 3, y = height / 2},
      score_text_position = {x = 10, y = height - 60}
    },
  },
  -- powerup_spawn_time = 20,
  -- powerups = {
  --   {
  --     geometry = {width / 2, height / 4, 50, 50}
  --   },
  --   {
  --     geometry = {width / 2, height / 4 * 3, 50, 50}
  --   },
  -- }
}
