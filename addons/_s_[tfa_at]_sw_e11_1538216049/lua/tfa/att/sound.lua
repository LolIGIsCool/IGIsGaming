if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "E11 OG Sound"
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { 
TFA.AttachmentColors["+"], "Overlays the current sound with the OG BF2 sound.", 
}
ATTACHMENT.Icon = "entities/dc17m_laser.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.ShortName = "ogs"

ATTACHMENT.WeaponTable = {

["Primary"] = {
		--["Sound"] = Sound ("weapons/bf3/wpn_imp_blaster_fire.wav");
		["Sound"] = "weapons/bf3/e11_a.wav",
	},
}

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
