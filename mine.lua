



local gps_x = 0
local gps_z = 0
local gps_y = 0




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


local face_direction = "west"  -- Default facing direction
function select_direction()
    local directions = { "north", "east", "south", "west" }

    print("Choose a direction:")
    for i, dir in ipairs(directions) do
        print(i .. ". " .. dir)
    end

    write("Enter number (1-4): ")
    local choice = read()

    local num = tonumber(choice)
    if num and directions[num] then
        return directions[num]
    else
        print("Invalid selection.")
        return nil
    end
end


local function ask_for_integer(prompt) 
    while true do
        write(prompt or "Enter how many block you want to mine: ")
    local input = read()
    local num = tonumber(input)
    if num and math.floor(num) == num then
      return num
    else
      print("Invalid input. Please enter a valid integer.")
    end
  end 
end



local face_direction = "west"


local function place_torch()
    for slot = 1, 16 do
        turtle.select(slot)
        local item = turtle.getItemDetail(slot)
        if item and (item.name == "minecraft:torch" or item.name == "silentgear:stone_torch") then
            if turtle.placeDown() then
                print("Torch placed successfully.")
                return true
            else
                print("Failed to place torch.")
                return false
            end
        end
    end
    print("No torch found in inventory.")
end
local function plug_liquid()
    local success, data = turtle.inspect()
    if data.name == "minecraft:water" or data.name == "minecraft:lava" then
        -- find any stone in the inventory
        for slot = 1, 16 do
            local item = turtle.getItemDetail(slot)
            if item and item.name == "minecraft:cobblestone" then
                turtle.select(slot)
                turtle.place()
                break
            end
        end
        
    end
end



local function move_foward()
    while turtle.detect() do
        turtle.dig()
    end
    if turtle.forward() then
        if face_direction == "west" then
            gps_x = gps_x - 1
        elseif face_direction == "east" then
            gps_x = gps_x + 1
        elseif face_direction == "north" then
            gps_z = gps_z - 1
        elseif face_direction == "south" then
            gps_z = gps_z + 1
        end
        
        
        
        
        
        
        
        
        
        
        
        
        
    else    
        return false
    end
end





local function backward()
    if turtle.back() then
        if face_direction == "west" then
            local gps_x = gps_x + 1
        elseif face_direction == "east" then
            local gps_x = gps_x - 1
        elseif face_direction == "north" then
            local gps_z = gps_z + 1
        elseif face_direction == "south" then
            local gps_z = gps_z - 1
        end
        return true
    else
        return false
    end
end






local function enough_fuel(value)
    return turtle.getFuelLevel() >= (math.abs(gps_z) + math.abs(gps_x) + value)
end



local function turnLeft()
    if turtle.turnLeft() then
        if face_direction == "west" then
            face_direction = "south"
        elseif face_direction == "south" then
            face_direction = "east"
        elseif face_direction == "east" then
            face_direction = "north"
        elseif face_direction == "north" then
            face_direction = "west"
        end
        return true
    else
        return false
    end
end
local function turnRight()
    if turtle.turnRight() then
        if face_direction == "west" then
            face_direction = "north"
        elseif face_direction == "north" then
            face_direction = "east"
        elseif face_direction == "east" then
            face_direction = "south"
        elseif face_direction == "south" then
            face_direction = "west"
        end
        return true
    else
        return false
    end
end

local function faceNorth()
    while face_direction ~= "north" do
        if not turnLeft() then
            return false
        end
    end
    return true
end
local function faceSouth()
    while face_direction ~= "south" do
        if not turnLeft() then
            return false
        end
    end
    return true
end
local function faceWest()
    while face_direction ~= "west" do
        if not turnLeft() then
            return false
        end
    end
    return true
end
local function faceEast()
    while face_direction ~= "east" do
        if not turnLeft() then
            return false
        end
    end
    return true
end



local function return_south()
    faceNorth()
    while gps_z > 0 do
        if not move_foward() then
            return 
        end
    end
end
local function return_north()
    faceSouth()
    while gps_z < 0 do
        if not move_foward() then
            return 
        end
    end
end
local function return_east()
    faceEast()
    while gps_x < 0 do
        if not move_foward() then
            return 
        end
    end
end


local function return_center()
    if gps_x < 0 and gps_z > 0 then
        return_south()
    end 
    if gps_x < 0 and gps_z < 0 then
        return_north()
    end 
end

local function return_home()
    if gps_x == 0 and gps_z == 0 then
        return 
    end
    return_center()  
    if gps_z < 0 and gps_z == 0 then
        return_east()
    end
end
        
        

local function set_home()
    gps_x = 0
    gps_z = 0
    face_direction = "west"
end

local function digNorth(len)
    faceNorth()
    while turtle.detect() do
        turtle.dig()

    end
    return move_foward()
end
local function refuel()
    for slot =1, 16  do 
            local item = turtle.getItemDetail(slot)
            if item ~= nil and isFuel(item.name) then
                turtle.select(slot)
                turtle.refuel()
            end
    end
end

local mine

local keepItems = {
  ["minecraft:torch"] = true,
  ["silentgear:stone_torch"] = true,
  ["minecraft:coal"] = true,
  ["minecraft:charcoal"] = true
}
local stone_items = {
  ["minecraft:cobblestone"] = true,
  ["minecraft:stone"] = true,
  ["minecraft:andesite"] = true,
  ["minecraft:diorite"] = true,
  ["minecraft:granite"] = true,
  ["forbidden_arcanus:dark_stone"] = true
}

local function dumpItems()
  for i = 1, 16 do
        turtle.select(i)
        local item = turtle.getItemDetail()
        if item ~= nil and not keepItems[item.name] then
            turtle.dropDown()
        end
    end
end
local function remove_liquid(inspected_function,place_function)
    local truth,inspected_value = inspected_function()
    if inspected_value.name == "minecraft:water" or inspected_value.name == "minecraft:lava" then
        -- find any stone in the inventory
        for slot = 1, 16 do
            local item = turtle.getItemDetail(slot)
            if item and stone_items[item.name] then
                turtle.select(slot)
                place_function() 
                break
            end
        end
        
    end
end

local torchs = {
    ["minecraft:torch"] = true,
    ["silentgear:stone_torch"] = true
}

local function is_torch(f)
    local is_block, item = f()
    if is_block and torchs[item.name] then
        return true
    end
    return false
end

local function mine_foward()
    if turtle.detectUp() then 
        remove_liquid(turtle.inspectUp, turtle.placeUp)
        if not is_torch(turtle.inspectUp) then
            turtle.digUp()
        end
    end
    if turtle.detectDown() then
        remove_liquid(turtle.inspectDown, turtle.placeDown)
        if not is_torch(turtle.inspectDown) then
            turtle.digDown()
        end
    end
    if turtle.detect() then
        remove_liquid(turtle.inspect, turtle.place)
        if not is_torch(turtle.inspect) then
            turtle.dig()
        end
    end
    move_foward()
    refuel() -- Refuel the turtle        
     -- Check if the turtle has enough fuel

end
local function turn_around()
    turnLeft()
    turnLeft()
end

local function mine_x_blocks(x)
    for i = 1, x do
        if i % 4 == 0 then
            place_torch() -- Place a torch every 8 blocks
        end
        mine_foward()
        end
end
local function move_x_blocks(x)
    for i = 1, x do
        move_foward()
    end
end
local function branch_mine(mine_path_len)
        mine_x_blocks(mine_path_len)
        turn_around() -- Turn around to face the opposite direction
        move_x_blocks(mine_path_len) -- Move back to the main path 
end



local function distance_in_center_from_home()
    if face_direction == "north" or face_direction == "south" then
        return math.abs(gps_z) 
    elseif face_direction == "west" or face_direction == "east" then
        return math.abs(gps_x) 
    end
    
end
local function return_home_from_center()
    turn_around() -- Turn around to face the opposite direction
    local distance_from_home = distance_in_center_from_home() -- Calculate the distance from home 
    print("Distance from home: " .. distance_from_home)
    if distance_from_home > 0 then
        move_x_blocks(distance_from_home) -- Move back to the center
    end
end
-- dump items in chest above
local keepItems = {
  ["minecraft:torch"] = true,
  ["silentgear:stonetorch"] = true,
  ["minecraft:coal"] = true,
  ["minecraft:charcoal"] = true
}
--check if inv is full
local function isInventoryFull()
  for i = 1, 16 do
    if turtle.getItemCount(i) == 0 then
      return false
    end
  end
  return true
end

local is_chest = {
    ["minecraft:chest"] = true,
    ["minecraft:trapped_chest"] = true,
    ["minecraft:ender_chest"] = true,
    ["ironchest:iron_chest"] = true,
    ["ironchest:gold_chest"] = true,
    ["ironchest:diamond_chest"] = true,
    ["ironchest:obsidian_chest"] = true,
    ["storagedrawers:oak_full_drawers"] = true,
    ["storagedrawers:spruce_full_drawers"] = true,
    ["storagedrawers:birch_full_drawers"] = true,
    ["storagedrawers:jungle_full_drawers"] = true,
    ["storagedrawers:acacia_full_drawers"] = true,
    ["storagedrawers:dark_oak_full_drawers"] = true,
    ["storagedrawers:crimson_full_drawers"] = true,
    ["storagedrawers:warped_full_drawers"] = true,
    ["sophisticatedstorage:chest"] = true,
    ["sophisticatedstorage:wood_chest"] = true,
    ["sophisticatedstorage:stone_chest"] = true,
    ["sophisticatedstorage:iron_chest"] = true,
    ["sophisticatedstorage:gold_chest"] = true,
    ["sophisticatedstorage:diamond_chest"] = true,
    ["sophisticatedstorage:netherite_chest"] = true

}



local function dumpItemsUp()
  local is_block,item = turtle.inspectUp() 
  if is_block and is_chest[item.name]  then
    for i = 1, 16 do
        turtle.select(i)
        local item = turtle.getItemDetail()
        if item ~= nil and not keepItems[item.name] then
            turtle.dropUp()
        end
    end
   else
    print("No chest found above.")
  end

end

local function mineF(face_direction,amount, mine_separation, mine_path_len)
    if not enough_fuel(1) then
        print("Not enough fuel to start mining.")
        return
    end
    set_home() -- Set the home position    
    move_foward() -- Move forward to start mining

    place_torch()
    for i = 1, amount do
        refuel() -- Refuel the turtle
        if not enough_fuel((mine_path_len+3)*2 + mine_separation) then
            print("Not enough fuel to continue mining.")
            break 
        end
        if isInventoryFull() then
            print("Inventory full, returning to dump items.")
            local blocks_to_return = distance_in_center_from_home()
            return_home_from_center() -- Return to the home position
            dumpItemsUp() -- Dump items in the chest above
            turn_around() -- Turn around to face the opposite direction
            move_x_blocks(blocks_to_return) -- Move back to the center
        end
        mine_x_blocks(mine_separation) -- Move forward the separation distance
        turnLeft() -- Turn left 
        branch_mine(mine_path_len) -- Mine the specified length in the current direction 
        branch_mine(mine_path_len) -- Mine the specified length in the current direction
        turnRight() -- Turn right to face the next direction
    end
    return_home_from_center() -- Return to the home position
    dumpItemsUp()
end
-- KEEP
local face_direction = select_direction() -- Select the direction to mine 
local amount = 0 
local mine_separation = 0
local mine_path_len = 0
if #arg ~= 3 then
    print(#arg)
    amount = ask_for_integer("how many branches should we mine?: ") -- Get the number of blocks to mine                        
    mine_separation = ask_for_integer("how many blocks should it separate the branches") -- Get the separation between mines
    mine_path_len = ask_for_integer("how long should each branch be") -- Get the length of the mine
else
     amount = tonumber(arg[1])
     mine_separation = tonumber(arg[2])
     mine_path_len = tonumber(arg[3])
end
mineF(face_direction, amount, mine_separation, mine_path_len) -- Start mining in the selected direction with the specified parameters

--mineF("north",100,2,10)
