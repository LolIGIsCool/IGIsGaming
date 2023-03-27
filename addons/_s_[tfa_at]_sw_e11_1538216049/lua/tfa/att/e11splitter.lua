if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "E11 Splitter"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { 
	--TFA.AttachmentColors["+"], "", 
	--TFA.AttachmentColors["+"], "", 
}
ATTACHMENT.Icon = "entities/e11splitter.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "SPLIT"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["e11splitter"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["e11splitter"] = {
			["active"] = true
		}
	},
	["Primary"] = {
		["Sound"] = Sound ("weapons/bf3/e11e.wav");
		["KickUp"] = function(wep,stat) return stat*5 end,
		["KickDown"] = function(wep,stat) return stat*5 end,
		["KickHorizontal"] = function(wep,stat) return stat*3 end,
		["SpreadMultiplierMax"] = function(wep,stat) return stat*2 end,
		["NumShots"] = 4,
		["AmmoConsumption"] = 3,
		["Damage"] = function(wep,stat) return stat/5 end,
		["Spread"] = function(wep,stat) return stat*3.5 end,
		["IronAccuracy"] = function(wep,stat) return stat*70 end,
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
