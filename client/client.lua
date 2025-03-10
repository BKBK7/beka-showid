local allPlayers = {}
local radius = Config.Distance
local color = Config.Color
local scale = Config.Scale 
local textfont = Config.Textfont 
local key = Config.Key

function getNearbyPlayers()
    local players = {}
    local ped = PlayerPedId()
    local playerCoords = GetEntityCoords(ped)
    for _, player in pairs(GetActivePlayers()) do
        local playerPed = GetPlayerPed(player)
        local isCrouching = GetPedCrouchMovement(player)
        local isCover = IsPedInCover(player)
        local ragdoll = IsPedRagdoll(player)
        if isCrouching == 0 and not isCover and not ragdoll then
            local pedCoord = GetEntityCoords(playerPed)
            local distance = #(pedCoord - playerCoords)
            if distance <= radius then
                table.insert(players, player)
            end
        end
    end
    return players
end

function DrawText3D(x, y, z, text, color)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFontForCurrentCommand(textfont)
        SetTextColor(color[1], color[2], color[3], 255)
        SetTextCentre(1)
        DisplayText(CreateVarString(10, "LITERAL_STRING", text), _x, _y)
    end
end

function DrawInformation()
    local myCoords = GetEntityCoords(PlayerPedId())
    for _, playerId in ipairs(getNearbyPlayers()) do
        local ped = GetPlayerPed(playerId)
        local pedCoords = IsPedMale(ped) and GetWorldPositionOfEntityBone(ped, 167) or GetWorldPositionOfEntityBone(ped, 247)
        if #(myCoords - pedCoords) <= radius then
            local serverId = GetPlayerServerId(playerId)
            local text = tostring(serverId)
            if allPlayers and next(allPlayers) ~= nil then
                local info = allPlayers[serverId]
                if info then 
                    text = info .. "\n" .. text
                end
            end
            DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 0.3, text, color)
        end
    end
end

RegisterNetEvent('beka-showid:client:sendInfo')
AddEventHandler('beka-showid:client:sendInfo', function(players)
    allPlayers = players
end)

RegisterCommand('showid', function()
    local endTime = GetGameTimer() + 5000
    while GetGameTimer() < endTime do
        DrawInformation()
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    if Config.UseKey then
        while true do
            if IsControlPressed(0, key) then
                DrawInformation()
            end
            Citizen.Wait(0)
        end
    end
end)