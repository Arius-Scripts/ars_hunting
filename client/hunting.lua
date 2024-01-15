currentZone = nil
local spawnedEntities = 0
entities = {}

local function disableWeapon()
    while not cache.weapon do Wait(1) end

    while cache.weapon do
        DisableControlAction(0, 24, true)  -- Attack 1
        DisableControlAction(0, 257, true) -- Attack 2
        DisableControlAction(0, 25, true)  -- Aim

        Wait(1)
    end
end

lib.onCache('weapon', function(value)
    if value then
        if Config.AimBlock.enable then
            if Config.AimBlock.global then
                if utils.validWeapon(Config.AimBlock.weaponsToBlock, value) then
                    aimBlock(Config.AimBlock.global)
                end
            else
                if currentZone then
                    if utils.validWeapon(Config.AimBlock.weaponsToBlock, value) then
                        aimBlock(Config.AimBlock.global)
                    end
                end
            end
        end


        if currentZone then
            if currentZone.allowedWeapons then
                if not utils.validWeapon(currentZone.allowedWeapons, value) then
                    lib.alertDialog({
                        header = locale("weapon_not_allowed_title"),
                        content = locale("weapon_not_allowed_content"),
                        centered = true,
                        cancel = false
                    })

                    disableWeapon()
                end
            end
        end
    end
end)

local function initCam(entity)
    FreezeEntityPosition(cache.ped, true)
    ClearFocus()
    local playerCoords = cache.coords
    local entityCoords = GetEntityCoords(entity)

    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", playerCoords, 0, 0, 0, GetGameplayCamFov())
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)

    SetCamCoord(cam, entityCoords.x, entityCoords.y + 2, entityCoords.z + 3.0)
    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z)

    return cam
end

local function stopCam(cam)
    ClearFocus()
    RenderScriptCams(false, true, 500, true, false)
    DestroyCam(cam, false)
    FreezeEntityPosition(cache.ped, false)
end

local function getEntity(_entity)
    for i = 1, #entities do
        local entity = entities[i]
        if entity then
            if entity.entity == _entity then return entity end
        end
    end

    return false
end

function removeEntity(_entity)
    for _, entity in pairs(entities) do
        if entity then
            if entity.entity == _entity then
                utils.removeBlip(entity?.blip)
                entities[_] = nil
                break
            end
        end
    end

    DeleteEntity(_entity)
    spawnedEntities -= 1

    utils.debug(entities)
end

local function spawnEntities()
    utils.debug("Spawning entities")

    while currentZone do
        if spawnedEntities < currentZone.maxSpawns then
            local spawnChance = math.random(1, 100)

            local animal = currentZone.animals[math.random(1, #currentZone.animals)]

            if animal.chance >= spawnChance then
                local coords = utils.getSpawnPoint(currentZone.coords, currentZone.radius)
                local entity = utils.createPed(animal.model, coords, 0.0, true, true)


                SetRelationshipBetweenGroups(5, `WILD_ANIMAL`, `PLAYER`)
                SetRelationshipBetweenGroups(5, `PLAYER`, `WILD_ANIMAL`)
                SetPedRelationshipGroupHash(entity, `WILD_ANIMAL`)

                TaskWanderStandard(entity)

                animal.blip.entity = entity
                local blip = animal.blip.enable and utils.createEntityBlip(animal.blip) or nil
                local marker = animal.marker

                spawnedEntities += 1
                utils.debug("entity spawned: ", entity, "Coords: ", coords)

                entities[#entities + 1] = { entity = entity, blip = blip }

                CreateThread(function()
                    while not IsEntityDead(entity) do
                        local sleep = 1500
                        local entityCoords = GetEntityCoords(entity)

                        if marker.enable then
                            local playerCoords = GetEntityCoords(cache.ped)
                            local dist = #(playerCoords - entityCoords)
                            local tracker = Config.Debug or getEntity(entity)?.track

                            if dist <= (tracker and 400.0 or 30.0) then
                                sleep = 0
                                DrawMarker(tracker and 1 or 23, entityCoords.x, entityCoords.y, entityCoords.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.2, 2.0, tracker and 100.0 or 1.0, marker.color.r, marker.color.g, marker.color.b, tracker and 155 or marker.color.a, false, true, 2, false, nil, nil,
                                    false)
                            end
                        end

                        Wait(sleep)
                    end

                    if not Config.Target then
                        while DoesEntityExist(entity) do
                            local sleep = 1500

                            local playerCoords = GetEntityCoords(cache.ped)
                            local entityCoords = GetEntityCoords(entity)
                            local dist = #(playerCoords - entityCoords)

                            if dist <= 3.0 then
                                sleep = 0
                                utils.drawText3D(entityCoords, locale("interact_haverest_animal"), 1, 0)

                                if IsControlJustPressed(0, 38) then
                                    harvestAnimal(animal, entityCoords, entity)
                                end
                            end

                            Wait(sleep)
                        end
                    else
                        if Config.Target == "ox_target" then
                            local entityCoords = GetEntityCoords(entity)

                            exports.ox_target:addLocalEntity(entity, {
                                {
                                    name = "harvest_animal",
                                    label = locale('interact_haverest_animal'),
                                    icon = 'fa-solid fa-knife',
                                    onSelect = function(data)
                                        harvestAnimal(animal, entityCoords, entity)
                                    end
                                },
                            })
                        elseif Config.Target == "qb-target" then
                            local entityCoords = GetEntityCoords(entity)
                            print(entityCoords)
                            exports['qb-target']:AddTargetEntity(entity, {
                                options = {
                                    {
                                        num = 1,
                                        type = "client",
                                        icon = 'fas fa-knife',
                                        label = locale('interact_haverest_animal'),
                                        action = function()
                                            harvestAnimal(animal, entityCoords, entity)
                                        end,
                                    }
                                },
                                distance = 2.5,
                            })
                        end
                    end
                end)
            end
        end
        Wait(Config.SpawnDelay * 1000)
    end
end


function harvestAnimal(animal, entityCoords, entity)
    local canHarvest = true

    if animal.harvestWeapons then
        utils.debug("Checking valid harvesting weapon")
        if not utils.validWeapon(animal.harvestWeapons, cache.weapon) then
            canHarvest = false
        end
    end

    if canHarvest then
        local cam = initCam(entity)
        FreezeEntityPosition(entity, true)

        lib.progressBar({
            duration = animal.harvestTime * 1000,
            label = locale("harvesting_animal"),
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
                move = true
            },
            anim = {
                dict = 'anim@gangops@facility@servers@bodysearch@',
                clip = 'player_search',
                flag = 1,

            },
        })
        stopCam(cam)
        removeEntity(entity)

        local data  = {}
        data.coords = entityCoords
        data.items  = animal.items

        TriggerServerEvent("ars_hunting:harvestAnimal", data)
    else
        utils.showNotification(locale("invalid_harvesting_weapon"))
    end
end

CreateThread(function()
    while true do
        for _, entity in pairs(entities) do
            if entity?.entity then
                local entityCoords = GetEntityCoords(entity.entity)
                local playerCoords = GetEntityCoords(cache.ped)
                local dist = #(entityCoords - playerCoords)

                if dist > Config.DeleteEntityRadius then
                    removeEntity(entity.entity)
                end

                if currentZone then
                    local dist2 = #(entityCoords - currentZone.coords)
                    if dist2 >= currentZone.radius then
                        removeEntity(entity.entity)
                    end
                end
            end
        end
        Wait(5000)
    end
end)

for zoneName, zoneData in pairs(Config.HuntingZones) do
    local zone = lib.zones.sphere({
        name = zoneName,
        coords = zoneData.coords,
        radius = zoneData.radius,
        debug = Config.Debug
    })

    if zoneData.zone_radius.enable then
        utils.createZoneBlip({ coords = zoneData.coords, radius = zoneData.radius, color = zoneData.zone_radius.color, alpha = zoneData.zone_radius.opacity })
        utils.debug("Zone Blip Created")
    end
    if zoneData.blip.enable then
        zoneData.blip.pos = zoneData.coords
        utils.createBlip(zoneData.blip)
        utils.debug("Blip Created")
    end

    function zone:onEnter()
        currentZone = zoneData
        SetForcePedFootstepsTracks(true)

        CreateThread(spawnEntities)
    end

    function zone:onExit()
        SetForcePedFootstepsTracks(false)
        currentZone = nil
    end
end


local canTrack = true

local function trackAnimal()
    if not canTrack then return utils.showNotification(locale("wait_for_another_track")) end

    local distCheck = 99999.0
    local closestEntityIndex = nil

    for index, animal in pairs(entities) do
        if animal.entity then
            if animal.track then return utils.showNotification(locale("already_tracking")) end

            local entityCoords = GetEntityCoords(animal.entity)
            local playerCoords = GetEntityCoords(PlayerPedId())
            local dist = #(entityCoords - playerCoords)

            if dist < distCheck then
                distCheck = dist
                closestEntityIndex = index
            end
        end
    end

    if closestEntityIndex then
        if lib.progressCircle({
                label = locale("tracking_animal"),
                duration = math.random(3500, 10000),
                position = 'bottom',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                    sprint = true
                },
                anim = {
                    dict = 'cellphone@',
                    clip = 'cellphone_text_read_base'
                },
                prop = {
                    model = `prop_prologue_phone`,
                    pos = vec3(0.0, 0.0, 0.0),
                    rot = vec3(0.0, 0.0, 0.0),
                    bone = 28422
                },
            })
        then
            if Config.TrackingFailureChance > math.random(1, 100) then return utils.showNotification(locale("could_not_track_animal")) end

            entities[closestEntityIndex].track = true
            canTrack = false

            CreateThread(function()
                while not canTrack do
                    DisplayRadar(true)
                    Wait(1)
                end
            end)
            TaskTurnPedToFaceEntity(cache.ped, entities[closestEntityIndex].entity, 1000)
            ForcePedMotionState(cache.ped, 1110276645, 0, 0, 0)

            SetTimeout(Config.DelayBetweenTracks * 1000, function()
                canTrack = true
                if entities[closestEntityIndex] then
                    entities[closestEntityIndex].track = nil
                end
            end)

            SetTimeout(Config.TrackingDuration * 1000, function()
                DisplayRadar(false)
                canTrack = true
                if entities[closestEntityIndex] then
                    entities[closestEntityIndex].track = nil
                end
            end)

            utils.showNotification(locale("animal_tracked"))
        end
    end
end

RegisterNetEvent("ars_hunting:trackAnimal", trackAnimal)



local function placeBait()
    lib.requestAnimDict("pickup_object")
    lib.requestModel("v_res_mpotpouri")
    local entity = nil
    local notifSent = false

    TaskPlayAnim(cache.ped, "pickup_object", "pickup_low", 8.0, 8.0, 1000, 50, 0, false, false, false)
    Wait(1000)

    local coords = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 0.5, 0)
    local prop = CreateObject("v_res_mpotpouri", coords.x, coords.y, coords.z, true, false, true)
    PlaceObjectOnGroundProperly(prop)


    CreateThread(function()
        while DoesEntityExist(prop) do
            local sleep = 3000
            local dist = #(cache.coords - coords)
            if dist <= 55 then
                sleep = 1
                DrawMarker(2, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.4, 0.4, 0.4, 245, 147, 66, 150, true, false, 2, false, nil, nil, false)
                utils.drawText3D(vector3(coords.x, coords.y, coords.z - 0.5), "~o~ Bait", 1, 0)
            end

            if entity then
                local entityCoords = GetEntityCoords(entity.entity)
                local dist_2 = #(entityCoords - coords)

                if dist_2 <= 20.0 then
                    if not notifSent then
                        notifSent = true
                        utils.showNotification(locale("animal_near_bait"))
                    end

                    if dist_2 <= 2.0 then
                        notifSent = false
                        DeleteEntity(prop)
                        TaskWanderStandard(entity.entity)
                        utils.showNotification(locale("animal_ate_bait"))
                        break
                    end
                end
            end


            Wait(sleep)
        end
    end)

    for _, _entity in pairs(entities) do
        local entityCoords = GetEntityCoords(_entity.entity)
        local dist = #(entityCoords - coords)

        if dist <= Config.BaitAttractionDistance then
            utils.debug("found", dist, entityCoords)

            entity = _entity
            ClearPedTasks(_entity.entity)
            TaskWanderInArea(_entity.entity, coords.x, coords.y, coords.z, 1.0, 4, 1.0)

            SetTimeout(Config.BaitTimeLimit * 60000, function()
                notifSent = false
                DeleteEntity(prop)
                TaskWanderStandard(_entity.entity)
                utils.showNotification(locale("bait_despawned"))
            end)

            break
        end
    end
end
RegisterNetEvent("ars_hunting:placeBait", placeBait)



function deleteAllEntities()
    for k, v in pairs(entities) do
        if DoesEntityExist(v.entity) then
            DeleteEntity(v.entity)
        end
    end
end

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    deleteAllEntities()
    stopMission()
    lib.hideTextUI()
end)
