
--[[
  
]]

local app = require 'app'

function lovr.load(args)
  -- This is called once on load.
  --
  -- You can use it to load assets and set everything up.
  -- local width = lovr.system.getWindowHeight()
  -- local height = lovr.system.getWindowHeight()
  -- print("Width: " .. width .. " Height: " .. height)

  -- print('loaded!')
  app:init(args)
end

function lovr.update(dt)
  -- This is called continuously and is passed the "delta time" as dt, which
  -- is the number of seconds elapsed since the last update.
  --
  -- You can use it to simulate physics or update game logic.

  --print('updating', dt)
  app:update(dt)
end

function lovr.draw(pass)
  -- This is called once every frame.
  --
  -- You can call functions on the pass to render graphics.
  --print('rendering')
  --pass:text('hello world', 0, 1.7, -3, .5)
  --https://lovr.org/docs/Pass:cube
  --pass:cube(0, 1.7, -1, .5, lovr.headset.getTime(), 0, 1, 0, 'line')
  app.draw(pass)
end