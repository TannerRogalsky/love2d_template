describe("Grid", function()
  local Grid

  setup(function()
    class = require("lib/middleclass")
    Grid = require("lib/grid")
  end)

  teardown(function()
    Grid = nil
  end)

  describe("Grid:new", function()
    it("requires width and height arguments, both should be natural numbers", function()
      assert.is_truthy(Grid:new(10, 10))
      assert.has.errors(function() Grid:new(0, -1) end)
      assert.has.errors(function() Grid:new({10, 10}) end)
    end)
  end)

  describe("the grid's iterator, grid:each", function()
    local grid

    setup(function()
      grid = Grid:new(2, 2)
      grid[1][1] = 1
      grid[1][2] = 2
      grid[2][1] = 3
      grid[2][2] = 4
    end)

    teardown(function()
      grid = nil
    end)

    it("iterates over the entire grid when called without arguments", function()
      local index = 0
      for _, _, value in grid:each() do
        index = index + 1
        assert.are.equal(value, index)
      end
    end)

    it("iterates over part of the grid when called with arguments", function()
      local index = 2
      for _, _, value in grid:each(2, 1) do
        index = index + 1
        assert.are.equal(value, index)
      end
    end)

    it("respects the grid's orientation", function()
      local index = 4
      grid:rotate(180)
      for _, _, value in grid:each() do
        assert.are.equal(value, index)
        index = index - 1
      end
    end)
  end)

  describe("rotation functions", function()
    local grid

    setup(function()
      grid = Grid:new(2, 2)
      grid[1][1] = 1
      grid[1][2] = 2
      grid[2][1] = 3
      grid[2][2] = 4
    end)

    teardown(function()
      grid = nil
    end)

    describe("grid:rotate", function()
      it("takes an angle value to rotate the grid by", function()
        assert.are.equals(grid:get(2, 2), 4)
        grid:rotate(180)
        assert.are.equals(grid:get(1, 1), 4)
        grid:rotate(180)
        assert.are.equals(grid:get(2, 2), 4)
      end)

      it("throws an error when you try to rotate it by an angle that is not a multiplier of 90 degrees", function()
        assert.has_error(function() grid:rotate(92) end)
      end)
    end)

    describe("grid:rotate_to", function()
      it("takes an angle to rotate the grid to", function()
        assert.are.equals(grid:get(2, 2), 4)
        grid:rotate_to(180)
        assert.are.equals(grid:get(1, 1), 4)
        grid:rotate_to(180)
        assert.are.equals(grid:get(1, 1), 4)
      end)

      it("throws an error when you try to rotate it by an angle that is not a multiplier of 90 degrees", function()
        assert.has_error(function() grid:rotate_to(92) end)
      end)
    end)
  end)

  describe("grid:get", function()
    it("respects the grid's orientation", function()
      local grid = Grid:new(2, 2)
      grid:set(2, 2, true)
      assert.is_true(grid:get(2, 2))
      grid:rotate(180)
      assert.is_true(grid:get(1, 1))
      grid:rotate(90)
      assert.is_true(grid:get(2, 1))
    end)

    it("is aliased to grid:g", function()
      local grid = Grid:new(2, 2)
      assert.are.equals(grid.get, grid.g)
    end)

    it("returns nil when the cell isn't initialized or is out of bounds", function()
      local grid = Grid:new(2, 2)
      assert.is.falsy(grid:get(1, 1))
      assert.is.falsy(grid:get(0, 0))
    end)
  end)

  describe("grid:set", function()
    it("respects the grid's orientation", function()
      local grid = Grid:new(2, 2)
      grid:set(2, 2, true)
      assert.is_true(grid:get(2, 2))
      grid:rotate(180)
      grid:set(2, 2, true)
      assert.is_true(grid:get(1, 1))
      assert.is_true(grid:get(2, 2))
    end)

    it("is aliased to grid:s", function()
      local grid = Grid:new(2, 2)
      assert.are.equals(grid.set, grid.s)
    end)

    it("returns nil when the cell is out of bounds", function()
      local grid = Grid:new(2, 2)
      assert.is.falsy(grid:set(0, 0))
    end)
  end)
end)
