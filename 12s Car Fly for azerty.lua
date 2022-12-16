util.keep_running()
util.require_natives(1663599433)
local root = menu.my_root()
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
local keepMomentum = false

root:toggle_loop("Vehicle fly", {"12SvehicleFly"}, "", function()
    yourself = PLAYER.GET_PLAYER_PED(players.user())
    carUsed = PED.GET_VEHICLE_PED_IS_IN(yourself, false)
    ENTITY.SET_ENTITY_COLLISION(carUsed, true, true)
    if NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(carUsed) == false then
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(carUsed)
        util.yield(3000)
    end
    if keepMomentum == false then
        ENTITY.SET_ENTITY_VELOCITY(carUsed, 0, 0, 0)
    end
    if PED.IS_PED_IN_VEHICLE(yourself, carUsed, false) then
        if noClipCar then
            ENTITY.SET_ENTITY_COLLISION(carUsed, false, true)
        else
            ENTITY.SET_ENTITY_COLLISION(carUsed, true, true)
        end
        camYaw = math.floor(CAM.GET_GAMEPLAY_CAM_ROT().Z*10)/10
        camPitch = math.floor(CAM.GET_GAMEPLAY_CAM_ROT().X*10)/10
        ENTITY.SET_ENTITY_ROTATION(carUsed, camPitch, 0, camYaw, 0, true)
        if util.is_key_down(0x5A) then -- Z key
            VEHICLE.SET_VEHICLE_FORWARD_SPEED(carUsed, carFlySpeed)
        end
        if util.is_key_down(0x53) then -- S key
            VEHICLE.SET_VEHICLE_FORWARD_SPEED(carUsed, -carFlySpeed)
        end
        if util.is_key_down(0x44) then -- D key
            local speedFly = carFlySpeed
            ENTITY.APPLY_FORCE_TO_ENTITY(carUsed, 1, speedFly*2, 0, 0, 0, 0, 0, 0, true, true, true, false)
        end
        if util.is_key_down(0x51) then -- Q key
            local speedFly = carFlySpeed
            ENTITY.APPLY_FORCE_TO_ENTITY(carUsed, 1, -speedFly*2, 0, 0, 0, 0, 0, 0, true, true, true, false)
        end
        if util.is_key_down(0x10) then
            local speedFly = carFlySpeed
            ENTITY.APPLY_FORCE_TO_ENTITY(carUsed, 1, 0, 0, speedFly, 0, 0, 0, 0, true, true, true, false)
        end
        if util.is_key_down(0x11) then
            local speedFly = carFlySpeed
            ENTITY.APPLY_FORCE_TO_ENTITY(carUsed, 1, 0, 0, -speedFly, 0, 0, 0, 0, true, true, true, false)
        end
        if util.is_key_down(0x20) then
            carFlySpeed = carFlySpeedSelect*10*2
        else
            carFlySpeed = carFlySpeedSelect*10
        end
    else
        ENTITY.SET_ENTITY_COLLISION(carUsed, true, true)
    end
end)

root:slider("Fly speed", {}, "", 1, 100, 5, 1, function(a)
    carFlySpeedSelect = a
end)

root:toggle("No clip fly", {}, "", function(a)
    noClipCar = a
end)

root:toggle("Keep momentum", {}, "", function(a)
    keepMomentum = a
end)