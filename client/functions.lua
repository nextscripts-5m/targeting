EndTargeting = function ()
    DisablePlayerFiring(PlayerPedId(), false)
    LeaveCursorMode()
    SendNUIMessage({toggle  = false})
    SetNuiFocus(false, false)
end

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