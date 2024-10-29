QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('moneywash:server:StartMoneyWash')
AddEventHandler('moneywash:server:StartMoneyWash', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local markedBills = Player.Functions.GetItemByName(Config.ItemRequired)
    local citizenId = Player.PlayerData.citizenid
    local endTime = os.time() + math.floor(Config.WashTime / 1000)
    local formattedEndTime = os.date('%Y-%m-%d %H:%M:%S', endTime)
    local washTimeInMinutes = Config.WashTime / 60000 -- Convert milliseconds to minutes

    if markedBills ~= nil and markedBills.amount > 0 then
        local amount = markedBills.amount
        local totalCash = amount * Config.CashMultiplier

        if Player.Functions.RemoveItem(Config.ItemRequired, amount) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.ItemRequired], 'remove', amount)
            TriggerClientEvent('QBCore:Notify', src, 'Money washing started. Come back in '.. washTimeInMinutes ..' minutes to collect your cash.', 'success')

            exports.oxmysql:execute('INSERT INTO money_wash (citizenid, marked_bills, cash_amount, end_time, ready) VALUES (@citizenid, @marked_bills, @cash_amount, @end_time, @ready)', {
                ['@citizenid'] = citizenId,
                ['@marked_bills'] = amount,
                ['@cash_amount'] = totalCash,
                ['@end_time'] = formattedEndTime,
                ['@ready'] = 0
            })
        else
            TriggerClientEvent('QBCore:Notify', src, 'Failed to remove marked bills.', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'You need marked bills to start money washing.', 'error')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        exports.oxmysql:execute('SELECT * FROM money_wash WHERE end_time <= NOW()', {}, function(results)
            for _, result in ipairs(results) do
                local Player = QBCore.Functions.GetPlayerByCitizenId(result.citizenid)

                if Player then
                    TriggerClientEvent('moneywash:client:CollectReady', Player.PlayerData.source, result.cash_amount)
                else
                    exports.oxmysql:execute('UPDATE money_wash SET ready = 1 WHERE id = @id', {
                        ['@id'] = result.id
                    })
                end
            end
        end)
    end
end)

RegisterServerEvent('moneywash:server:CollectCash')
AddEventHandler('moneywash:server:CollectCash', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenId = Player.PlayerData.citizenid

    exports.oxmysql:execute('SELECT * FROM money_wash WHERE citizenid = @citizenid AND ready = 1', {
        ['@citizenid'] = citizenId
    }, function(results)
        if #results > 0 then
            local totalCash = 0
            for _, result in ipairs(results) do
                totalCash = totalCash + result.cash_amount
                exports.oxmysql:execute('DELETE FROM money_wash WHERE id = @id', {
                    ['@id'] = result.id
                })
            end
            Player.Functions.AddMoney('cash', totalCash)
            TriggerClientEvent('QBCore:Notify', src, 'Money washing complete. You received $'..totalCash..'!', 'success')
        else
            TriggerClientEvent('QBCore:Notify', src, 'No cash ready for collection.', 'error')
        end
    end)
end)