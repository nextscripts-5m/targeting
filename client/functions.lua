DisableControls = function ()
    DisablePlayerFiring(PlayerPedId(), true)
    for k, control in pairs(Config.DisabledControls) do
        DisableControlAction(0, control, true)
    end
end

CheckSelection = function ()
    return IsDisabledControlJustReleased(0, Config.SelectControl)
end

CheckExit = function ()
    for k, control in pairs(Config.ExitControl) do
        if IsDisabledControlJustReleased(0, control) then
            IsSelecting = false
        end
    end
end

GetClosestPlayers = function (coords, maxDistance)
	local players	= GetActivePlayers()
    local nearby 	= {}
    local count 	= 0
    maxDistance 	= maxDistance or 2.0

    for i = 1, #players do
        local playerId = players[i]

        if playerId ~= PlayerId() then
            local playerPed 	= GetPlayerPed(playerId)
            local playerCoords 	= GetEntityCoords(playerPed)
            local distance 		= #(coords - playerCoords)

            if distance < maxDistance then
                count += 1
                nearby[count] = {
                    id 			= playerId,
                    ped 		= playerPed,
                    coords 		= playerCoords,
                }
            end
        end
    end

    return nearby
end

table.merge = function (t1, t2)
	local index	= #t1 + 1
	for i = 1, #t2 do
		t1[index] 	= t2[i]
		index 		+= 1
	end
	return t1
end

GetClosestPlayersAndNpc = function (coords, maxDistance)
	local peds 		= GetGamePool('CPed')
    local nearby 	= {}
    local count 	= 0
    maxDistance 	= maxDistance or 2.0

    for i = 1, #peds do
        local ped = peds[i]

        if not IsPedAPlayer(ped) then
            local pedCoords = GetEntityCoords(ped)
            local distance = #(coords - pedCoords)

            if distance < maxDistance then
                count += 1
                nearby[count] = {
                    ped 	= ped,
                    coords 	= pedCoords,
                }
            end
        end
    end

	local players	= GetClosestPlayers(coords, maxDistance)
	return table.merge(players, nearby)
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