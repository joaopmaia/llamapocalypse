
local Actor = {
  _world = nil,
  _type = nil,
  _collision_list = {},
  _x = 0,
  _y = 0,
  _z_index = 0,
  _width = 0,
  _height = 0,
  _max_height = 0,
  _y_velocity = 0,
  _collision_cb = nil,
  _prevent_collision = {}
}

Actor.__index = Actor

setmetatable (Actor, {
  __call = function (cls, ...)
    local self = setmetatable (cls, ...)
    self:_init(...)
    return self
  end
})

function Actor:_init (x, y)
  self._x = x
  self._y = y
end

function Actor:get_world ()
  return self._world
end

function Actor:set_world (world)
  self._world = world
end

function Actor:get_type ()
  return self._type
end

function Actor:set_type (t)
  self._type = t
end

function Actor:get_collision_list ()
  return self._collision_list
end

function Actor:set_collision_list (coll_list)
  self._collision_list = coll_list
end

function Actor:set_collision_cb(func)
  self._collision_cb = func
end

function Actor:can_collide (obj)
  if obj and self:get_type() and self:get_collision_list() then
    for _, coll_type in pairs(self:get_collision_list()) do
      if obj:get_type() == coll_type then
        for _, actor in pairs(self._prevent_collision) do
          if actor == obj then
            return false
          end
        end
        return true
      end
    end
  end
  return false
end

function Actor:get_dimensions()
  return self:get_x(), self:get_y(), self:get_x() + self:get_width(), self:get_y() + self:get_height()
end

function Actor:is_inside_boundaries(actor)
  x1, y1, xw1, yh1 = self:get_dimensions()
  x2, y2, xw2, yh2 = actor:get_dimensions()
  return x1 < xw2 and xw1 > x2 and y1 < yh2 and yh1 > y2
end

function Actor:check_collision (actors)
  if actors then
    for _, actor in pairs(actors) do
      if self ~= actor and self:can_collide(actor) and self:is_inside_boundaries(actor) then
        table.insert(self._prevent_collision, actor)
        self._collision_cb()
      end
    end
  end
end

function Actor:get_x ()
  return self._x
end

function Actor:set_x (x)
  self._x = x
end

function Actor:get_y ()
  return self._y
end

function Actor:set_y (y)
  self._y = y
end

function Actor:get_z_index ()
  return self._z_index
end

function Actor:set_z_index (z_index)
  self._z_index = z_index
end

function Actor:get_width ()
  return self._width
end

function Actor:set_width (width)
  self._width = width
end

function Actor:get_height ()
  return self._height
end

function Actor:set_height (height)
  self._height = height
end

function Actor:get_max_height ()
  return self._max_height
end

function Actor:set_max_height (max_height)
  self._max_height = max_height
end

function Actor:get_y_velocity ()
  return self._y_velocity
end

function Actor:set_y_velocity (y_velocity)
  self._y_velocity = y_velocity
end

function Actor:draw ()
  local _dummy = nil
end

function Actor:update (dt)
  local _dummy = nil
end

return Actor
