TOOL.Category = "Tood's NPC Tool v2"
TOOL.Name = "NPC Spawn Tool"

if CLIENT then
	language.Add( "Tool.npc_spawn_tool.name", "NPC Spawn Tool v2" )
	language.Add( "Tool.npc_spawn_tool.desc", "Fill in the fields, left click to spawn the NPC, right click on any NPC to copy the class to your clipboard." )
	language.Add( "Tool.npc_spawn_tool.0", "Created by Tood." )
end

local StoreVars = {
	classname = "npc_combine_s",
	weaponclass = "weapon_ar2",
	modelpath = "models/Combine_Super_Soldier.mdl",
	npchealth = "500",
	wepdifficulty = "1",
	npcrelationships = "1",
	npcamount = "1",
	minspawn = "1",
	maxspawn = "20",
}

table.Merge( TOOL.ClientConVar, StoreVars )

local VecTable = {}
-- 	If you INCREASE the tool var "npc_spawn_tool_npcamount" then you will need to add more vectors to this table or the extra NPCs will not spawn in.
VecTable[1] = { Vec = Vector(90, 90, 1) }
VecTable[2] = { Vec = Vector(-90, 90, 1) }
VecTable[3] = { Vec = Vector(-90, -90, 1) }
VecTable[4] = { Vec = Vector(90, -90, 1) }
VecTable[5] = { Vec = Vector(-45, 90, 1) }
VecTable[6] = { Vec = Vector(59, 90, 1) }
VecTable[7] = { Vec = Vector(73, 75, 1) }
VecTable[8] = { Vec = Vector(34, -85, 1) }
VecTable[9] = { Vec = Vector(-130, 85, 1) }
VecTable[10] = { Vec = Vector(-177, -95, 1) }

function TOOL:SummonNPC( Class, tr )
local AllNPCs = list.Get( "NPC" )
local NPCClass = AllNPCs[Class]
if !NPCClass then return end
	for i = 1, self:GetClientInfo( "npcamount" ) do
		timer.Simple( math.random( self:GetClientInfo( "minspawn" ), self:GetClientInfo( "maxspawn" ) ), function()
		local SpawnNPC = ents.Create( NPCClass.Class )
		if !IsValid( SpawnNPC ) then return end
			SpawnNPC:SetPos( tr + VecTable[i].Vec )
			timer.Simple( 0.1, function() -- Fucking timers
				SpawnNPC:SetHealth( self:GetClientInfo( "npchealth" ) )
			end )
			if self:GetClientInfo( "modelpath" ) != "" then
				SpawnNPC:SetModel( self:GetClientInfo( "modelpath" ) ) -- Let them override the NPC's default model.
			elseif NPCClass.Model then
				SpawnNPC:SetModel( NPCClass.Model ) -- Set the model to the NPCs default model if they choose not to override it.
			end
			SpawnNPC:Give( self:GetClientInfo( "weaponclass" ) )
			self:MergeVars( SpawnNPC )
			SpawnNPC:SetCurrentWeaponProficiency( self:GetClientInfo( "wepdifficulty" ) )
			for k, ply in ipairs( player.GetAll() ) do -- Only doing players because doing NPC relationships is annoying af.
				if self:GetClientInfo( "npcrelationships" ) == "1" then
					SpawnNPC:AddEntityRelationship( ply, D_HT, 99 )
				elseif self:GetClientInfo( "npcrelationships" ) == "3" then
					SpawnNPC:AddEntityRelationship( ply, D_LI, 99 )
				end
			end
			SpawnNPC:Spawn()
			SpawnNPC:Activate()
			
			undo.Create( "despawn_npc" )
				undo.AddEntity( SpawnNPC )
				undo.SetPlayer( self:GetOwner() )
				undo.SetCustomUndoText( "Successfully removed " .. NPCClass.Name .. "." )
			undo.Finish()
		end )
	end
	
	return SpawnNPC
end

function TOOL:LeftClick( tr )
if !IsValid( self:GetOwner() ) then return end
if !self:GetOwner():IsPlayer() then return end
if CLIENT then return true end
local FetchClass = self:GetClientInfo( "classname" )
	self:SummonNPC( FetchClass, tr.HitPos )
	return true
end

function TOOL:RightClick( tr )
if !IsValid( self:GetOwner() ) then return end
if !self:GetOwner():IsPlayer() then return end
	if CLIENT then
		if !self.AlreadyUsed || self.AlreadyUsed < CurTime() then
			if !tr.Hit || !IsValid( tr.Entity ) || !tr.Entity:IsNPC() then
				notification.AddLegacy( "This function only works on NPCs. Try again by targeting a valid NPC.", NOTIFY_ERROR, 3 )
				self.AlreadyUsed = CurTime() + 5
				return false 
			end
			notification.AddLegacy( "Successfully copied " .. tr.Entity:GetClass() .. " to your clipboard!", NOTIFY_HINT, 3 )
			SetClipboardText( tr.Entity:GetClass() )
			self.AlreadyUsed = CurTime() + 5
		end
	end
	return true
end

function TOOL:MergeVars( ent )
	for k, v in pairs( StoreVars ) do
		ent:SetKeyValue( k, self:GetClientInfo( k ) )
	end
end

local GetCVars = TOOL:BuildConVarList()

function TOOL.BuildCPanel( pnl )
	pnl:SetName( "NPC Spawn Tool v2" )
-----------------------------------------------
	pnl:AddControl( "ComboBox", {
		MenuButton = 1,
		Folder = "npc_spawn_tool",
		Options = {
			[ "#preset.default" ] = GetCVars
		},
		CVars = table.GetKeys( GetCVars )
	} )
-----------------------------------------------
	pnl:TextEntry( "NPC Class", "npc_spawn_tool_classname" )
	pnl:ControlHelp( "Paste the class of the NPC you wish to spawn." )
-----------------------------------------------
	pnl:TextEntry( "NPC Weapon", "npc_spawn_tool_weaponclass" )
	pnl:ControlHelp( "Paste the path of the weapon for your NPC to use." )
-----------------------------------------------
	pnl:TextEntry( "NPC Model", "npc_spawn_tool_modelpath" )
	pnl:ControlHelp( "Paste the model path here to override. Leave blank if you want to use the NPCs default model. This does not override models for NPCs like VJ Base NPCs." )
-----------------------------------------------
	pnl:NumSlider( "NPC Health", "npc_spawn_tool_npchealth", 50, 10000, 0 )
	pnl:ControlHelp( "Use the slider to set the health of your NPC." )
-----------------------------------------------
	local DiffBox = pnl:ComboBox( "Weapon Difficulty", "npc_spawn_tool_wepdifficulty" )
	DiffBox:AddChoice( "Bad", WEAPON_PROFICIENCY_POOR )
	DiffBox:AddChoice( "Normal", WEAPON_PROFICIENCY_AVERAGE )
	DiffBox:AddChoice( "Good", WEAPON_PROFICIENCY_GOOD )
	DiffBox:AddChoice( "Great", WEAPON_PROFICIENCY_VERY_GOOD )
	DiffBox:AddChoice( "Perfect", WEAPON_PROFICIENCY_PERFECT )
	pnl:ControlHelp( "Choose how good your NPCs weapon aim should be." )
-----------------------------------------------
	local RelationBox = pnl:ComboBox( "NPC Relationship", "npc_spawn_tool_npcrelationships" )
	RelationBox:AddChoice( "Enemy", "1" )
	RelationBox:AddChoice( "Friendly", "3" )
	pnl:ControlHelp( "Choose how NPCs react to all players." )
-----------------------------------------------
	pnl:NumSlider( "NPC Amount", "npc_spawn_tool_npcamount", 1, 10, 0 )
	pnl:ControlHelp( "How many NPCs should spawn." )
-----------------------------------------------
	pnl:NumSlider( "Min Spawn Time", "npc_spawn_tool_minspawn", 1, 5, 0 )
	pnl:ControlHelp( "How long before the NPCs spawn in." )
-----------------------------------------------
	pnl:NumSlider( "Max Spawn Time", "npc_spawn_tool_maxspawn", 6, 20, 0 )
	pnl:ControlHelp( "Max amount of seconds cap for all NPCs to finally spawn in." )
end