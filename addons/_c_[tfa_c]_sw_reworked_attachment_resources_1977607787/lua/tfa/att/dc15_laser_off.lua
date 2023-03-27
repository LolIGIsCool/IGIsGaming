if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Laser OFF"
ATTACHMENT.ShortName = "L-OFF"
ATTACHMENT.Icon = "entities/att/laser_off.png"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "",
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
