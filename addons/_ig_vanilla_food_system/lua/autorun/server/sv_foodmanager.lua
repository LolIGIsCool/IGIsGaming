util.AddNetworkString("VANILLAFOOD_net_OpenBuyMenu")
util.AddNetworkString("VANILLAFOOD_net_Purchase")

resource.AddFile("materials/vanilla/food/loveyouveteran.png")
resource.AddFile("resource/fonts/vanilla/Acumin_ItPro.ttf")
resource.AddFile("resource/fonts/vanilla/Acumin_RPro.ttf")

//create directory
if not file.IsDir("vanilla_food", "DATA") then
    file.CreateDir("vanilla_food")
end

//create and/or save food stock
local function SavePlayerStock(id, data)
    if not file.Exists("vanilla_food/" .. id .. ".json","DATA") then
        local foodData = {}
        //populate table
        for k, v in pairs(vanillaIGFoodItems) do
            table.insert(foodData,v.Stock)
        end
        local converted = util.TableToJSON(foodData,true)
        file.Write("vanilla_food/" .. id ..  ".json",converted)
    else
        local converted = util.TableToJSON(data,true)
        file.Write("vanilla_food/" .. id .. ".json", converted)
    end
end

//read food stock
function ReadPlayerStock(id)
    if not file.Exists("vanilla_food/" .. id .. ".json", "DATA") then return end
    local data = util.JSONToTable(file.Read("vanilla_food/" .. id .. ".json"))

    return data
end

//Intialize player
local function CreatePlayerStock(ply)
    if not file.Exists("vanilla_food/" .. ply:SteamID64() .. ".json","DATA") then
        SavePlayerStock(ply:SteamID64())
    end
end
hook.Add("PlayerInitialSpawn", "VANILLAFOOD_hook_IntializePlayer", CreatePlayerStock)

local function ManageFoodBuff(ply)
    local buff = ply:GetNWString("VANILLABUFF","")
    if buff == "" then return end
    local id = ply:SteamID64()

    ply.VANILLAOldSpeedRun = ply:GetRunSpeed()
    ply.VANILLAOLDWalkSpeed = ply:GetWalkSpeed()

    ply.VANILLAOLDCrouchSpeed = ply:GetCrouchedWalkSpeed()

    ply.VANILLAOLDMaxHealth = ply:GetMaxHealth()

    local timerLength = 900;
    local has = false;

    if _G.HasAugment(ply, "Slow Metabolism") and ply:GetVar("AugmentsActive", true) then
        timerLength = 1080;
        has = true;
    end

    if timer.Exists(id .. "VANILLABUFFTIMER") then timer.Remove(id .. "VANILLABUFFTIMER") end
    if has then ActivateAugment(ply,"Slow Metabolism",0) end
    timer.Create(id .. "VANILLABUFFTIMER",1,timerLength,function()
        if not IsValid(ply) then timer.Remove(id .. "VANILLABUFFTIMER") return end
        ply:SetNWInt("VANILLABUFFTIMER",timer.RepsLeft(id .. "VANILLABUFFTIMER"))

        if timer.RepsLeft(id .. "VANILLABUFFTIMER") == 0 then
            if buff == "Blue Milk" or buff == "Macaroon" then
                ply:SetRunSpeed(ply.VANILLAOldSpeedRun)
                ply:SetWalkSpeed(ply.VANILLAOLDWalkSpeed)
            end
            if buff == "Ration Bar" then
                ply:SetCrouchedWalkSpeed(ply.VANILLAOLDCrouchSpeed)
            end
            if buff == "Soup" or buff == "Macaroon" then
                ply:SetMaxHealth(ply.VANILLAOLDMaxHealth)
                if ply:Health() >= ply:GetMaxHealth() then ply:SetHealth(ply:GetMaxHealth()) end
            end


           ActivateAugment(ply,"Slow Metabolism",false)
            ply:SetNWInt("VANILLABUFFTIMER",0)
            ply:SetNWString("VANILLABUFF","")
        end
    end)

    if buff == "Blue Milk" or buff == "Macaroon" then
        ply:SetRunSpeed(ply.VANILLAOldSpeedRun + (ply.VANILLAOldSpeedRun * 0.15))
        ply:SetWalkSpeed(ply.VANILLAOLDWalkSpeed + (ply.VANILLAOLDWalkSpeed * 0.15))
    end

    if buff == "Ration Bar" then
        ply:SetCrouchedWalkSpeed(ply.VANILLAOLDCrouchSpeed + (ply.VANILLAOLDCrouchSpeed * 0.5))
    end

    if buff == "Soup" or buff == "Macaroon" then
        ply:SetMaxHealth(ply.VANILLAOLDMaxHealth + (ply.VANILLAOLDMaxHealth * 0.15))
        if ply:Health() == ply.VANILLAOLDMaxHealth then ply:SetHealth(ply:GetMaxHealth()) end
    end
end

timer.Create("VANILLAFOOD_timer_HealthRegen", 60, 0, function()
    for k, v in pairs(player.GetAll()) do
        if v:GetNWString("VANILLABUFF","") == "Mon Calamari Pizza" then
            local maxHealth = v:GetMaxHealth()
            local health = v:Health()
            local missingHealth = maxHealth - health
            if (math.floor(maxHealth * 0.05)) <= missingHealth then
                v:SetHealth(health + (math.floor(maxHealth * 0.05)))
            else
                v:SetHealth(maxHealth)
            end
        end
    end
end)

hook.Add("PlayerSwitchWeapon","VANILLAFOOD_hook_PlayerSwitchWeapon",function(ply, old, new)
    if ply:GetNWString("VANILLABUFF","") == "Bantha Burger" and (new.Base == "tfa_gun_base" or new.Base == "tfa_3dscoped_base") then
        new.Primary.KickUp = (new.Primary.KickUp - (new.Primary.KickUp * 1))
        new.Primary.KickDown = (new.Primary.KickDown - (new.Primary.KickDown * 1))
        new.Primary.StaticRecoilFactor = (new.Primary.StaticRecoilFactor - (new.Primary.StaticRecoilFactor * 1))
    end
    if ply:GetNWString("VANILLABUFF","") == "Shuura" and (new.Base == "tfa_gun_base" or new.Base == "tfa_3dscoped_base") then
        new.Primary.KickUp = (new.Primary.KickUp - (new.Primary.KickUp * 1))
        new.Primary.KickDown = (new.Primary.KickDown - (new.Primary.KickDown * 1))
        new.Primary.StaticRecoilFactor = (new.Primary.StaticRecoilFactor - (new.Primary.StaticRecoilFactor * 1))

        new.Primary.RPM_MAX = new.Primary.RPM_MAX + (new.Primary.RPM_MAX * 0.2)
        new.Primary_TFA.RPM = new.Primary.RPM_MAX + (new.Primary.RPM_MAX * 0.2)
    end
end)

hook.Add( "EntityTakeDamage", "VANILLAFOOD_hook_EntityTakeDamage", function( target, dmginfo )
    if not IsValid(target) then return end

    local blPly = dmginfo:GetAttacker()
    if blPly:IsPlayer() and dmginfo:IsBulletDamage() and blPly:GetNWString("VANILLABUFF","") == "Food Basket" then
        dmginfo:ScaleDamage(1.1)
    elseif blPly:IsPlayer() and dmginfo:IsBulletDamage() and blPly:GetNWString("VANILLABUFF","") == "Macaroon" then
        dmginfo:ScaleDamage(1.15)
    end

    if target:IsPlayer() and target:GetNWString("VANILLABUFF","") == "Roast Porg" then
        dmginfo:ScaleDamage(0.9)
    elseif target:IsPlayer() and target:GetNWString("VANILLABUFF","") == "Macaroon" then
        dmginfo:ScaleDamage(0.85)
    end

    if blPly:IsPlayer() and blPly:GetActiveWeapon().Base == "dangumeleebase" and blPly:GetNWString("VANILLABUFF","") == "Steak" then
        dmginfo:ScaleDamage(1.5)
    end
end)

net.Receive("VANILLAFOOD_net_Purchase",function(len, ply)
    local id = net.ReadInt(6)
    local plyData = ReadPlayerStock(ply:SteamID64())

    //Is it a real item? Does the player have it in stock? Do they have enough money? Do they already have food?
    if not istable(vanillaIGFoodItems[id]) then return end
    if plyData[id] == 0 then return end
    if not ply:SH_CanAffordPremium(tonumber(vanillaIGFoodItems[id].Price)) then return end
    if ply:GetNWString("VANILLABUFF","") ~= "" then return end

    //Remove credits
    ply:SH_AddPremiumPoints(-(tonumber(vanillaIGFoodItems[id].Price)), nil, false, false)

    ply:SetNWString("VANILLABUFF",vanillaIGFoodItems[id].Name)
    plyData[id] = tonumber(plyData[id]) - 1
    SavePlayerStock(ply:SteamID64(),plyData)
    net.Start("VANILLAFOOD_net_Purchase")
    net.WriteInt(id,6)
    net.Send(ply)
    ManageFoodBuff(ply)
end)

hook.Add( "PlayerDeath", "VANILLAFOOD_hook_playedeath", function( victim, inflictor, attacker )
    if victim:IsPlayer() then
        if victim:GetNWString("VANILLABUFF") == "Ration Bar" then
        	ply.VANILLAOLDCrouchSpeed = ply:GetCrouchedWalkSpeed()
        end
                    
        victim:SetNWString("VANILLABUFF","")
        victim:SetNWInt("VANILLABUFFTIMER",0)

        if _G.HasAugment(victim, "Slow Metabolism") then
            ActivateAugment(victim,"Slow Metabolism",0)
        end
    end
end )

//Reset food stock
concommand.Add("vanilla_reset_food", function(ply)
    if not IsValid(ply) then
        local delTable = file.Find( "vanilla_food/*.json", "DATA")
        for k, v in pairs(delTable) do
            file.Delete("vanilla_food/" .. v)
        end
        for k, v in pairs(player.GetAll()) do
            CreatePlayerStock(v)
            v:ChatPrint("[MESS HALL] Food has been re-stocked!")
        end
    end
end)

hook.Add("PlayerSpawn", "VANILLAFOOD_hook_playerspawn", function(ply, cum)
            ply:AddEFlags(EFL_NO_DAMAGE_FORCES);
end)
