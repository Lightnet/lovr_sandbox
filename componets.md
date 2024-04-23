


```lua

  local entity = World:create()
  entity:add(new_body(100,100))
  entity:add(new_rectangle_component())
```


```lua
  local player_type = {
    {new_body, 300, 100},
    {new_rectangle_component}
  }
  local test = World:assemble(player_type)
```

```lua
  local test2 = World:assemble {
    {new_body, 300, 100},
    {new_rectangle_component}
  }
```

```lua
local entity1 = World:create()
entity1:madd(new_body(100,100))
  :madd(new_rectangle_component())
```

```lua
World:create()
  :madd(new_body(100,100))
  :madd(new_rectangle_component())
```


```lua
local test2 = World:assemble {
  {coms.new_body, 300, 100},
  {coms.new_rectangle_component}
}
test2:add(coms.functional(function(self, dt)
  --print("hello world")
  local body = self:get "body"
  body.x = body.x + dt * 10
end))
```