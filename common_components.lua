--///////////////////////////////////////////////
-- ECS
--///////////////////////////////////////////////
local Component = require 'component'

return {
  new_body = function(x,y)
    local body = Component.new "body"
    body.x = x
    body.y = y
    return body
  end,
  new_rectangle_component = function ()
    return Component.new "rect"
  end,
  functional = function(fn)
    local functional = Component.new "functional"
    functional.fn = fn
    return functional
  end
}

-- local player_type = {
--   {new_body, 300, 100},
--   {new_rectangle_component}
-- }