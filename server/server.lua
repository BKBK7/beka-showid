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
                elseif useInfo == 'playername' then
                    if Config.Framework == 'RSG' then
                        local RSGCore = exports['rsg-core']:GetCoreObject()
                        local Player = RSGCore.Functions.GetPlayer(tonumber(playerId))
                        info = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
                    elseif Config.Framework == 'VORP' then
                        local VORPcore = exports.vorp_core:GetCore()
                        local Player = VORPcore.getUser(tonumber(playerId)).getUsedCharacter
                        info = Player.firstname..' '..Player.lastname
                    else
                        print('In order to use playername as info you need to use RSG or VORP Framework or you need to edit here')
                    end
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

function UpdatePlayers(source)
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
        elseif useInfo == 'playername' then
            if Config.Framework == 'RSG' then
                local RSGCore = exports['rsg-core']:GetCoreObject()
                local Player = RSGCore.Functions.GetPlayer(src)
                info = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
            elseif Config.Framework == 'VORP' then
                local VORPcore = exports.vorp_core:GetCore()
                local Player = VORPcore.getUser(src).getUsedCharacter
                info = Player.firstname..' '..Player.lastname
            else
                print('In order to use playername as info you need to use RSG or VORP Framework or you need to edit here')
            end
        end
        allPlayers[tonumber(src)] = info
        TriggerClientEvent('beka-showid:client:sendInfo', -1, allPlayers)
    end
end

RegisterNetEvent('RSGCore:Server:OnPlayerLoaded', function()
    Wait(2000)
    UpdatePlayers(source)
end)

AddEventHandler("vorp:SelectedCharacter",function(source,character)
    Wait(2000)
    UpdatePlayers(source)
end)
