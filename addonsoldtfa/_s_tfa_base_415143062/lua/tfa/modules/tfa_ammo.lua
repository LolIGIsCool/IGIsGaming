--[[Bow Ammo]]
--
game.AddAmmoType({
	name = "light_battery",
	dmgtype = 2,
	flags = 0,
	force = 600,
	maxsplash = 8,
	minsplash = 4,
	plydmg = sk_plr_dmg_ar2,
	npcdmg = sk_npc_dmg_ar2,
	maxcarry = 100
})

if CLIENT then
	language.Add("light_battery_ammo", "Light Battery Packs")
end
--
game.AddAmmoType({
	name = "standard_battery",
	dmgtype = 2,
	flags = 0,
	force = 600,
	maxsplash = 8,
	minsplash = 4,
	plydmg = sk_plr_dmg_ar2,
	npcdmg = sk_npc_dmg_ar2,
	maxcarry = 300
})

if CLIENT then
	language.Add("standard_battery_ammo", "Standard Battery Packs")
end

game.AddAmmoType({
	name = "heavy_battery",
	dmgtype = 2,
	flags = 0,
	force = 600,
	maxsplash = 8,
	minsplash = 4,
	plydmg = sk_plr_dmg_ar2,
	npcdmg = sk_npc_dmg_ar2,
	maxcarry = 540
})

if CLIENT then
	language.Add("heavy_battery_ammo", "Heavy Battery Packs")
end

game.AddAmmoType({
	name = "high_power_battery",
	dmgtype = 2,
	flags = 0,
	force = 600,
	maxsplash = 8,
	minsplash = 4,
	plydmg = sk_plr_dmg_ar2,
	npcdmg = sk_npc_dmg_ar2,
	maxcarry = 30
})

if CLIENT then
	language.Add("high_power_battery_ammo", "High-Power Battery Packs")
end