local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	
end



AddPlayerModel( "Shadow Guard", 		"models/imperial/guard/blackguard.mdl" )
