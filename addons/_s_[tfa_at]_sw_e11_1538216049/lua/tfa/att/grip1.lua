if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "E11 GRIP"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { 
TFA.AttachmentColors["+"], "4.5% lower base spread", 
TFA.AttachmentColors["+"], "4.5% increased accuracy", 
}
ATTACHMENT.Icon = "entities/e11_grip_512.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "E-11 Grip"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["grip1"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["e11_grip"] = {
			["active"] = true
		}
	},
["Primary"] = {
		["Spread"] = function( wep, val) return val * .8 end,
		["IronAccuracy"] = function( wep, val) return val * .8 end,
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
