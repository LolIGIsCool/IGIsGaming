local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	
end

AddPlayerModel( "GRealms Gungans", 				"models/grealms/characters/gungans/gungans.mdl" )
