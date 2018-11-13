
Actor = require("actor")

Llama = {
  _tick = 0,
  _quad = nil,
  _interval = 0.05,
  _sprite_control = 0,
  _zindex = 1
}

Llama.__index = Llama

setmetatable (Llama, {
  __index = Actor,
  __call = function (cls, ...)
    local self = setmetatable ({}, cls)
    self:_init (...)
    return self
  end })

function Llama:_init (args)
  assert(args.x and args.y)
  Actor._init (self, args.x, args.y)
  self:set_type("llama")
  self:set_collision_list({ "scientist" })
  self:set_max_height(args.max_height or -950)
  self._sprites = {}
  self._zindex = args.zindex
  if args.sprites then
    for index, file in pairs(args.sprites) do
      self._sprites[index] = love.graphics.newImage(file)
      self:set_width(args.sprite_width or self._sprites[index]:getWidth() * 2)
      self:set_height(args.sprite_height or self._sprites[index]:getHeight() * 2)
    end
  end
  self._quad = love.graphics.newQuad(0, 0,
                                     self:get_width(), self:get_height(),
                                     self:get_width() , self:get_height())
end

function Llama:draw ()
  love.graphics.draw(self._sprites[self._sprite_control], self._quad, self:get_x(), self:get_y())
end

function Llama:update (dt)
  self._tick = self._tick + dt
  if self._tick > self._interval then
    self._sprite_control = (self._sprite_control + 1) % (#self._sprites + 1)
    self._tick = 0
  end
end

function Llama:jump()
  if self:get_y_velocity() == 0 then
    self:set_y_velocity(self:get_max_height())
  end
end

return Llama
