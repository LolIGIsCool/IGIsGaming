AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("igSquadMenu")
util.AddNetworkString("igSquadMenuSelect")
util.AddNetworkString("igSquadMenuEdit")
util.AddNetworkString("igSquadMenuPurchase")

function ENT:Initialize()
	self:SetModel("models/KingPommes/starwars/playermodels/gnk.mdl")
	--self:SetModel("models/props_borealis/bluebarrel001.mdl")
	self:SetUseType(SIMPLE_USE)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)    
    local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:AcceptInput( name, activator, caller )
	if name == "Use" and caller:IsPlayer() then
		if table.HasValue(DYANMIC_BYPASS, caller:GetRegiment()) then
			caller:PrintMessage( HUD_PRINTTALK, "You don't have permission to use this." )
		else
			local PlayerTable = caller:GetFullDynamicPlayerTable()
			local RegimentTable = caller:GetDynamicFullRegimentTable()
			local AceSleeve = "false"

			if HasAugment(caller,"Ace up the Sleeve [PRIMARY]") then
				AceSleeve = "primary"
			elseif HasAugment(caller,"Ace up the Sleeve [SPECIALIST]") then
				AceSleeve = "spec"
			end

			net.Start("igSquadMenu")
				net.WriteTable(RegimentTable)
				net.WriteTable(PlayerTable)
				net.WriteString(AceSleeve)
			net.Send(caller)
		end
	end
end

net.Receive("igSquadMenuSelect", function(len, ply)
	local slot = net.ReadString()
	local playerloadout = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/data/player/"..ply:SteamID64()..".txt", "DATA"))
	for k, v in ipairs( ents.FindInSphere(ply:GetPos(),500) ) do
    	if v:GetClass() == "npc_igloadout" then
    		local PlayerTable = ply:GetFullDynamicPlayerTable()
    		if slot == "1" then
    			PlayerTable["First"]["Active"] = true
    			PlayerTable["Second"]["Active"] = false
    			PlayerTable["Third"]["Active"] = false
    			playerloadout[ply:SteamID()]["First"]["Active"] = true
    			playerloadout[ply:SteamID()]["Second"]["Active"] = false
    			playerloadout[ply:SteamID()]["Third"]["Active"] = false
    		elseif slot == "2" then
    			PlayerTable["First"]["Active"] = false
    			PlayerTable["Second"]["Active"] = true
    			PlayerTable["Third"]["Active"] = false
    			playerloadout[ply:SteamID()]["First"]["Active"] = false
    			playerloadout[ply:SteamID()]["Second"]["Active"] = true
    			playerloadout[ply:SteamID()]["Third"]["Active"] = false
    		elseif slot == "3" then
    			PlayerTable["First"]["Active"] = false
    			PlayerTable["Second"]["Active"] = false
    			PlayerTable["Third"]["Active"] = true
    			playerloadout[ply:SteamID()]["First"]["Active"] = false
    			playerloadout[ply:SteamID()]["Second"]["Active"] = false
    			playerloadout[ply:SteamID()]["Third"]["Active"] = true
    		end
    		ply:DynamicLoadout()
    		file.Write("ig_dynamic_loadout_v2/data/player/"..ply:SteamID64()..".txt", util.TableToJSON(playerloadout,true))
		else
    	end
    end
end)

net.Receive("igSquadMenuEdit", function(len, ply)
	local slot = net.ReadString()
	local weapontable = net.ReadTable()
	local templayerdata = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/data/player/"..ply:SteamID64()..".txt", "DATA"))
	for k, v in ipairs( ents.FindInSphere(ply:GetPos(),500) ) do
    	if v:GetClass() == "npc_igloadout" then
			if slot == "1" and templayerdata[ply:SteamID()]["First"]["Purchased"] == true then
				if ply:DynamicEditCheck(weapontable) then
					templayerdata[ply:SteamID()]["First"]["Loadout"]["Primary"] = weapontable["Primary"]
					templayerdata[ply:SteamID()]["First"]["Loadout"]["Secondary"] = weapontable["Secondary"]
					templayerdata[ply:SteamID()]["First"]["Loadout"]["Spec"] = weapontable["Spec"]
					templayerdata[ply:SteamID()]["First"]["Loadout"]["Ace"] = weapontable["Ace"]
					file.Write("ig_dynamic_loadout_v2/data/player/"..ply:SteamID64()..".txt", util.TableToJSON(templayerdata,true))
					DYNAMIC_PLAYER_DATA[ply:SteamID()]["First"]["Loadout"]["Primary"] = weapontable["Primary"]
					DYNAMIC_PLAYER_DATA[ply:SteamID()]["First"]["Loadout"]["Secondary"] = weapontable["Secondary"]
					DYNAMIC_PLAYER_DATA[ply:SteamID()]["First"]["Loadout"]["Spec"] = weapontable["Spec"]
					DYNAMIC_PLAYER_DATA[ply:SteamID()]["First"]["Loadout"]["Ace"] = weapontable["Ace"]
					ply:DynamicLoadout()
				else
					ply:DynamicError("2", "Security Check Failed. Attempting to equip weapon you don't have access to.")
				end
			elseif slot == "2" and templayerdata[ply:SteamID()]["Second"]["Purchased"] == true then
				if ply:DynamicEditCheck(weapontable) then
					templayerdata[ply:SteamID()]["Second"]["Loadout"]["Primary"] = weapontable["Primary"]
					templayerdata[ply:SteamID()]["Second"]["Loadout"]["Secondary"] = weapontable["Secondary"]
					templayerdata[ply:SteamID()]["Second"]["Loadout"]["Spec"] = weapontable["Spec"]
					templayerdata[ply:SteamID()]["Second"]["Loadout"]["Ace"] = weapontable["Ace"]
					file.Write("ig_dynamic_loadout_v2/data/player/"..ply:SteamID64()..".txt", util.TableToJSON(templayerdata,true))
					DYNAMIC_PLAYER_DATA[ply:SteamID()]["Second"]["Loadout"]["Primary"] = weapontable["Primary"]
					DYNAMIC_PLAYER_DATA[ply:SteamID()]["Second"]["Loadout"]["Secondary"] = weapontable["Secondary"]
					DYNAMIC_PLAYER_DATA[ply:SteamID()]["Second"]["Loadout"]["Spec"] = weapontable["Spec"]
					DYNAMIC_PLAYER_DATA[ply:SteamID()]["Second"]["Loadout"]["Ace"] = weapontable["Ace"]
					ply:DynamicLoadout()
				else
					ply:DynamicError("2", "Security Check Failed. Attempting to equip weapon you don't have access to.")
				end
			elseif slot == "3" and templayerdata[ply:SteamID()]["Third"]["Purchased"] == true then
				if ply:DynamicEditCheck(weapontable) then
					templayerdata[ply:SteamID()]["Third"]["Loadout"]["Primary"] = weapontable["Primary"]
					templayerdata[ply:SteamID()]["Third"]["Loadout"]["Secondary"] = weapontable["Secondary"]
					templayerdata[ply:SteamID()]["Third"]["Loadout"]["Spec"] = weapontable["Spec"]
					templayerdata[ply:SteamID()]["Third"]["Loadout"]["Ace"] = weapontable["Ace"]
					file.Write("ig_dynamic_loadout_v2/data/player/"..ply:SteamID64()..".txt", util.TableToJSON(templayerdata,true))
					DYNAMIC_PLAYER_DATA[ply:SteamID()]["Third"]["Loadout"]["Primary"] = weapontable["Primary"]
					DYNAMIC_PLAYER_DATA[ply:SteamID()]["Third"]["Loadout"]["Secondary"] = weapontable["Secondary"]
					DYNAMIC_PLAYER_DATA[ply:SteamID()]["Third"]["Loadout"]["Spec"] = weapontable["Spec"]
					DYNAMIC_PLAYER_DATA[ply:SteamID()]["Third"]["Loadout"]["Ace"] = weapontable["Ace"]
					ply:DynamicLoadout()
				else
					ply:DynamicError("2", "Security Check Failed. Attempting to equip weapon you don't have access to.")
				end
			end
		end
	end
end)

net.Receive("igSquadMenuPurchase", function(len, ply)
	for k, v in ipairs( ents.FindInSphere(ply:GetPos(),500) ) do
    	if v:GetClass() == "npc_igloadout" then
			local slot = net.ReadString()
			local playerloadout = util.JSONToTable(file.Read("ig_dynamic_loadout_v2/data/player/"..ply:SteamID64()..".txt", "DATA"))
			if slot == "1" then
				playerloadout[ply:SteamID()]["First"]["Purchased"] = true
				file.Write("ig_dynamic_loadout_v2/data/player/"..ply:SteamID64()..".txt", util.TableToJSON(playerloadout,true))
				
				DYNAMIC_PLAYER_DATA[ply:SteamID()]["First"]["Purchased"] = true
			elseif slot == "2" and ply:SH_CanAffordPremium(25000) then
				playerloadout[ply:SteamID()]["Second"]["Purchased"] = true
				file.Write("ig_dynamic_loadout_v2/data/player/"..ply:SteamID64()..".txt", util.TableToJSON(playerloadout,true))
				ply:SH_AddPremiumPoints(-25000, "You have spent 50,000 Credits purchasing the second loadout slot", false, false)

				DYNAMIC_PLAYER_DATA[ply:SteamID()]["Second"]["Purchased"] = true
			elseif slot == "3" and ply:SH_CanAffordPremium(75000) then
				playerloadout[ply:SteamID()]["Third"]["Purchased"] = true
				file.Write("ig_dynamic_loadout_v2/data/player/"..ply:SteamID64()..".txt", util.TableToJSON(playerloadout,true))
				ply:SH_AddPremiumPoints(-75000, "You have spent 150,000 Credits purchasing the second loadout slot", false, false)

				DYNAMIC_PLAYER_DATA[ply:SteamID()]["Third"]["Purchased"] = true
			end
		end
	end
end)