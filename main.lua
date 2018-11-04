Map = require("map")
Llama = require("llama")

time = 0
local map, llama

function love.load()
  love.physics.setMeter(64)
  world = love.physics.newWorld(0, 2000, true)
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)
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
  if love.keyboard.isDown("space") then
    --llama:apply_force(time, 0, -2000)
    llama:jump(time)
  end
end

function love.draw()
  map:draw()
  llama:draw()
end

function beginContact(a, b, coll)
  if a:getUserData() == "ground" and b:getUserData() == "llama" or
     a:getUserData() == "llama" or b:getUserData() == "ground" then
    llama:reset_jumps()
  end
end

function endContact(a, b, coll)

end

function preSolve(a, b, coll)

end

function postSolve(a, b, coll)

end
