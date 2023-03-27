include('shared.lua')

language.Add("npc_dan_zombie", "Infected Zombie")
killicon.Add("npc_dan_zombie","HUD/killicons/default",Color ( 255, 80, 0, 255 ) )

function ENT:Initialize()	
end

function ENT:Draw()	
	--self:SetModelScale( Vector(5,5,5) )
	self.Entity:DrawModel()
end