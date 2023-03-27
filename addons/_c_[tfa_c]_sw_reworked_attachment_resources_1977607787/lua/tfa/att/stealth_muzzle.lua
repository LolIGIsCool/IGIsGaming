if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Stealth Muzzle"
ATTACHMENT.ShortName = "SM"
ATTACHMENT.Icon = "entities/att/stealth.png"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "", 
    TFA.AttachmentColors["+"], "Better Control", 
    TFA.AttachmentColors["+"], "Silenced Sound", 
}

ATTACHMENT.WeaponTable = {
	["Silenced"] = true,
	["VElements"] = {
		["stealth_barrel"] = {
			["active"] = true
		},	
	},
	["WElements"] = {
		["stealth_barrel"] = {
			["active"] = true
		},
	},
	["Primary"] = {
		["Sound"] = Sound ("w/dc19.wav");
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
