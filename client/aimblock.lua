local hasHuntingRifle = false
local isFreeAiming = false
local blockShotActive = false

local function aimBlock()
    if blockShotActive then return end
    blockShotActive = true
    CreateThread(function()
        while hasHuntingRifle do
            Wait(0)
            local player = PlayerId()
            local entity = nil
            local aiming, entity = GetEntityPlayerIsFreeAimingAt(player)
            local freeAiming = IsPlayerFreeAiming(player)
            local type = GetEntityType(entity)
            if not freeAiming or IsPedAPlayer(entity) or type == 2 or (type == 1 and IsPedInAnyVehicle(entity, false)) then
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 47, true)
                DisableControlAction(0, 58, true)
                DisablePlayerFiring(PlayerPedId(), true)
            end
        end
        blockShotActive = false
    end)
end

CreateThread(function()
    local huntingrifle = Config.HuntingRifle
    while Config.BlockDeath do
        Wait(0)
        if GetSelectedPedWeapon(PlayerPedId()) == huntingrifle then
            hasHuntingRifle = true
            aimBlock()
        else
            hasHuntingRifle = false
        end
    end
end)