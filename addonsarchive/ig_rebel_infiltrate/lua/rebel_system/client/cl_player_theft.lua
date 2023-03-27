
local target -- will be set when the player accepts a mission
local zone_radius
local obj
local ResetPlayerVariables = function()
	target = nil 
	zone_radius = nil
	obj = nil
end

hook.Add( "Think", "RebelTheftClient", function()
	if not target or not zone_radius or not IsValid(obj)  then return end
	if obj:GetPos():DistToSqr(target) <= zone_radius^2 then 
		ResetPlayerVariables()
		LocalPlayer():TargetHit()
	end
end )

hook.Add("PostDrawTranslucentRenderables", "ShowRebelDropOffZone", function()
	if not target or not zone_radius then return end
	render.SetColorMaterial()
	render.DrawSphere(target, zone_radius, 100,100, Color(255,0,0, 200))

end)


-- called when the player either starts a new mission or from 
net.Receive("RebelMissionSystemReceiveTheftLocation", function(len)
	target = net.ReadVector()
	zone_radius = net.ReadInt(15)
	obj = LocalPlayer()
end)

net.Receive("CL_Rebel_Gear_Stats", function()
	target = net.ReadVector()
	zone_radius = net.ReadInt(15)
	obj = nil
end)

net.Receive("StopRebelTheftMission", function(len)
	ResetPlayerVariables()
end)