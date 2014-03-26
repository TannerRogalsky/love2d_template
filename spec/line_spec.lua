describe("Line", function()
  local Line

  setup(function()
    Line = require("lib/line")
  end)

  teardown(function()
    Line = nil
  end)

  it("should be instantiated via .new", function()
    local line = Line.new(0, 0, 100, 100)
    assert.is.truthy(line)
    assert.is_true(Line.is_line(line))
  end)

  describe("operations not postfixed with '_inplace' should return a new Line instance", function()
    it("should return a new Line instance when rotated is called", function()
      local line = Line.new(0, 0, 100, 100)

      assert.are_not.equals(line, line:rotated(0))
      assert.are.same(line, line:rotated(0))
    end)
  end)

  describe("Line:parallel", function()
    local line_a, line_b, line_c

    setup(function()
      line_a = Line.new(0, 0, 100, 100)
      line_b = Line.new(50, 50, 150, 150)
      line_c = Line.new(75, 75, 175, 100)
    end)

    teardown(function()
      line_a, line_b, line_c = nil, nil, nil
    end)

    it("should return true when a line is parallel", function()
      assert.is_true(line_a:parallel(line_b))
      assert.is_true(line_b:parallel(line_a))
    end)

    it("should return false when a line is not parallel", function()
      assert.is_false(line_b:parallel(line_c))
      assert.is_false(line_a:parallel(line_c))
    end)
  end)

  describe("Line:intersects", function()
    local line_a, line_b, line_c, line_d

    setup(function()
      line_a = Line.new(0, 0, 100, 100)
      line_b = Line.new(0, 50, 100, 50)
      line_c = Line.new(0, 100, 100, 100)
      line_d = Line.new(20, 0, 120, 100)
    end)

    teardown(function()
      line_a, line_b, line_c, line_d = nil, nil, nil, nil
    end)

    it("should return a line to the point of intersection when a line intersects", function()
      assert.is.truthy(line_a:intersects(line_b))
      assert.is.truthy(line_d:intersects(line_b))
    end)

    it("should return nil when a line does not intersect", function()
      assert.is.falsy(line_a:intersects(line_c))
      assert.is.falsy(line_a:intersects(line_d))
    end)
  end)
end)
