if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Heavy Barrel"
ATTACHMENT.ShortName = "HEAT" --Abbreviation, 5 chars or less please
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { TFA.Attachments.Colors["+"], "50% Increase to Damage", TFA.Attachments.Colors["-"], "50% Decrease to RPM"}
ATTACHMENT.Icon = "entities/autobarrel.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function( wep, stat ) return stat * 1.5 end,
		["RPM"] = function( wep, stat ) return stat * 0.5 end,
	},
	["VElements"] = {
		["barrel3"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["barrel3"] = {
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
