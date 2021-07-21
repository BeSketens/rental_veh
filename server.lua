function steamID(source)
    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamId = v
        end
        break
    end
    return steamId
end

RegisterServerEvent('rental:getPlayerMoney')
AddEventHandler('rental:getPlayerMoney', function(source, veh)
    local steam = steamID(source)
        MySQL.Async.fetchAll("SELECT money FROM users WHERE identifier = @identifier", 
                        {['@identifier'] = steam },
                        function(result) -- callback function
                            if result then
                                if result[1].money >= 250 then
                                    TriggerClientEvent('rental:success', source, veh, result[1].money)
                                else 
                                    TriggerClientEvent('rental:failure', source)
                                end
                            end
                        end
        )
end)

RegisterServerEvent('rental:setPlayerMoney')
AddEventHandler('rental:setPlayerMoney', function(source, money)
    local steam = steamID(source)
    local newAmount = money - 250
    MySQL.Async.execute('UPDATE users SET money = @money WHERE identifier = @identifier',
                        {['@money'] = newAmount, ['@identifier'] = steam},
                        function(result)
                        end)
end)