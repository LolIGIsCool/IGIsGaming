if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Accelerator Barrel"
ATTACHMENT.ShortName = "HEAT" --Abbreviation, 5 chars or less please
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { TFA.Attachments.Colors["+"], "30% Increase to RPM", TFA.Attachments.Colors["-"], "30% Decrease to Damage"}
ATTACHMENT.Icon = "entities/autobarrel.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function( wep, stat ) return stat * .7 end,
		["RPM"] = function( wep, stat ) return stat * 1.3 end,
	},
	["VElements"] = {
		["barrel2"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["barrel2"] = {
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
