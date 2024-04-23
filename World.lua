local Entity = require 'Entity'

local World = {
  entities = {},
  systems = {}
}

function World:register(system)
  table.insert(self.systems, system)
  return system
end

function World:getAllWith(requires)
  local matched = {}

  for i = 1, #self.entities do
    local ent = self.entities[i]
    local matches = true

    for j = 1, #requires do
      if ent:get(j) == nil then
        matches = false
      end
    end
    if matches then table.insert(matched, ent) end
  end
  return matched
end

function World:assemble(components)

  local ent = self:create()

  for i, v in ipairs(components) do
    assert(type(v) == "table" , "World:assemble requires a table of tables")
    assert(#v > 0)
    local fn = v[1]
    assert(type(fn) == "function")
    
    if #v == 1 then
      ent:add(fn())
    else
      local args = {}
      for i = 2, #v do
        table.insert(args, v[i])
      end
      ent:add(fn(unpack(args)))
    end
  end

  return ent
end

function World:create()
  local entity = Entity.new()
  table.insert(self.entities, entity)
  return entity
end

function World:update(dt)
  for i = #self.entities, 1, -1 do
    local entity = self.entities[i]
    if entity.remove then
      for i, system in ipairs(self.systems) do
        if system:match(entity) then
          system:destroy(entity)
        end
      end
      table.remove(self.entities, i)
    else
      for i, system in ipairs(self.systems) do
        if system:match(entity) then
          if entity.loaded == false then
            system:load(entity)
          end
          system:update(dt, entity)
        end
        entity.loaded = true
      end
    end
  end
end

function World:draw()
  for i = 1, #self.entities do
    local entity = self.entities[i]
    for i, system in ipairs(self.systems) do
        if system:match(entity) then
          system:draw(entity)
        end
      end
  end
end
return World