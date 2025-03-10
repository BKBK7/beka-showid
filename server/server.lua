local allPlayers = {}

AddEventHandler("onServerResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        Wait(2000) -- wait for setup client side
        allPlayers = {}

        local players = GetPlayers()
        local useInfo = Config.Info
        local info 
        if useInfo then
            for _, playerId in ipairs(players) do
                if useInfo == 'name' then
                    info = GetPlayerName(playerId)
                elseif useInfo == 'steam' then
                    info = GetPlayerIdentifierByType(playerId, 'steam')
                elseif useInfo == 'license' then
                    info = GetPlayerIdentifierByType(playerId, 'license')
                end
                allPlayers[tonumber(playerId)] = info
            end
            TriggerClientEvent('beka-showid:client:sendInfo', -1, allPlayers)
        end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    allPlayers[src] = nil
    TriggerClientEvent('beka-showid:client:sendInfo', -1, allPlayers)
end)

AddEventHandler('playerJoining', function()
    local src = source
    local useInfo = Config.Info
    local info 
    if useInfo then
        if useInfo == 'name' then
            info = GetPlayerName(src)
        elseif useInfo == 'steam' then
            info = GetPlayerIdentifierByType(src, 'steam')
        elseif useInfo == 'license' then
            info = GetPlayerIdentifierByType(src, 'license')
        end
        allPlayers[tonumber(src)] = info
        TriggerClientEvent('beka-showid:client:sendInfo', -1, allPlayers)
    end
end)