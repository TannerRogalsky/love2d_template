local width, height = g.getHeight(), g.getHeight()

return {
  width = width,
  height = height,
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
    [Direction.NORTH] = {
      goal = {width - width / 3 * 2, 0, width / 3, 50},
      spawn_point = {x = width / 2, y = height / 4 * 3}
    },
    [Direction.EAST] = {
      goal = {width - 50, height / 3, 50, height / 3},
      spawn_point = {x = width / 4, y = height / 2}
    },
    [Direction.SOUTH] = {
      goal = {width - width / 3 * 2, height - 50, width / 3, 50},
      spawn_point = {x = width / 2, y = height / 4}
    },
    [Direction.WEST] = {
      goal = {0, height / 3, 50, height / 3},
      spawn_point = {x = width / 4 * 3, y = height / 2}
    },
  }
}
