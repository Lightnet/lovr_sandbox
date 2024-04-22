--[[
  application
  TODO:
   * chat
   * network
   * 
]]

local app = {}
--state
local menu_state = "network"
local network_state = "none"
--hand pointer
local tips = {}
local isFirstFrame = true

-- //////////////////////////////////////////////
-- UI BUTTON
-- //////////////////////////////////////////////

local function uiButton(text,fn,pos)
  if pos == nil then
    pos = lovr.math.newVec3(0, 0, -3)
  end

  return {
    text = text,
    fn = fn,
    textSize = .1,
    position = pos, --lovr.math.newVec3(0, 1, -3),
    width = 1.0,
    height = .4,
    hover = false,
    active = false
  }
end

-- //////////////////////////////////////////////
-- Ray Cast for button plane
-- //////////////////////////////////////////////
local function raycast(rayPos, rayDir, planePos, planeDir)
  local dot = rayDir:dot(planeDir)
  if math.abs(dot) < .001 then
    return nil
  else
    local distance = (planePos - rayPos):dot(planeDir) / dot
    if distance > 0 then
      return rayPos + rayDir * distance
    else
      return nil
    end
  end
end

-- //////////////////////////////////////////////
-- BUTTON TEST
-- //////////////////////////////////////////////

local button = {
  text = 'Please click me',
  textSize = .1,
  count = 0,
  position = lovr.math.newVec3(0, 1, -3),
  width = 1.0,
  height = .4,
  hover = false,
  active = false
}

-- ui button update
local function update_ui()
  button.hover, button.active = false, false

  for i, hand in ipairs(lovr.headset.getHands()) do
    tips[hand] = tips[hand] or lovr.math.newVec3()

    -- Ray info:
    local rayPosition = vec3(lovr.headset.getPosition(hand .. '/point'))
    local rayDirection = vec3(quat(lovr.headset.getOrientation(hand .. '/point')):direction())

    -- Call the raycast helper function to get the intersection point of the ray and the button plane
    local hit = raycast(rayPosition, rayDirection, button.position, vec3(0, 0, 1))

    local inside = false
    if hit then
      local bx, by, bw, bh = button.position.x, button.position.y, button.width / 2, button.height / 2
      inside = (hit.x > bx - bw) and (hit.x < bx + bw) and (hit.y > by - bh) and (hit.y < by + bh)
    end

    -- If the ray intersects the plane, do a bounds test to make sure the x/y position of the hit
    -- is inside the button, then mark the button as hover/active based on the trigger state.
    if inside then
      if lovr.headset.isDown(hand, 'trigger') then
        button.active = true
      else
        button.hover = true
      end

      if lovr.headset.wasReleased(hand, 'trigger') then
        button.count = button.count + 1
        print('BOOP')
      end
    end

    -- Set the end position of the pointer.  If the raycast produced a hit position then use that,
    -- otherwise extend the pointer's ray outwards by 50 meters and use it as the tip.
    tips[hand]:set(inside and hit or (rayPosition + rayDirection * 50))
  end
end
-- ui button draw
local function draw_ui(pass)
  -- Button background
  if button.active then
    pass:setColor(.4, .4, .4)
  elseif button.hover then
    pass:setColor(.2, .2, .2)
  else
    pass:setColor(.1, .1, .1)
  end
  pass:plane(button.position, button.width, button.height)

  -- Button text (add a small amount to the z to put the text slightly in front of button)
  pass:setColor(1, 1, 1)
  pass:text(button.text, button.position + vec3(0, 0, .001), button.textSize)
  pass:text('Count: ' .. button.count, button.position + vec3(0, .5, 0), .1)

  -- Pointers
  -- for hand, tip in pairs(tips) do
  --   local position = vec3(lovr.headset.getPosition(hand))

  --   pass:setColor(1, 1, 1)
  --   pass:sphere(position, .01)

  --   if button.active then
  --     pass:setColor(0, 1, 0)
  --   else
  --     pass:setColor(1, 0, 0)
  --   end

  --   pass:line(position, tip)
  -- end
end

local function draw_ui_menu(pass)
end

-- //////////////////////////////////////////////
-- PYHSICS
-- //////////////////////////////////////////////

-- https://lovr.org/docs/Pass:box
function draw_ground(pass)
  local pos = lovr.math.vec3(0,0,0)
  local size = lovr.math.vec3(1,1,1)
  local rot = lovr.math.quat()

  pass:cube(pos, size, rot, 'line')

  pos.x = 1
  pass:cube(pos, size, rot, 'line')
end

function set_up_physics_boxes()
  world = lovr.physics.newWorld()
  world:setLinearDamping(.01)
  world:setAngularDamping(.005)

  -- Create the ground
  world:newBoxCollider(0, 0, 0, 50, .05, 50):setKinematic(true)

  -- Create boxes!
  boxes = {}
  for x = -1, 1, .25 do
    for y = .125, 2, .2499 do
      local box = world:newBoxCollider(x, y, -2 - y / 5, .25)
      table.insert(boxes, box)
      box:setFriction(.8)
    end
  end

  controllerBoxes = {}

  lovr.timer.step() -- Reset the timer before the first update
  lovr.graphics.setBackgroundColor(.8, .8, .8)
end


function update_physics_boxes(dt)
  -- Update the physics simulation
  world:update(1 / 60)

  -- Place boxes on controllers
  for i, hand in ipairs(lovr.headset.getHands()) do
    if not controllerBoxes[i] then
      controllerBoxes[i] = world:newBoxCollider(0, 0, 0, .25)
      controllerBoxes[i]:setKinematic(true)
    end
    controllerBoxes[i]:setPose(lovr.headset.getPose(hand))
  end
end

-- A helper function for drawing boxes
function drawBox(pass, box)
  local x, y, z = box:getPosition()
  pass:cube(x, y, z, .25, box:getOrientation())
end

function draw_boxes(pass)
  pass:setShader(shader)

  pass:setColor(1, 0, 0)
  for i, box in ipairs(boxes) do
    drawBox(pass, box)
  end

  if lovr.headset.getDriver() ~= 'desktop' then
    pass:setColor(0, 0, 1)
    for i, box in ipairs(controllerBoxes) do
      drawBox(pass, box)
    end
  end
end

-- //////////////////////////////////////////////
-- NETWORK
-- //////////////////////////////////////////////

local net_buttons = {}

function setup_menu_network()
  table.insert(net_buttons,uiButton(
    "Host",
    function()
      print("Host")
      menu_state="chat"
    end,
    lovr.math.newVec3(0, 1.0, -3)
  ))
  table.insert(net_buttons,uiButton(
    "Join",
    function()
      print("Join")
      menu_state="chat"
    end,
    lovr.math.newVec3(0, 0.5, -3)
  ))
  table.insert(net_buttons,uiButton(
    "Quit",
    function()
      print("Quit")
    end--,
    --lovr.math.newVec3(0, 0, -3)
  ))
end

function menu_network_draw(pass)
  local button_len = #net_buttons

  for i, button in ipairs(net_buttons) do
    -- Button background
    if button.active then
      pass:setColor(.4, .4, .4)
    elseif button.hover then
      pass:setColor(.2, .2, .2)
    else
      pass:setColor(.1, .1, .1)
    end
    pass:plane(button.position, button.width, button.height)
    -- Button text (add a small amount to the z to put the text slightly in front of button)
    pass:setColor(1, 1, 1)
    pass:text(button.text, button.position + vec3(0, 0, .001), button.textSize)
  end
end

function pointer_hand(pass)
  -- Pointers
  for hand, tip in pairs(tips) do
    local position = vec3(lovr.headset.getPosition(hand))

    pass:setColor(1, 1, 1)
    pass:sphere(position, .01)

    if button.active then
      pass:setColor(0, 1, 0)
    else
      pass:setColor(1, 0, 0)
    end

    pass:line(position, tip)
  end
end

function menu_network_update()

  local button_len = #net_buttons

  for i, button in ipairs(net_buttons) do
    button.hover, button.active = false, false

    for ii, hand in ipairs(lovr.headset.getHands()) do
      tips[hand] = tips[hand] or lovr.math.newVec3()

      -- Ray info:
      local rayPosition = vec3(lovr.headset.getPosition(hand .. '/point'))
      local rayDirection = vec3(quat(lovr.headset.getOrientation(hand .. '/point')):direction())

      -- Call the raycast helper function to get the intersection point of the ray and the button plane
      local hit = raycast(rayPosition, rayDirection, button.position, vec3(0, 0, 1))

      local inside = false
      if hit then
        local bx, by, bw, bh = button.position.x, button.position.y, button.width / 2, button.height / 2
        inside = (hit.x > bx - bw) and (hit.x < bx + bw) and (hit.y > by - bh) and (hit.y < by + bh)
      end

      -- If the ray intersects the plane, do a bounds test to make sure the x/y position of the hit
      -- is inside the button, then mark the button as hover/active based on the trigger state.
      if inside then
        if lovr.headset.isDown(hand, 'trigger') then
          button.active = true
        else
          button.hover = true
        end

        if lovr.headset.wasReleased(hand, 'trigger') then
          --button.count = button.count + 1
          button.fn()
          print('BOOP')
        end
      end

      -- Set the end position of the pointer.  If the raycast produced a hit position then use that,
      -- otherwise extend the pointer's ray outwards by 50 meters and use it as the tip.
      tips[hand]:set(inside and hit or (rayPosition + rayDirection * 50))
    end
  end
end


-- //////////////////////////////////////////////
-- CHAT
-- //////////////////////////////////////////////
local chat_buttons = {}

function setup_menu_chat()
  table.insert(chat_buttons,uiButton(
    "Ping",
    function()
      print("Ping")
    end,
    lovr.math.newVec3(0, 1.0, -3)
  ))

  table.insert(chat_buttons,uiButton(
    "Send",
    function()
      print("Ping")
    end,
    lovr.math.newVec3(0, 0.5, -3)
  ))

  table.insert(chat_buttons,uiButton(
    "Exit",
    function()
      print("Ping")
    end,
    lovr.math.newVec3(0, 0, -3)
  ))
end

function menu_chat_draw(pass)
  --local button_len = #chat_buttons

  for i, button in ipairs(chat_buttons) do
    -- Button background
    if button.active then
      pass:setColor(.4, .4, .4)
    elseif button.hover then
      pass:setColor(.2, .2, .2)
    else
      pass:setColor(.1, .1, .1)
    end
    pass:plane(button.position, button.width, button.height)
    -- Button text (add a small amount to the z to put the text slightly in front of button)
    pass:setColor(1, 1, 1)
    pass:text(button.text, button.position + vec3(0, 0, .001), button.textSize)
  end
end
-- POINT HAND
function pointer_hand(pass)
  -- Pointers
  for hand, tip in pairs(tips) do
    local position = vec3(lovr.headset.getPosition(hand))

    pass:setColor(1, 1, 1)
    pass:sphere(position, .01)

    if button.active then
      pass:setColor(0, 1, 0)
    else
      pass:setColor(1, 0, 0)
    end

    pass:line(position, tip)
  end
end

function menu_chat_update()

  local button_len = #chat_buttons

  for i, button in ipairs(chat_buttons) do
    button.hover, button.active = false, false

    for ii, hand in ipairs(lovr.headset.getHands()) do
      tips[hand] = tips[hand] or lovr.math.newVec3()

      -- Ray info:
      local rayPosition = vec3(lovr.headset.getPosition(hand .. '/point'))
      local rayDirection = vec3(quat(lovr.headset.getOrientation(hand .. '/point')):direction())

      -- Call the raycast helper function to get the intersection point of the ray and the button plane
      local hit = raycast(rayPosition, rayDirection, button.position, vec3(0, 0, 1))

      local inside = false
      if hit then
        local bx, by, bw, bh = button.position.x, button.position.y, button.width / 2, button.height / 2
        inside = (hit.x > bx - bw) and (hit.x < bx + bw) and (hit.y > by - bh) and (hit.y < by + bh)
      end

      -- If the ray intersects the plane, do a bounds test to make sure the x/y position of the hit
      -- is inside the button, then mark the button as hover/active based on the trigger state.
      if inside then
        if lovr.headset.isDown(hand, 'trigger') then
          button.active = true
        else
          button.hover = true
        end

        if lovr.headset.wasReleased(hand, 'trigger') then
          --button.count = button.count + 1
          button.fn()
          print('BOOP')
        end
      end

      -- Set the end position of the pointer.  If the raycast produced a hit position then use that,
      -- otherwise extend the pointer's ray outwards by 50 meters and use it as the tip.
      tips[hand]:set(inside and hit or (rayPosition + rayDirection * 50))
    end
  end
end

-- //////////////////////////////////////////////
-- MAIN SECTION
-- //////////////////////////////////////////////
function app:init(args)
  set_up_physics_boxes()
  setup_menu_network()
  setup_menu_chat()
end

function app:update(dt)
  --update_ui()
  -- update_physics_boxes(dt)
  if menu_state == "network" then
    menu_network_update()
  end
  if menu_state == "chat" then
    menu_chat_update()
  end
end

function app:draw(pass)
  --draw_ui(pass)
  -- draw_boxes(pass)
  -- draw_ground(pass)
  if menu_state == "network" then
    menu_network_draw(pass)
  end

  if menu_state == "chat" then
    menu_chat_draw(pass)
  end

  pointer_hand(pass)
end

return app