
World = require("world")
Map = require("map")
Llama = require("actors.llama")
Scientist = require("actors.scientist")
Console = require("actors.console")
Vent = require("actors.vent")
Laser = require("actors.laser")
Engi = require("actors.engi")

time = 0
speed = 200
local world, map
llama_count = 0
llamas = {}
end_sprites = {}

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
  llama_count = llama_count + 1
  local llama = Llama { x = love.math.random(love.graphics.getWidth() * 0.7),
                        y = 200,
                        sprites = load_llama_sprites() }
  llama:set_collision_cb(clone_llama)
  table.insert(llamas, llama)
  world:add_actor(llama)
  if llama_count == 4 then
    gamestate = "over"
  end
end
gamestate = "title"
music = {}
function love.load()
  music = love.audio.newSource("Decoration/lab2.wav", "stream")
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
  for i = 0, 5 do
    end_sprites[i] = love.graphics.newImage("Decoration/clone_" .. i .. ".png")
  end

  llama:set_collision_cb(clone_llama)
  table.insert(llamas, llama)
  world:set_map(map)
  world:add_actor(llama)

end
 con = 0
 pontos = 0
 ven = 0
 timerCon = 0
 timerVent = 0
 decor = 0
 endtick = 0
 endcontrol = 0
 

function love.update(dt)
  if gamestate == "title" then
    if love.keyboard.isDown("space") then
      gamestate = "play"
    end
    if love.keyboard.isDown("q") then
      gamestate = "easteregg"
    end
  elseif gamestate == "over" then
    endtick = endtick + dt/dt
    music:stop()
  if endtick > 8 then
    if endcontrol == 5 then
      endcontrol = 0
    end
    endcontrol = (endcontrol + 1) % 6   
    endtick = 0
  end
    if love.keyboard.isDown("space") then
      gamestate = "title"
      love.event.quit( "restart" )
    end
  elseif gamestate == "easteregg" then
    if love.keyboard.isDown("space") then
      gamestate = "title"
    end
  else
    music:play()
    con = dt + con
    timerCon = love.math.random(1,6)
    print(timerCon)
    ven = dt + ven
    timerVent = math.random(1,2)
    decor = math.random(1,3)
    pontos = pontos + dt/dt
    local prob_sci = love.math.random(1,1000)

    if prob_sci > 5 then
      local sci = Scientist { x = 900,
                              y = 400,
                              sprites = "Scientist-Comp/Animations.png" }
      world:add_actor(sci)
    end

    if timerCon < con then 
      con = 0
      if decor == 1 then 
        local cons = Console { x = 900,
                               y = 400,
                               sprites = "industrial/console/console-active.png" }
        world:add_actor(cons)
      end
      if decor == 2 then
        local laser = Laser { x = 900,
                               y = 400,
                               sprites = "industrial/laser/laser-turn-off.png" }
        world:add_actor(laser)
      end
      if decor == 3 then
        local cons = Console { x = 900,
                               y = 400,
                               sprites = "industrial/console/console-active.png" }
        world:add_actor(cons)
      end
    end

    if timerVent < ven then 
      ven = 0
      local vent = Vent { x = 900,
                             y = 400,
                             sprites = "industrial/vent/vent.png" }
      world:add_actor(vent)
    end

    world:update(dt)
    if love.keyboard.isDown("space") then

      for _, llama in pairs(llamas) do
        llama:jump()
      end

    end
  end
end

function love.draw()
  if gamestate == "title" then
     telaini = love.graphics.newImage("Decoration/TELA.png")
     love.graphics.draw(telaini, 0, 0)
    love.graphics.print("Aperte espaço para começar o jogo!", 285, 290 )
  elseif gamestate == "over" then
    love.graphics.draw(end_sprites[endcontrol], 0,0)
    love.graphics.print("Game Over! Aperte espaço para ir ao menu inicial.", 285, 290 )
  elseif gamestate == "easteregg" then
    local easteregg = love.graphics.newImage("Decoration/easteregg.png")
    love.graphics.draw(easteregg, 0, 0)
  else
    world:draw()
    love.graphics.print("Pontuação: " .. pontos, 550, 10, 0, 2 )
  end
end
