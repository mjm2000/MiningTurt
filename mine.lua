local sides = {"top", "bottom", "left", "right", "back"}
function combineLists(list1, list2)
  for _, v in ipairs(list2) do
    table.insert(list1, v)
  end
  return list1
end
local inventory = {}

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

local suck_lookup = {
    ["top"] = turtle.suckUp,
    ["bottom"] = turtle.suckDown,
    ["left"] = turtle.suckLeft,
    ["right"] = turtle.suckRight,
    ["back"] = turtle.suck
}
local drop_lookup = {
    ["top"] = turtle.dropUp,
    ["bottom"] = turtle.dropDown,
    ["left"] = turtle.dropLeft,
    ["right"] = turtle.dropRight,
    ["back"] = turtle.drop
}



local function isFuel(name)
  return fuels[name] == true
end
print("Checking for fuel in chests...")



for label,function in pairs(suck_lookup) do
    print("Checking side: " .. label)
    while function() do
        local item = turtle.getItemDetail()
        if item and isFuel(item.name) then
            turtle.refuel()
        else
            drop_lookup[label]()
        end
    end
end





--for i,side in ipairs(sides) do
--    print("Checking side: " .. side)
--    --if turtle.detect(side) then
--    chest = peripheral.wrap(side)
--    if chest ~= nil then
--        chestList = chest.list() 
--        for index, value in ipairs(chestList) do
--            print(name)
--            if value.count > 0 then
--                local name = value.name
--                print(name)
--                if name ~= nil and isFuel(value.name) then
--                    print("Found fuel: " .. name .. " with count: " .. value.count)
--                    chest.pushItems(side, 1, value.count)  
--                end
--            end
--        end
--    end
--end


