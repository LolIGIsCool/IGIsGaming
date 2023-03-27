
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "World Scanner"
ENT.Author			= "FiLzO"
ENT.Information		= ""
ENT.Category		= "Other"

ENT.Spawnable		= true
ENT.AdminOnly		= false

sound.Add( {
	name = "Terminal1.Play",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 60,
	pitch = { 100, 100 },
	sound = "ambient/machines/combine_terminal_loop1.wav"
} )

C_ScannerRange = CreateConVar( "worldscanner_range", "512", FCVAR_NOTIFY, "Set Entity Scanner, scan range." )
C_ScannerPointer = CreateConVar( "worldscanner_pointer_time", "5", FCVAR_NOTIFY, "Set Entity Pointer, life time." )

if SERVER then

function ENT:Initialize()
	self:SetModel("models/props_combine/breenglobe.mdl")
	self:SetMaterial("models/props_combine/combine_interface_disp")
	self:SetNoDraw(false)
	self:DrawShadow(true)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self.UseDelay = 0
	self.Entities = {}
	
end

function ENT:Use( activator, ent )
if activator:IsPlayer() then
if self.UseDelay > CurTime()  then return end
self.UseDelay = CurTime() + C_ScannerPointer:GetInt()
self:EmitSound("ambient/machines/combine_terminal_idle2.wav")
activator:PrintMessage( HUD_PRINTTALK, "Scanning complete. Check your console for result :)" )
for k, v in pairs(ents.FindByClass("pp_prop_effect")) do
if !table.HasValue(self.Entities, v) then
	self:Scan(v)
end
end
end
end


function ENT:Scan(ent)
	if not IsValid(ent) then return end
	
	table.insert(self.Entities, ent)
	
	table.RemoveByValue(self.Entities, ent)

	if IsValid(ent) and IsValid(self) and self:GetPos():Distance(ent:GetPos()) < C_ScannerRange:GetInt() then
	print("-----------------------------------------------------------------------------------")
	print("Entity Name:    " .. ent:GetName())
	print("Entity ID:      " .. ent:EntIndex())
	print("Entity Class:   " .. ent:GetClass())
	print("Entity Pos X:   " .. ent:GetPos().x)
	print("Entity Pos Y:   " .. ent:GetPos().y)
	print("Entity Pos Z:   " .. ent:GetPos().z)
	if ent:Health() > 0 then
	print("Entity Health:  " .. ent:Health())
	end
	if ent:IsPlayer() and ent:Armor() > 0 then
	print("Entity Armor:   " .. ent:Armor())
	end
	if ent:GetModel() then
	print("Entity Model:   " .. ent:GetModel())
	end
	if ent:GetMaterial() then
	print("Entity Material:   " .. ent:GetMaterial())
	end
	if ent:GetSkin() then
	print("Entity Skin:   " .. ent:GetSkin())
	end
	if ent:GetSpawnFlags() then
	print("Entity Spawnflags:   " .. ent:GetSpawnFlags())
	end
	if ent:GetSolid() then
	print("Entity Solid Type:   " .. ent:GetSolid())
	end
	pointer = ents.Create("prop_effect")
	pointer:SetModel("models/editor/axis_helper.mdl")
	pointer:SetPos( ent:GetPos() )
	pointer:Spawn()
	pointer:Activate()
	SafeRemoveEntityDelayed(pointer,C_ScannerPointer:GetInt())
	end
		if !IsValid(ent) || !IsValid(self) then

				table.RemoveByValue( self.Entities, ent )

		end
end


function ENT:Think()
end
function ENT:OnRemove()
end
end
