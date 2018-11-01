
Map = {
  _map = {},
  _ground = {},
  _tileset = {},
  _dirty = false,
  _x = 0,
  _y = 0,
  _xtiles = 0,
  _ytiles = 0,
  _speed = 100,
  width = 0,
  height = 0,
}

Map.__index = Map

setmetatable (Map, {
  __call = function (cls, ...)
    local self = setmetatable ({}, cls)
    self:_init (...)
    return self
  end })

function Map:_init (...)
  local args = ...
  self.width = args.width or 800
  self.height = args.height or 600
  self.tile_width = args.tile_width or 64
  self.tile_height = args.tile_height or 64
  self._xtiles = math.ceil(self.width / self.tile_width) + 1
  self._ytiles = math.ceil(self.height / self.tile_height)
  self._ground.body = love.physics.newBody(world, self.width / 2, self.height - self.tile_height / 2);
  self._ground.shape = love.physics.newRectangleShape(self.width, self.tile_height)
  self._ground.fixture = love.physics.newFixture(self._ground.body, self._ground.shape)
  if self.width % self.tile_width == 0 then
    self._xtiles = self._xtiles + 1
  end
  if self.height % self.tile_height == 0 then
    self._ytiles = self._ytiles + 1
  end
  if args.tileset then
    for index, file in pairs(args.tileset) do
      self._tileset[index] = love.graphics.newImage(file)
    end
    self:_init_map()
  end
end

function Map:_init_map ()
  for x = 0, self._xtiles do
    self._map[x] = {}
    for y = 0, self._ytiles do
      self._map[x][y] = love.math.random(#self._tileset)
    end
  end
  self._dirty = true
end

function Map:_pivot_map ()
  for x = 0, self._xtiles do
    for y = 0, self._ytiles do
      if x == self._xtiles then
        self._map[x][y] = love.math.random(#self._tileset)
      else
        self._map[x][y] = self._map[x + 1][y]
      end
    end
  end
end

function Map:draw ()
  if self._dirty then
    if self._x > self.tile_width then
      self:_pivot_map()
      self._x = self._x % self.tile_width
    end
    local first_quad = love.graphics.newQuad(self._x, 0,
                                             self.tile_width - self._x, self.tile_height,
                                             self.tile_width, self.tile_height)
    local last_quad = love.graphics.newQuad(0, 0,
                                            self.tile_width - self._x, self.tile_height,
                                            self.tile_width, self.tile_height)
    local quad = love.graphics.newQuad(0, 0,
                                       self.tile_width, self.tile_height,
                                       self.tile_width, self.tile_height)
    for x = 0, self._xtiles do
      for y = 0, self._ytiles do
        local tile = self._tileset[self._map[x][y]]
        if x == 0 then
          love.graphics.draw(tile, first_quad, 0, y * self.tile_height)
        elseif x == self._xtiles then
          love.graphics.draw(tile, last_quad, x * self.tile_width - self._x, y * self.tile_height)
        else
          love.graphics.draw(tile, quad, x * self.tile_width - self._x, y * self.tile_height)
        end
      end
    end
    love.graphics.polygon("fill", self._ground.body:getWorldPoints(self._ground.shape:getPoints()))
    self._dirty = false
  end
end

function Map:move (dt)
  self._x = self._x + self._speed * dt
  self._dirty = true
end

return Map
