if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "E11 Caster"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { 
--TFA.AttachmentColors["+"], "", 
--TFA.AttachmentColors["+"], "", 
}
ATTACHMENT.Icon = "entities/e11caster.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "CASTR"

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["e11caster"] = {
			["active"] = true
		}
	},
	["WElements"] = {
		["e11caster"] = {
			["active"] = true
		}
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end

-- add the caster code here ^^
