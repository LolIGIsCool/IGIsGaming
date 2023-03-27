print("Running fpscmd.lua (print at top of file)")
function hook.Exists(hook, identifier)
    return isfunction(hook.GetTable()[hook][identifier])
end

local function fpsfix(ply)
    ply:ConCommand("Gmod_mcore_test 1")
    ply:ConCommand("mat_queue_mode -1")
    ply:ConCommand("cl_threaded_bone_setup 1")
end

concommand.Add("fpsfix", fpsfix)

local function retryfix(ply)
    ply:ConCommand("retry")
end

concommand.Add("retfix", retryfix)

local moosefixfacesmodels = {
    ["models/player/swbf_imperial_isb_agentv2/swbf_imperial_isb_agentv2.mdl"] = true,
    ["models/player/swbf_imperial_officer_admiralv2/swbf_imperial_officer_admiralv2.mdl"] = true,
    ["models/player/swbf_imperial_officer_colonelv2/swbf_imperial_officer_colonelv2.mdl"] = true,
    ["models/player/swbf_imperial_officer_commodorev2/swbf_imperial_officer_commodorev2.mdl"] = true,
    ["models/player/swbf_imperial_officer_ensignv2/swbf_imperial_officer_ensignv2.mdl"] = true,
    ["models/player/swbf_imperial_officer_grand_admiralv2/swbf_imperial_officer_grand_admiralv2.mdl"] = true,
    ["models/player/swbf_imperial_officer_isbofficerv2/swbf_imperial_officer_isbofficerv2.mdl"] = true,
    ["models/player/swbf_imperial_officer_lieutenantv2/swbf_imperial_officer_lieutenantv2.mdl"] = true,
    ["models/player/swbf_imperial_officer_ncov2/swbf_imperial_officer_ncov2.mdl"] = true
}

local function moosefixfaces(ply)
    if moosefixfacesmodels[ply:GetModel()] then
        local FlexNum = ply:GetFlexNum()
        for i = 0, FlexNum do
            ply:SetFlexWeight(i, 0)
        end
    end
end

hook.Add("PlayerSpawn", "MooseFixFaces", moosefixfaces)

--does it work?
--function peskynetexploiters()
--for k,v in pairs(net.Receivers) do print(debug.getinfo(v).source) end
--end
--[[
hook.Add("PlayerButtonDown", "mooseman123", function(ply, key)
    if (key == KEY_F12) then
        if SERVER then
            local servertime = os.date("%I:%M %p")
            local tookscreenshot = "User " .. ply:Nick() .. "(" .. ply:SteamID() .. ") just took a screenshot at " .. servertime .. " \n"
            file.Append("screenshots.txt", tookscreenshot)
            print(ply:Nick() .. " just took a screenshot")
        end
    end
end)]]

hook.Add("IGPlayerSay", "morefpsyay", function(ply, text)
    if (text:lower() == "!info") then
        ply:ChatPrint("------ Current Job Statistics ------")
        ply:ChatPrint("Regiment: " .. ply:GetJobTable().Regiment)
        ply:ChatPrint("Rank: " .. ply:GetJobTable().Name)
        ply:ChatPrint("Current Health: " .. ply:Health())
        ply:ChatPrint("Max Health: " .. ply:GetJobTable().Health)
        ply:ChatPrint("Clearance: " .. ply:GetJobTable().Clearance)
        ply:ChatPrint("Job Count: " .. ply:GetJobTable().Count)
    end

    if (text:lower() == "!library") then
        ply:SendLua([[gui.OpenURL("https://docs.google.com/spreadsheets/d/1M_qXTTHWzw2FU3jkg4ieCCDOhTz6lxonPyK8p0qYHX4/edit#gid=0")]])
    end
	
	if (text:lower() == "!discord") then
        ply:ChatPrint("Discord Invite link - discord.gg/imperialgaming")
    end
	
    if (text:lower() == "!help") then
        ply:ChatPrint("!fps - Helps improve FPS")
        ply:ChatPrint("!content - Shows steam content pack.")
        ply:ChatPrint("!steam       - Shows steam group page.")
        ply:ChatPrint("!donate      - Shows donation page.")
        ply:ChatPrint("!forums  - Shows our forums.")
        ply:ChatPrint("!cl          - Shows clearance levels.")
        ply:ChatPrint("!rules       - Shows our server rules.")
        ply:ChatPrint("!library         - Lists of IG related links.")
        ply:ChatPrint("!info        - Shows Stats of your current job.")
        ply:ChatPrint("!nlr        - Shows the NLR Rules.")
        ply:ChatPrint("!dupe        - Shows the Adv Dupe 2 Rules.")
		ply:ChatPrint("!discord        - Shows Discord invite link.")
    end
end)

function setelevatorbuttons()
    if game.GetMap() ~= "rp_stardestroyer_v2_7_inf" then return end

    for k, v in pairs(ents.FindInSphere(Vector( -254, -1897, -4807 ), 5)) do
        if v and v:IsValid() and v:GetClass() == "func_button" then
            v:SetNWBool("elevatorbutton", true)
        end
    end

    for k, v in pairs(ents.FindInSphere(Vector(-129.75, -1897, -5512.06), 5)) do
        if v and v:IsValid() and v:GetClass() == "func_button" then
            v:SetNWBool("elevatorbutton", true)
        end
    end
end

hook.Add("InitPostEntity", "InitPostEntitySetDoors22", setelevatorbuttons)
hook.Add("PostCleanupMap", "PostCleanupMapSetDoors22", setelevatorbuttons)

local elevatorButtons = {298,379,380,283}
hook.Add("PlayerUse", "autisms", function(ply, ent)
    local entID = ent:EntIndex()
    if (ply.plyusecd or 0) > CurTime() then return end
    ply.plyusecd = CurTime() + 1 
    if ply == iggetkumo() then
        ply:ChatPrint(tostring(entID))
    end

    if ent:GetClass() == "func_button" and table.HasValue(elevatorButtons, entID) and game.GetMap() == "rp_stardestroyer_v2_7_inf" then
        if SERVER then
            local lift_plat3 = ents.FindByName("lift_plat3")[1]
            if lift_plat3:GetVelocity().z > 1 then ply:ChatPrint("The elevator is currently on the move, please wait") return false end
            if lift_plat3:GetVelocity().z < 0 then ply:ChatPrint("The elevator is currently on the move, please wait") return false end
        end
    end

    if entID == 500 and game.GetMap() == "rp_titan_base_bananakin" then
        if SERVER then
            timer.Simple(5, function()
                ent:Input("Use", ply, ent)
            end)
        end
    end

    if entID == 1621 and game.GetMap() == "rp_titan_base_bananakin" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "briefing", "calling", "button")
        end
    end

    if entID == 1622 and game.GetMap() == "rp_titan_base_bananakin" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "debrief", "calling", "button")
        end
    end

    if entID == 297 and game.GetMap() == "rp_titan_base_bananakin" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "turned", "the", "shield", "generator", "on")
        end
    end

    if entID == 298 and game.GetMap() == "rp_titan_base_bananakin" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "turned", "the", "shield", "generator", "off")
        end
    end

    if entID == 1596 and game.GetMap() == "rp_titan_base_bananakin" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "facility", "alarm", "button")
        end
    end

    if entID == 612 and game.GetMap() == "rp_rishimoon_crimson" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "alarm!")
        end
    end

    if entID == 868 and game.GetMap() == "rp_rishimoon_crimson" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "first", "power", "button!")
        end
    end

    if entID == 610 and game.GetMap() == "rp_rishimoon_crimson" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "second", "power", "button!")
        end
    end

    if entID == 866 and game.GetMap() == "rp_rishimoon_crimson" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "third", "power", "button!")
        end
    end

    if entID == 378 and game.GetMap() == "rp_stardestroyer_v2_7_inf" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "alarm!")
        end
    end

    if entID == 372 and game.GetMap() == "rp_stardestroyer_v2_7_inf" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "alarm!")
        end
    end

    if entID == 943 and game.GetMap() == "rp_stardestroyer_v2_7_inf" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "alarm!")
        end
    end

    --hyper space
    if entID == 1570 and game.GetMap() == "rp_stardestroyer_v2_7_inf" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "hyperspace", "jump", "button!")
        end
    end

    --power
    if entID == 789 and game.GetMap() == "rp_stardestroyer_v2_7_inf" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "power", "button!")
        end
    end
        
    -- fleet button
    if entID == 1185 and game.GetMap() == "rp_stardestroyer_v2_7_inf" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "fleet", "button!")
        end
		if ply:SteamID() == "STEAM_0:0:18299963" and "STEAM_0:0:178929973" and "STEAM_0:0:145575207" then
			RunConsoleCommand("ulx", "cexec", ply:Nick(), "say", "/me has a heart attack" )
           	RunConsoleCommand("ulx", "slay", ply:Nick() )
        end
    end

    -- Turbolaser 1
    if entID == 817 and game.GetMap() == "rp_deathstar_v1_2" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "first", "turbolaser", "button!")
        end
    end

    -- Turbolaser 2
    if entID == 816 and game.GetMap() == "rp_deathstar_v1_2" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "second", "turbolaser", "button!")
        end
    end

    -- Turbolaser 3
    if entID == 820 and game.GetMap() == "rp_deathstar_v1_2" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "third", "turbolaser", "button", "WATCH", "OUT", "OMG")
        end
    end

    -- Turbolaser override button
    if entID == 1034 and game.GetMap() == "rp_deathstar_v1_2" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "turbolaser", "override", "button", "WATCH", "OUT", "OMG")
        end
    end

    -- Turbolaser override button
    if entID == 1035 and game.GetMap() == "rp_deathstar_v1_2" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "turbolaser", "override", "toggle", "thingy")
        end
    end

    -- Hyperspace
    if entID == 13 and game.GetMap() == "rp_deathstar_v1_2" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "hyperspace", "button")
        end
    end

    -- Lockdown
    if entID == 651 and game.GetMap() == "rp_deathstar_v1_2" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "lockdown", "button")
        end
    end

    -- Alarm 
    if entID == 647 and game.GetMap() == "rp_deathstar_v1_2" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "alarm", "button")
        end
    end

    -- red lights thing
    if entID == 648 and game.GetMap() == "rp_deathstar_v1_2" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "red", "lights", "thingy")
        end
    end

    -- Airlock Door 1
    if entID == 1349 and game.GetMap() == "rp_deathstar_v1_2" then
        if SERVER then
            RunConsoleCommand("ulx", "tsay", ply:Nick(), "(", ply:Team(), ")", "has", "entered", "the", "control", "room", "airlock")
        end
    end

    -- Airlock Door 2
    if entID == 661 and game.GetMap() == "rp_deathstar_v1_2" then
        if SERVER then
            RunConsoleCommand("ulx", "tsay", ply:Nick(), "(", ply:Team(), ")", "has", "activated", "the", "control", "room", "airlock")
        end
    end

    -- Docking Bay 327
    if entID == 1326 and game.GetMap() == "rp_deathstar_v1_2" then
        if SERVER then
            RunConsoleCommand("ulx", "tsay", ply:Nick(), "(", ply:Team(), ")", "has", "activated", "the", "Docking", "Bay", "327", "Door")
        end
    end

    -- TIE Hangar Bay 62-N9
    if entID == 1328 and game.GetMap() == "rp_deathstar_v1_2" then
        if SERVER then
            RunConsoleCommand("ulx", "tsay", ply:Nick(), "(", ply:Team(), ")", "has", "activated", "TIE", "Hangar", "Bay", "62-N9", "Door")
        end
    end

    -- Docking Bay 327 Lift
    if entID == 1041 and game.GetMap() == "rp_deathstar_v1_2" then
        if SERVER then
            RunConsoleCommand("ulx", "tsay", ply:Nick(), "(", ply:Team(), ")", "has", "activated", "the", "Docking", "Bay", "327", "Lift")
        end
    end

    -- TIE Hangar Bay 62-N9 Lift
    if entID == 1350 and game.GetMap() == "rp_deathstar_v1_2" then
        if SERVER then
            RunConsoleCommand("ulx", "tsay", ply:Nick(), "(", ply:Team(), ")", "has", "activated", "TIE", "Hangar", "Bay", "62-N9", "Lift")
        end
    end

    if entID == 261 and game.GetMap() == "rp_storm_outpost" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "alarm", "button")
        end
    end

    if entID == 1104 and game.GetMap() == "rp_storm_outpost" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "opened", "the", "main", "gate")
        end
    end
	
	if game.GetMap() == "rp_lothal" then --lothal base
        if ent:GetName() == "Engine_Cont_Button_1" then
			if SERVER then
				RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "first", "reactor", "button")
			end
		end
		if ent:GetName() == "Engine_Cont_Button_2" then
			if SERVER then
				RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "second", "reactor", "button")
			end
		end
		if ent:GetName() == "Engine_Cont_Button_3" then
			if SERVER then
				RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "third", "reactor", "button")
			end
		end
    end
	
	-- rp_batuu_v2
	if entID == 1636 and game.GetMap() == "rp_batuu_v2" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "alarm", "button!")
        end
    end
    if entID == 1665 and game.GetMap() == "rp_batuu_v2" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "Event Soon", "button!")
        end
    end
    if entID == 1666 and game.GetMap() == "rp_batuu_v2" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "DB Call", "button!")
        end
    end
    if entID == 1663 and game.GetMap() == "rp_batuu_v2" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "Alarm Sound", "button!")
        end
    end
    if entID == 2693 and game.GetMap() == "rp_batuu_v2" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "Dropship Alert", "button!")
        end
    end
    if entID == 2424 and game.GetMap() == "rp_batuu_v2" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "NPC Smart", "button!")
        end
    end
    if entID == 2609 and game.GetMap() == "rp_batuu_v2" then
        if SERVER then
            RunConsoleCommand("ulx", "asay", ply:Nick(), "(", ply:SteamID(), ")", "has", "pressed", "the", "Reactor", "button!")
        end
    end
	
end)

function SetDoorsIG()
    print("LOADING DOORS")

    if game.GetMap() == "rp_rishimoon_crimson_ig_v1" then
        for _, ent in pairs(ents.FindByName("kadeci_shield")) do
            SafeRemoveEntityDelayed(ent, 0)
        end
    end

    if game.GetMap() == "rp_unity_base" then
        for _, ent in pairs(ents.FindByName("cellblock_shield79")) do
            SafeRemoveEntityDelayed(ent, 0)
        end
    end

    if game.GetMap() == "rp_stardestroyer_v2_7_inf" then
        for _, ent in pairs(ents.FindByClass("func_monitor")) do
            SafeRemoveEntityDelayed(ent, 0)
        end
    end

    --if game.GetMap() == "rp_stardestroyer_v2_6_inf" then
    --    for _, ent in pairs(ents.FindByName("buttonLockDownG")) do
    --        SafeRemoveEntityDelayed(ent, 0)
    --    end
    --end

    --if game.GetMap() == "rp_stardestroyer_v2_6_inf" then
    --    for _, ent in pairs(ents.FindByName("buttonLockDownR")) do
    --        SafeRemoveEntityDelayed(ent, 0)
    --    end
    --end

    timer.Simple(30, function()
        for k, v in pairs(ents.FindByClass("prop_dynamic")) do
            if v:GetModel() == "models/props_combine/portalskydome.mdl" then
                v:SetColor(Color(33, 255, 0, 255))
            end
        end
    end)

    if game.GetMap() == "rp_stardestroyer_v2_7_inf" then
        for _, ent in pairs(ents.FindByClass("func_reflective_glass")) do
            SafeRemoveEntityDelayed(ent, 0)
        end
    end

    if SERVER then
        if game.GetMap() == "rp_stardestroyer_v2_7_inf" then
            for k, v in pairs(ents.FindByClass("func_door")) do
                if v:GetName() == "door42_2" then
                    v:SetKeyValue("targetname", "door42_1")
                    v:SetName("door42_1")
                elseif v:GetName() == "door16_2" then
                    v:SetKeyValue("targetname", "door16_1")
                    v:SetName("door16_1")
                elseif v:GetName() == "door37_2" then
                    v:SetKeyValue("targetname", "door37_1")
                    v:SetName("door37_1")
                elseif v:GetName() == "blastdoor6_2" then
                    v:SetKeyValue("targetname", "blastdoor6_1")
                    v:SetName("blastdoor6_1")
                elseif v:GetName() == "door57_2" then
                    v:SetKeyValue("targetname", "door57_1")
                    v:SetName("door57_1")
                elseif v:GetName() == "door34_2" then
                    v:SetKeyValue("targetname", "door34_1")
                    v:SetName("door34_1")
                elseif v:GetName() == "door25_2" then
                    v:SetKeyValue("targetname", "door25_1")
                    v:SetName("door25_1")
                elseif v:GetName() == "door31_2" then
                    v:SetKeyValue("targetname", "door31_1")
                    v:SetName("door31_1")
                elseif v:GetName() == "door26_2" then
                    v:SetKeyValue("targetname", "door26_1")
                    v:SetName("door26_1")
                elseif v:GetName() == "door46_2" then
                    v:SetKeyValue("targetname", "door46_1")
                    v:SetName("door46_1")
				elseif v:GetName() == "door7_1" then
                    v:SetKeyValue("targetname", "door7_1")
                    v:SetName("door7_2")
                elseif v:MapCreationID() == 3281 then
                   	v:SetKeyValue("tergetname", "maintacc_801")
                   	v:SetName("maintacc_801")
                elseif v:MapCreationID() == 3283 then
                	v:SetKeyValue("tergetname", "maintacc_701")
                   	v:SetName("maintacc_701")
                end
            end
        end

        if game.GetMap() == "rp_titan_base_bananakin" then
            for k, v in pairs(ents.FindByClass("item_ammo_crate")) do
                if v:EntIndex() == 470 then
                    v:Remove()
                elseif v:EntIndex() == 469 then
                    v:Remove()
                elseif v:EntIndex() == 468 then
                    v:Remove()
                elseif v:EntIndex() == 472 then
                    v:Remove()
				elseif v:EntIndex() == 471 then
                    v:Remove()
				elseif v:EntIndex() == 473 then
                    v:Remove()
                end
            end
        end

        if game.GetMap() == "rp_lothal" then
            for k, v in pairs(ents.FindByClass("func_door")) do
                if v:GetName() == "Base_Door_Double_A12" then
                    v:SetKeyValue("targetname", "Base_Door_Double_B12")
                    v:SetName("Base_Door_Double_B12")
                end
            end
        end
    end
end

hook.Add("InitPostEntity", "InitPostEntitySetDoors", SetDoorsIG)
hook.Add("PostCleanupMap", "InitPostEntitySetDoors", SetDoorsIG)

local customphys = {

			----------[[Current Staff]]----------

    ["STEAM_0:0:57771691"] = function(ply) --Kumo [Community Developer]
    ply:SetWeaponColor(Vector(50000, 7500, 1500))
    end,
	["STEAM_0:0:41555770"] = function(ply) --Zaspan [Server Manager]
        ply:SetWeaponColor(Vector(-0, -111111111111111111111111111111111, -1111111111111111))
    end,
	["STEAM_0:0:7634642"] = function(ply) --Tank [Community Developer]
        ply:SetWeaponColor(Vector(0.55, 0, 1))
    end,
	["STEAM_0:1:39901172"] = function(ply) --Wingza [Staff Manager]
        ply:SetWeaponColor(Vector(6969, 6969, -69696969))
    end,
	["STEAM_0:0:44722715"] = function(ply) --Rook [Event Manager]
        ply:SetWeaponColor(Vector(0, 0, 0))
    end,
	["STEAM_0:1:100919525"] = function(ply) --Gusky [Senior Admin]
        ply:SetWeaponColor(Vector(12000, 10000, 500))
    end,
    ["STEAM_0:1:40777706"] = function(ply) --Stryker [Server Developer]
        ply:SetWeaponColor(Vector(999, 0, 999999999))
    end,
    ["STEAM_0:1:90832271"] = function(ply) --Siege [Senior Admin]
        ply:SetWeaponColor(Vector(999999, 255, 255))
    end,
    ["STEAM_0:1:59558371"] = function(ply) --Kristofer [Lead Event Master]
        ply:SetWeaponColor(Vector(50000, 7500, 1500))
    end,
	
			----------[[Advisors]]----------
			
    ["STEAM_0:0:52423713"] = function(ply) --Moose [Advisor]
        ply:SetWeaponColor(Vector(-0, -111111111111111111111111111111111, -1111111111111111))
    end,
    ["STEAM_0:1:52838150"] = function(ply) --Whitey [Advisor]
        ply:SetWeaponColor(Vector(0.1, 0.90, 0.2))
    end,
    ["STEAM_0:0:80706730"] = function(ply) --Jman [Advisor]
        ply:SetWeaponColor(Vector(0.3, 0.3, 0.3))
    end,
    ["STEAM_0:1:44379558"] = function(ply) --Cody [Advisor]
        ply:SetWeaponColor(Vector(0.9, 0, 0.7))
    end,
    ["STEAM_0:0:31409949"] = function(ply) --Welshy [Advisor]
        ply:SetWeaponColor(Vector(255, 0, 97))
    end,
    ["STEAM_0:0:23047205"] = function(ply) --Wolf [Advisor/ExOwner]
        ply:SetWeaponColor(Vector(0, 0, 0))
    end,
    
            ----------[[Developers]]----------
    ["STEAM_0:1:46112709"] = function(ply) --HenDoge [Senior Dev]
        ply:SetWeaponColor(Vector(102, 0, 102))
    end,
    ["STEAM_0:1:45778562"] = function(ply) --Twist [Dev]
        ply:SetWeaponColor(Vector(0, 120000, 128000))
    end,
    ["STEAM_0:0:143657869"] = function(ply) --vanilla [senior dev]
        if not string.EndsWith(string.lower(ply:Nick()),"'aubrey'") then
        	ply:SetWeaponColor(Vector(249, 155, 249))
        end
    end,
    ["STEAM_0:1:41764671"] = function(ply) --fire [senior dev]
        ply:SetWeaponColor(Vector(0, 0, 255))
    end,
    
			----------[[Resigned Staff]]----------
	
    ["STEAM_0:1:53841913"] = function(ply) --Fliqqs [Resigned]
        ply:SetWeaponColor(Vector(1, 0.2, 0))
    end,
    ["STEAM_0:0:41928156"] = function(ply) --Pablo [Resigned]
        ply:SetWeaponColor(Vector(-0, -4444444, 444412312312312321313))
    end,    
    ["STEAM_0:1:179817353"] = function(ply) --Imposing [Resigned]
        ply:SetWeaponColor(Vector(12, -123213, -2132132))
    end,
    ["STEAM_0:1:155613207"] = function(ply) --Frank [Resigned]
        ply:SetWeaponColor(Vector(1, 0.12, 0.5))
    end,
    ["STEAM_0:0:206112276"] = function(ply) --Chopz [Resigned]
        ply:SetWeaponColor(Vector(0.55, 0, 1))
    end
}

hook.Add("PlayerSpawn", "CustomPhysgunColours", function(ply)
    if customphys[ply:SteamID()] then
        customphys[ply:SteamID()](ply)
    end
end)

hook.Add("PlayerSpawnedSWEP", "MooseWeaponSpawnLogs", function(ply, ent)
    print(ply:Nick() .. " just spawned a " .. ent:GetClass() .. " with the creator tool")
    ulx.logString(string.format("%s just spawned a %s with the creator tool", ply:Nick(), ent:GetClass()),false)
end)

hook.Add("PlayerSpray", "RIPSprays", function(ply) return true end)

if (SERVER) then
    hook.Add("PlayerLeaveVehicle", "FixBactaPos", function(ply, vehc)
        local vehic = vehc
        local playa = ply

        timer.Simple(1, function()
            if not (vehic) or not (playa) then return end
            if not vehic:IsValid() or not playa:IsValid() then return end
            if not vehic:IsVehicle() or not playa:IsPlayer() then return end

            if vehic:GetVehicleClass() == "bacta_seat" and not playa:IsInWorld() then
                local savevector = Vector(-2508.88, -2725.25, -4863.97)
                playa:SetPos(savevector)
                playa:ChatPrint("You were detected stuck and have been moved to a safe position")
            end
        end)
    end)

    hook.Add("PlayerLeaveVehicle", "FixSeatPosBridge", function(ply, vehc)
        local vehic = vehc
        local playa = ply

        timer.Simple(0.5, function()
            if not (vehic) or not (playa) then return end
            if not vehic:IsValid() or not playa:IsValid() then return end
            if not vehic:IsVehicle() or not playa:IsPlayer() then return end

            if vehic:GetClass() == "prop_vehicle_prisoner_pod" and vehic:GetModel() == "models/kingpommes/emperors_tower/imp_chaira/imp_chaira.mdl" and playa:IsInWorld() and playa:GetPos().z > 752.03125 then
                local savevector = playa:GetPos() + Vector(0, 0, -50)
                playa:SetPos(savevector)
                playa:ChatPrint("You were detected stuck and have been moved to a safe position")
            end
        end)
end)

concommand.Add("extinguish",function()for k,v in pairs(ents.GetAll()) do
        v:Extinguish() 
    end 
end)

concommand.Add("rehallow",function()for k,v in pairs(ents.FindByClass("kumo_spookitem")) do
        v:Remove()
print("halloween Items removed")
    end 
end)

concommand.Add("strgivepoints",function(ply, cmd, args) 
    if ply:IsSuperAdmin() then
        local steamidp = args[1]
        local pointsgiven = args[2]
        for k, v in ipairs(player.GetAll()) do
            if v:SteamID() == steamidp then
                v:SH_AddStandardPoints(pointsgiven)
            end
        end
    end
end)

concommand.Add("strgivecreds",function(ply, cmd, args) 
    if ply:IsSuperAdmin() then
        local steamidp = args[1]
        local credosgiven = args[2]
        for k, v in ipairs(player.GetAll()) do
            if v:SteamID() == steamidp then
                v:SH_AddPremiumPoints(credosgiven)
            end
        end
    end
end)         

concommand.Add("regimsg",function(ply, cmd, args) 
    if ply:IsSuperAdmin() then
        local igsregmsg = args[1]
        local igsmsg = args[2]
        local callername = ply:Nick()
        for k, v in ipairs(player.GetAll()) do
            if v:GetRegiment() == igsregmsg or v:IsSuperAdmin() then
                v:PrintMessage(HUD_PRINTTALK, igsregmsg.." | " ..callername.. " | " ..igsmsg)
            end
        end
    end
end)

end

globaleventtargett = 0

EventNoTarget = false;
hook.Add("IGPlayerSay", "chatglobeventtarg", function(ply, text, caller)
    if ply:IsAdmin() and (text:lower() == "!eventtarget") then
		EventNoTarget = !EventNoTarget;
		RunConsoleCommand("ulx", "asay", ply:Nick(), "has", "turned", "Event", "Character", "NPC", "no", "target", "to", tostring(EventNoTarget));
            
		for _, v in ipairs(player.GetAll()) do
           if v:GetRegiment() == "Event" then
               v:SetNoTarget(EventNoTarget);
           end
        end
    end    
end)

local function notargetforeventguys(ply)
    if ply:GetRegiment() == "Event" then
        ply:SetNoTarget(EventNoTarget);
    end
end

hook.Add("PlayerSpawn", "strykernotargetnpcspawn", notargetforeventguys);
hook.Add("PlayerChangedTeam", "strykernotargetnpcteamchange", notargetforeventguys);

if CLIENT then
    net.Receive("newforumpost",function()
        local topicname,author,featured = net.ReadString(),net.ReadString(),net.ReadBool()
        if not featured and GetConVar("kumo_forumoff"):GetBool() then return end
        chat.AddText(color_white,"[",Color(100,100,200),"Forums",color_white,"] ",Color(200,100,100),author," has posted a new",(featured and " featured " or " "), "topic '",topicname, "' to the forums, type !forumpost to view it.")
        surface.PlaySound("buttons/button17.wav")
    end)
end

hook.Add("CanProperty", "RIPContextMenu", function(ply, property, ent)
    if ply:IsSuperAdmin() then
        return true
    elseif ply:IsAdmin() and ent:GetClass() == "gmod_light" then
        return true
    elseif ply:IsEventMaster() then
        return true
    elseif ply:IsUserGroup("admin") then
        return true
    else
        return false
    end
end)
print("Finished running fpscmd.lua (print at bottom of file)")