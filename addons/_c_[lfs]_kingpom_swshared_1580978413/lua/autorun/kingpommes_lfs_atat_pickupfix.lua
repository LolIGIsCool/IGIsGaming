if SERVER then
	hook.Add("OnEntityCreated", "KingPommes.ATAT.LAATC_DROPPER", function(ent)
		if ent:GetClass() ~= "lunasflightschool_laatcgunship" and ent.Base ~= "lunasflightschool_laatcgunship" then return end
		if not isfunction(ent.CanDrop) then return end

		-- backup the old function
		ent.CanDropOld = ent.CanDrop

		-- override the CanDrop function
		ent.CanDrop = function()
			-- if the held vehicle is the atat always allow it to be dropped. Else return the regulat function
			if ent:GetHeldEntity():GetClass() == "kingpommes_lfs_atat" then
				return true
			else
				return ent.CanDropOld(ent)
			end
		end
	end)
end

if CLIENT then
	killicon.Add( "kingpommes_lfs_atat_footcollider", "HUD/killicons/atat_crushed", Color( 255, 80, 0, 255 ) )
	killicon.Add( "kingpommes_lfs_atat_head", "HUD/killicons/atat_shot", Color( 255, 80, 0, 255 ) )
	killicon.Add( "kingpommes_lfs_atat", "HUD/killicons/atat_shot", Color( 255, 80, 0, 255 ) )
	language.Add( "kingpommes_lfs_atat_footcollider", "AT-AT" )
end