
World = require("world")
Map = require("map")
Llama = require("actors.llama")
Scientist = require("actors.scientist")
Vent = require("actors.vent")
Console = require("actors.console")

time = 0
speed = 200
aux = 0
local world, map, llama, scientist, vent, console

-- A list of drawable objects
local drawList = {}

-- Sorting function
function drawSort(a,b) return a.zindex < b.zindex end


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

  drawList[1] = Llama { x = 100,
                  y = 200,
                  zindex = 0,
                  sprites = load_llama_sprites() }

 

  world:set_map(map)
end

function love.update(dt)
  world:update(dt)
  
  drawList[2] = Scientist { x = 900,
                          y = 400,
                          zindex = 1,
                          sprites = "Scientist-Comp/Animations.png" }

  drawList[3] = Console { x = 900,
                      y = 400,
                      zindex = 1,
                      sprites = "industrial/console/console-active.png" }
  drawList[4]= Vent {x = 900,
               y = 400,
               zindex = 1,
               sprites = "industrial/vent/vent.png"}
end

function love.draw()
  --map:draw()

  local prob = love.math.random(1,1000)
  local prob2 = love.math.random(1,1000)
  local prob3 = love.math.random(1,1000)
  local drawn = false -- true when the character has been drawn
 
  for i,v in ipairs(drawList) do
      if not drawn then
          world:add_actor(drawList[i])
          drawn = true
      end
  if prob < 5 then
    print("SCIENTIST")
    world:add_actor(drawList[1])
  end
  if prob2 < 10 then
    print("VENT")
    world:add_actor(drawList[3])
  end
  if prob3 < 10 then
    print("CONSOLE")
    world:add_actor(drawList[2])
  end
   end
 
  if not drawn then -- if the person is below all objects it won't be drawn within the for loop
    world:add_actor(drawList[i])
  end

  --map:move(dt, speed)
  if love.keyboard.isDown("space") then
    drawList[1]:jump()
  end
  world:draw()

end
