if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Extended Magazine"
ATTACHMENT.ShortName = "EXTEND" --Abbreviation, 5 chars or less please
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { TFA.Attachments.Colors["+"], "Adds a 100 round clip", TFA.Attachments.Colors["-"], "50% worse base Accuracy"}
ATTACHMENT.Icon = "entities/asf12sa.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Spread"] = 0.15,
		["IronAccuracy"] = 0.025,
		["ClipSize"] = 100,
	},
	["VElements"] = {
		["magazine1"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["magazine1"] = {
			["active"] = true
		},
	},
}

function ATTACHMENT:Attach(wep)
	wep:Unload()
end

function ATTACHMENT:Detach(wep)
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
