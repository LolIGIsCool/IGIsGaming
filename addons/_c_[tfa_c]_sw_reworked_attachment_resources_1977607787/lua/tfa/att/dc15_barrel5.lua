if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "A280-CFE Barrel"
ATTACHMENT.ShortName = "B5"
ATTACHMENT.Icon = "entities/att/b5.png"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "", 
    TFA.AttachmentColors["+"], "Better Control", 
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["barrel5"] = {
			["active"] = true
		},	
	},
	["WElements"] = {
		["barrel5"] = {
			["active"] = true
		},
	},
	["Primary"] = {
		["KickUp"] = function(wep,stat) return stat/2 end,
		["KickDown"] = function(wep,stat) return stat/2 end,
		["KickHorizontal"] = function(wep,stat) return stat/2 end,
		["SpreadMultiplierMax"] = function(wep,stat) return stat/2 end,
	},
}

function ATTACHMENT:Attach(wep)
end

function ATTACHMENT:Detach(wep)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
