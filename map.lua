
Map = {
  _world = {},
  _map = {},
  _ground = {},
  _wall_tileset = {},
  _ground_tileset = {},
  _dirty = false,
  _x = 0,
  _y = 0,
  _xtiles = 0,
  _ytiles = 0,
  _width = 0,
  _height = 0,
}

Map.__index = Map

setmetatable (Map, {
  __call = function (cls, ...)
    local self = setmetatable ({}, cls)
    self:_init (...)
    return self
  end })

function Map:_init (args)
  self._width = args.width or 800
  self._height = args.height or 600
  self.tile_width = args.tile_width or 64
  self.tile_height = args.tile_height or 64
  self._xtiles = math.ceil(self._width / self.tile_width) + 1
  self._ytiles = math.ceil(self._height / self.tile_height)
  self._ground = math.ceil((args.ground or 400) / self.tile_height)
  if self._width % self.tile_width == 0 then
    self._xtiles = self._xtiles + 1
  end
  if self._height % self.tile_height == 0 then
    self._ytiles = self._ytiles + 1
  end
  if args.wall_tileset then
    for index, file in pairs(args.wall_tileset) do
      self._wall_tileset[index] = love.graphics.newImage(file)
    end
    self:_init_map()
  end
  if args.ground_tileset then
    for index, file in pairs(args.ground_tileset) do
      self._ground_tileset[index] = love.graphics.newImage(file)
    end
    self:_init_map()
  end
end

function Map:_init_map ()
  for x = 0, self._xtiles do
    self._map[x] = {}
    for y = 0, self._ytiles do
      self._map[x][y] = love.math.random(#self._wall_tileset)
    end
  end
  self._dirty = true
end

function Map:_pivot_map ()
  for x = 0, self._xtiles do
    for y = 0, self._ytiles do
      if x == self._xtiles then
        self._map[x][y] = love.math.random(#self._wall_tileset)
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
        local tile = nil
        if y == self._ground then
          tile = self._ground_tileset[1]
        else
          tile = self._wall_tileset[self._map[x][y]]
        end
        if x == 0 then
          love.graphics.draw(tile, first_quad, 0, y * self.tile_height)
        elseif x == self._xtiles then
          love.graphics.draw(tile, last_quad, x * self.tile_width - self._x, y * self.tile_height)
        else
          love.graphics.draw(tile, quad, x * self.tile_width - self._x, y * self.tile_height)
        end
      end
    end
    self._dirty = false
  end
end

function Map:update (dt)
  self._x = self._x + self:get_world():get_speed() * dt
  self._dirty = true
end

function Map:get_world ()
  return self._world
end

function Map:set_world (world)
  self._world = world
end

return Map
