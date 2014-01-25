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
  }
}
