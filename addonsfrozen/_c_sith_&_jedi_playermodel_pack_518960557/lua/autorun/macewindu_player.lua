local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	
end


AddPlayerModel( "MaceWindu", 					"models/ryan7259/mace_windu/mace_windu_player.mdl" )
