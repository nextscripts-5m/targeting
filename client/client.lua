IsSelecting             = false
local enableNpc         = false
local selectedPed

StopTargeting = function ()
    IsSelecting = false
end
exports("StopTargeting", StopTargeting)

EndTargeting = function ()
    DisablePlayerFiring(PlayerPedId(), false)
    LeaveCursorMode()
    SendNUIMessage({toggle  = false})
    SetNuiFocus(false, false)
    selectedPed = nil
end

StartTargeting = function (data)

    IsSelecting     = true
    enableNpc       = data.npc and data.npc or enableNpc
    EnterCursorMode()
    SetNuiFocus(false, true)
    SendNUIMessage({
        toggle  = true
    })

    CreateThread(function ()

        while true do

            if not IsSelecting then break end

            local pedCoords = GetEntityCoords(PlayerPedId())
            local peds      = enableNpc and GetClosestPlayersAndNpc(pedCoords, Config.MaxDistance) or GetClosestPlayers(pedCoords, Config.MaxDistance)

            for k, closestPed in pairs(peds) do

                if IsEntityAPed(closestPed.ped) or (enableNpc and closestPed.ped) then

                    local closestPedCoords      = GetPedBoneCoords(closestPed.ped, 0x5C01, 0.0, 0.0, 0.0)
                    local _, screenX, screenY   = GetScreenCoordFromWorldCoord(closestPedCoords.x, closestPedCoords.y, closestPedCoords.z)

                    if screenX > 0 and screenY > 0 then

                        local mouseX, mouseY    = GetControlNormal(0, 239), GetControlNormal(0, 240)
                        local xDistance         = math.abs(mouseX-screenX)
                        local yDistance         = math.abs(mouseY-screenY)

                        -- For precision
                        if(xDistance < 0.05 and yDistance < 0.15) then
                            selectedPed     = closestPed.ped

                        elseif closestPed.ped == selectedPed then
                            Wait(1)
                            selectedPed = nil
                        end
                    end
                end
            end

            Wait(0)
        end

        EndTargeting()
    end)
    return GetID()
end
exports("StartTargeting", StartTargeting)



function GetID()
    local id
    local callback  = promise:new()
    CreateThread(function ()
        while true do
            if not IsSelecting then break end

            DisableControls()
            CheckExit()
            
            if selectedPed then
                AddMarkerOnPed(selectedPed)
            end

            if CheckSelection() then
                if selectedPed then
                    id          = GetPlayerServerId(NetworkGetPlayerIndexFromPed(selectedPed)) > 0 and GetPlayerServerId(NetworkGetPlayerIndexFromPed(selectedPed))  or selectedPed
                    IsSelecting = false
                    break
                else
                    print(("It's not a %s"):format(enableNpc and "ped" or "player"))
                    IsSelecting = false
                    break
                end
            end
            Wait(0)
        end
        callback:resolve(id)
    end)
    return Citizen.Await(callback)
end



--[[
    Threads and Events
]]
CreateThread(function ()
    while true do
        Wait(0)
        if not HasStreamedTextureDictLoaded(Config.StreamFile) then
            RequestStreamedTextureDict(Config.StreamFile, true)
            while not HasStreamedTextureDictLoaded(Config.StreamFile) do
                Wait(1)
            end
        end
        break
    end
    print(("^2%s^7::Marker Loaded"):format(GetCurrentResourceName()))
end)

RegisterNetEvent("onClientResourceStart", function (resourceName)
    if GetCurrentResourceName() == resourceName then
        EndTargeting()
        IsSelecting     = false
    end
end)



--[[
    Debug
]]
-- RegisterCommand("target", function ()
--     print(StartTargeting())
-- end)
