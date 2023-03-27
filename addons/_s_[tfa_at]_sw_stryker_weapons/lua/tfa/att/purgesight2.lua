if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Side Scope"
ATTACHMENT.ShortName = "SCOPE" --Abbreviation, 5 chars or less please
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { TFA.Attachments.Colors["+"], "Switches to your side scope", TFA.Attachments.Colors["-"], "40% Lower base Accuracy"}
ATTACHMENT.Icon = "entities/sidebarrel.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Spread"] = 0.1,
		["IronAccuracy"] = 0.016,
	},
	["IronSightsPos"] = Vector(-6, -13, 2),
	["IronSightsAng"] = Vector(0, 1.5, -45),
}

function ATTACHMENT:Attach(wep)
end

function ATTACHMENT:Detach(wep)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
