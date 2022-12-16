util.keep_running()
util.require_natives(1663599433)
local root = menu.my_root()

-- local root = menu.list(vehicle, "Vehicle fly", {}, "")
local carYaw = 0
local carPitch = 0
local camYaw = 0
local camPitch = 0
local carFlySpeedSelect = 5
local vehicleFly
local carFlySpeed = carFlySpeedSelect*10
local vehicleFlyCheck
local noClipCar
local yourself
local carUsed

util.create_tick_handler(function()
    yourself = PLAYER.GET_PLAYER_PED(players.user())
    carUsed = PED.GET_VEHICLE_PED_IS_IN(yourself, false)
end)

root:toggle("Vehicle fly", {"12SvehicleFly"}, "", function(a)
    vehicleFly = a
    vehicleFlyCheck = a
    ENTITY.SET_ENTITY_COLLISION(carUsed, true, true)
end)

root:slider("Fly speed", {}, "", 1, 100, 5, 1, function(a)
    carFlySpeedSelect = a
end)

root:toggle("No clip fly", {}, "", function(a)
    noClipCar = a
end)

local function vehicleFlapper()
    ENTITY.SET_ENTITY_VELOCITY(carUsed, 0, 0, 0)
    carYaw = math.floor(ENTITY.GET_ENTITY_HEADING(carUsed)*10)/10
    camYaw = math.floor(CAM.GET_GAMEPLAY_CAM_ROT().Z*10)/10
    carPitch = math.floor(ENTITY.GET_ENTITY_HEADING(carUsed)*10)/10
    camPitch = math.floor(CAM.GET_GAMEPLAY_CAM_ROT().X*10)/10
    ENTITY.SET_ENTITY_ROTATION(carUsed, camPitch, 0, camYaw, 0, true)
    if util.is_key_down(0x5A) == true then
        VEHICLE.SET_VEHICLE_FORWARD_SPEED(carUsed, carFlySpeed)
    end
    if util.is_key_down(0x53) == true then
        VEHICLE.SET_VEHICLE_FORWARD_SPEED(carUsed, -carFlySpeed)
    end
    if util.is_key_down(0x44) == true then
        local speedFly = carFlySpeed
        ENTITY.APPLY_FORCE_TO_ENTITY(carUsed, 1, speedFly*2, 0, 0, 0, 0, 0, 0, true, true, true, false)
    end
    if util.is_key_down(0x51) == true then
        local speedFly = carFlySpeed
        ENTITY.APPLY_FORCE_TO_ENTITY(carUsed, 1, -speedFly*2, 0, 0, 0, 0, 0, 0, true, true, true, false)
    end
    if util.is_key_down(0x10) == true then
        local speedFly = carFlySpeed
        ENTITY.APPLY_FORCE_TO_ENTITY(carUsed, 1, 0, 0, speedFly, 0, 0, 0, 0, true, true, true, false)
    end
    if util.is_key_down(0x11) == true then
        local speedFly = carFlySpeed
        ENTITY.APPLY_FORCE_TO_ENTITY(carUsed, 1, 0, 0, -speedFly, 0, 0, 0, 0, true, true, true, false)
    end
    if util.is_key_down(0x20) == true then
        carFlySpeed = carFlySpeedSelect*10*2
    elseif util.is_key_down(0x20) == false then
        carFlySpeed = carFlySpeedSelect*10
    end
end

util.create_tick_handler(function()
    if vehicleFlyCheck == true then
        if NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(carUsed) == false then
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(carUsed)
            util.yield(3000)
        end
        if PED.IS_PED_IN_VEHICLE(yourself, carUsed, false) == false then
            vehicleFly = false
            ENTITY.SET_ENTITY_COLLISION(carUsed, true, true)
        elseif PED.IS_PED_IN_VEHICLE(yourself, carUsed, false) == true then
            vehicleFly = true
            if noClipCar == true then
                ENTITY.SET_ENTITY_COLLISION(carUsed, false, true)
            else
                ENTITY.SET_ENTITY_COLLISION(carUsed, true, true)
            end
        end
    end
    if vehicleFly then vehicleFlapper() end
end)