local function getPermSigns()
	return util.JSONToTable( file.Read( "perm_signs/" .. game.GetMap() .. ".txt" ) or '' ) or {}
end

concommand.Add( "signs_perm", function( ply )
	if !IsValid( ply ) or !ply:IsAdmin() then return end
	
	if 	ply:IsSuperAdmin() then
		local ent = ply:GetEyeTrace().Entity

		if !IsValid( ent ) then return end

		local signs = getPermSigns()
		local psid = tostring( ent._permSignId or (table.Count( signs ) + 1) ) -- update old id or generate new one

		if ent.Base == "signs_base" then
			signs[psid] = {
				class = ent:GetClass(),
				pos = ent:GetPos(),
				ang = ent:GetAngles(),

				backgroundColor = ent:GetBackgroundColor(),
				imageUrl = ent:GetImageUrl(),
				imageCropMode = ent:GetImageCropMode(),
				textOverlays = ent:GetTextOverlays()
			}
		elseif ent.Base == "signs_ticker_base" then
			signs[psid] = {
				class = ent:GetClass(),
				pos = ent:GetPos(),
				ang = ent:GetAngles(),

				backgroundColor = ent:GetBackgroundColor(),
				text = ent:GetText(),
				textColor = ent:GetTextColor(),
				textSpeed = ent:GetTextSpeed(),
				textCycleDelay = ent:GetTextCycleDelay(),
				font = ent:GetFont(),
				fontBold = ent:GetFontBold(),
				fontItalic = ent:GetFontItalic(),
				fontOutline = ent:GetFontOutline()
			}
		else
			ply:PrintMessage( HUD_PRINTCONSOLE, "This entity is not a sign." )

			return
		end

		ent._permSignId = psid

		if !file.Exists( "perm_signs", "DATA" ) then
			file.CreateDir( "perm_signs" )
		end

		file.Write( "perm_signs/" .. game.GetMap() .. ".txt", util.TableToJSON( signs ) )

		ply:PrintMessage( HUD_PRINTCONSOLE, "Success" )
	end
end )

concommand.Add( "signs_unperm", function( ply )
	if !IsValid( ply ) or !ply:IsAdmin() then return end
	if 	ply:IsSuperAdmin() then
		local ent = ply:GetEyeTrace().Entity
		PrintTable(getPermSigns())
		if !IsValid( ent ) or !ent._permSignId then return end
		print("test")
		local signs = getPermSigns()
		print(signs)
		signs[ent._permSignId] = nil
		ent._permSignId = nil
		
		file.Write( "perm_signs/" .. game.GetMap() .. ".txt", util.TableToJSON( signs ) )

		ply:PrintMessage( HUD_PRINTCONSOLE, "Success" )
	end
end )

concommand.Add( "signs_isperm", function( ply )
	if !IsValid( ply ) or !ply:IsAdmin() then return end

	local ent = ply:GetEyeTrace().Entity
	if 	ply:IsSuperAdmin() then
		if !IsValid( ent ) then return end

		ply:PrintMessage( HUD_PRINTCONSOLE, "The sign " .. (ent._permSignId and "is" or "isn't") .. " permanent." )
	end
end )


local function spawnPermSigns()
	for sid, sinfo in pairs( getPermSigns() ) do
		local sign = ents.Create( sinfo.class )

		if !IsValid( sign ) then return end

		sign:SetPos( sinfo.pos )
		sign:SetAngles( sinfo.ang )
		sign:Spawn()

		sign:GetPhysicsObject():EnableMotion( false )

		if sign.Base == "signs_base" then
			sign:SetBackgroundColor( sinfo.backgroundColor )
			sign:SetImageUrl( sinfo.imageUrl )
			sign:SetImageCropMode( sinfo.imageCropMode )
			sign:SetTextOverlays( sinfo.textOverlays )
		elseif sign.Base == "signs_ticker_base" then
			sign:SetBackgroundColor( sinfo.backgroundColor )
			sign:SetText( sinfo.text )
			sign:SetTextColor( sinfo.textColor )
			sign:SetTextSpeed( sinfo.textSpeed )
			sign:SetTextCycleDelay( sinfo.textCycleDelay )
			sign:SetFont( sinfo.font )
			sign:SetFontBold( sinfo.fontBold )
			sign:SetFontItalic( sinfo.fontItalic )
			sign:SetFontOutline( sinfo.fontOutline )
		end

		timer.Simple( 1, function() -- ugly, but it takes a second for the clients to synchronize and instantiate new entities (should really just queue messages on client...)
			if IsValid( sign ) then
				sign:BroadcastData()
			end
		end )

		sign._permSignId = sid
	end
end

concommand.Add("signs_refresh",function(ply)
    if not ply:IsSuperAdmin() then return end 
    for _, ent in pairs( ents.GetAll() ) do
        if IsValid( ent ) and (ent.Base == "signs_base" or ent.Base == "signs_ticker_base") then

            ent:Remove()
        end
    end
    spawnPermSigns()
end)

hook.Add( "InitPostEntity", "sv_signs_loadsigns", spawnPermSigns )
hook.Add( "PostCleanupMap", "sv_signs_reloadsigns", spawnPermSigns )
