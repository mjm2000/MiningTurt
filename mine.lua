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

local face_direction = "west"

local function move_foward()
    while turtle.inspect() do
        tutle.dig()
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

local gps_x = 0
local gps_z = 0
local gps_y = 0
local function check_fuel() 
    if turtle.getFuelLevel() <= (abs(gps_z) + abs(gps_x) + 5) then
                return_home()
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


local function return_home()
    if gps_x == 0 and gps_z == 0 then
        return 
    end
    if gps_x < 0 and gps_z > 0 then
        return_south()
    end 
    if gps_x < 0 and gps_z < 0 then
        return_north()
    end 
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


local function mineF()
    local mine_path_len =  10
    local mine_separation = 2
    
    set_home() -- Set the home position    
    turtle.suckUp() -- Suck items from the right side
    while turtle.suckleft() do
    end
    turtle.refuel() -- Refuel the turtle
    move_foward() -- Move forward to start mining
    while true do
        for slot =1, 16  do 
            local item = turtle.getItemDetail(slot)
            if item ~= nil and isFuel(item.name) then
                turtle.select(slot)
                turtle.refuel()
            end
        end 
        check_fuel() -- Check if the turtle has enough fuel
        
        for i = 1, mine_path_len do
            if not move_foward() then
                return false
            end
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


