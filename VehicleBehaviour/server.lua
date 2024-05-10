RegisterServerEvent("vehicleSync")
RegisterServerEvent("SpawnBuccaneer")
RegisterServerEvent("vehicleCheck")
RegisterNetEvent("vehicleDiff")
--[[
        Ideally you'd store the vehicle in a database to track what player owns it,
        but I'd rather not go into that much effort for a proof-of-concept prototype. 
--]]
local storedVehicle = {
    vehicleID,
    vehicleData -- Store the vehicle characteristics somewhere. This is just here for posterity.
}

AddEventHandler("vehicleCheck", function(vehicleID)
    if not (storedVehicle.vehicleID == vehicleID) then
        storedVehicle.vehicleID = vehicleID
        TriggerClientEvent("vehicleDiff", source)
    end
end)


AddEventHandler("vehicleSync", function(vehicleTarget, vehicleData)
    -- When a player enters a vehicle
    if storedVehicle == nil then
        storedVehicle = { VehID = vehicleTarget, VehData = vehicleData }
    end
end)


AddEventHandler("SpawnBuccaneer", function(ID, args)
    local model = 'buccaneer'
    --TriggerLatentClientEvent("loadVehicle", playerID, 50, model)
    Wait(800)
    Vehicle = CreateVehicleServerSetter(
        GetHashKey('buccaneer'),
        'automobile',
        args[1] + 5,
        args[2]+5,
        args[3]+1,
        0.0
        )
    while not DoesEntityExist(Vehicle) do Wait(0) end
        
end)