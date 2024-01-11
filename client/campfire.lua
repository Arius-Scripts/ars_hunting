if not Config.Campfire.enable then return end


local function openCampfireMenu(campfire, campfirePoint)
    lib.registerContext({
        id = 'campfire_menu',
        title = locale("campfire_menu_title"),
        options = {
            {
                title = locale("cook_items"),
                icon = Config.ImagesPath .. "cook.png",
                onSelect = function()
                    local options = {}

                    for i = 1, #Config.Campfire.items do
                        local item = Config.Campfire.items[i]
                        local metadata = {}

                        for q = 1, #item.require do
                            local require = item.require[q]
                            metadata[#metadata + 1] = { label = require.label, value = require.quantity .. "x" }
                        end

                        options[#options + 1] = {
                            title = item.label,
                            icon = Config.ImagesPath .. item.give .. ".png",
                            metadata = metadata,
                            onSelect = function()
                                local hasItems = lib.callback.await('ars_hunting:hasItems', false, item.require)
                                if not hasItems then return utils.showNotification(locale("no_items")) end

                                if lib.progressBar({
                                        duration = item.cookTime * 1000,
                                        label = (locale("cooking_item")):format(item.label),
                                        useWhileDead = false,
                                        canCancel = false,
                                        disable = {
                                            car  = true,
                                            move = true
                                        },
                                        prop = {
                                            {
                                                model = `prop_stickbfly`,
                                                pos = vec3(0.0, 0.0, 0.0),
                                                rot = vec3(51.1120, 2.11, -149.86),
                                                bone = 28422
                                            }
                                        },
                                    })
                                then
                                    local data = {
                                        required = item.require,
                                        give = item.give
                                    }
                                    TriggerServerEvent("ars_hunting:cookItem", data)
                                end
                            end
                        }
                    end

                    lib.registerContext({
                        id = 'campfire_menu_cooking',
                        title = locale("campfire_menu_title"),
                        menu = "campfire_menu",
                        options = options
                    })

                    lib.showContext('campfire_menu_cooking')
                end
            },
            {
                title = locale("take_campfire"),
                icon = "fa-solid fa-xmark",
                iconColor = "#fc8803",
                onSelect = function()
                    lib.progressBar({
                        duration = 1000,
                        label = locale("taking_campfire"),
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                            move = true
                        },
                        anim = {
                            dict = 'pickup_object',
                            clip = 'pickup_low'
                        },
                    })
                    local data = {
                        coords = GetEntityCoords(campfire)
                    }
                    DeleteEntity(campfire)
                    TriggerServerEvent("ars_hunting:takeCampfire", data)

                    if campfirePoint then campfirePoint:remove() end
                end
            }
        }
    })

    lib.showContext("campfire_menu")
end

local function useCampFire()
    lib.requestModel("prop_beach_fire")

    lib.progressBar({
        duration = 1000,
        label = locale("placing_campfire"),
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true
        },
        anim = {
            dict = 'pickup_object',
            clip = 'pickup_low'
        },
    })

    local land = false
    local safeZ = 0

    local coords = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 1.5, 5.0)

    repeat
        Citizen.Wait(100)
        land, safeZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 1)
    until land


    local campfire = CreateObjectNoOffset("prop_beach_fire", coords.x, coords.y, safeZ + .15, true, true, true)

    if Config.Target then
        if Config.Target == "ox_target" then
            exports.ox_target:addLocalEntity(campfire, {
                {
                    name = "harvest_animal",
                    label = locale('interact_campfire'),
                    icon = 'fa-solid fa-tent',
                    onSelect = function(data)
                        openCampfireMenu(campfire)
                    end
                },
            })
        elseif Config.Target == "qb-target" then
            exports['qb-target']:AddTargetEntity(campfire, {
                options = {
                    {
                        num = 1,
                        type = "client",
                        icon = 'fas fa-tent',
                        label = locale('interact_campfire'),
                        action = function()
                            openCampfireMenu(campfire)
                        end,
                    }
                },
                distance = 2.5,
            })
        end
    else
        local campfirePoint = lib.points.new({
            coords = GetEntityCoords(campfire),
            distance = 5,
        })
        function campfirePoint:nearby()
            if self.currentDistance <= 3.0 then
                utils.drawText3D(GetEntityCoords(campfire), locale("interact_campfire"), 1, 0)

                if IsControlJustReleased(0, 38) then
                    openCampfireMenu(campfire, campfirePoint)
                end
            end
        end
    end
end

RegisterNetEvent("ars_hunting:useCampfire", useCampFire)
