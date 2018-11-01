Map = require("map")
Llama = require("llama")

time = 0
local map, llama

function love.load()
  love.physics.setMeter(64)
  world = love.physics.newWorld(0, 2000, true)
  map = Map { tileset = { "LAB/wall/tile065.png",
                          "LAB/wall/tile066.png",
                          "LAB/wall/tile068.png",
                          "LAB/wall/tile069.png" } }
  local llama_sprite = {}
  for i = 0, 5 do
    llama_sprite[i] = "llama/lhama_" .. i .. ".png"
  end
  llama = Llama { world = world,
                  sprite_width = 100, 
                  sprites = llama_sprite }
end


function love.update(dt)
  time = time + dt
  world:update(dt)
  map:move(dt)
  llama:move(dt)
  if love.keyboard.isDown("up") then
    llama:apply_force(time, 0, -2000)
  end
  if love.keyboard.isDown("left") then
    llama:apply_force(time, -1000, 0)
  end
  if love.keyboard.isDown("right") then
    llama:apply_force(time, 1000, 0)
  end
end

function love.draw()
  map:draw()
  llama:draw()
end
