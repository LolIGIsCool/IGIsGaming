--[[-------------------------------------------------------------------
	Medal System Clientside Core:
		The core functions for the client side
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2018
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}
wOS.Medals = wOS.Medals or {}
wOS.Medals.SelectedMedals = wOS.Medals.SelectedMedals or {}
wOS.Medals.SelectedMedalsInfo = wOS.Medals.SelectedMedalsInfo or {}
wOS.Medals.Offsety = 178
wOS.Medals.Offsetp = -13.05
wOS.Medals.OffsetZoom = 60

local w, h = ScrW(), ScrH()
list.Add( "DesktopWindows", {
	icon = "wos/vas/widget.png",
	title = "VAS Menu",
	init = function() wOS.Medals:ToggleMedalMenu() end,
})

hook.Add("PostPlayerDraw", "wOS.Medals.DrawModel", function(ply)
	
	if !ply.MedalModels then return end
	if !ply.SelectedMedals then return end
	
	local amount = table.Count(ply.SelectedMedals)
	if amount < 1 then return end
	
	local id = ply:LookupBone("ValveBiped.Bip01_Spine2")
	
	if id then
		local min, max = ply:GetCollisionBounds() 
		
		for index, info in pairs(ply.SelectedMedals) do
			local badge = wOS.Medals.Badges[ info.Name ]
			if not badge then return end
			if index > 6 then break end
			local pos, ang = ply:GetBonePosition(id)
			pos = pos - ang:Right()*max.y*0.66
			ply.MedalModels[index]:SetPos(pos + ang:Up() * info.Positions.Up - ang:Right() * info.Positions.Right + ang:Forward() * info.Positions.Forward)	
			
			ang:RotateAroundAxis( ang:Up(), badge.OffsetAngle.p )
			ang:RotateAroundAxis( ang:Right(), badge.OffsetAngle.y )
			ang:RotateAroundAxis( ang:Forward(), badge.OffsetAngle.r )
			
			ply.MedalModels[index]:SetAngles( ang )
			ply.MedalModels[index]:DrawModel()
		end
	end

end )

hook.Add("PreDrawHalos", "wOS.Medals.Halos", function()
	
	-- PUT IN CODE FOR HALOS TO APPEAR AROUND PLAYERS MEDALS WHEN LOOKED AT
	
end)

hook.Add( "Think", "wOS.Medals.AutorequestData", function()
	hook.Remove( "Think", "wOS.Medals.AutorequestData"	)
	net.Start( "wOS.Medals.Badges.RequestData" )
	net.SendToServer()
end )

hook.Add( "CalcView", "wOS.Medals.ThirdPersonView", function( ply, pos, ang )

	if ( !IsValid( ply ) or !ply:Alive() or ply:InVehicle() or ply:GetViewEntity() != ply ) then return end
	if !IsValid( wOS.Medals.Menu ) then return end
	
	ang = Angle( wOS.Medals.Offsetp, wOS.Medals.Offsety, 0 )
	pos = pos - ang:Up()*20 - ang:Forward()*wOS.Medals.OffsetZoom

	return {
		origin = pos,
		angles = ang,
		drawviewer = true
	}
	
end )
