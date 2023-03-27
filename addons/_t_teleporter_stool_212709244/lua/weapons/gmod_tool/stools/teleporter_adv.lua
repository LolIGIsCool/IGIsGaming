//Teleporter STool
//By Slade Xanthas

TOOL.Category		= "Construction"
TOOL.Name			= "#tool.teleporter_adv.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""
TOOL.LastClick		= CurTime()

if CLIENT then

    language.Add("tool.teleporter_adv.name", "Teleporter")
    language.Add("tool.teleporter_adv.desc", "Spawn a Teleporter")
    language.Add("tool.teleporter_adv.0", "Primary: Create/Update Teleporter you're looking at.  Spawn two teleporters to make a set.")
	
	language.Add("Cleanup_teleporters_adv", "Teleporters")
	language.Add("Cleaned_teleporters_adv", "Cleaned up all Teleporters")
	language.Add("SBoxLimit_teleporters_adv", "You've hit Teleporter limit!")
	language.Add("Undone_teleporter_adv", "Undone Teleporter")
	
	language.Add("Sound_None", "None")
	language.Add("Sound_Teleport1", "Teleport 1")
	language.Add("Sound_Teleport2", "Teleport 2")
	language.Add("Sound_Teleport3", "Teleport 3")
	language.Add("Sound_Zap1", "Zap 1")
	language.Add("Sound_Zap2", "Zap 2")
	language.Add("Sound_Zap3", "Zap 3")
	language.Add("Sound_Disintegrate1", "Disintegrate 1")
	language.Add("Sound_Disintegrate2", "Disintegrate 2")
	language.Add("Sound_Disintegrate3", "Disintegrate 3")
	language.Add("Sound_Disintegrate4", "Disintegrate 4")
	
	language.Add("Effect_None", "No Effect")	
	language.Add("Effect_Explosion", "Explosion")
	language.Add("Effect_Propspawn", "Prop Spawn")
	language.Add("Effect_Sparks", "Sparks")
	
	elseif SERVER then
	
	CreateConVar("sbox_maxteleporters_adv", 10)
	
end

TOOL.ClientConVar["model"] = "models/Items/combine_rifle_ammo01.mdl"
TOOL.ClientConVar["sound"] = "ambient/levels/citadel/weapon_disintegrate2.wav"
TOOL.ClientConVar["effect"] = "sparks"
TOOL.ClientConVar["radius"] = "100"
TOOL.ClientConVar["players"] = "1"
TOOL.ClientConVar["props"] = "1"
TOOL.ClientConVar["ontouch"] = "0"
TOOL.ClientConVar["onuse"] = "0"
TOOL.ClientConVar["showbeam"] = "1"
TOOL.ClientConVar["showradius"] = "1"
TOOL.ClientConVar["key"] = "1"

cleanup.Register("teleporters_adv")

local function MakeTeleporter(ply, pos, Ang, model, sound, effect, radius, players, props, ontouch, onuse, showbeam, showradius, key) //The main teleporter creation code.  All values have been sent over from left click.

	if !SERVER then return end
	if !IsValid(ply) then return end
	if !ply:CheckLimit("teleporters_adv") then return false end

	local teleporter = ents.Create("gmod_advteleporter")
	if !IsValid(teleporter) then return false end	

	teleporter:SetAngles(Ang)
	teleporter:SetPos(pos)
	teleporter:SetModel(Model(model))
	teleporter:Spawn()	
	teleporter:Setup(model, sound, effect, radius, players, props, ontouch, onuse, showbeam, showradius, key, ply) //Run Setup.
	
	numpad.OnDown(ply, key, "Teleporter_On", teleporter)
	numpad.OnUp(ply, key, "Teleporter_Off", teleporter)

	local ttable = {
		model = model,
		sound = sound,
		effect = effect,
		radius = radius,
		players = players,
		props = props,
		ontouch = ontouch,
		onuse = onuse,
		showbeam = showbeam,
		showradius = showradius,
		key = key,
	}
	table.Merge(teleporter:GetTable(), ttable) //Set up the entity's table.

	ply:AddCount("teleporters_adv", teleporter)
	
	DoPropSpawnedEffect(teleporter)

	return teleporter

end

duplicator.RegisterEntityClass("gmod_advteleporter", MakeTeleporter, "pos", "ang", "model", "sound", "effect", "radius", "players", "props", "ontouch", "onuse", "showbeam", "showradius", "key", "destination") //Register everything with the duplicator.

function TOOL:LeftClick(trace)

	local ent = trace.Entity

	if !trace.HitPos then return false end
	if IsValid(ent) && ent:IsPlayer() then return false end
	if SERVER && !util.IsValidPhysicsObject(ent,trace.PhysicsBone) then return false end
	if CLIENT then return true end
	
	local ply = self:GetOwner()
	local model = self:GetClientInfo("model")
	local sound = self:GetClientInfo("sound")
	local effect = self:GetClientInfo("effect")
	local radius = math.Clamp(self:GetClientNumber("radius"),0,750)
	local players = (self:GetClientNumber("players") == 1)
	local props = (self:GetClientNumber("props") == 1)
	local ontouch = (self:GetClientNumber("ontouch") == 1)
	local onuse = (self:GetClientNumber("onuse") == 1)
	local showbeam = (self:GetClientNumber("showbeam") == 1)
	local showradius = (self:GetClientNumber("showradius") == 1)
	local key = self:GetClientNumber("key")
	
	if IsValid(ent) && ent:GetClass() == "gmod_advteleporter" then
		ent:Setup(model, sound, effect, radius, players, props, ontouch, onuse, showbeam, showradius, key, ply) //Setup the variables again and merge the table to update the entity.
		local ttable = {
			model = model,
			sound = sound,
			effect = effect,
			radius = radius,
			players = players,
			props = props,
			ontouch = ontouch,
			onuse = onuse,
			showbeam = showbeam,
			showradius = showradius,
			key = key,
		}
		table.Merge(ent:GetTable(), ttable)
		return true
	end
	
	if !self:GetSWEP():CheckLimit("teleporters_adv") then return false end
	
	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90
	
	local teleporter = MakeTeleporter(ply, trace.HitPos, Ang, model, sound, effect, radius, players, props, ontouch, onuse, showbeam, showradius, key) //MAKE ME A TELEPORTER, SCOTTY.

	local min = teleporter:OBBMins()
	teleporter:SetPos(trace.HitPos - trace.HitNormal * min.z)
	
	if !teleporter:IsInWorld() then teleporter:Remove() return false end

	if trace.HitWorld then teleporter:GetPhysicsObject():EnableMotion(false) end
	
	if IsValid(ent) then
		local const = constraint.Weld(teleporter, ent, trace.PhysicsBone, 0, 0)
		local nocollide = constraint.NoCollide(teleporter, ent, 0, trace.PhysicsBone)
		ent:DeleteOnRemove(teleporter)
	end

	undo.Create("Teleporter_adv")
		undo.AddEntity(teleporter)
		undo.AddEntity(const)
		undo.AddEntity(nocollide)
		undo.SetPlayer(ply)
	undo.Finish()

	ply:AddCleanup("teleporters_adv", teleporter)
	ply:AddCleanup("teleporters_adv", const)
	ply:AddCleanup("teleporters_adv", nocollide)
	
	return true
	
end

function TOOL:RightClick(trace)
	return false
end

function TOOL:Reload(trace)
	return false
end

function TOOL:UpdateGhostEntity( ent, ply )

	if !IsValid(ent) then return end

	local tr = ply:GetEyeTrace()

	if !tr.Hit || IsValid(tr.Entity) && tr.Entity:GetClass() == "gmod_advteleporter" || tr.Entity:IsPlayer() then //Ghost entity check to see what's under the cursor.
		ent:SetNoDraw(true) //Something above is valid, remove the ghost.
		return
	end

	local Ang = tr.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90

	local min = ent:OBBMins()
	ent:SetPos(tr.HitPos - tr.HitNormal * min.z)
	ent:SetAngles(Ang)

	ent:SetNoDraw(false)
	
end

function TOOL:Think()

	if !IsValid(self.GhostEntity) || (IsValid(self.GhostEntity) && self.GhostEntity:GetModel() ~= self:GetClientInfo("model")) then
		self:MakeGhostEntity(self:GetClientInfo("model"), Vector( 0, 0, 0 ), Angle( 0, 0, 0 )) //Make a GHOOOOOSTTTT
	end

	self:UpdateGhostEntity(self.GhostEntity, self:GetOwner()) //and update it.
	
end

function TOOL.BuildCPanel(CPanel)

	CPanel:AddControl("Header", {Text = "#Tool.teleporter_adv.name", Description = "#Tool.teleporter_adv.desc"})

	local Options = { 
	Default = {
			teleporter_model 		= "models/Items/combine_rifle_ammo01.mdl",
			teleporter_sound 		= 0,
			teleporter_ontouch		= 0,
			teleporter_onuse 		= 0,
			teleporter_key 			= 1
			}
	}
	
	local CVars = {
		"teleporter_adv_model",
		"teleporter_adv_sound",
		"teleporter_adv_effect",
		"teleporter_adv_players",
		"teleporter_adv_props",
		"teleporter_adv_ontouch",
		"teleporter_adv_onuse",
		"teleporter_adv_showbeam",
		"teleporter_adv_showradius",
		"teleporter_adv_key"
	}
		
	CPanel:AddControl( "ComboBox", 
		{ Label = "#Presets", 
		MenuButton = 1, 
		Folder = "teleporter_adv", 
		Options = Options, 
		CVars = CVars } 
	)

	CPanel:AddControl("PropSelect", 
		{ Label = "Model:", 
		ConVar = "teleporter_adv_model", 
		Category = "Teleporters", 
		Models = list.Get("TeleporterModels") }	
	)			
	
	CPanel:AddControl( "Numpad", 
		{ Label = "Key:", 
		Command = "teleporter_adv_key", 
		ButtonSize = 22 } 
	)

 	CPanel:AddControl( "Slider", 
		{ Label = "Teleport Radius:", 
		Command = "teleporter_adv_radius", 
		min = 50,
		max = 500 } 
	)		
	
	CPanel:AddControl( "Label", { Text = "Teleport Sound:" } )
 	CPanel:AddControl( "ComboBox", 
		{ Label = "Teleport Sound:", 
		MenuButton = 0, 
		Command = "teleporter_adv_sound", 
		Options = list.Get( "TeleporterSounds" ) } 
	)		

	CPanel:AddControl( "Label", { Text = "Teleport Effect:" } )
 	CPanel:AddControl( "ComboBox", 
		{ Label = "Teleport Effect:", 
		MenuButton = 0, 
		Command = "teleporter_adv_effect", 
		Options = list.Get( "TeleporterEffects" ) } 
	)
	
	CPanel:AddControl( "CheckBox", 
		{ Label = "Teleport Players", 
		Command = "teleporter_adv_players" } 
	)

	CPanel:AddControl( "CheckBox", 
		{ Label = "Teleport Props", 
		Command = "teleporter_adv_props" } 
	)	
	
	CPanel:AddControl( "CheckBox", 
		{ Label = "Teleport On Touch", 
		Command = "teleporter_adv_ontouch" } 
	)	
	
	CPanel:AddControl( "CheckBox", 
		{ Label = "Teleport On Use", 
		Command = "teleporter_adv_onuse" } 
	)
	
	--[[CPanel:AddControl( "CheckBox", 
		{ Label = "Show Beam", 
		Command = "teleporter_adv_showbeam" } 
	)]]--
	
	CPanel:AddControl( "CheckBox", 
		{ Label = "Show Teleport Radius", 
		Command = "teleporter_adv_showradius" } 
	)

end

list.Set("TeleporterModels", "models/Items/combine_rifle_ammo01.mdl", {})
list.Set("TeleporterModels", "models/props_c17/clock01.mdl", {})
list.Set("TeleporterModels", "models/props_junk/sawblade001a.mdl", {})
list.Set("TeleporterModels", "models/props_combine/combine_mine01.mdl", {})
list.Set("TeleporterModels", "models/props_wasteland/prison_toilet01.mdl", {})
list.Set("TeleporterModels", "models/props_lab/teleplatform.mdl", {})

list.Set("TeleporterSounds", "#Sound_None", {teleporter_adv_sound = ""})
list.Set("TeleporterSounds", "#Sound_Teleport1", {teleporter_adv_sound = "ambient/machines/teleport1.wav" })
list.Set("TeleporterSounds", "#Sound_Teleport2", {teleporter_adv_sound = "ambient/machines/teleport3.wav" })
list.Set("TeleporterSounds", "#Sound_Teleport3", {teleporter_adv_sound = "ambient/machines/teleport4.wav" })
list.Set("TeleporterSounds", "#Sound_Zap1", {teleporter_adv_sound = "ambient/machines/zap1.wav" })
list.Set("TeleporterSounds", "#Sound_Zap2", {teleporter_adv_sound = "ambient/machines/zap2.wav" })
list.Set("TeleporterSounds", "#Sound_Zap3", {teleporter_adv_sound = "ambient/machines/zap3.wav" })
list.Set("TeleporterSounds", "#Sound_Disintegrate1", {teleporter_adv_sound = "ambient/levels/citadel/weapon_disintegrate1.wav" })
list.Set("TeleporterSounds", "#Sound_Disintegrate2", {teleporter_adv_sound = "ambient/levels/citadel/weapon_disintegrate2.wav" })
list.Set("TeleporterSounds", "#Sound_Disintegrate3", {teleporter_adv_sound = "ambient/levels/citadel/weapon_disintegrate3.wav" })
list.Set("TeleporterSounds", "#Sound_Disintegrate4", {teleporter_adv_sound = "ambient/levels/citadel/weapon_disintegrate4.wav" })

list.Set("TeleporterEffects", "#Effect_Propspawn", {teleporter_adv_effect = "propspawn"})
list.Set("TeleporterEffects", "#Effect_Explosion", {teleporter_adv_effect = "explosion"})
list.Set("TeleporterEffects", "#Effect_Sparks", {teleporter_adv_effect = "sparks"})
list.Set("TeleporterEffects", "#Effect_None", {teleporter_adv_effect = ""})
