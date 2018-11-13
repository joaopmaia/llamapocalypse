
World = require("world")
Map = require("map")
Llama = require("actors.llama")
Scientist = require("actors.scientist")

time = 0
speed = 200
local world, map, llama, scientist

function load_llama_sprites ()
  local llama_sprites = {}
  for i = 0, 5 do
    llama_sprites[i] = "llama/lhama_" .. i .. ".png"
  end
  return llama_sprites
end

function load_wall_tileset ()
  return { "LAB/wall/tile065.png",
           "LAB/wall/tile066.png",
           "LAB/wall/tile068.png",
           "LAB/wall/tile069.png" }
end

function love.load()
  world = World { width = love.graphics.getWidth(),
                  height = love.graphics.getHeight(), 
                  ground = 430 }

  map = Map { width = world:get_width(),
              height = world:get_height(),
              wall_tileset = load_wall_tileset(),
              ground_tileset = { "LAB/wall/tile101.png" },
              ground = 350 }

  llama = Llama { x = love.math.random(love.graphics.getWidth() * 0.7),
                  y = 200,
                  sprites = load_llama_sprites() }

  scientist = Scientist { x = 900,
                          y = 400,
                          sprites = "Scientist-Comp/Animations.png" }

  world:set_map(map)
  world:add_actor(llama)
  world:add_actor(scientist)
end

function love.update(dt)
  world:update(dt)
  --map:move(dt, speed)
  if love.keyboard.isDown("space") then
    llama:jump()
  end
end

function love.draw()
  --map:draw()
  world:draw()
end
