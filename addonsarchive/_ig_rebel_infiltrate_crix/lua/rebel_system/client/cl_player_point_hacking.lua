
local target -- will be set when the player accepts a mission
local zone_timer = 0 -- if the player needs to stay in an area for a certain amount of time this will be set
local zone_radius
local original_timer 
local loopid = nil
local soundID = "hack" --default
local ResetPlayerVariables = function()
	zone_timer = 0 
	target = nil 
	zone_radius = nil
	original_timer = nil
	LocalPlayer().IsWaiting = false
	LocalPlayer().HackPointFound = false
	LocalPlayer():NoLongerHacking()
	if loopid then LocalPlayer():StopLoopingSound(loopid) end
	soundID = "hack"
	loopid = nil
end

hook.Add( "HUDPaint", "RebelHackClient", function()
	if not target or not zone_radius then 
		return 
	end
	if LocalPlayer():GetPos():DistToSqr(target) <= zone_radius^2 then 
		-- either countdown the timer or say we got there
		if not LocalPlayer().HackPointFound then 
			LocalPlayer().HackPointFound = true
			LocalPlayer():InitStartHackPoint()
		end
		if zone_timer > 0.1 then
			if not LocalPlayer().IsWaiting then 
				LocalPlayer().IsWaiting = true
				loopid = LocalPlayer():StartLoopingSound(hackingsound[soundID])
			end
			zone_timer = zone_timer - RealFrameTime() 
		else 
			ResetPlayerVariables()
			LocalPlayer():TargetHit()
		end
	else 
		if LocalPlayer().IsWaiting then 
			LocalPlayer().IsWaiting = false 
			if loopid then LocalPlayer():StopLoopingSound(loopid) end
			loopid = nil
		end
	end

	if not LocalPlayer().IsWaiting or not original_timer then return end 
	-- draw a charging bar for the player indicating they have to wait
	surface.SetDrawColor(50,50,50,255)
	surface.DrawRect( ( ScrW() * 0.5 ) - 150 , ScrH() - 70, 300, 30 )
	surface.SetDrawColor(50,50,255,255)
	surface.DrawRect( ( ScrW() * 0.5 ) - 150 , ScrH() - 70, 300 * (zone_timer / original_timer) , 30 )
end )



hook.Add("PostDrawTranslucentRenderables", "RebelHackSphere", function(bDepth, bSkyBox)
	if (bSkybox) then return end
	if not target or not zone_radius then return end
	render.SetColorMaterial()
	render.DrawSphere(target, zone_radius, 30,30, Color(255,0,0, 200))
	
end)


net.Receive("StopRebelHacking", function()
	ResetPlayerVariables()
end)

net.Receive("RebelMissionSystemHackingTarget", function()
	target = net.ReadVector()
	zone_radius = net.ReadInt(15)
	local time = net.ReadUInt(15)
	local sd = net.ReadString()
	if sd ~= "none" and sd ~= nil then soundID = sd end
	original_timer = time 
	zone_timer = time
end)