AcidFW = nil

Citizen.CreateThread(function() 
    while AcidFW == nil do
          TriggerEvent('AcidFW:GetObject', function(obj) AcidFW = obj end) 
          Citizen.Wait(200)
    end
end)

local isLoggedIn = false

RegisterNetEvent('AcidFW:Client:OnPlayerLoaded')
AddEventHandler('AcidFW:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    TriggerEvent('AcidFW-playtime:Main')   
end)

RegisterNetEvent('AcidFW:Client:OnPlayerUnload')
AddEventHandler('AcidFW:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('AcidFW-playtime:Main')
AddEventHandler('AcidFW-playtime:Main', function()
    while true do 
        if isLoggedIn then 
            Citizen.Wait(120000)
            TriggerServerEvent('AcidFW-playtime:Server:MainTrigger')
        else
            Citizen.Wait(120000)
        end
    end
end)

RegisterNetEvent('AcidFW-playtime:Leaderboard')
AddEventHandler('AcidFW-playtime:Leaderboard', function(res)
    TriggerEvent('chat:addMessage', {
        template = '<div class="chat-message advert"><div class="chat-message-body"><strong>AcidFW-REFERRALS LEADERBOARD</strong><br>'..res..'</div></div>',
    })
end)
