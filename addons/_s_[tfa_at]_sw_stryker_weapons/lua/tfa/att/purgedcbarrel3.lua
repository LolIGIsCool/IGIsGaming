if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "DC-15A Barrel"
ATTACHMENT.ShortName = "VEGA" --Abbreviation, 5 chars or less please
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { TFA.Attachments.Colors["+"], "Better Control", TFA.Attachments.Colors["-"], "10% Decrease to Damage"}
ATTACHMENT.Icon = "entities/pistolbarrel3.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function( wep, stat ) return stat * .9 end,
		["Spread"] = function( wep, stat ) return stat * .3 end,
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
