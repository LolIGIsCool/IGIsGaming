hook.Add( "InitPostEntity", "PlaceLimitingProp", function()

	util.PrecacheModel( "models/hunter/plates/plate4x4.mdl" )

	local blockingModel = ents.CreateClientProp()
	blockingModel:SetPos( Vector( -1122, -1838, -4803 ) )
	blockingModel:SetAngles( Angle( 90, 90, 0 ) )
	blockingModel:SetModel( "models/hunter/plates/plate4x4.mdl" )
	blockingModel:Spawn()

end )