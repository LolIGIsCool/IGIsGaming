function AddAmmoType(name, text)
	game.AddAmmoType({name = name,
	dmgtype = DMG_BULLET})
	
	if CLIENT then
		language.Add(name .. "_ammo", text)
	end
end

AddAmmoType("stun_ammo", "Stun Charge") 