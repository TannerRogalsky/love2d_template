local width, height = g.getHeight(), g.getHeight()

return {
  width = width,
  height = height,
  obstructions = {
    {
      geometry = {width / 4, height / 4, 50, 100}
    },
    {
      geometry = {width / 4, height / 4 * 3, 50, 100}
    },
    {
      geometry = {width / 4 * 3, height / 4 * 3, 50, 100}
    },
    {
      geometry = {width / 4 * 3, height / 4, 50, 100}
    },
  },
  traps = {
    {
      geometry = {width / 2, height / 4, 50, 50}
    },
    {
      geometry = {width / 2, height / 4 * 3, 50, 50}
    },
  },
  bounds = {
    {
      geometry = {0, 0, width, 0}
    },
    {
      geometry = {0, 0, 0, height}
    },
    {
      geometry = {width, 0, width, height}
    },
    {
      geometry = {0, height, width, height}
    },
  }
  player_positions = {
    [Direction.NORTH] = {
      goal = {width - width / 3 * 2, 0, width / 3, 50},
      spawn_point = {x = width / 2, y = height / 4}
    },
    [Direction.EAST] = {
      goal = {width - 50, height / 3, 50, height / 3},
      spawn_point = {x = width / 4 * 3, y = height / 2}
    },
    [Direction.SOUTH] = {
      goal = {width - width / 3 * 2, height - 50, width / 3, 50},
      spawn_point = {x = width / 2, y = height / 4 * 3}
    },
    [Direction.WEST] = {
      goal = {0, height / 3, 50, height / 3},
      spawn_point = {x = width / 4, y = height / 2}
    },
  }
}
