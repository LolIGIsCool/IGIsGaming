if SERVER then
	resource.AddFile("models/player/heracles421/tarkin/moff_tarkin.mdl")
	resource.AddFile( "materials/models/heracles421/tarkin/clothes_wrp.vtf" )
	resource.AddFile( "materials/models/heracles421/tarkin/t_imperial_officer_01_body_c.vtf" )
	resource.AddFile( "materials/models/heracles421/tarkin/t_imperial_officer_01_body_msr.vtf" )
	resource.AddFile( "materials/models/heracles421/tarkin/t_imperial_officer_01_body_n.vtf" )
	resource.AddFile( "materials/models/heracles421/tarkin/t_imperial_officer_01_boots_c.vtf" )
	resource.AddFile( "materials/models/heracles421/tarkin/t_imperial_officer_01_gloves_c.vtf" )
	resource.AddFile( "materials/models/heracles421/tarkin/t_imperial_officer_01_gloves_msr.vtf" )
	resource.AddFile( "materials/models/heracles421/tarkin/t_imperial_officer_01_gloves_n.vtf" )
	resource.AddFile( "materials/models/heracles421/tarkin/t_tarkin_body.vmt" )
	resource.AddFile( "materials/models/heracles421/tarkin/t_tarkin_boots.vmt" )
	resource.AddFile( "materials/models/heracles421/tarkin/t_tarkin_gloves.vmt" )
	resource.AddFile( "materials/models/heracles421/tarkin/t_tarkin_head.vmt" )
	resource.AddFile( "materials/models/heracles421/tarkin/t_tarkin_head_c.vtf" )
end

player_manager.AddValidModel( "Moff Tarkin", "models/player/heracles421/tarkin/moff_tarkin.mdl" )
list.Set( "PlayerOptionsModel", "Moff Tarkin", "models/player/heracles421/tarkin/moff_tarkin.mdl" )