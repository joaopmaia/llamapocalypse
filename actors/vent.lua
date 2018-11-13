
Actor = require("actor")

Vent = {
  _tick = 0,
  _quads = {},
  _interval = 0.05,
  _sprite_control = 0,
  _world = nil,
  _sprites = nil,
  _zindex = 0
}

Vent.__index = Vent

setmetatable (Vent, {
  __index = Actor,
  __call = function (cls, ...)
    local self = setmetatable ({}, cls)
    self:_init (...)
    return self
  end })

function Vent:_init (args)
  assert(args.x and args.y)
  Actor._init (self, args.x, args.y)
  self:set_type ("vent")
  self._y = args.y
  self._zindex = args.zindex
  if args.sprites then
    self._sprites = love.graphics.newImage(args.sprites)
  end
  local width = self._sprites:getWidth() / 5
  local height = self._sprites:getHeight()
  for i = 0, 4 do
    self._quads[i] = love.graphics.newQuad(width * i, 0,
                                           width, height,
                                           self._sprites:getDimensions())
  end
end

function Vent:draw ()
  love.graphics.draw(self._sprites, self._quads[self._sprite_control], self:get_x() + self:get_width(), 450, 0, -3, 3)

end

function Vent:update (dt)
  self._tick = self._tick + dt
  if self._tick > self._interval then
    self._sprite_control = (self._sprite_control + 1) % (#self._quads + 1)
    self._tick = 0
  end
  self:set_x(self:get_x() - self:get_world():get_speed() * dt)
end

return Vent
