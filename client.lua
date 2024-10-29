local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    local pedModel = Config.Ped.model
    local location = Config.Location

    exports['qb-target']:AddTargetModel(pedModel, {
        options = {
            {
                type = "client",
                event = "moneywash:client:StartMoneyWash",
                icon = "fas fa-dollar-sign",
                label = "Start Money Wash",
                job = "all",
            },
        },
        distance = 2.5,
    })

    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(0)
    end

    local ped = CreatePed(4, pedModel, location.x, location.y, location.z, location.w, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end)

RegisterNetEvent('moneywash:client:StartMoneyWash')
AddEventHandler('moneywash:client:StartMoneyWash', function()
    TriggerServerEvent('moneywash:server:StartMoneyWash')
end)

RegisterNetEvent('moneywash:client:CollectCash')
AddEventHandler('moneywash:client:CollectCash', function(totalCash)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local location = Config.Location

    if #(playerCoords - vector3(location.x, location.y, location.z)) < 2.5 then
        TriggerServerEvent('moneywash:server:CollectCash', totalCash)
    else
        QBCore.Functions.Notify('You need to go back to the location to collect your cash.', 'error')
    end
end)
 