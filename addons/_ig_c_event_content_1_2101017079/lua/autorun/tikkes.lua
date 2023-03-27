local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )

end


AddPlayerModel( "Senator Tikkes",		"models/player/tiki/tikkes.mdl" )
