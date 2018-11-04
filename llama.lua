
Llama = {
  _dt = 0,
  _quad = nil,
  _body = nil,
  _shape = nil,
  _fixture = nil,
  _interval = 0.05,
  _sprite_control = 0,
  _jumps = 0,
  _jump_tick = 0,
  world = nil,
  sprite_width = 0,
  sprite_heigth = 0,
}

Llama.__index = Llama

setmetatable (Llama, {
  __call = function (cls, ...)
    local self = setmetatable ({}, cls)
    self:_init (...)
    return self
  end })

function Llama:_init (...)
  local args = ...
  self.world = args.world
  self.sprite_width = args.sprite_width or 50
  self.sprite_heigth = args.sprite_heigth or self.sprite_width
  self._body = love.physics.newBody(self.world, 800 * 0.25, 600 * 0.25, "dynamic")
  self._shape = love.physics.newRectangleShape(self.sprite_width, self.sprite_heigth)
  self._fixture = love.physics.newFixture(self._body, self._shape, 1)
  self._fixture:setUserData("llama")
  self._quad = love.graphics.newQuad(0, 0,
                                     self.sprite_width, self.sprite_heigth,
                                     self.sprite_width, self.sprite_heigth)
  self._sprites = {}
  if args.sprites then
    for index, file in pairs(args.sprites) do
      self._sprites[index] = love.graphics.newImage(file)
    end
  end
end

function Llama:draw ()
  love.graphics.draw(self._sprites[self._sprite_control], self._quad, self._body:getX(), self._body:getY())
end

function Llama:move (dt)
  self._dt = self._dt + dt
  if self._dt > self._interval then
    self._sprite_control = (self._sprite_control + 1) % (#self._sprites + 1)
    self._dt = 0
  end
end

function Llama:reset_jumps ()
  self._jumps = 0
end

function Llama:jump(time)
  if self._jump_tick == 0 then
    self._jump_tick = time
  end
  dt = time - self._jump_tick
  if self._jumps == 0 or dt > 0.2 and self._jumps < 2 then
    self._body:applyLinearImpulse(0, -1800)
    self._jumps = self._jumps + 1
  end
  self._jump_tick = time
end

return Llama
