local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	
end



AddPlayerModel( "Imperial Snowtrooper", 		"models/player/sono/starwars/snowtrooper.mdl" )
AddPlayerModel( "Imperial Shadow Snowtrooper", 		"models/player/sono/starwars/snowshadow.mdl" )