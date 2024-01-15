if not Config.UseAimBlock then return end
function aimBlock()
    CreateThread(function()
        while cache.weapon and currentZone do
            local aiming, entity = GetEntityPlayerIsFreeAimingAt(cache.playerId)
            local freeAiming = IsPlayerFreeAiming(cache.playerId)
            local type = GetEntityType(entity)

            if not freeAiming or IsPedAPlayer(entity) or type == 2 or (type == 1 and IsPedInAnyVehicle(entity, false)) then
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 47, true)
                DisableControlAction(0, 58, true)
                DisablePlayerFiring(cache.ped, true)
            end
            Wait(1)
        end
    end)
end
