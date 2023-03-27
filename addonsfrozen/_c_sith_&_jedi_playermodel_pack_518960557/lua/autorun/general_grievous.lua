
local function AddPlayerModel( name, model )

    list.Set( "PlayerOptionsModel", name, model )
    player_manager.AddValidModel( name, model )
    
end

-- Star Wars PlayerModels

AddPlayerModel( "Grievous","models/player/Grievous.mdl")