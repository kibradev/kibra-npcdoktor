ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)


Citizen.CreateThread(function()
    while true do 
        local PlayerPedId = PlayerPedId()
        local PlayerCoord = GetEntityCoords(PlayerPedId)
       -- local alanda = false
        local sleep = 2000
        for i = 1, #Kibra, 1 do 
            local Ucret = Kibra[i].Fiyat
            local Dist = #(PlayerCoord - Kibra[i].DoktorKordinat)
            if Dist < 2 then
                sleep = 2
              --  alanda = true
              --  exports['okokTextUI']:Open('[E] - '..Kibra[i].DoktorName.."'e tedavi ol <b>$"..Kibra[i].Fiyat..'</b>', 'lightblue', 'left')
                DrawText3D(Kibra[i].DoktorKordinat.x, Kibra[i].DoktorKordinat.y, Kibra[i].DoktorKordinat.z + 1.0, '[E] - '..Kibra[i].DoktorName.."'e tedavi ol <b>$"..Kibra[i].Fiyat)
                if IsControlJustPressed(0, 38) then 
                    TriggerEvent("kibra-npcdoktor:client:Kontrol")
                end
            end
            -- if not alanda then 
            --     sleep = 100
            --     exports['okokTextUI']:Close() 
            -- end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent("kibra-npcdoktor:client:Kontrol")
AddEventHandler("kibra-npcdoktor:client:Kontrol", function ()
    ESX.TriggerServerCallback('kibra-npcdoktor:server:ems-sayi', function(count)
        if count >= Kibra.EMSLimit then 
         --   ESX.Notify("Pillbox Hastanesi","Şehirde zaten doktorlar var. Doktorlarımıza müracaat et.",3000,"warning")
            exports['mythic_notify']:SendAlert("error","Şehirde zaten doktorlar var. Doktorlarımıza müracaat et.")
        else
            TriggerServerEvent("kibra-npcdoktor:server:ParaKontrol")
        end
    end)
end)

RegisterNetEvent("kibra-npcdoktor:client:Tedavi")
AddEventHandler("kibra-npcdoktor:client:Tedavi", function ()
    for k = 1, #Kibra, 1 do
    TriggerEvent('esx_ambulancejob:revive', Kibra[k].Spawn)
    end
end)

Citizen.CreateThread(function()
    for i = 1, #Kibra, 1 do
    RequestModel(Kibra[i].DoktorHash)
    while not HasModelLoaded(Kibra[i].DoktorHash) do
        Wait(100000)
    end
    npc = CreatePed(1, Kibra[i].DoktorHash, Kibra[i].DoktorKordinat.x, Kibra[i].DoktorKordinat.y, Kibra[i].DoktorKordinat.z, Kibra[i].Heading, false, true)
    SetPedCombatAttributes(npc, 46, true)               
    SetPedFleeAttributes(npc, 0, 0)               
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetEntityAsMissionEntity(npc, true, true)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    end
end)


DrawText3D = function (x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
  end