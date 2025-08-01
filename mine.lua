



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

local function move_foward()
    while turtle.inspect() do
        turtle.dig()
    end
    if turtle.forward() then
        if face_direction == "west" then
            local gps_x = gps_x - 1
        elseif face_direction == "east" then
            local gps_x = gps_x + 1
        elseif face_direction == "north" then
            local gps_z = gps_z - 1
        elseif face_direction == "south" then
            local gps_z = gps_z + 1
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




local function check_fuel() 
    if turtle.getFuelLevel() <= (math.abs(gps_z) + math.abs(gps_x) + 5) then
            -- return_home()
            print("Not enough fuel to continue mining. Returning home.")
    end
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
  ["silentgear:stonetorch"] = true,
  ["minecraft:coal"] = true,
  ["minecraft:charcoal"] = true
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


local function mine_foward()
    if turtle.detect() then 
        turtle.digUp()
    end
    if turtle.detectDown() then
        turtle.digDown()
    end
    if turtle.detect() then
        turtle.dig()
    end
    move_foward()
    refuel() -- Refuel the turtle        
    check_fuel() -- Check if the turtle has enough fuel

end
local function turn_around()
    turnLeft()
    turnLeft()
end
local function mineF(face_direction,amount, mine_separation, mine_path_len)
    set_home() -- Set the home position    
    turtle.suckUp() -- Suck items from the right side
    dumpItems() -- Dump items to the chest below   
    move_foward() -- Move forward to start mining
    for i = 1, amount do
        for i = 1, mine_separation do
            mine_foward() -- Mine forward
            print("separation: ".. i)
        end
        turnLeft() -- Turn left 
        for i = 1, mine_path_len do
            mine_foward() -- Mine forward
            print("branch left: ".. i)
        end
        turn_around() -- Turn around to face the opposite direction
        for i = 1, mine_path_len do
            move_foward() 
        end
        for i = 1, mine_path_len do                 
            mine_foward() -- Mine forward
            print("branch right: ".. i)
        end
        turn_around() -- Turn around to face the opposite direction
        for i = 1, mine_path_len do
            move_foward() 
        end                                                                
        turnLeft() -- Turn right to face the next direction
    end
end
-- KEEP
--local face_direction = select_direction() -- Select the direction to mine 
--local amount = ask_for_integer("how many blocks should it mine") -- Get the number of blocks to mine                        
--                                                                                                                           
--local mine_separation = ask_for_integer("how many blocks should it separate the mine") -- Get the separation between mines
--local mine_path_len = ask_for_integer("how long should the mine be") -- Get the length of the mine

mineF("north",100,2,10)
