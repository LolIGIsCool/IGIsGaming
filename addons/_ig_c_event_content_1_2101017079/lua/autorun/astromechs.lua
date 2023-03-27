local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	
end



AddPlayerModel( "Astromech V1 Red",  "models/player/valley/petastromechred.mdl" )
AddPlayerModel( "Astromech V1 Blue", "models/player/valley/petastromechblue.mdl" )
AddPlayerModel( "Astromech V1 Purple", "models/player/valley/petastromechpurple.mdl" )
AddPlayerModel( "Astromech V2 Orange", "models/player/valley/astromechv2orange.mdl" )
AddPlayerModel( "Astromech V2 Red", "models/player/valley/astromechv2red.mdl" )
AddPlayerModel( "Astromech V2 Pink", "models/player/valley/astromechv2pink.mdl" )
