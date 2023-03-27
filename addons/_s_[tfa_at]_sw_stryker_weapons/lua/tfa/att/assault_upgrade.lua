if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Reflex Sight"
ATTACHMENT.ShortName = "REFLEX" --Abbreviation, 5 chars or less please
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { TFA.Attachments.Colors["+"], "Adds a sight to your DC-15", TFA.Attachments.Colors["-"], "30% better base Accuracy"}
ATTACHMENT.Icon = "entities/159808368697939890.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Spread"] = 0.1,
		["IronAccuracy"] = 0.017,
	},
	["VElements"] = {
		["dc15a"] = {
			["bodygroup"] = {[1] = 0},
		},
		["scope"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["dc15a"] = {
			["bodygroup"] = {[1] = 0},
		},
	},
	["IronSightsPos"] = Vector(-4.4, 0, 1),
	["IronSightsAng"] = Vector(0, 1.2, 0),
}

function ATTACHMENT:Attach(wep)
end

function ATTACHMENT:Detach(wep)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
