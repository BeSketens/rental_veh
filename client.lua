local vehicleOut = false
local npc_coords = vector4(-855.7451, -128.2418, 36.7384, 292.80316162109)
local pedSpawned = false
local vehClaimed = false
local source = GetPlayerServerId(PlayerId())

Citizen.CreateThread(function()
    RequestModel(GetHashKey("a_m_y_business_03"))
    while not HasModelLoaded(GetHashKey("a_m_y_business_03")) do
        Wait(1)
    end  
    ----------------
    -- [[ BLIP ]]
        local blip = AddBlipForCoord(npc_coords)
        SetBlipSprite(blip, 464)
        SetBlipShrink(blip, true)
        SetBlipColour(blip, 11)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Véhicule sans permis")
        EndTextCommandSetBlipName(blip)
    ----------------
    -- [[ NPC ]]
        local npc = CreatePed(4, 0xA1435105, npc_coords.x, npc_coords.y, npc_coords.z, npc_coords.w, false, true)
        SetEntityHeading(npc, npc_coords.w)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
    ----------------
    -- [[ MENU ]]
        local MainMenu = RageUI.CreateMenu('OtherLife', 'Véhicules de location')
        MainMenu.EnableMouse = false
                                
        function RageUI.PoolMenus:Rental()

            MainMenu:IsVisible(function(Items)
                Items:AddButton('Panto', nil, { isDisabled = not vehicleOut }, function(onSelected)
                    if onSelected then 
                        TriggerServerEvent('rental:getPlayerMoney', source, 'panto')
                    end
                end)
                Items:AddButton('Faggio', nil, { isDisabled = not vehicleOut }, function(onSelected)
                    if onSelected then 
                        TriggerServerEvent('rental:getPlayerMoney', source, 'faggio3')
                    end
                end)
                Items:AddButton('BMX', nil, { isDisabled = not vehicleOut }, function(onSelected)
                    if onSelected then 
                        TriggerServerEvent('rental:getPlayerMoney', source, 'bmx')
                    end
                end)

            end, function() end)
        end
    ----------------
        while true do
        local interval = 1
        local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), npc_coords, true)
        if not vehicleOut and distance < 2 then
            AddTextEntry("HELP", 'Appuyez sur ~INPUT_PICKUP~ pour parler au vendeur')
            DisplayHelpTextThisFrame('HELP', false)
            if IsControlJustPressed(1, 38) then
                RageUI.Visible(MainMenu, not RageUI.Visible(MainMenu))
            end
        elseif vehicleOut and distance < 2 then -- timeout not over
            AddTextEntry("HELP", 'You already have a vehicle out, come back later')
            DisplayHelpTextThisFrame('HELP', false)
        elseif vehClaimed then -- closes menu after picking a vehicle
            vehClaimed = false
            RageUI.GoBack()
            interval = 200
        else
            interval = 200
        end
        Wait(interval)
    end
end)

-- [[ EVENTS ]] -- 

    -- timer on rental --
        RegisterNetEvent('menu:timeout')
        AddEventHandler('menu:timeout', function()
            Citizen.CreateThread(function()
                Citizen.Wait(600 * 1000) -- 60 min
                vehicleOut = false
            end)
        end)

    -- réussite de la location
        RegisterNetEvent('rental:success')
        AddEventHandler('rental:success', function(veh, money)
            TriggerServerEvent('rental:setPlayerMoney', source, money)
            vehicleOut = true
            vehClaimed = true
            TriggerEvent('menu:timeout')
            spawnVeh(veh)
        end)

    -- échec de la location
        RegisterNetEvent('rental:failure')
        AddEventHandler('rental:failure', function()
            SetNotificationTextEntry("STRING")
            AddTextComponentString('~r~Vous n\'avez pas assez d\'argent ! La location coûte 250$ !')
            DrawNotification(false, true)
        end)




-- [[ FUNCTIONS ]] -- 

    local vehCoords = vector4(-842.1758, -138.4088, 37.60364, 238.11022949219)
    function spawnVeh(car)
        RequestModel(car)
        while not HasModelLoaded(car) do
            Citizen.Wait(0)
        end
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), false))
        local veh = CreateVehicle(car, vehCoords.x, vehCoords.y, vehCoords.z, vehCoords.w)
        SetPedIntoVehicle(PlayerPedId(), veh, -1)
        SetEntityAsNoLongerNeeded(veh)
        SetModelAsNoLongerNeeded(car)
    end