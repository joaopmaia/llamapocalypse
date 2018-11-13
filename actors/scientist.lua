
Actor = require("actor")

Scientist = {
  _tick = 0,
  _quads = {},
  _interval = 0.05,
  _sprite_control = 0,
  _zindex = 0
}

Scientist.__index = Scientist

setmetatable (Scientist, {
  __index = Actor,
  __call = function (cls, ...)
    local self = setmetatable ({}, cls)
    self:_init (...)
    return self
  end })

function Scientist:_init (args)
  assert(args.x and args.y)
  Actor._init (self, args.x, args.y)
  self:set_type ("scientist")
  if args.sprites then
    self._sprites = love.graphics.newImage(args.sprites)
  end
  self._zindex = args.zindex
  self:set_max_height(args.max_height or -950)
  local width = self._sprites:getWidth() / 5
  local height = self._sprites:getHeight() / 7
  for i = 0, 3 do
    self._quads[i] = love.graphics.newQuad(width * i, height,
                                           width, height,
                                           self._sprites:getDimensions())
  end
  self:set_width(width * 3)
  self:set_height(height * 3)
  local level = love.math.random(0,3)
end

function Scientist:jump()
  if self:get_y_velocity() == 0 then
    self:set_y_velocity(self:get_max_height())
  end
end

function Scientist:jumper()
  local prob2 = love.math.random(0,100)
  if level == 0 then
    print("level 0")
    if prob2 > 2 then
      Scientist:jump()
    end
  end
  if level == 1 then
    print("level 1")
    if prob2 < 8 then
      Scientist:jump()
    end
  end
  if level == 2 then
    print("level 2")
    if prob2 < 14 then
      Scientist:jump()
    end
  end
  if level == 3 then
    print("level 3")
    if prob2 < 20 then
      Scientist:jump()
    end
  end
  -- body
end

function Scientist:draw ()
  love.graphics.draw(self._sprites, self._quads[self._sprite_control], self:get_x() + self:get_width(), self:get_y(), 0, -3, 3)
end

function Scientist:update (dt)
  self._tick = self._tick + dt
  if self._tick > self._interval then
    self._sprite_control = (self._sprite_control + 1) % (#self._quads + 1)
    self._tick = 0
  end
  self:set_x(self:get_x() - self:get_world():get_speed() * dt)
  if self:get_x() < 0 then
    self:get_world():delete_actor(self)
  end
  Scientist:jumper()
end

return Scientist
