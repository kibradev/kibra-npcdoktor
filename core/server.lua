ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent("kibra-npcdoktor:server:ParaKontrol")
AddEventHandler("kibra-npcdoktor:server:ParaKontrol", function() 
    local src = source
    local Player = ESX.GetPlayerFromId(source) 
    for i = 1, #Kibra, 1 do 
    if Player.getMoney() >= Kibra[i].Fiyat then 
        Player.removeMoney(Kibra[i].Fiyat)
        TriggerClientEvent("kibra-npcdoktor:client:Tedavi", source) 
        Citizen.Wait(1000)
      --  TriggerClientEvent('okokNotify:Alert', src, "Pillbox Hastanesi", "Tedavi Oldunuz! Tedavi Masrafları olarak "..Kibra[i].Fiyat..'$ ödediniz.', 5000, 'success')
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'success', text = "Tedavi Oldunuz! Tedavi Masrafları olarak "..Kibra[i].Fiyat..'$ ödediniz.' })

    else 
      --  TriggerClientEvent('okokNotify:Alert', src, "Pillbox Hastanesi", "Tedavi Masraflarınız için Bankanızda Yeterli Para yok!", 5000, 'error')
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = "Tedavi Masraflarınız için Bankanızda Yeterli Para yok!" })

    end
end
end)


ESX.RegisterServerCallback('kibra-npcdoktor:server:ems-sayi', function(source, cb)
    cb(getEMS("ambulance"))
end)

function getEMS(jobName)
    local sayi = 0
    local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if jobName == "ambulance" then
            if xPlayer.job.name == "ambulance" then
                sayi = sayi + 1
            end
        else
            if xPlayer.job.name == jobName  then
                sayi = sayi + 1
            end
        end
    end
    return sayi
end