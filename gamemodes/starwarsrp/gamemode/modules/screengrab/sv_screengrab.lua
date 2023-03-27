util.AddNetworkString( "bScreenGrabStop" )
util.AddNetworkString( "bScreenGrabFailed" )
util.AddNetworkString( "bScreenGrabSuccess" )
util.AddNetworkString( "bScreenGrabStart" )

net.Receive( "bScreenGrabSuccess", function( len, ply )
	if !IsValid( ply.ScreenGrabber ) then return end

	local url = net.ReadString()
	if url:gsub( ".+i%.imgur%.com/%w+%.jpg", "" ) != "" then
		ply.ScreenGrabber:PrintMessage( HUD_PRINTTALK, ply:Nick() .. ": Tampered with screenshot." )
		ply.ScreenGrabber = nil
	return end

	ply.ScreenGrabber:PrintMessage( HUD_PRINTTALK, ply:Nick() .. ": " .. url )

	if ( ply.ScreenGrabber.ScreenGrabTime or math.huge ) > CurTime() then
		net.Start( "bScreenGrabSuccess" )
			net.WriteString( url )
		net.Send( ply.ScreenGrabber )
	end

	ply.ScreenGrabber = nil
end )

net.Receive( "bScreenGrabFailed", function( len, ply )
	if !IsValid( ply.ScreenGrabber ) then return end

	ply.ScreenGrabber:PrintMessage( HUD_PRINTTALK, "Failed to screengrab " .. ply:Nick() .. ". " .. net.ReadString() )
	ply.ScreenGrabber = nil
end )

hook.Add( "IGPlayerSay", "ScreenGrabChat", function( ply, text )
	if !ply:IsDeveloper() then return end
	text = string.Explode( " ", string.lower( text ) )

	if text[ 1 ] == "!screengrab" then
		local target, err = ULib.getUser( text[ 2 ] )

		if !target then
			ply:PrintMessage( err )
			return
		end

		ply.ScreenGrabTime = CurTime() + ( tonumber( text[ 3 ] ) or 60 )
		target.ScreenGrabber = ply

		net.Start( "bScreenGrabStart" )
		net.Send( target )

		ply:PrintMessage( HUD_PRINTTALK, "Starting screengrab on: " .. target:Nick() )

		return ""
	elseif text[ 1 ] == "!screengraball" then
		for k, target in pairs( player.GetHumans() ) do
			if target == ply then continue end
			target.ScreenGrabber = ply
		end

		ply.ScreenGrabTime = CurTime() + ( tonumber( text[ 2 ] ) or 60 )
		net.Start( "bScreenGrabStart" )
		net.Broadcast()

		ply:PrintMessage( HUD_PRINTTALK, "Starting screengrab on everyone" )

		return ""
	end
end )