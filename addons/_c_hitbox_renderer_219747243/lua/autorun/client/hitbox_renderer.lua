local hitboxCurrentlyRendering = false
local renderAll = false
local renderRagDolls = false
local renderNPCs = false
local renderLocalPlayer = false
local zeroAngle = Angle(0, 0, 0)


local function HitboxRender()

	for _, ent in pairs(ents.GetAll()) do

		--if ply == LocalPlayer() then continue end

		if not renderAll then

			if not ent:IsPlayer() and not ent:IsRagdoll() and not ent:IsNPC() then continue end

			if not renderLocalPlayer and ent == LocalPlayer() then continue end
			
			if not renderNPCs and ent:IsNPC() then continue end

			if not renderRagDolls and ent:IsRagdoll() then continue end

		end

		if ent:GetHitBoxGroupCount() == nil then continue end

		for group=0, ent:GetHitBoxGroupCount() - 1 do
		    
		 	for hitbox=0, ent:GetHitBoxCount( group ) - 1 do

		 		local pos, ang =  ent:GetBonePosition( ent:GetHitBoxBone(hitbox, group) )
		 		local mins, maxs = ent:GetHitBoxBounds(hitbox, group)

				render.DrawWireframeBox( pos, ang, mins, maxs, Color(51, 204, 255, 255), true )
			end
		end

		render.DrawWireframeBox( ent:GetPos(), zeroAngle, ent:OBBMins(), ent:OBBMaxs(), Color(255, 204, 51, 255), true )

	end
end 

concommand.Add( "hitbox_togglerender", function( ply, cmd, args, str)

	if not ply:IsAdmin() then return end

	if hitboxCurrentlyRendering then
		hook.Remove("PostDrawOpaqueRenderables", "HitboxRender")
		hitboxCurrentlyRendering = false
	else
		hook.Add("PostDrawOpaqueRenderables", "HitboxRender", HitboxRender )
		hitboxCurrentlyRendering = true
	end

end )

concommand.Add( "hitbox_renderall", function( ply, cmd, args, str)

	renderAll = not renderAll
	print("Render all hitboxes: " .. tostring(renderAll))

end )

concommand.Add( "hitbox_renderragdolls", function( ply, cmd, args, str)

	renderRagDolls = not renderRagDolls
	print("Render ragdolls: " .. tostring(renderRagDolls))

end )

concommand.Add( "hitbox_rendernpcs", function( ply, cmd, args, str)

	renderNPCs = not renderNPCs
	print("Render NPCs: " .. tostring(renderNPCs))

end )

concommand.Add( "hitbox_renderlocalplayer", function( ply, cmd, args, str)

	renderLocalPlayer = not renderLocalPlayer
	print("Render local player: " .. tostring(renderLocalPlayer))

end )