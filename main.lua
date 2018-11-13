
World = require("world")
Map = require("map")
Llama = require("actors.llama")
Scientist = require("actors.scientist")
Console = require("actors.console")

time = 0
speed = 200
local world, map

llamas = {}

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

function clone_llama()
  local llama = Llama { x = love.math.random(love.graphics.getWidth() * 0.7),
                        y = 200,
                        sprites = load_llama_sprites() }
  llama:set_collision_cb(clone_llama)
  table.insert(llamas, llama)
  world:add_actor(llama)
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

  local llama = Llama { x = love.math.random(love.graphics.getWidth() * 0.7),
                        y = 200,
                        sprites = load_llama_sprites() }

  llama:set_collision_cb(clone_llama)
  table.insert(llamas, llama)
  world:set_map(map)
  world:add_actor(llama)
end

function love.update(dt)
  local prob_sci = love.math.random(1,1000)
  local prob_cons = love.math.random(1,1000)
  if prob_sci < 5 then
    local sci = Scientist { x = 900,
                            y = 400,
                            sprites = "Scientist-Comp/Animations.png" }
    world:add_actor(sci)
  end
  if prob_cons < 10 then 
    local cons = Console { x = 900,
                           y = 400,
                           sprites = "industrial/console/console-active.png" }
    world:add_actor(cons)
  end
  world:update(dt)
  if love.keyboard.isDown("space") then
    for _, llama in pairs(llamas) do
      llama:jump()
    end
  end
end

function love.draw()
  world:draw()
end
