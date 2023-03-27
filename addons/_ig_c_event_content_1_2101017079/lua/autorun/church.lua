local function AddPlayerModel( name, model )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )
	
end

AddPlayerModel( "SW:TOR Jaric", "models/player/valley/jaric.mdl" )
AddPlayerModel( "SW:TOR Jensyn", "models/player/valley/jensyn.mdl" )
AddPlayerModel( "SW:TOR Shae", "models/player/valley/shae.mdl" )

player_manager.AddValidModel( "qyzen", "models/player/valley/qyzen.mdl" );
list.Set( "PlayerOptionsModel", "qyzen", "models/player/valley/qyzen.mdl" );

player_manager.AddValidModel( "kira", "models/player/valley/kira.mdl" );
list.Set( "PlayerOptionsModel", "kira", "models/player/valley/kira.mdl" );

player_manager.AddValidModel( "aric", "models/player/valley/aric.mdl" );
list.Set( "PlayerOptionsModel", "aric", "models/player/valley/aric.mdl" );

player_manager.AddValidModel( "doc", "models/player/valley/doc.mdl" );
list.Set( "PlayerOptionsModel", "doc", "models/player/valley/doc.mdl" );