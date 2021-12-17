AcidFW = nil
TriggerEvent('AcidFW:GetObject', function(obj) AcidFW = obj end)

RegisterServerEvent('AcidFW-playtime:Server:MainTrigger')
AddEventHandler('AcidFW-playtime:Server:MainTrigger', function()
  local src = source
  local Player = AcidFW.Functions.GetPlayer(src)
  local steam = Player.PlayerData.steam
  local cid = Player.PlayerData.citizenid
  local name = Player.PlayerData.name		
  if steam ~= nil and Player ~= nil then 
    exports['ghmattimysql']:execute('SELECT * FROM acidplaytime WHERE steam = @steam', {['@steam'] = steam}, function(result)
      if result[1] ~= nil then
        local newmins = (result[1].mins) + 2
        AcidFW.Functions.ExecuteSql(false, "UPDATE `acidplaytime` SET mins = '"..newmins.."' WHERE `steam` = '"..steam.."'")
      else
        AcidFW.Functions.ExecuteSql(true, "INSERT INTO `acidplaytime` (`steam`, `name`, `mins`) VALUES ('"..steam.."','"..name.."', 2)")
      end
    end)
  end
end)


AcidFW.Commands.Add("playtime", "Check your Playtime", {}, false, function(src, args)
  local Player = AcidFW.Functions.GetPlayer(src)
  local steam = Player.PlayerData.steam
      exports['ghmattimysql']:execute('SELECT * FROM acidplaytime WHERE steam = @steam', {['@steam'] = steam}, function(result)
        if result[1] ~= nil then 
          local val = result[1].mins

          local days = math.floor(val / 1440)

          val = val - (days * 1440)

          local hrs = math.floor(val / 60) 

          val = val - (hrs  * 60)

          str = days..' Days, '..hrs..' Hours, and '..val..' Minutes'

          TriggerClientEvent('chatMessage', src, "PLAYTIME", "normal" , str)
        end
      end)
end)

AcidFW.Commands.Add("playtimelb", "Leaderboard for Playtime", {}, false, function(src, args)
  local tbl = {}
  local lboard = '' 
  exports['ghmattimysql']:execute('SELECT * FROM acidplaytime', function(result)
    for k, v in pairs(result) do
      -- print(uses)
      if v.mins ~= 0 then 
        table.insert(tbl, v)
        table.sort(tbl, function(a, b) return a.mins > b.mins end)
      end
    end
    for k,v in ipairs(tbl) do
      if k < 8 then 
        local val = v.mins

          local days = math.floor(val / 1440)

          val = val - (days * 1440)

          local hrs = math.floor(val / 60) 

          val = val - (hrs  * 60)

          str = days..' Days, '..hrs..' Hours, and '..val

        lboard = ''..lboard..''..k..'. '..v.name..' - '..days..' Days, '..hrs..' Hours, and '..val..' Minutes<br>'
      end
    end
    Citizen.Wait(100)
    TriggerClientEvent('AcidFW-playtime:Leaderboard', src, lboard)
  end)
end)

AcidFW.Commands.Add("playtimeid", "Check a User's Playtime", {{name="id", help="ID of player"}}, false, function(src, args)
  local Player = AcidFW.Functions.GetPlayer(tonumber(args[1]))
		if Player ~= nil then
      local steam = Player.PlayerData.steam
      exports['ghmattimysql']:execute('SELECT * FROM acidplaytime WHERE steam = @steam', {['@steam'] = steam}, function(result)
        if result[1] ~= nil then 
          local val = result[1].mins

          local days = math.floor(val / 1440)

          val = val - (days * 1440)

          local hrs = math.floor(val / 60) 

          val = val - (hrs  * 60)

          str = days..' Days, '..hrs..' Hours, and '..val..' Minutes'

          TriggerClientEvent('chatMessage', src, "PLAYTIME of ID "..tonumber(args[1]), "normal" , str)
        end
      end)
    else
			TriggerClientEvent('chatMessage', src, "SYSTEM", "error", "Player is not online!")
		end
end, 'admin')

