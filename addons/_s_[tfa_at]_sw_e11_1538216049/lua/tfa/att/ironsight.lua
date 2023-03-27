if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Ironsight"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { 
TFA.AttachmentColors["+"], "20% lower base spread", 
TFA.AttachmentColors["-"], "10% higher max spread" }
ATTACHMENT.Icon = "entities/e11r_scope_512.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "IRONSIGHT"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["ironsight"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["ironsight"] = {
			["active"] = true
		}
	},
["Primary"] = {
		["Spread"] = function( wep, val) return val*0.8 end,
		["IronAccuracy"] = function( wep, val) return val*0.8 end,
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
