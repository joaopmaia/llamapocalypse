Map = require("map")

local map

function love.load()
  map = Map { tileset = { "LAB/wall/tile065.png",
                          "LAB/wall/tile066.png",
                          "LAB/wall/tile068.png",
                          "LAB/wall/tile069.png" } }
end

function love.update(dt)
  map:move(dt * 0.2, 0)
end

function love.draw()
  map:draw()
end
