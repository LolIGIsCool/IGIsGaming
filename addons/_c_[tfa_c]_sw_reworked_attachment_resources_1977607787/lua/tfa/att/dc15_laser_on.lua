if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Laser ON"
ATTACHMENT.ShortName = "L-ON"
ATTACHMENT.Icon = "entities/att/laser.png"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "", 
    TFA.AttachmentColors["+"], "Better Spread Recovery", 
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
	["Primary"] = {
		["SpreadIncrement"] = function(wep,stat) return stat/1.5 end,
		["SpreadRecovery"] = function(wep,stat) return stat*1.5 end,
	},
}

function ATTACHMENT:Attach(wep)
end

function ATTACHMENT:Detach(wep)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
