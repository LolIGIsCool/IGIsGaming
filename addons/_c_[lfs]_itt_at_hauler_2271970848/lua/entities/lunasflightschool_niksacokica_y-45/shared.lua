ENT.Type = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript_gunship" )

ENT.PrintName = "Y-45"
ENT.Author = "niksacokica"
ENT.Information = ""
ENT.Category = "[LFS] Empire"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.MDL = "models/niksacokica/jfo_vehicles/y-45.mdl"

ENT.AITEAM = 2

ENT.Mass = 10000

ENT.HideDriver = true
ENT.SeatPos = Vector(133,0,185)
ENT.SeatAng = Angle(0,-90,0)

function ENT:AddDataTables()
	self:NetworkVar( "Bool",22, "GXHairRG" )
	self:NetworkVar( "Entity",22, "HeldEntity" )
end