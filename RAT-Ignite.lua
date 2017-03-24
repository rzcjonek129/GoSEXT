local ver = "1.00"
PrintChat(string.format("<b><font color='#EE2EC'>RATzone RATignite Loaded... go to the site for more http://ratzone.eu "))
if GetUser() ~= "jonek129" then 
  GetWebResultAsync("https://raw.githubusercontent.com/rzcjonek129/GoSEXT/master/Version%20Folder/RAT-Ignite.version", function(data)
    if tonumber(data) > RAT-IgniteVersion then
      PrintChat("<b><font color='#EE2EC'>RAT-Ignite - </font></b> New version found! " ..data.." Downloading update, please wait...")
      DownloadFileAsync("https://raw.githubusercontent.com/rzcjonek129/GoSEXT/master/RAT-Ignite.lua", SCRIPT_PATH .. "RAT-Ignite.lua", function() PrintChat("<b><font color='#EE2EC'>RAT-Ignite - </font></b> Updated from v"..tostring(ChallengerBaseultVersion).." to v"..data..". Please press F6 twice to reload.") return end)
    end
  end)
end

local RATignite = nil

if GetCastName(myHero, SUMMONER_1):lower():find("summonerdot") then
        RATignite = SUMMONER_1
end
if GetCastName(myHero, SUMMONER_2):lower():find("summonerdot") then
        RATignite = SUMMONER_2
end

if RATignite == nil then
        return
end

RatApi = MenuConfig("RatApi", "RATzone RATignite")
RatApi:Slider("HEALTH", "Minimum Enemy HP + Player Lvl * 5", 50,25,200,25)
RatApi:Boolean("BARRIER", "Calculate Barrier", true)
RatApi:Boolean("SHIELD", "Calculate other shields", false)

OnLoad(function()
        for i,o in pairs(GetEnemyHeroes()) do
                RatApi:Boolean(GetObjectName(o), GetObjectName(o), true)
        end
end)

OnTick(function (myHero)
        local level = GetLevel(myHero)
        local dmg = 50 + (20 * level)
        local minhp = RatApi.HEALTH:Value() + ( level * 5 )
        local barrier = RatApi.BARRIER:Value()
        local shield = RatApi.SHIELD:Value()
        if RATignite ~= nil then
                if Ready(RATignite) then
                        for i, enemy in pairs(GetEnemyHeroes()) do
                                if ValidTarget(enemy, 600) and RatApi[GetObjectName(enemy)]:Value() then
                                        local currenthp = GetCurrentHP(enemy)
                                        local regenhp = GetHPRegen(enemy)
                                        local hp = currenthp + regenhp + ( regenhp * 5 * 0.6 )
                                        if barrier and GotBuff(enemy, "SummonerBarrier") ~= 0 then
                                                hp = hp + GetDmgShield(enemy)
                                        elseif shield then
                                                hp = hp + GetDmgShield(enemy)
                                        end
                                        if hp > minhp and hp <= dmg then
                                                CastTargetSpell(enemy, RATignite)
                                        end
                                end
                        end
                end
        end
end)
