ESX = exports['es_extended']:getSharedObject()

CreateThread(function()
    while true do 
        local ply = PlayerPedId()
        local plyCoords = GetEntityCoords(ply)
        local _sleep = 1000
            if #(plyCoords - Config.menus.police) < 2 and getdata().job.name == 'police' and not IsPedInAnyVehicle(ply, false)  then
                textui(true, '[~b~E~w~] Garaje')
                _sleep = 0
                
                if IsControlJustPressed(0, 38) then
                    OpenGarageMenu('police')
                end
            else 
                textui(false, '')
        end
        Wait(_sleep)
    end
end)

CreateThread(function()
    while true do 
        local ply = PlayerPedId()
        local plyCoords = GetEntityCoords(ply)
        local _sleep = 1000
            if #(plyCoords - Config.menus.ambulance) < 2 and getdata().job.name == 'ambulance' and not IsPedInAnyVehicle(ply, false) then
                _sleep = 0
                textui(true, '[~b~E~w~] Garaje')
                if IsControlJustPressed(0, 38) then
                    OpenGarageMenu('ambulance')
                    textui(false, '[~b~E~w~] Garaje')
                end
            else 
                textui(false, '')
        end
        Wait(_sleep)
    end
end)

CreateThread(function()
    while true do 
        local ply = PlayerPedId()
        local plyCoords = GetEntityCoords(ply)
        local _sleep = 1000
            if #(plyCoords - Config.menus.mechanic) < 2 and getdata().job.name == 'mechanic' and not IsPedInAnyVehicle(ply, false) then
                _sleep = 0
                textui(true, '[~b~E~w~] Garaje')
                if IsControlJustPressed(0, 38) then
                    OpenGarageMenu('mechanic')
                    textui(false, '[~b~E~w~] Garaje')
                end
            else 
                textui(false, '')
        end
        Wait(_sleep)
    end
end)

function textui(bool, msg)
    if not bool then
    exports['rsx_textui']:textui(false, '')
    else 
    exports['rsx_textui']:textui(true, msg)

    end
end

CreateThread(function()
    while true do
        local _sleep = 1000
        local ply = PlayerPedId()
        local plyCoords = GetEntityCoords(ply)
        for k, v in pairs(Config.jobsnames) do
            for k, v2 in pairs(Config.dels) do
            if #(plyCoords - v2) < 3 and getdata().job.name == v and IsPedInAnyVehicle(ply, false) then
                textui(true, '[~r~E~w~] Guardar coche')
                _sleep = 0
                if IsControlJustPressed(0, 38) then
                    exitfromcar(PlayerPedId())
                    textui(false, '')
                end
            end
            end
        end
        Wait(_sleep)
    end
end)

function exitfromcar(ply)
    if IsPedInAnyVehicle(ply, false) then
        TaskLeaveVehicle(ply, GetVehiclePedIsIn(ply, false), 0)
        Wait(2000)
        ESX.Game.DeleteVehicle(GetVehiclePedIsIn(ply, true))
    end
end
function getdata()
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
    return ESX.PlayerData
end

function OpenGarageMenu(type)
    local elements = {}
    local spawning
    if type == 'police' then
        spawning = Config.spawns.police
        for k, v in pairs(Config.polveh) do
            table.insert(elements, {label = v.label, value = v.value})
        end
    elseif type == 'ambulance' then
        spawning = Config.spawns.ambulance
        for k, v in pairs(Config.ambveh) do
            table.insert(elements, {label = v.label, value = v.value})
        end
    elseif type == 'mechanic' then
        spawning = Config.spawns.mechanic
        for k, v in pairs(Config.mechveh) do
            table.insert(elements, {label = v.label, value = v.value})
        end
    end
    ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'emservice',{
        title = 'Garaje',
		align = 'center',
		elements = elements
	},
	function(data, menu)
		local b = data.current.value
            print('Spawning '..b)
            ESX.Game.SpawnVehicle(b, spawning, 0, function(veh)
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                ESX.UI.Menu.CloseAll()
            end)
	end,
	function(data, menu)
		menu.close()
	    end)
end

exports('custom', function()
    customize()
end)

function customize()
    ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'emservice',{
        title = 'Garaje',
		align = 'center',
		elements = {
            {label = 'Extras', value = 'extras'},
            {label = 'Livery', value = 'livery'}, 
        }
	},
	function(data, menu)
		local b = data.current.value
            if b == 'extras' then
                extras()
            elseif b == 'livery' then
                livery()
        end
	end,
	function(data, menu)
		menu.close()
	    end)
end

function extras()
    local elems = {}
    local ply = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(ply, false)
    for i = 0, 20 do
        if DoesExtraExist(plyVeh, i) then
            local label = 'Extra '..i
            table.insert(elems, {label = label, value = i})
        end
    end
    
    ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extras',{
        title = 'Extras',
		align = 'center',
		elements = elems
	},
	function(data, menu)
		local b = data.current.value
        print(b)
            if not IsVehicleExtraTurnedOn(plyVeh, b)  then
                SetVehicleExtra(plyVeh, b, 0)
                print('Extra '..b..' turned on')
            else
                SetVehicleExtra(plyVeh, b, 1)
                print('Extra '..b..' turned off')
            end
	end,
	function(data, menu)
		menu.close()
	    end)
end

function livery()
    local elems = {}
    local ply = PlayerPedId()
    local plyVeh = GetVehiclePedIsIn(ply, false)

    for i = 1, GetVehicleLiveryCount(plyVeh) do
        local label = 'Livery '..i
        table.insert(elems, {label = label, value = i})
    end

    ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'liv',{
        title = 'Liveries',
		align = 'center',
		elements = elems
	},
	function(data, menu)
		local b = data.current.value
        print(b)
            if not IsVehicleExtraTurnedOn(plyVeh, b)  then
                SetVehicleLivery(plyVeh, b)
                print('Livery '..b..' turned on')
            else
                SetVehicleLivery(plyVeh, b)
                print('Livery '..b..' turned off')
            end
	end,
	function(data, menu)
		menu.close()
	    end)
end