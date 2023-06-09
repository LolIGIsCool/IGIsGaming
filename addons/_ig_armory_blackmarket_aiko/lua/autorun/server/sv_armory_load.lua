if not SERVER then return end

MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(9, 255,0), "Loading Serverside Load Files", "\n")
folders = {"starwars_armory", "starwars_blackmarket"}
for _, Folder in ipairs(folders) do
	for _, File in ipairs(file.Find(Folder .. "/load/*.lua", "LUA")) do
		if File == "cl_init.lua" then
			AddCSLuaFile(Folder .. "/load/" .. File)
		end
		include(Folder .. "/load/" .. File)
		MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(255, 208,0), Folder .. "/load/" .. File, "\n")
	end
end
MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blackmarket] ", Color(9, 255,0), "Loaded Serverside Load Files", "\n")

resource.AddFile("vanilla/armory/dartgun.png" )
resource.AddFile("vanilla/armory/imperialarts_blade_bxcommandodroidblade.png")
resource.AddFile("vanilla/armory/imperialarts_blade_extendablebaton.png")
resource.AddFile("vanilla/armory/middlefinger_animation_swep.png")
resource.AddFile("vanilla/armory/rw_sw_a280.png")
resource.AddFile("vanilla/armory/rw_sw_a280c.png")
resource.AddFile("vanilla/armory/rw_sw_dc15a.png")
resource.AddFile("vanilla/armory/rw_sw_dlt19.png")
resource.AddFile("vanilla/armory/rw_sw_dlt20a.png")
resource.AddFile("vanilla/armory/rw_sw_dual_dc17s.png")
resource.AddFile("vanilla/armory/rw_sw_dual_e5bx.png")
resource.AddFile("vanilla/armory/rw_sw_dual_rk3.png")
resource.AddFile("vanilla/armory/rw_sw_e11d.png")
resource.AddFile("vanilla/armory/rw_sw_e22.png")
resource.AddFile("vanilla/armory/rw_sw_e5s_auto.png")
resource.AddFile("vanilla/armory/rw_sw_huntershotgun.png")
resource.AddFile("vanilla/armory/rw_sw_nade_dioxis.png")
resource.AddFile("vanilla/armory/rw_sw_nade_impact.png")
resource.AddFile("vanilla/armory/rw_sw_nade_smoke.png")
resource.AddFile("vanilla/armory/rw_sw_nade_stun.png")
resource.AddFile("vanilla/armory/rw_sw_nade_thermal.png")
resource.AddFile("vanilla/armory/rw_sw_nade_training.png")
resource.AddFile("vanilla/armory/rw_sw_nt242c.png")
resource.AddFile("vanilla/armory/rw_sw_pinglauncher.png")
resource.AddFile("vanilla/armory/rw_sw_relbyk23.png")
resource.AddFile("vanilla/armory/rw_sw_rk3.png")
resource.AddFile("vanilla/armory/rw_sw_scoutblaster.png")
resource.AddFile("vanilla/armory/rw_sw_se14c.png")
resource.AddFile("vanilla/armory/rw_sw_se14r.png")
resource.AddFile("vanilla/armory/rw_sw_t21.png")
resource.AddFile("vanilla/armory/rw_sw_tl50.png")
resource.AddFile("vanilla/armory/rw_sw_tusken_cycler.png")
resource.AddFile("vanilla/armory/rw_sw_umb1.png")
resource.AddFile("vanilla/armory/rw_sw_valken38x.png")
resource.AddFile("vanilla/armory/rw_sw_westar11.png")
resource.AddFile("vanilla/armory/rw_sw_westarm5.png")
resource.AddFile("vanilla/armory/stryker_adrenaline.png")
resource.AddFile("vanilla/armory/str_sw_e11s_mr.png")
resource.AddFile("vanilla/armory/str_sw_iqa11_carbine.png")
resource.AddFile("vanilla/armory/ven_e11.png")
resource.AddFile("vanilla/armory/weapon_camo.png")
resource.AddFile("vanilla/armory/weapon_cuff_standard.png")
resource.AddFile("vanilla/armory/weapon_jew_det.png")
resource.AddFile("vanilla/armory/weapon_rpw_binoculars_nvg.png")
resource.AddFile("vanilla/armory/bkeycard_.png")
resource.AddFile("vanilla/armory/bkeycard__.png")
resource.AddFile("vanilla/armory/bkeycard___.png")
resource.AddFile("vanilla/armory/bkeycard____.png")
resource.AddFile("vanilla/armory/bkeycard_____.png")