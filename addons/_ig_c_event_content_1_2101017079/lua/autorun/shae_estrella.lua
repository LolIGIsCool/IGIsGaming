local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	
end

AddPlayerModel( "Shae Vizla", "models/player/estrella/shae_vizla.mdl" )