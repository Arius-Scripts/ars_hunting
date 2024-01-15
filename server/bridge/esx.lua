local ESX = GetResourceState('es_extended'):find('start') and exports['es_extended']:getSharedObject() or nil

if not ESX then return end

framework = {}

function framework.addItems(data)
    local xPlayer = ESX.GetPlayerFromId(data.target)

    if type(data.items) == "table" then
        for _, item in pairs(data.items) do
            xPlayer.addInventoryItem(item.item, (item?.quantity or 1))
        end
    else
        xPlayer.addInventoryItem(data.items, 1)
    end
end

function framework.hasMoney(target)
    local xPlayer = ESX.GetPlayerFromId(target)
    return xPlayer.getMoney()
end

function framework.addMoney(data)
    local xPlayer = ESX.GetPlayerFromId(data.target)
    xPlayer.addMoney(data.amount)
end

function framework.removeMoney(data)
    local xPlayer = ESX.GetPlayerFromId(data.target)
    xPlayer.removeMoney(data.amount)
end

function framework.hasItems(data)
    local xPlayer = ESX.GetPlayerFromId(data.target)

    if type(data.items) == "table" then
        for _, item in pairs(data.items) do
            local hasItem = xPlayer.getInventoryItem(item.item)
            if not hasItem then return false end

            if hasItem.count >= item.quantity then return true end
        end
    else
        return xPlayer.getInventoryItem(data.items).count > 0
    end
end

function framework.removeItem(data)
    local xPlayer = ESX.GetPlayerFromId(data.target)
    xPlayer.removeInventoryItem(data.item, data.count)
end

ESX.RegisterUsableItem(Config.TrackerItem, function(source)
    TriggerClientEvent("ars_hunting:trackAnimal", source)
end)

ESX.RegisterUsableItem(Config.BaitItem, function(source)
    framework.removeItem({ target = source, item = Config.BaitItem, count = 1 })
    TriggerClientEvent("ars_hunting:placeBait", source)
end)

if Config.Campfire.enable then
    ESX.RegisterUsableItem(Config.Campfire.campfireItem, function(source, name, item)
        framework.removeItem({ target = source, item = Config.Campfire.campfireItem, count = 1 })
        TriggerClientEvent("ars_hunting:useCampfire", source)
    end)
end
