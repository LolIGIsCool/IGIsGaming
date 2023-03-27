if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Range Finder"
ATTACHMENT.ShortName = "RF"
ATTACHMENT.Icon = "entities/att/rangefinder.png"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "", 
    --TFA.AttachmentColors["+"], "", 
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["rangefinder"] = {
			["active"] = true
		},	
		["rangefinder_scope"] = {
			["active"] = true
		},	
	},
	["WElements"] = {
		["rangefinder"] = {
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
