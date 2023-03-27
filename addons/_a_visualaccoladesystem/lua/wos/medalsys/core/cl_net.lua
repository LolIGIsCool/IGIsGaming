--[[-------------------------------------------------------------------
	Client Networking File:
		File deals with all clientside networking
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

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

wOS = wOS or {}
wOS.Medals = wOS.Medals or {}
wOS.Medals.Badges = wOS.Medals.Badges or {}
wOS.Medals.AccoladeList = wOS.Medals.AccoladeList or {}

net.Receive( "wOS.Medals.Badges.SendPlayerMedals", function( len )

	local ply = net.ReadEntity()
	if not IsValid( ply ) then return end
	
	ply.AccoladeList = {}
	
	local count = net.ReadUInt( 32 )
	for i=1, count do
		ply.AccoladeList[ net.ReadString() ] = net.ReadString()
	end
	
	--Pointer fix for our localplayer variable
	if ply == LocalPlayer() then
		LocalPlayer().AccoladeList = table.Copy( ply.AccoladeList )
	end
	
	if IsValid( wOS.Medals.Menu ) then
		if wOS.Medals.SideFrame.RebuildFromData then
			wOS.Medals.SideFrame:RebuildFromData()
		end
	end
	
end )


net.Receive("wOS.Medals.Badges.SendAllBadges", function()

	local badges = net.ReadTable()

	for _, data in pairs( badges ) do
		wOS.Medals.Badges[ data.Name ] = table.Copy( data )
	end

end)

net.Receive( "wOS.Medals.Badges.RequestBadgePos", function()

	local ply = net.ReadEntity()
	if not IsValid( ply ) then return end
	
	local data = net.ReadTable()
	ply.SelectedMedals = table.Copy( data )
	PrintTable(ply.SelectedMedals)
	if ply == LocalPlayer() then
		LocalPlayer().SelectedMedals = table.Copy( ply.SelectedMedals )
		if IsValid( wOS.Medals.Menu ) then
			if wOS.Medals.SideFrame.RebuildFromData then
				wOS.Medals.SideFrame:RebuildFromData()
			end
		end
	end

	if ply.MedalModels then
		for slot, _ in ipairs( ply.MedalModels ) do
			ply.MedalModels[ slot ]:Remove()
		end
	end
	
	ply.MedalModels = {}
	
	for slot, dat in ipairs( ply.SelectedMedals ) do
		ply.MedalModels[slot] = ClientsideModel( dat.Model )
		if dat.Skin then
			ply.MedalModels[slot]:SetSkin( dat.Skin )
		end
		ply.MedalModels[slot]:SetNoDraw(true)
	end

end )