require "util"
require "defines"

game.oninit(function()
glob.clones = {}
glob.remains = {}
glob.easy_death = true -- change to not display x coords

-- boolean used for easily testing mod during developement, false gives free items oninit and possibly debug statements
glob.release = false 

-- if set above or difficulty is easy (currently the difficulty can not be chose and it is always 'normal', thus the bool above)
if glob.easy_death or (game.difficulty == defines.difficulty.easy) then 
  glob.easy_death = {}
  glob.easy_death.print = true
  glob.easy_death.remains = true
elseif game.difficulty == defines.difficulty.normal then
  glob.easy_death = {}
  glob.easy_death.print = false
  glob.easy_death.remains = true
else -- hard mode
  glob.easy_death = {}
  glob.easy_death.print = false
  glob.easy_death.remains = false
end

if glob.easy_death.remains then --do nothing

-- comment out this line to turn off death remains (until difficulty is added/determined in freeplay, it is currently always Normal)
elseif (game.difficulty == defines.difficulty.easy) or (game.difficulty == defines.difficulty.normal) then glob.easy_death.remains = true 
else glob.easy_death.remains = false
end

--tell player if Death Printing is true or false
game.player.print("Death Print "..tostring(glob.easy_death.print)) 
--tell player if Death Remains are true or false
game.player.print("Death Remains "..tostring(glob.easy_death.remains)) 
if game.player.character and not glob.release then 
--could just use player.insert but it only makes sense when playing WITH a character
  game.player.character.insert{name="cloning-tank", count=10}
end
end)

game.onload(function()
local reset = false -- change to reset to normal difficulty
  if reset then 
    glob.easy_death = {}
    glob.easy_death.print = false
    glob.easy_death.remains = true
  end
end)

game.onevent(defines.events.onentitydied, function(event)
  if game.player.character and game.player.character.equals(event.entity) then
    writeDebug(glob.clones)
    if glob.easy_death.print then game.player.print("X: "..event.entity.position.x.." Y: "..event.entity.position.y) end
    --remove any invalid cloning-tanks (from being mined or destroyed)
    for k,clone in ipairs (glob.clones) do 
      if clone.entity.valid == false then table.remove(glob.clones, k) end
    end
    
    local activeClone = false
    for k, clone in ipairs(glob.clones) do
      if clone.active then
        activeClone = k
        break
      end
    end
    if activeClone then
      -- set to false for up to a minute (assuming power is maintained)
      glob.clones[activeClone].active = false 
      -- and prevent game from ending
      game.setgamestate{gamefinished=false, playerwon=false} 
      
      local maxrep = 10
      local position = 0
      writeDebug(glob.clones[activeClone])
      repeat --find a place that will not be inside of an entity
        position = game.findnoncollidingposition("player", glob.clones[activeClone].entity.position, 100, 1)
        maxrep = maxrep - 1
      until (position ~= 0 or maxrep == 0)
      writeDebug(position)
      if position == 0 then position = glob.clones[activeClone].entity.position end
      
      --spawn 'clone' near cloning tank (or in the cloning tank if a suitable position was not found!)
      local clone=game.createentity{name="player", position=position, force=event.entity.force} 
      game.player.character = clone
      
      writeDebug(glob.easy_death.remains)
      if glob.easy_death.remains then 
        writeDebug("Creating remains at death point")
        --create player's remains at death location
        local remains = game.createentity{name="player-remains", position=event.entity.position, force=game.forces.neutral} 
        writeDebug("created remains", remains.valid)
        writeDebug("remains failed", not remains.valid)
        -- add remains to glob.remains table (so they can be removed when empty)
        table.insert(glob.remains, remains) 
        local inv = {}
        do  -- swap inventories, note: do block for folding in vim only!
          inv[1] = event.entity.getinventory(defines.inventory.playerquickbar).getcontents()
          inv[2] = event.entity.getinventory(defines.inventory.playermain).getcontents()
          inv[3] = event.entity.getinventory(defines.inventory.playerguns).getcontents()
          inv[4] = event.entity.getinventory(defines.inventory.playertools).getcontents()
          inv[5] = event.entity.getinventory(defines.inventory.playerammo).getcontents()
          inv[6] = event.entity.getinventory(defines.inventory.playerarmor).getcontents()
        end
        --writeDebug(inv)
        for _,table in pairs (inv) do
          for name, count in pairs(table) do
            remains.insert{name=name,count=count}        
          end
        end
      end
    end
  end
end)

-- add tank to glob.clones table
game.onevent(defines.events.onbuiltentity, function(event) 
  if event.createdentity.name == "cloning-tank" then
    writeDebug("new cloning tank")
    table.insert(glob.clones, {entity=event.createdentity, active=true})
  end
end)

-- check for empty remains every 10 seconds
game.onevent(defines.events.ontick, function(event) 
  if glob.easy_death.remains and (game.tick%(60*10) == 0) then
    for k,remains in ipairs (glob.remains) do
      if remains.valid and remains.getinventory(defines.inventory.chest).getitemcount() == 0 then
        remains.die()
        table.remove(glob.remains, k)
      end
    end
  end
  
  if event.tick%3600 == 0 then --every minute
    --remove any invalid cloning-tanks (from being mined or destroyed)
    for k,clone in ipairs (glob.clones) do 
      if not clone.valid then table.remove(glob.clones, k) end
    end
    
    for k, clone in pairs(glob.clones) do 
      if clone.entity.energy and clone.entity.recipe == "maintain_clone" then --
        if not clone.active then clone.active = true end
      else
        if clone.active then clone.active = false end
      end
    end
  end
end)

function writeDebug(message, conditions)
  local conditionsMet = true
  if conditions then
    if type(conditions) == "boolean" then
      conditionsMet = conditions
    elseif type(conditions) == "table" then
      for _, condition in pairs(conditions) do
        if type(condition) == "boolean" and not condition then conditionsMet = false end
      end
    end
  end
  if not glob.release and conditionsMet then game.player.print(serpent.block(message)) end
end
