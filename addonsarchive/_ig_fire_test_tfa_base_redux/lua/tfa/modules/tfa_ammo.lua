-- Copyright (c) 2018-2020 TFA Base Devs

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

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