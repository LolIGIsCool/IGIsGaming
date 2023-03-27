

local target -- will be set when the player accepts a mission
local zone_radius
local ResetPlayerVariables = function()
	target = nil 
	zone_radius = nil
end

hook.Add("PostDrawTranslucentRenderables", "ReconDrawSphere", function()
	if not target or not zone_radius then return end
	render.SetColorMaterial()
	render.DrawSphere(target, zone_radius, 100,100, Color(255,0,0, 200))
	if LocalPlayer():GetPos():DistToSqr(target) <= zone_radius^2 then 
		ResetPlayerVariables()
		LocalPlayer():TargetHit()
	end
end)


-- called when the player either starts a new mission or from 
net.Receive("RebelMissionSystemReceiveTarget", function(len)
	target = net.ReadVector()
	zone_radius = net.ReadInt(15)
end)

net.Receive("StopRebelMission", function(len)
	ResetPlayerVariables()
end)