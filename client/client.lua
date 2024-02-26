IsSelecting             = false
local enableNpc         = false
local selectedPed

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
                    id          = GetPlayerServerId(NetworkGetPlayerIndexFromPed(selectedPed))
                    IsSelecting = false
                    break
                else
                    print(("It's not a %s"):format(enableNpc and "ped" or "player"))
                end
            end
            Wait(0)
        end
        callback:resolve(id)
    end)
    return Citizen.Await(callback)
end

AddMarkerOnPed = function (selectedPed)
    -- Head Bone 0x796E = 31086
    local pedBoneCoords = GetPedBoneCoords(selectedPed, 31086, 0.0, 0.0, 0.0)
    local textureDict   = Config.Marker.textureDict and Config.Marker.textureDict or nil
    local textureName   = Config.Marker.textureName and Config.Marker.textureName or nil
    DrawMarker(Config.Marker.type, pedBoneCoords.x, pedBoneCoords.y, pedBoneCoords.z + Config.Marker.zOffset,
        Config.Marker.direction.x, Config.Marker.direction.y, Config.Marker.direction.z, -- direction
        Config.Marker.rotation.x, Config.Marker.rotation.y, Config.Marker.rotation.z, -- rotation
        Config.Marker.scale.x, Config.Marker.scale.y, Config.Marker.scale.z, -- scale
        Config.Marker.rgb.r, Config.Marker.rgb.g, Config.Marker.rgb.b, -- rgb
        Config.Marker.alpha, Config.Marker.bobUpAndDown, Config.Marker.faceCamera, -- alpha, bobUpAndDown, faceCamera
        2, Config.Marker.rotate, -- 2, rotate
        textureDict, textureName, false -- textureDict, textureName, drawnOnEnts
    )
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
