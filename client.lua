local QBCore = exports['qb-core']:GetCoreObject()

-- Load Ped
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
            {
                type = "client",
                event = "moneywash:client:CollectCash",
                icon = "fas fa-dollar-sign",
                label = "Collect Clean Cash",
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
AddEventHandler('moneywash:client:CollectCash', function()
    TriggerServerEvent('moneywash:server:CollectCash')
end)
