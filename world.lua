
World = {
  _width = 0,
  _height = 0,
  _map = nil,
  _speed = 0,
  _ground = 0,
  _gravity = 0,
  _actors = {}
}

World.__index = World

setmetatable (World, {
  __call = function (cls, ...)
    local self = setmetatable ({}, cls)
    self:_init (...)
    return self
  end })

function World:_init (args)
  self._width = args.width or 800
  self._height = args.height or 600
  self._map = args.map or nil
  self._speed = args.speed or 200
  self._ground = args.ground or 400
  self._gravity = args.gravity or -2400
end

function World:add_actor(actor)
  if actor ~= nil then
    actor:set_world(self)
    table.insert(self._actors, actor)
  end
end

function World:set_map(map)
  if map ~= nil then
    map:set_world(self)
    self._map = map
  end
end

function World:get_map()
  return self._map
end

function World:update(dt)
  if self._map then
    self._map:update(dt)
  end
  if self._actors then
    for _, actor in pairs(self._actors) do
      local ground = self._ground - actor:get_height()
      if actor:get_y_velocity() ~= 0 then
        actor:set_y(actor:get_y() + actor:get_y_velocity() * dt)
        actor:set_y_velocity(actor:get_y_velocity() - self._gravity * dt)
      end
      if actor:get_y() > ground then
        actor:set_y_velocity(0)
        actor:set_y(ground)
      end
      if actor:get_y_velocity() == 0 and actor:get_y() < self._ground then
        actor:set_y_velocity(ground - actor:get_y())
      end
      actor:update(dt)
    end
    for _, actor in pairs(self._actors) do
      actor:check_collision(self._actors)
    end
  end
end

function World:draw()
  if self._map then
    self._map:draw()
  end
  if self._actors then
    for _, actor in pairs(self._actors) do
      actor:draw()
    end
  end
end

function World:delete_actor(obj)
  if self._actors then
    for index, actor in pairs(self._actors) do
      if obj == actor then
        actor = nil
        table.remove(self._actors, index)
        collectgarbage()
      end
    end
  end
end

function World:get_speed()
  return self._speed
end

function World:get_width()
  return self._width
end

function World:get_height()
  return self._height
end

return World
