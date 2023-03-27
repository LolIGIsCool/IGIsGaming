if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "E11 Suppressor"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { 
TFA.AttachmentColors["+"], "50% lower recoil", 
TFA.AttachmentColors["-"], "5% lower damage", 
}
ATTACHMENT.Icon = "entities/e11supp.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "SUPP"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["e11supp"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["e11supp"] = {
			["active"] = true
		}
	},
	["Silenced"] = true,
	["Primary"] = {
		["Damage"] = function(wep,stat) return stat*0.9 end,
		["Sound"] = Sound ("weapons/bf3/e11supp.wav");
		["KickUp"] = function(wep,stat) return stat/2 end,
		["KickDown"] = function(wep,stat) return stat/2 end,
		["KickHorizontal"] = function(wep,stat) return stat/2 end,
		["SpreadMultiplierMax"] = function(wep,stat) return stat/2 end,
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
