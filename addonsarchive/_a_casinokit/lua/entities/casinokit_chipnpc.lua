AddCSLuaFile()

ENT.CasinoKitPersistable = true
ENT.Base 			= "casinokit_npc"
ENT.RenderGroup = RENDERGROUP_BOTH
DEFINE_BASECLASS("casinokit_npc")

ENT.Spawnable = true
ENT.Category = "Casino Kit"
ENT.PrintName = "Chip Exchange Npc"

ENT.Model = "models/imperial_officer/npc_officer.mdl"

if CLIENT then
	function ENT:DrawTranslucent()
		if LocalPlayer():EyePos():Distance(self:GetPos()) > 512 then return end
		self:DrawOverheadText(CasinoKit.L("chip_exchange"))
	end

	function ENT:Draw()
		BaseClass.Draw(self)
	end
end

function ENT:Use(ply)
	ply:ConCommand("casinokit_chipexchange_npc " .. self:EntIndex())
end