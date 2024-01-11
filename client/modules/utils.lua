local CreatePed = CreatePed
local SetModelAsNoLongerNeeded = SetModelAsNoLongerNeeded
local CreateVehicle = CreateVehicle
local SetVehicleNeedsToBeHotwired = SetVehicleNeedsToBeHotwired
local NetworkFadeInEntity = NetworkFadeInEntity
local AddBlipForCoord = AddBlipForCoord
local SetBlipSprite = SetBlipSprite
local SetBlipDisplay = SetBlipDisplay
local SetBlipScale = SetBlipScale
local SetBlipColour = SetBlipColour
local SetBlipAsShortRange = SetBlipAsShortRange
local BeginTextCommandSetBlipName = BeginTextCommandSetBlipName
local AddTextComponentString = AddTextComponentString
local EndTextCommandSetBlipName = EndTextCommandSetBlipName

utils = {}


function utils.showNotification(msg, type, duration)
    lib.notify({
        title = 'Ars Hunting',
        description = msg,
        type = type and type or 'info',
        duration = duration or 5000,
    })
end

function utils.debug(...)
    if Config.Debug then
        local args = { ... }

        for i = 1, #args do
            local arg = args[i]
            args[i] = type(arg) == 'table' and json.encode(arg, { sort_keys = true, indent = true }) or tostring(arg)
        end

        print('^6[DEBUG] ^7', table.concat(args, '\t'))
    end
end

function utils.createPed(name, ...)
    local model = lib.requestModel(name)

    if not model then return end

    local ped = CreatePed(5, model, ...)

    SetModelAsNoLongerNeeded(model)
    return ped
end

function utils.createVehicle(name, ...)
    local model = lib.requestModel(name)

    if not model then return end

    local vehicle = CreateVehicle(model, ...)

    SetVehicleNeedsToBeHotwired(vehicle, false)
    NetworkFadeInEntity(vehicle, true)
    SetModelAsNoLongerNeeded(model)

    return vehicle
end

function utils.getSpawnPoint(coords, _radius)
    local radius = _radius - 50
    local safeCoords = nil
    local foundLand = nil
    local safeZ = nil

    local x = coords.x + math.random(-radius, radius)
    local y = coords.y + math.random(-radius, radius)
    local z = 0.0

    repeat
        Citizen.Wait(1)
        z += 5
        foundLand, safeZ = GetGroundZFor_3dCoord(x, y, z, true)
    until foundLand

    safeCoords = vector3(x, y, safeZ)

    return safeCoords
end

function utils.drawText3D(coords, text, size, font)
    local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)

    local camCoords = GetFinalRenderedCamCoord()
    local distance = #(vector - camCoords)

    if not size then
        size = 1
    end
    if not font then
        font = 0
    end

    local scale = (size / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(0.0, 0.55 * scale)
    SetTextFont(font)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText('STRING')
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(vector.xyz, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

function utils.createBlip(data)
    local blip = AddBlipForCoord(data.pos)
    SetBlipSprite(blip, data.type)
    SetBlipDisplay(blip, 6)
    SetBlipScale(blip, data.scale)
    SetBlipColour(blip, data.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.name)
    EndTextCommandSetBlipName(blip)

    return blip
end

function utils.createEntityBlip(data)
    local blip = AddBlipForEntity(data.entity)
    SetBlipSprite(blip, data.type)
    SetBlipDisplay(blip, 6)
    SetBlipScale(blip, data.scale)
    SetBlipColour(blip, data.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.name)
    EndTextCommandSetBlipName(blip)

    return blip
end

function utils.createZoneBlip(data)
    local blip = AddBlipForRadius(data.coords, data.radius)
    SetBlipColour(blip, data.color)
    SetBlipAlpha(blip, data.alpha)

    return blip
end

function utils.removeBlip(blip)
    if DoesBlipExist(blip) then
        RemoveBlip(blip)
    end
end

function utils.validWeapon(weaponList, currentWeapon)
    for _, allowedWeapon in pairs(weaponList) do
        if joaat(currentWeapon) == joaat(allowedWeapon) then return true end
    end

    return false
end

RegisterNetEvent('ars_hunting:showNotification', utils.showNotification)

-- © 𝐴𝑟𝑖𝑢𝑠 𝐷𝑒𝑣𝑒𝑙𝑜𝑝𝑚𝑒𝑛𝑡
