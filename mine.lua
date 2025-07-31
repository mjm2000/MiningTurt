sides = {"top", "bottom", "left", "right", "back"}
function combineLists(list1, list2)
  for _, v in ipairs(list2) do
    table.insert(list1, v)
  end
  return list1
end
inventory = {}

--for slot = 1, 16 do
--  local count = turtle.getItemCount(slot)
--  if count > 0 then
--    local detail = turtle.getItemDetail(slot)
--    table.insert(inventory, {
--      slot = slot,
--      name = detail.name,
--      count = count
--    })
--  end
--end
local fuels = {
  ["minecraft:coal"] = true,
  ["minecraft:charcoal"] = true,
  ["minecraft:lava_bucket"] = true,
  ["minecraft:blaze_rod"] = true,
  ["minecraft:stick"] = true,
  ["minecraft:planks"] = true,
  ["minecraft:wood"] = true,
  ["minecraft:sapling"] = true,
}

suck_lookup = {
    ["top"] = turtle.suckUp,
    ["bottom"] = turtle.suckDown,
    ["left"] = turtle.suckLeft,
    ["right"] = turtle.suckRight,
    ["back"] = turtle.suck
}



function isFuel(name)
  return fuels[name] == true
end
print("Checking for fuel in chests...")
for i = 1, #sides do
    local side = sides[i]
    if turtle.detect(side) then
        chest = peripheral.wrap(side)
        chestList = chest.list() 
        for index, value in ipairs(chestList) do
            print(name)
            if value.count > 0 then
                local name = value.name
                print(name)
                if name ~= nil and isFuel(value.name) then
                    suck_lookup[side](value.count)
                end
            end
        end
    end
end


