local width, height = g.getHeight(), g.getHeight()
local trap_width, trap_height = height / 16, height / 16
local obstruction_width, obstruction_height = height / 25, height / 25
local goal_width_horiz, goal_height_horiz = width / 32, height / 6
local goal_width_vert, goal_height_vert = height / 6, width / 32

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
    },
    {
      {
        pressed = {},
        update = {
          -- u = Player.on_update_up,
          -- r = Player.on_update_right,
          -- d = Player.on_update_down,
          -- l = Player.on_update_left
        }
      },
      COLORS.blue,
      Direction.SOUTH,
      love.joystick.getJoysticks()[1]
    },
    {
      {
        pressed = {},
        update = {
          -- u = Player.on_update_up,
          -- r = Player.on_update_right,
          -- d = Player.on_update_down,
          -- l = Player.on_update_left
        }
      },
      COLORS.yellow,
      Direction.NORTH,
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
    [Direction.NORTH] = {
      goal = {width / 2 - goal_width_vert / 2, 0, goal_width_vert, goal_height_vert},
      goal_draw_hints = {
        orientation = -90,
        scale = {
          x = 2,
          y = 2
        },
        offset = {
          x = 40 / 2,
          y = 150 / 2
        }
      },
      spawn_point = {x = width / 2, y = height / 4 * 3},
      score_text_position = {x = 0, y = 0}
    },
    [Direction.EAST] = {
      goal = {width - goal_width_horiz, height / 2 - goal_height_horiz / 2, goal_width_horiz, goal_height_horiz},
      goal_draw_hints = {
        orientation = 0,
        scale = {
          x = 2,
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
    [Direction.SOUTH] = {
      goal = {width / 2 - goal_width_vert / 2, height - goal_height_vert, goal_width_vert, goal_height_vert},
      goal_draw_hints = {
        orientation = 90,
        scale = {
          x = 2,
          y = 2
        },
        offset = {
          x = 40 / 2,
          y = 150 / 2
        }
      },
      spawn_point = {x = width / 2, y = height / 4},
      score_text_position = {x = width - 60, y = height - 60}
    },
    [Direction.WEST] = {
      goal = {0, height / 2 - goal_height_horiz / 2, goal_width_horiz, goal_height_horiz},
      goal_draw_hints = {
        orientation = 180,
        scale = {
          x = 2,
          y = 2
        },
        offset = {
          x = 40 / 2,
          y = 150 / 2
        }
      },
      spawn_point = {x = width / 4 * 3, y = height / 2},
      score_text_position = {x = 0, y = height - 60}
    },
  }
}
