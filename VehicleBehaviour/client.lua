RegisterNetEvent("vehicleSync")
RegisterNetEvent("SpawnBuccaneer")
RegisterNetEvent("SaveVehicle")
RegisterNetEvent("vehicleCheck")
RegisterNetEvent("vehicleDiff")
Wait(3000)
local playerID = GetPlayerServerId(PlayerId())
local playerEntity = NetToEnt(playerID)
NetworkRegisterEntityAsNetworked(playerEntity)
SetNetworkIdAlwaysExistsForPlayer(playerID, playerEntity, true)
local playerPed = GetPlayerPed(-1)

local saveVehicle = false
local pedInVehicle = false
local isSameVehicle = false
local vehicleTarget

RegisterNUICallback('closeMenu', function()
    SendNUIMessage({showUI = false; })
    SetNuiFocus(false, false)
end)

RegisterNUICallback('populateFields', function()
    if(pedInVehicle and not (vehicleTarget == nil)) then
        SendNUIMessage({
            action = 'populateFields',
            f_mass = GetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fMass'),
            f_InitialDragCoeff = GetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fInitialDragCoeff'),
            Vec3_CenterOfMass = GetVehicleHandlingVector(vehicleTarget, "CHandlingData", 'vecCenterOfMassOffset'),
            Vec3_InertiaMult = GetVehicleHandlingVector(vehicleTarget, "CHandlingData", 'vecInertiaMultiplier'),
            f_DriveBias = GetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fDriveBiasFront'),
            i_numGears = GetVehicleHandlingInt(vehicleTarget, "CHandlingData", 'nInitialDriveGears'),
            f_DriveInertia = GetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fDriveInertia'),
            f_TopSpeed = GetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fInitialDriveMaxFlatVel'),
            f_BrakingForce = GetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fBrakeForce'),
            f_BrakeBias = GetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fBrakeBiasFront'),
            f_MaxSteerAngle = GetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fSteeringLock'),
            f_InitialDriveForce = GetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fInitialDriveForce')
        })
    end
end)

RegisterNUICallback('updateVehicle', function(vehTable)
    SetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fMass', vehTable.f_mass+0.0)
    SetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fInitialDragCoeff', vehTable.f_InitialDragCoeff+0.0)
    SetVehicleHandlingVector(vehicleTarget, "CHandlingData", 'vecCenterOfMassOffset', vector3(vehTable.Vec3_CenterOfMass_x+0.0, vehTable.Vec3_CenterOfMass_y+0.0, vehTable.Vec3_CenterOfMass_z+0.0))
    SetVehicleHandlingVector(vehicleTarget, "CHandlingData", 'vecInertiaMultiplier', vector3(vehTable.Vec3_InertiaMult_x+0.0, vehTable.Vec3_InertiaMult_y+0.0, vehTable.Vec3_InertiaMult_z+0.0))
    SetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fDriveBiasFront', vehTable.f_DriveBias+0.0)
    SetVehicleHandlingInt(vehicleTarget, "CHandlingData", 'nInitialDriveGears', vehTable.i_numGears+0)
    SetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fDriveInertia', vehTable.f_DriveInertia+0.0)
    SetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fInitialDriveMaxFlatVel', vehTable.f_TopSpeed+0.0)
    --ModifyVehicleTopSpeed(vehicleTarget, vehTable.f_TopSpeed+0.0)
    SetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fBrakeForce', vehTable.f_BrakingForce+0.0)
    SetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fInitialDriveForce', vehTable.f_InitialDriveForce+0.0)
    -- Save vehicle data to server now after modification, to be streamed to the vehicle when loaded if not saved in the garage. 

    --SetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fBrakeBiasFront')
    --SetVehicleHandlingFloat(vehicleTarget, "CHandlingData", 'fSteeringLock')
    --]]
end)

RegisterCommand('showuitest', function()
    SendNUIMessage({action = 'showUI'; }) -- Sends a message to the js file. 
    SetNuiFocus(true, true)
end)

RegisterCommand('spawnBuccaneer', function()
    RequestModel(GetHashKey('buccaneer'))
    local timeout = 0
    while not HasModelLoaded('buccaneer') and timeout <= 300 do
        Wait(100)
        RequestModel('buccaneer')
        timeout = timeout + 100
    end
    TriggerServerEvent("SpawnBuccaneer", playerID, GetEntityCoords(playerEntity, true))
end)

RegisterKeyMapping('showuitest', 'Opens the UI', 'keyboard', 'h')
RegisterKeyMapping('spawnBuccaneer', 'Spawns a Buccaneer', 'keyboard', 'e')

Citizen.CreateThread(function()
    local waiting = true
    while waiting do
        Citizen.Wait(200)
        if IsPedSittingInAnyVehicle(playerPed) then
            vehicleTarget = GetVehiclePedIsUsing(playerPed)
            if GetPedInVehicleSeat(vehicleTarget, -1) == playerPed or GetPedInVehicleSeat(vehicleTarget, 3) == playerPed then
                pedInVehicle = true
                TriggerServerEvent("vehicleCheck", VehToNet(vehicleTarget))
            end
        else
            pedInVehicle = false
            vehicleTarget = nil
        end
    end
end)

AddEventHandler("loadVehicle", function(modelID)
    RequestModel(GetHashKey(modelID))
    local timeout = 0
    while not HasModelLoaded(veh) and timeout <= 300 do
        Wait(100)
        RequestModel(veh)
        timeout = timeout + 100
    end
end)

AddEventHandler("vehicleDiff", function()
    isSameVehicle = false
    SendNUIMessage({ action = "diffVehicle" })
end)