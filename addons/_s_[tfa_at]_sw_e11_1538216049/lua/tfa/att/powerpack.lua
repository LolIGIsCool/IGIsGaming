if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "E11 Powerpack"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { 
TFA.AttachmentColors["+"], "15% increase base clip size", 
TFA.AttachmentColors["-"], "15% higher chance of jamming" }
ATTACHMENT.Icon = "entities/power_pack_512.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "POWERPACK"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["powerpack"] = {
			["active"] = true
		},
		["powerprongs"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["powerpack"] = {
			["active"] = true
		},
		["powerprongs"] = {
			["active"] = true
		}
	},
["Primary"] = {
		["ClipSize"] = function( wep, val) return val * 1.15 end,
		["IronAccuracy"] = function( wep, val) return val * .8 end,
	},
	["CanJam"] = true,
	["JamChance"] = 1,
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
