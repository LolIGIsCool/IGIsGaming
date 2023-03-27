if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "FN-205 Barrel"
ATTACHMENT.ShortName = "HEAVY" --Abbreviation, 5 chars or less please
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { TFA.Attachments.Colors["+"], "10% Increase to Damage", TFA.Attachments.Colors["-"], "10% Decrease to RPM"}
ATTACHMENT.Icon = "entities/pistolbarrel1.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function( wep, stat ) return stat * 1.1 end,
		["RPM"] = function( wep, stat ) return stat * .9 end,
	},
	["VElements"] = {
		["barrel1"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["barrel1"] = {
			["active"] = true
		},
	},
}

function ATTACHMENT:Attach(wep)
end

function ATTACHMENT:Detach(wep)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
