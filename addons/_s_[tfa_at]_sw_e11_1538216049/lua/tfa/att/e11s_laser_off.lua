if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Laser Off"
ATTACHMENT.ShortName = "OFF"
ATTACHMENT.Icon = "entities/e11_laser_off.png"
ATTACHMENT.Description = { 
    TFA.AttachmentColors["="], "Laser Module",
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["laser_beam"] = {
			["active"] = false
		},	
		["laser"] = {
			["active"] = true
		},	
	},
	["WElements"] = {
		["laser_beam"] = {
			["active"] = false
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
