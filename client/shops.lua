local function sellBuyItem(item, buy)
    local input = lib.inputDialog(buy and (locale("buy_item_x")):format(item.label) or (locale("sell_item_x")):format(item.label), {
        { type = 'number', label = locale("item_quantity_title"), icon = 'hashtag' },
    })
    if not input then return end


    local data = {
        item = item.item,
        buy = buy,
        price = input[1] * item.price,
        quantity = input[1]
    }

    TriggerServerEvent("ars_hunting:sellBuyItem", data)
end


local function openShop(items, shopName)
    local options = {}

    if items.buy and items.buy[1] then
        options[#options + 1] = {
            title = locale("shop_buy_item"),
            icon = Config.ImagesPath .. "sell.png",
            onSelect = function()
                local _items = {}

                for i = 1, #items.buy do
                    local item = items.buy[i]
                    _items[#_items + 1] = {
                        title = item.label,
                        icon = Config.ImagesPath .. item.item .. ".png",
                        description = ("%s$"):format(item.price),
                        onSelect = function()
                            sellBuyItem(item, true)
                        end
                    }
                end

                lib.registerContext({
                    id = 'shop_buy_item',
                    title = locale("shop_buy_item"),
                    menu = "hunting_shop",
                    options = _items
                })
                lib.showContext('shop_buy_item')
            end
        }
    end

    if items.sell and items.sell[1] then
        options[#options + 1] = {
            title = locale("shop_sell_item"),
            icon = Config.ImagesPath .. "buy.png",
            onSelect = function()
                local _items = {}

                for i = 1, #items.sell do
                    local item = items.sell[i]
                    _items[#_items + 1] = {
                        title = item.label,
                        icon = Config.ImagesPath .. item.item .. ".png",
                        description = ("%s$"):format(item.price),
                        onSelect = function()
                            sellBuyItem(item, false)
                        end
                    }
                end

                lib.registerContext({
                    id = 'shop_sell_item',
                    title = locale("shop_sell_item"),
                    menu = "hunting_shop",
                    options = _items
                })
                lib.showContext('shop_sell_item')
            end
        }
    end

    lib.registerContext({
        id = 'hunting_shop',
        title = shopName,
        options = options
    })
    lib.showContext('hunting_shop')
end


for shopName, shopData in pairs(Config.Shops) do
    local shop = lib.points.new({
        coords = shopData.coords.xyz,
        distance = shopData.ped.enable and 60 or 5,
    })

    if shopData.blip.enable then
        shopData.blip.pos = shopData.coords.xyz
        shopData.blip.name = shopName
        utils.createBlip(shopData.blip)
        utils.debug("Shop Blip Created")
    end

    function shop:onEnter()
        local pedData = shopData.ped
        if pedData.enable then
            if not self.ped then
                local ped = utils.createPed(pedData.model, shopData.coords)
                FreezeEntityPosition(ped, true)
                SetEntityInvincible(ped, true)
                SetBlockingOfNonTemporaryEvents(ped, true)

                if Config.Target then
                    if Config.Target == "ox_target" then
                        exports.ox_target:addLocalEntity(ped, {
                            {
                                name = "harvest_animal",
                                label = (locale("interact_open_shop")):format(shopName),
                                icon = 'fa-solid fa-knife',
                                onSelect = function(data)
                                    openShop(shopData.items, shopName)
                                end
                            },
                        })
                    elseif Config.Target == "qb-target" then
                        exports['qb-target']:AddTargetEntity(ped, {
                            options = {
                                {
                                    num = 1,
                                    type = "client",
                                    icon = 'fas fa-knife',
                                    label = (locale("interact_open_shop")):format(shopName),
                                    action = function()
                                        openShop(shopData.items, shopName)
                                    end,
                                }
                            },
                            distance = 2.5,
                        })
                    end
                end

                self.ped = ped
            end
        end
    end

    function shop:onExit()
        if self.ped then
            DeleteEntity(self.ped)
            self.ped = nil
        end
    end

    if not Config.Target then
        function shop:nearby()
            if self.currentDistance <= 5.0 then
                if not self.ped then
                    DrawMarker(2, self.coords.x, self.coords.y, self.coords.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 252, 152, 3, 155, false, true, 2, false, nil, nil, false)
                end

                if self.currentDistance <= 3 then
                    if shopData.useDrawText then
                        utils.drawText3D(self.coords + vector3(0.0, 0.0, 1.0), (locale("interact_open_shop")):format(shopName), 0.5, 0)
                    end

                    if IsControlJustPressed(0, 38) then
                        openShop(shopData.items, shopName)
                    end
                end
            end
        end
    end
end
