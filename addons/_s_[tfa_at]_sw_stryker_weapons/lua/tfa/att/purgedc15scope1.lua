if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Precision Sight"
ATTACHMENT.ShortName = "REFLEX" --Abbreviation, 5 chars or less please
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { TFA.Attachments.Colors["+"], "Adds a sight to your DC-17", TFA.Attachments.Colors["-"], "30% Lower base Accuracy"}
ATTACHMENT.Icon = "entities/pistolscope.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Spread"] = 0.025,
		["IronAccuracy"] = 0.007,
	},
	["VElements"] = {
		["barrelscope"] = {
			["active"] = true
		},
		["scope"] = {
			["active"] = true
		},
	},
	["WElements"] = {
		["barrelscope"] = {
			["active"] = true
		},
	},
	["IronSightsPos"] = Vector(-5.9, -10, .5),
	["IronSightsAng"] = Vector(0, 0, 0),
}

function ATTACHMENT:Attach(wep)
end

function ATTACHMENT:Detach(wep)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
