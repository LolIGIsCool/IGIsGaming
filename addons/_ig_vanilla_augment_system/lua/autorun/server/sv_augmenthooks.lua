util.AddNetworkString("VANILLAAUGMENTS_net_PlaySound");

//Check if a player has an augment
function HasAugment(ply,aug)
    if not ply:IsPlayer() then return end
    local plyData = ply.vanillaAugments or {};
    if table.HasValue(plyData,aug) then
        return true
    else
        return false
    end
end

//Activates an augment for the player.
function ActivateAugment(ply,aug,len)
    if not ply:IsPlayer() then return end
    local currentTable = util.JSONToTable(ply:GetNWString("VANILLAAUGMENTS_nwstring_ActiveAugments",""))
    if currentTable == nil then return end

    if len == false then
        table.RemoveByValue( currentTable, aug );
        ply:SetNWString("VANILLAAUGMENTS_nwstring_ActiveAugments", util.TableToJSON(currentTable));
    elseif len ~= 0 then
        //If it's already there
        if table.HasValue( currentTable, aug ) then return end

        table.insert(currentTable,aug)
        ply:SetNWString("VANILLAAUGMENTS_nwstring_ActiveAugments", util.TableToJSON(currentTable))
        timer.Simple(len,function()
            local currentTable2 = util.JSONToTable(ply:GetNWString("VANILLAAUGMENTS_nwstring_ActiveAugments",""))
            if currentTable2 == nil then return end

            table.RemoveByValue( currentTable2, aug )
            ply:SetNWString("VANILLAAUGMENTS_nwstring_ActiveAugments", util.TableToJSON(currentTable2))
        end)

    elseif len == 0 then
        if table.HasValue( currentTable, aug ) then
            table.RemoveByValue( currentTable, aug )
            ply:SetNWString("VANILLAAUGMENTS_nwstring_ActiveAugments", util.TableToJSON(currentTable))
        else
            table.insert(currentTable,aug)
            ply:SetNWString("VANILLAAUGMENTS_nwstring_ActiveAugments", util.TableToJSON(currentTable))
        end
    end
end

local logisticsPrimeWeapons = {
    "ven_riddick_dlt23v",
    "rw_sw_sg6",
    "rw_sw_tl40",
    "rw_sw_e11sp",
    "rw_sw_dual_se44c",
    "rw_sw_dlt19s",
    "rw_sw_dual_dc15s",
    "rw_sw_ib94"
}

//global variables
function ApplyHealthBoosters(ply)
    if not ply:GetVar("AugmentsActive", true) then return end

    local maxHealth = ply:GetJobTable().Health;
    local newHealth = ply:GetJobTable().Health;

    if HasAugment(ply, "Health Booster I") then newHealth = math.floor(maxHealth + maxHealth * 0.05) end
    if HasAugment(ply, "Health Booster II") then newHealth = math.floor(newHealth + maxHealth * 0.05) end
    if HasAugment(ply, "Health Booster III") then newHealth = math.floor(newHealth + maxHealth * 0.1) end

    ply:SetMaxHealth(newHealth);
    ply:SetHealth(newHealth);
end

function ApplyAmmoBoosters(ply)
    if not ply:GetVar("AugmentsActive", true) then return end

    if HasAugment(ply, "Ammunition Hoarder I") then
        local ammoTable = ply:GetAmmo()
        for k, v in pairs(ammoTable) do
            ply:SetAmmo(v + (v * 0.1), k)
        end
    end
    if HasAugment(ply, "Ammunition Hoarder II") then
        local ammoTable = ply:GetAmmo()
        for k, v in pairs(ammoTable) do
            ply:SetAmmo(v + (v * 0.1), k)
        end
    end
end

function ApplySpeedBoosters(ply)
    if not ply:GetVar("AugmentsActive", true) then return end

    //standard walk speed
	ply:SetWalkSpeed(ply:GetJobTable().WalkSpeed);
            
    //slow walk speed
	ply:SetSlowWalkSpeed(100);

    //Sprint Speed
    local runSpeed = ply:GetJobTable().RunSpeed;

    if HasAugment(ply, "Faster Than Light I") then runSpeed = runSpeed + (runSpeed * 0.025) end
    if HasAugment(ply, "Faster Than Light II") then runSpeed = runSpeed + (runSpeed * 0.025) end
    if HasAugment(ply, "Faster Than Light III") then runSpeed = runSpeed + (runSpeed * 0.05) end

    ply:SetRunSpeed(runSpeed);

    //Crawl Speed
    local crouchSpeed = ply:GetCrouchedWalkSpeed();

    if HasAugment(ply, "Skilled Crawler I") then crouchSpeed = crouchSpeed + (crouchSpeed * 0.25) end
    if HasAugment(ply, "Skilled Crawler II") then crouchSpeed = crouchSpeed + (crouchSpeed * 0.25) end
    if HasAugment(ply, "Skilled Crawler III") then crouchSpeed = crouchSpeed + (crouchSpeed * 0.25) end

    ply:SetCrouchedWalkSpeed(crouchSpeed);
end

hook.Add("PlayerInitialSpawn","VANILLAAUGMENTS_hook_PlayerInitialSpawn", function(ply)
    ply:SetVar("AugmentsActive", true)
end)

hook.Add("PlayerSpawn","VANILLAAUGMENTS_hook_PlayerSpawn", function(ply)
timer.Simple(0,function()
    //Assigns every player an active augment table
    local blankTable = {}
    ply:SetNWString("VANILLAAUGMENTS_nwstring_ActiveAugments", util.TableToJSON(blankTable))
    ply:SetNWString("ResentmentSource", util.TableToJSON(blankTable));

    //player variables
    ply:SetVar("CanEventHorizon",true)
    ply:SetVar("EventHorizonActive",false)

    ply:SetVar("CanLastStand",true)
    ply:SetVar("LastStandActive",false)

    ply:SetNWBool("InspiringAuraSource",false)
    ply:SetNWBool("InspiringAuraActive",false)

    ply:SetVar("CanSprintShoot",true);
    ply:SetNWBool("SprintShootActive",false);

    ply:SetNWBool("WookieArmsTarget",false);

    ply:SetVar("CanLogistics",true);

    //apply boosters things
    ApplyHealthBoosters(ply);
    ApplyAmmoBoosters(ply);
    ApplySpeedBoosters(ply);

    //logisctis prime
    if HasAugment(ply, "Logistics Prime") and ply:GetVar("AugmentsActive", true) and ply:GetVar("CanLogistics",false) then
        ply:SetVar("CanLogistics",false);

        local randomNumberOfDoom = math.random(1,#logisticsPrimeWeapons);

        ply:Give(logisticsPrimeWeapons[randomNumberOfDoom]);
        ActivateAugment(ply,"Logistics Prime",6);
        net.Start("VANILLAAUGMENTS_net_PlaySound");
        net.WriteInt(5,4);
        net.Send(ply);

        //prevent exploit
        timer.Simple(5,function()
            if not ply:IsValid() then return end

            ply:SetVar("CanLogistics",true);
        end)
    end

    //exception time
    if ply:SteamID64() == "76561198247581466" and ply:Nick() == "Cinnamon" then
      	ply:SetModel("models/vanilla/vanilla_female_inquisitor.mdl");
    end

    if ply:GetRegiment() == "Shadow Unit" then
        ply:GiveAmmo(3,"slam",true);
   	end
end)
end)

local plymeta = FindMetaTable("Player")

function plymeta:CanRegen()
    if not self:IsPlayer() then return false end
    if self:Health() >= self:GetMaxHealth() then return false end
    if not self:GetNWBool("ighealthregen", true) then return false end
    if not HasAugment(self, "Passive Recovery") then return false end
    if not self:Alive() then return false end
    if not self:GetVar("AugmentsActive", true) then return false end

    return true
end

function plymeta:CanEventHorizon()
    if not self:IsPlayer() then return false end
    if not HasAugment(self, "Event Horizon") then return false end
    if not self:GetVar("CanEventHorizon") then return false end
    if not self:Alive() then return false end
    if not self:GetVar("AugmentsActive", true) then return false end

    return true
end

function plymeta:CanLastStand()
    if not self:IsPlayer() then return false end
    if not HasAugment(self, "Last Stand") then return false end
    if not self:GetVar("CanLastStand") then return false end
    if not self:Alive() then return false end
    if not self:GetVar("AugmentsActive", true) then return false end

    return true
end

function plymeta:CanBloodlust()
    if not self:IsPlayer() then return false end
    if not HasAugment(self, "Bloodlust") then return false end
    if self:Health() >= self:GetMaxHealth() then return false end
    if not self:Alive() then return false end
    if not self:GetVar("AugmentsActive", true) then return false end

    return true
end

function plymeta:CanCritStrike()
    if not self:IsPlayer() then return false end
    if not HasAugment(self, "Critical Strike I") then return false end
    if not self:Alive() then return false end
    if not self:GetVar("AugmentsActive", true) then return false end

    return true
end

function plymeta:CanZenith()
    if not self:IsPlayer() then return false end
    if not HasAugment(self, "Zenith Potential") then return false end
    if not self:Alive() then return false end
    if not self:GetVar("AugmentsActive", true) then return false end

    return true
end

timer.Create("VANILLAAUGMENTS_timer_HealthRegen", 25, 0, function()
    for k, v in pairs(player.GetAll()) do
        if v:CanRegen() then
            local maxHealth = v:GetMaxHealth()
            local health = v:Health()
            local missingHealth = maxHealth - health
            if 10 <= missingHealth then
                v:SetHealth(health + 10)
            else
                v:SetHealth(maxHealth)
            end
            ActivateAugment(v,"Passive Recovery",2)
        end
    end
end)

hook.Add( "PlayerShouldTakeDamage", "VANILLAAUGMENTS_hook_EventHorizon", function( ply )
    if not IsValid(ply) then return end
    if ply:GetVar("EventHorizonActive",false) then
        return false
    end
end)

hook.Add( "EntityTakeDamage", "VANILLAAUGMENTS_hook_EntityTakeDamage", function( target, dmginfo )
    if not IsValid(target) then return end

    //Crits
    local blPly = dmginfo:GetAttacker()
    if blPly:IsPlayer() and blPly:CanCritStrike() then
        local critChance
        if HasAugment(blPly,"Critical Strike II") then
            critChance = 0.1
        else
            critChance = 0.05
        end
        local critDamage
        if HasAugment(blPly,"Critical Limit") then
            critDamage = 2.5
        else
            critDamage = 2
        end

        if math.Rand(0,1) < critChance then
            ActivateAugment(blPly,"Critical Strike I",0.3)
            dmginfo:ScaleDamage(critDamage)
        end
    end

    //Last Stand
    if blPly:IsPlayer() and blPly:GetVar("LastStandActive",false) then
        dmginfo:ScaleDamage(2)
    end

    //Zenith Potential
    if blPly:IsPlayer() and blPly:CanZenith() and (blPly:GetActiveWeapon():Clip1()) <= (blPly:GetActiveWeapon():GetMaxClip1() * 0.1) then
        ActivateAugment(blPly,"Zenith Potential",0.3)
        dmginfo:ScaleDamage(1.1)
    end

    if not target:IsPlayer() then return end
    if target:GetNWBool("InspiringAuraActive",false) then
        dmginfo:ScaleDamage(0.9)
    end

    //Evasive Stance
    if target:IsPlayer() and target:GetVar("AugmentsActive", true) and HasAugment(target, "Evasive Stance I") then
        local chance = 0.025;
        local pic = "Evasive Stance I";
        if HasAugment(target, "Evasive Stance II") then
            chance = 0.05;
            pic = "Evasive Stance II";
        end

        if math.Rand(0,1) < chance then
            ActivateAugment(target, pic, 1);
            dmginfo:ScaleDamage(0.5);
        end
    end

    //Steadfast Presence
    if target:IsPlayer() then
        target:SetVar("SteadfastOLDVELOCITY",target:GetVelocity());
    end

    //wooikie amrs
    if target:GetNWBool("WookieArmsTarget",false) then
        dmginfo:ScaleDamage(1.3);
    end

    //personal resentment
    local resentTable = util.JSONToTable(target:GetNWString("ResentmentSource","[]"));
    if blPly:IsPlayer() and table.HasValue(resentTable, blPly:Nick()) then
        dmginfo:ScaleDamage(1.05);
    end
                
        //Event Horizon
    if target:IsPlayer() and (target:Health() - dmginfo:GetDamage() <= 0) and target:CanEventHorizon() then
        target:GodEnable();
        dmginfo:SetDamage(0);
                    
        ActivateAugment(target,"Event Horizon",1.2)
        target:SetVar("CanEventHorizon",false)
        target:SetVar("EventHorizonActive",true)
        timer.Simple(1.2,function()
            if not IsValid(target) then return end
            target:SetVar("EventHorizonActive",false)
            target:GodDisable();
        end)

        net.Start("VANILLAAUGMENTS_net_PlaySound");
        net.WriteInt(1,4);
        net.Send(target);
    end
end)

hook.Add("PostPlayerDeath","VANILLAAUGMENTS_hook_PostPlayerDeath", function(ply)
    for _, v in pairs(ents.GetAll()) do
        if not v:IsPlayer() or not v:IsNPC() then continue end

        local resentTable = util.JSONToTable(v:GetNWString("ResentmentSource","[]"));
        table.RemoveByValue(resentTable, ply:Nick());

        v:SetNWString("ResentmentSource", util.TableToJSON(resentTable));
    end
end)

hook.Add("PostEntityTakeDamage", "VANILLAAUGMENTS_hook_PostEntityTakeDamage", function(ply, dmginfo, took)
    if not IsValid(ply) then return end

    //Steadfast Presence
    if ply:IsPlayer() and HasAugment(ply, "Steadfast Presence I") and ply:GetVar("AugmentsActive", true) then
        local velFactor = 0.25;
        local whichPicYO = "Steadfast Presence I"

        if HasAugment(ply, "Steadfast Presence II") then velFactor = 0.5 whichPicYO = "Steadfast Presence II" end

        local newvel = ply:GetVelocity() * velFactor;
        local oldvel = ply:GetVar("SteadfastOLDVELOCITY", Vector(0,0,0));
        ply:SetVelocity(oldvel - newvel);

        ActivateAugment(ply, whichPicYO, 1);
    end

    //Last Stand
    if ply:IsPlayer() and (ply:Health() <= 30) and ply:CanLastStand() then
        ActivateAugment(ply,"Last Stand",3)
        ply:SetVar("CanLastStand",false)
        ply:SetVar("LastStandActive",true)
        timer.Simple(3,function()
            if not IsValid(ply) then return end
            ply:SetVar("LastStandActive",false)
        end)

        net.Start("VANILLAAUGMENTS_net_PlaySound");
        net.WriteInt(2,4);
        net.Send(ply);
    end

    //Bloodlust
    blPly = dmginfo:GetAttacker()
    if blPly:IsPlayer() and blPly:CanBloodlust() and took == true and ply ~= blPly and (ply:IsPlayer() or ply:IsNPC()) then
        blPly:SetHealth(blPly:Health() + math.ceil(dmginfo:GetDamage() * 0.05))
        if blPly:Health() <= blPly:GetMaxHealth() then
            ActivateAugment(blPly,"Bloodlust",0.3)
        end
    end

    //Wookie Arms
    if blPly:IsPlayer() and (ply:IsPlayer() or ply:IsNPC()) and HasAugment(blPly,"Wookie Arms") and blPly:GetVar("AugmentsActive",true) and not ply:GetNWBool("WookieArmsTarget",false) then
        if not string.StartWith(blPly:GetActiveWeapon():GetClass(),"imperialarts") then return end

        ply:SetNWBool("WookieArmsTarget",true);
        ActivateAugment(blPly, "Wookie Arms", 2);

        timer.Simple(2,function()
            if not ply:IsValid() then return end

            ply:SetNWBool("WookieArmsTarget",false);
        end)
    end

    //personal resentment
    local resentmentTable = util.JSONToTable(blPly:GetNWString("ResentmentSource", "[]"));

    if (blPly:IsPlayer() or blPly:IsNPC()) and HasAugment(ply, "Personal Resentment") and ply:GetVar("AugmentsActive",true) and not table.HasValue(resentmentTable, ply:Nick()) and ply ~= blPly then

        table.insert(resentmentTable, ply:Nick());
        blPly:SetNWString("ResentmentSource", util.TableToJSON(resentmentTable));

        timer.Simple(2,function()
            local resentmentTable2 = util.JSONToTable(blPly:GetNWString("ResentmentSource", "[]"));
            table.RemoveByValue(resentmentTable2, ply:Nick());
            blPly:SetNWString("ResentmentSource", util.TableToJSON(resentmentTable2));
        end)
    end
end)

//dead eye
hook.Add("PlayerSwitchWeapon","VANILLAAUGMENTS_hook_PlayerSwitchWeapon",function(ply, old, new)
    ActivateAugment(ply,"Inspiring Aura", false);

    if HasAugment(ply,"Inspiring Aura") and (new.Base == "tfa_gun_base" or new.Base == "tfa_3dscoped_base") and not ply:GetNWBool("InspiringAuraSource", false) and ply:GetVar("AugmentsActive",true) then
        ActivateAugment(ply,"Inspiring Aura",0);
    end

    local percent = (5 / 100)
    if HasAugment(ply,"Dead Eye I") and (new.Base == "tfa_gun_base" or new.Base == "tfa_3dscoped_base") and ply:GetVar("AugmentsActive",true) then
        new.Primary.KickUp = (new.Primary.KickUp - (new.Primary.KickUp * percent))
        new.Primary.Spread = (new.Primary.Spread - (new.Primary.Spread * percent))
        new.Primary.StaticRecoilFactor = (new.Primary.StaticRecoilFactor - (new.Primary.StaticRecoilFactor * percent))
        new.Primary.IronAccuracy = (new.Primary.IronAccuracy - (new.Primary.IronAccuracy * percent))
    end
    if HasAugment(ply,"Dead Eye II") and (new.Base == "tfa_gun_base" or new.Base == "tfa_3dscoped_base") and ply:GetVar("AugmentsActive",true) then
        new.Primary.KickUp = (new.Primary.KickUp - (new.Primary.KickUp * percent))
        new.Primary.Spread = (new.Primary.Spread - (new.Primary.Spread * percent))
        new.Primary.StaticRecoilFactor = (new.Primary.StaticRecoilFactor - (new.Primary.StaticRecoilFactor * percent))
        new.Primary.IronAccuracy = (new.Primary.IronAccuracy - (new.Primary.IronAccuracy * percent))
    end
end)

timer.Create("VANILLAUGMENTS_timer_InspiringAuraRemoval", 5, 0,function()
    for _, v in ipairs(player.GetAll()) do
        v:SetNWBool("InspiringAuraActive",false);
    end
end)

timer.Create("VANILLAUGMENTS_timer_InspiringAuraApply", 3, 0,function()
    for _, v in ipairs(player.GetAll()) do
        //Set source
        if HasAugment(v,"Inspiring Aura") and (v:GetActiveWeapon().Base == "tfa_gun_base" or v:GetActiveWeapon().Base == "tfa_3dscoped_base") and v:GetVar("AugmentsActive", true) and v:GetRegiment() ~= "Event" then
        	v:SetNWBool("InspiringAuraSource",true);
    	else
        	v:SetNWBool("InspiringAuraSource",false);
    	end
                    
        if v:GetNWBool("InspiringAuraSource", false) then
        	local sphere = ents.FindInSphere(v:GetPos(), 200);
        	for _, o in pairs(sphere) do
         	   if not o:IsPlayer() then continue end
               if o:GetRegiment() == "Event" then continue end
         	   o:SetNWBool("InspiringAuraActive",true);
        	end
    	end
    end
end)

hook.Add("PlayerTick","VANILLAAUGMENTS_hook_Think",function(ply, mv)
    if mv:KeyDown(IN_SPEED) and not ply:GetNWBool("SprintShootActive",true) and HasAugment(ply, "Unstoppable Advance") and ply:GetVar("CanSprintShoot",false) and ply:GetVar("AugmentsActive",true) and (ply:GetActiveWeapon().Base == "tfa_gun_base" or ply:GetActiveWeapon().Base == "tfa_3dscoped_base") then

        ply:SetVar("CanSprintShoot",false);
        ply:SetNWBool("SprintShootActive",true);
        ActivateAugment(ply, "Unstoppable Advance", 4);
        net.Start("VANILLAAUGMENTS_net_PlaySound");
        net.WriteInt(4,4);
        net.Send(ply);

        timer.Simple(4,function()
            if not ply:IsValid() then return end
            ply:SetNWBool("SprintShootActive",false);
            timer.Simple(40,function()
                if not ply:IsValid() then return end

                ply:SetVar("CanSprintShoot",true);
            end)
        end)
    end

    //if shoot + has augment + augments active + tfa gun
    if ply:KeyDown(IN_ATTACK) and HasAugment(ply, "Efficient Discharge") and ply:GetVar("Augments Active",true) and (ply:GetActiveWeapon().Base == "tfa_gun_base" or ply:GetActiveWeapon().Base == "tfa_3dscoped_base") and ply:GetActiveWeapon():CanPrimaryAttack() then
        local gun = ply:GetActiveWeapon();

        if math.Rand(0,1) < 0.05 then
            ply:GiveAmmo(1,gun.Primary.Ammo,true);
            ActivateAugment(ply,"Efficient Discharge",0.1);
        end
    end
end)

//debt collectorrrr
hook.Add("PlayerDeath","VANILLAAUGMENTS_hook_DebtCollectorPLY",function(vic,item,ply)
    if not ply:IsPlayer() then return end
    if vic == ply then return end
    if HasAugment(ply,"Debt Collector") and (vic:GetRegiment() == "Event" or vic:GetRegiment() == "Event2") and ply:GetVar("AugmentsActive",true) then
        ply:SH_AddPremiumPoints(math.random(25,5), nil, false, false)

        ActivateAugment(ply,"Debt Collector", 0.5)
        net.Start("VANILLAAUGMENTS_net_PlaySound");
        net.WriteInt(3,4);
        net.Send(ply);
    end
end)
hook.Add("OnNPCKilled","VANILLAAUGMENTS_hook_DebtCollectorNPC",function(vic,ply)
    if not ply:IsPlayer() then return end
    if HasAugment(ply,"Debt Collector") and ply:GetVar("AugmentsActive",true) then
        ply:SH_AddPremiumPoints(math.random(25,5), nil, false, false)

        ActivateAugment(ply,"Debt Collector", 0.5)
        net.Start("VANILLAAUGMENTS_net_PlaySound");
        net.WriteInt(3,4);
        net.Send(ply);
    end
end)

//Starship Overdrive

hook.Add("PlayerEnteredVehicle","VANILLAAUGMENTS_hook_StarshipOverdriveEnter",function(ply)
    if not IsValid(ply) then return end
    local veh = ply:lfsGetPlane()
    if not IsValid(veh) then return end

    if HasAugment(ply,"Starship Overdrive") and ply:GetVar("AugmentsActive",true) then
        local oldHealth = veh.MaxHealth
        local ammo1 = veh.MaxPrimaryAmmo
        local ammo2 = veh.MaxSecondaryAmmo

        local newHealth = oldHealth + (oldHealth * 0.05)
        if ammo1 > 0 then
            veh.MaxPrimaryAmmo = ammo1 + (ammo1 * 0.1)
        end
        if ammo2 > 0 then
            veh.MaxSecondaryAmmo = ammo2 + (ammo2 * 0.1)
        end

        if veh:GetHP() == oldHealth then
            veh:SetHP(newHealth)
            veh:SetAmmoPrimary(veh.MaxPrimaryAmmo)
            veh:SetAmmoSecondary(veh.MaxSecondaryAmmo)
        end

        ActivateAugment(ply,"Starship Overdrive",0)
    end
end)

hook.Add("PlayerLeaveVehicle","VANILLAAUGMENTS_hook_StarshipOverdriveLeave",function(ply)
    if not IsValid(ply) then return end

    ActivateAugment(ply,"Starship Overdrive", false);
end)
