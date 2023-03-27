if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Laser On"
ATTACHMENT.ShortName = "ON"
ATTACHMENT.Icon = "entities/e11_laser_on.png"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "", 
    TFA.AttachmentColors["+"], "Better Spread Recovery", 
    TFA.AttachmentColors["+"], "Better IronAccuracy", 
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["laser_beam"] = {
			["active"] = true
		},	
		["laser"] = {
			["active"] = true
		},	
	},
	["WElements"] = {
		["laser_beam"] = {
			["active"] = true
		},
		["laser"] = {
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
