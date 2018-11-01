
Llama = {
  _dt = 0,
  _quad = nil,
  _body = nil,
  _shape = nil,
  _fixture = nil,
  _interval = 0.05,
  _sprite_control = 0,
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
  self._body = love.physics.newBody(self.world, 100, 100, "dynamic")
  self._shape = love.physics.newRectangleShape(self.sprite_width, self.sprite_heigth)
  self._fixture = love.physics.newFixture(self._body, self._shape, 1)
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

last_time = 0
force_count = 0

function Llama:apply_force(time, fx, fy)
  if last_time == 0 then
    last_time = time
  end
  dt = time - last_time
  if dt > 0.04 then
    print(dt)
    self._body:applyLinearImpulse(fx, fy)
  end
  last_time = time
end

return Llama
