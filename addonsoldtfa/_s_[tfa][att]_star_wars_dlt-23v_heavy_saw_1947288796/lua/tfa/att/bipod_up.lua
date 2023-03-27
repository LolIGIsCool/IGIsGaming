if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Bipod Up"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { 
TFA.AttachmentColors["+"], "Decreases vertical recoil.", 
TFA.AttachmentColors["-"], "Increases horizontal recoil.",
}

ATTACHMENT.Icon = "entities/flashlight_512.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "Bipod"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["bipod_up"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["bipod_up"] = {
			["active"] = true
		}
	},
["Primary"] = {
		["KickUp"] = .167,
		["KickHorizontal"] = .1,
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
