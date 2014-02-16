Map = class('Map', Base)

function Map:initialize(attributes)
  Base.initialize(self)
  for k,v in pairs(attributes or {}) do
    self[k] = v
  end

  self.sections = DictGrid:new()
  self.mask_data = require("data/mask_data3")
end

function Map:add_section(x, y, section)
  section.x, section.y = x, y
  self.sections:set(x, y, section)
  self:create_section_bounds(section)
end

function Map:remove_section(x, y)
  local section = self.sections:get(x, y)
  section:destroy()
  self.sections:set(x, y, nil)
end

function Map:render()
  for x, y, section in self.sections:each() do
    section:render()
  end
end

function Map:bitmask_section(section)
  local function mask_neighbors(x, y, tile)
    local mask_value = 0
    local index = 0
    for dx=-1,1 do
      for dy=-1,1 do
        local ax, ay = x + dx, y + dy
        local adjacent_tile = section:get(ax, ay)
        if ax == x or ay == y then
          local bit_value = 1
          if adjacent_tile then
            bit_value = adjacent_tile.bit_value
          else
            local asx, asy = section.x + dx, section.y + dy
            local adjacent_section = self.sections:get(asx, asy)
            if adjacent_section then
              local nax, nay = math.abs(ax - section.width * dx), math.abs(ay - section.height * dy)
              adjacent_tile = adjacent_section:get(nax, nay)
              if adjacent_tile then
                bit_value = adjacent_tile.bit_value
              end
            end
          end
          -- do the mask
          local tile_mask_value = bit_value * math.pow(2, index)
          mask_value = mask_value + tile_mask_value
          index = index + 1
        end
      end
    end
    return mask_value
  end

  local section_changed = false
  local function mask_tile(x, y, tile)
    local mask_value = mask_neighbors(x, y, tile)
    tile.section = section
    local different_mask = tile:set_mask_data(self.mask_data[mask_value], mask_value)
    if different_mask then section_changed = true end
  end

  if section.masked then
    -- we've already masked this section once so only check the edges
    for x, y, tile in section.grid:each(1,1, section.width, 1) do
      mask_tile(x, y, tile)
    end
    for x, y, tile in section.grid:each(1,2, 1, section.height - 1) do
      mask_tile(x, y, tile)
    end
    for x, y, tile in section.grid:each(section.width,2, 1, section.height - 1) do
      mask_tile(x, y, tile)
    end
    for x, y, tile in section.grid:each(2,section.height, section.width - 2, 1) do
      mask_tile(x, y, tile)
    end
  else
    for x, y, tile in section.grid:each() do
      mask_tile(x, y, tile)
    end
  end
  section.masked = true

  -- the section is different since we masked it so redraw
  if section_changed then
    g.setCanvas(section.canvas)
    g.setColor(COLORS.background_grey:rgb())
    g.rectangle("fill", 0, 0, section.canvas:getWidth(), section.canvas:getHeight())
    for x, y, tile in section.grid:each() do
      tile:render()
    end
    g.setCanvas()
  end
end

function Map:bitmask_sections()
  slowroutine.new(0, function()
    for _, _, section in self.sections:each() do
      self:bitmask_section(section)
      coroutine.yield()
    end
  end)
end

function Map:create_section_bounds(section)
  local w, h = game.tile_width * section.width, game.tile_height * section.height
  local x, y = (section.x - 1) * w, (section.y - 1) * h
  local padding_x, padding_y = 3, 3
  local bound = Bound:new(x + padding_x, y + padding_y, w - (padding_x * 2), h - (padding_y * 2), section)
  section.bounds[bound.id] = bound
end
