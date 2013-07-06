local AStar = class('AStar')
local PriorityQueue = require 'lib/priority_queue'

function AStar:initialize(adjacency, cost, distance)
  assert(type(adjacency) == "function")
  assert(type(cost) == "function")
  assert(type(distance) == "function")

  self.adjacency = adjacency
  self.cost = cost
  self.distance = distance
end

local function reconstruct_path(came_from, current_node)
  if came_from[current_node] then
    local path = reconstruct_path(came_from, came_from[current_node])
    table.insert(path, current_node)
    return path
  else
    return {current_node}
  end
end

function AStar:find_path(start, goal)
  local closed_set, open_set, came_from = {}, PriorityQueue:new(), {}

  g_score = {}
  f_score = {}
  g_score[start] = 0
  f_score[start] = g_score[start] + self.distance(start, goal)

  open_set:enqueue(f_score[start], start)

  while not open_set:empty() do
    local current = open_set:pop()
    if current == goal then
      return reconstruct_path(came_from, goal)
    end

    closed_set[current] = true
    -- expects and iterator in the style of ipairs
    for _, neighbor in self.adjacency(current) do
      local tentative_g_score = g_score[current] + self.cost(current, neighbor)
      if not (closed_set[neighbor] and tentative_g_score >= g_score[neighbor]) then

        local neighbor_in_open_set = open_set:contains(neighbor)
        if not neighbor_in_open_set or tentative_g_score < g_score[neighbor] then
          came_from[neighbor] = current
          g_score[neighbor] = tentative_g_score
          f_score[neighbor] = g_score[neighbor] + self.distance(neighbor, goal)
          if not neighbor_in_open_set then
            open_set:enqueue(f_score[neighbor], neighbor)
          end
        end
      end
    end
  end
  return nil
end

return AStar
