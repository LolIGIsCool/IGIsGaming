AddCSLuaFile("shared.lua")

include("shared.lua")

resource.AddFile("materials/vgui/entities/stryker_adrenaline.vtf")
resource.AddFile("materials/vgui/entities/stryker_adrenaline.vmt")
resource.AddFile("materials/entities/str_sw_e11s_mr.png")
resource.AddFile("materials/entities/str_sw_iqa11_carbine.png")
resource.AddFile("materials/entities/str_sw_rt97c_suppression.png")
resource.AddFile("sound/weapons/tl50_cannon.wav")

sound.Add( {
	name = "squirt_sound",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 75,
	pitch = {97, 103},
	sound = "weapons/medkit/sw_syringe.wav"
} )