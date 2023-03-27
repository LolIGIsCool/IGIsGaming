if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Bipod deployed"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { 
TFA.AttachmentColors["+"], "Significantly increases accuracy.", 
TFA.AttachmentColors["-"], "Renders gunner almost completely immobile.", 

}
ATTACHMENT.Icon = "entities/flashlight_512.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "Bipod deployed"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["bipod_deployed"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["bipod_deployed"] = {
			["active"] = true
		}
	},
["Primary"] = {
		["Spread"] = .010,
		["SpreadRecovery"] = 10,
		["IronAccuracy"] = 0,
		["KickUp"] = .07,
		["KickDown"] = 0,
		["KickHorizontal"] = .08,
	},
["MoveSpeed"] = 0.0001,
["IronSightsMoveSpeed"] = .087,
["IronSightTime"] = 1.3,
["ToCrouchTime"] = 1.5,
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
