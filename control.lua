require "util"
require "defines"

game.oninit(function()
glob.clones = {}
glob.remains = {}
glob.easy_death = true -- change to not display x coords
glob.release = true -- boolean used for easily testing mod during developement, false gives free items oninit and possibly debug statements

if glob.easy_death then
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
elseif (game.difficulty == defines.difficulty.easy) or (game.difficulty == defines.difficulty.normal) then glob.easy_death.remains = true -- comment out this line to turn off death remains (until difficulty is added/determined in freeplay, it is currently always Normal)
else glob.easy_death.remains = false
end

game.player.print("Death Print "..tostring(glob.easy_death.print)) --tell player if Death Printing is true or false
game.player.print("Death Remains "..tostring(glob.easy_death.remains)) --tell player if Death Remains are true or false
if game.player.character and not glob.release then --could just use player.insert but it only makes sense when playing WITH a character
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
    if glob.easy_death.print then game.player.print("X: "..event.entity.position.x.." Y: "..event.entity.position.y) end
    for k,clone in ipairs (glob.clones) do --remove any invalid cloning-tanks (from being mined or destroyed)
      if clone.valid == false then table.remove(glob.clones, k) end
    end
    if glob.clones[1] then
      game.setgamestate{gamefinished=false, playerwon=false} --prevent game from ending
      local clone=game.createentity{name="player", position=glob.clones[1].position, force=event.entity.force} --Make usable character in same location as cloning tank.
      glob.clones[1].destroy() --test only, I would like to have these be reusable (ie take a minute or two and then be able to respawn)
      table.remove(glob.clones,1) --same ^
      game.player.character = clone
      
      if not glob.release then game.player.print(tostring(glob.easy_death.remains)) end
      if glob.easy_death.remains then 
        if not glob.release then game.player.print("Creating remains at death point") end
        local remains = game.createentity{name="player-remains", position=event.entity.position, force=game.forces.neutral} --create player's remains at death location
        if not glob.release and remains.valid then game.player.print("created") end
        glob.remains[#glob.remains+1] = remains -- add remains to glob.remains table (so they can be removed when empty)
        local inv = {}
        inv[1] = event.entity.getinventory(defines.inventory.playerquickbar).getcontents()
        inv[2] = event.entity.getinventory(defines.inventory.playermain).getcontents()
        inv[3] = event.entity.getinventory(defines.inventory.playerguns).getcontents()
        inv[4] = event.entity.getinventory(defines.inventory.playertools).getcontents()
        inv[5] = event.entity.getinventory(defines.inventory.playerammo).getcontents()
        inv[6] = event.entity.getinventory(defines.inventory.playerarmor).getcontents()
        if not glob.release then game.player.print(serpent.block(inv)) end
        for _,table in pairs (inv) do
          for name, count in pairs(table) do
            remains.insert{name=name,count=count}        
          end
        end
      end
    end
  end
end)

game.onevent(defines.events.onbuiltentity, function(event) -- add tank to glob.clones table
  if event.createdentity.name == "cloning-tank" then
    glob.clones[#glob.clones+1] = event.createdentity
  end
end)

game.onevent(defines.events.ontick, function(event) -- check for empty remains every 10 seconds
  if glob.easy_death.remains and (game.tick%(60*10) == 0) then
    for k,remains in ipairs (glob.remains) do
      if remains.valid and remains.getinventory(defines.inventory.chest).getitemcount() == 0 then
        remains.die()
        table.remove(glob.remains, k)
      end
    end
  end
end)
