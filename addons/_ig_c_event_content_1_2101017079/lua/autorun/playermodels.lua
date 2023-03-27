if SERVER then
	AddCSLuaFile()
end

local function AddPlayerModel( name, model, hands )

	list.Set( "PlayerOptionsModel", name, model )
	player_manager.AddValidModel( name, model )

	if hands then
		player_manager.AddValidHands( name, hands, 0, "00000000" )
	end

end

AddPlayerModel( "darth revan", "models/player/darth_revan.mdl" )
AddPlayerModel( "light revan", "models/player/light_revan.mdl" )