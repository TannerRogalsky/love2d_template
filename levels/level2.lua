local width, height = g.getWidth(), g.getHeight()

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
      Direction.WEST
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
      Direction.EAST
    }
  },
  traps = {
    {
      geometry = {width / 4, height / 4, 50, 50}
    },
    {
      geometry = {width / 4, height / 4 * 3, 50, 50}
    },
    {
      geometry = {width / 4 * 3, height / 4 * 3, 50, 50}
    },
    {
      geometry = {width / 4 * 3, height / 4, 50, 50}
    },
  },
  obstructions = {
    {
      geometry = {width / 2, height / 8 * 3, 30, 30}
    },
    {
      geometry = {width / 2, height / 8 * 5, 30, 30}
    },
    {
      geometry = {width / 8 * 3, height / 2, 30, 30}
    },
    {
      geometry = {width / 8 * 5, height / 2, 30, 30}
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
          x = 75,
          y = 220 / 2
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
          x = 75,
          y = 220 / 2
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
