if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Blue Tibanna Gas Cartridges"
ATTACHMENT.ShortName = "BTGC" --Abbreviation, 5 chars or less please
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { 
TFA.AttachmentColors["="],"Low energy ammo type - Fast rate of fire, low impact.",
TFA.AttachmentColors["+"],"%50 increase to Clip Size",
TFA.AttachmentColors["+"],"%50 increase to RPM",
TFA.AttachmentColors["+"],"%25 increase to movement speed.",
TFA.AttachmentColors["-"],"%70 decrease to damage",
TFA.AttachmentColors["-"],"%200 decrease to accuracy",
}
ATTACHMENT.Icon = "entities/blue_ammo.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.Damage = 15.5

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = 15,
		["ClipSize"] = 50,
		["DefaultClip"] = 50,
		["RPM"] = 500,
		["RPM_Burst"] = function( wep, val) return val * 0.75 end,
		["Spread"] = function( wep, val) return val * 2 end,
		["IronAccuracy"] = function( wep, val) return val * 2 end,
		["Force "] = 500,
		["Sound"] = "weapons/bf3/e11_light.wav"
	},
	["MoveSpeed"] = 1.05,
	["TracerName"] = "effect_sw_laser_blue"
}

function ATTACHMENT:Attach(wep)
	wep.ImpactEffect = "rw_sw_impact_blue"
	wep.MuzzleFlashEffect = "rw_sw_muzzleflash_blue"
	wep:Unload()
end

function ATTACHMENT:Detach(wep)
	wep.ImpactEffect = "rw_sw_impact_red"
	wep.MuzzleFlashEffect = "rw_sw_muzzleflash_red"
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end