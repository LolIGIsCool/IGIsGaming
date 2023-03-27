
TOOL.Category = "Stoneman"
TOOL.Name = "Boss Bar"

if CLIENT then
	language.Add( "tool.bossbartool.name", "Boss Health Bar Tool" )
	language.Add( "tool.bossbartool.desc", "Broadcast a specific player health to the server, with a boss health bar.." )
	language.Add( "tool.bossbartool.0", "Left Click: Select target to become a boss, Right click: Select yourself to become the boss, Reload: Disable all boss health bars." )
end

if SERVER then
    ---Precaching network messages---
    util.AddNetworkString("bossbar_start")
    util.AddNetworkString("bossbar_stop")
    util.AddNetworkString("bossbar_death")
	util.AddNetworkString("bossbar_buffer")
end

TOOL.ClientConVar[ "name" ] = "Stoneman, Destroyer of Worlds"
TOOL.ClientConVar[ "icon" ] = ""
TOOL.ClientConVar[ "maxhealth" ] = "1000"
TOOL.ClientConVar[ "health" ] = "1000"
TOOL.ClientConVar[ "label" ] = "BOSS :"
TOOL.ClientConVar[ "dmgscale" ] = "1"

list.Set("BossIcon", "Default (Star)", 				{bossbartool_icon = ""})
list.Set("BossIcon", "Eliminate (Skull)", 			{bossbartool_icon = "bossbar/skull.png"})
list.Set("BossIcon", "Defend (Shield)", 			{bossbartool_icon = "bossbar/defend.png"})
list.Set("BossIcon", "Capture (Prison)", 			{bossbartool_icon = "bossbar/capture.png"})

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel(CPanel)
	
	local Options = {
		Default = {
			bossbartool_icon 		= "",
		}
	}

    CPanel:AddControl( "ComboBox", 
	{ 
		MenuButton = 1,
		Folder = "bossbartool",
		Options = { [ "#preset.default" ] = ConVarsDefault },
		CVars = table.GetKeys( ConVarsDefault ) 
	}
	)
	
	CPanel:AddControl("Header",
	{
		Text = "Boss Bar Tool",
		Description = [[Left-Click to enable a boss health bar for the entity you're looking at. Right click to disable the boss bar.]]
	}
	)

    CPanel:AddControl( "TextBox",
	{
		Label = "Name:",
		Command = "bossbartool_name",
		MaxLength = "48"
	}
	)

	CPanel:AddControl("ComboBox",
	{
		Label = "Icon Options:",
		MenuButton = 0,
		Command = "bossbartool_icon",
		Options = list.Get("BossIcon")
	}
	)	

	CPanel:AddControl( "slider", 
	{
		Label = "Max Health:",
		Command = "bossbartool_maxhealth",
		min = "1",
		max = "100000000"
	}
	)

    CPanel:ControlHelp("Sets the max health of the boss entity.")

    CPanel:AddControl( "slider", 
	{ 
		Label = "Health:",
		Command = "bossbartool_health",
		min = "1",
		max = "100000000"
	} 
	)

    CPanel:ControlHelp("Sets the current health of the boss entity.")

	CPanel:AddControl( "slider", 
	{ 
		type = "float",
		Label = "Damage Scale:",
		Command = "bossbartool_dmgscale",
		min = "0",
		max = "1000"
	} 
	)

    CPanel:ControlHelp("Multiplies the boss damage by this number.")

    CPanel:AddControl( "TextBox", 
	{ 
		Label = "Label:",
		Command = "bossbartool_label",
		MaxLength = "12"
	} 
	)

    CPanel:ControlHelp("Sets the label.")	
end

function TOOL:LeftClick(tr)
	if not IsFirstTimePredicted() then return end
	if bossHealthSystem:IsValidBoss() then return end

	if !IsValid(tr.Entity) then return end
	local ent = tr.Entity
	
	if ent:IsWorld() then return end
	if (!ent:IsPlayer() and !ent:IsNPC() ) then return end
	
	self:SetBoss(ent)
end

function TOOL:RightClick(tr)
	if not IsFirstTimePredicted() then return end
	if bossHealthSystem:IsValidBoss() then return end

	local ent = self:GetOwner()

	self:SetBoss(ent)
end

function TOOL:Reload()
	if not IsFirstTimePredicted() then return end
	if bossHealthSystem:IsValidBoss() then
		bossHealthSystem:RemoveBoss()
		if CLIENT then
			notification.AddLegacy(("Turned off the boss bar"),0,5)
			surface.PlaySound("buttons/button14.wav")
		end
	end
	if not bossHealthSystem:IsValidBoss() then return end
	self:SetBoss(NULL)
end

function TOOL:SetBoss(ent)
	if CLIENT then
		if ent:IsPlayer() then
			notification.AddLegacy(("Turned on the boss bar for " .. ent:Nick()),0,5)
		else
			notification.AddLegacy(("Turned on the boss bar for an NPC"),0,5)
		end
	end
	
	local maxHealth = self:GetClientInfo("maxhealth")
	local health =  self:GetClientInfo("health")
	local name = self:GetClientInfo("name")
	local label = self:GetClientInfo("label")
	local dmgscale = self:GetClientInfo("dmgscale")
	local icon = self:GetClientInfo("icon")
	bossHealthSystem:AddBoss(ent, maxHealth, health, name, label, dmgscale, icon)
end