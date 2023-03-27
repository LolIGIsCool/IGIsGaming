if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Magazine XL"
ATTACHMENT.ShortName = ""
ATTACHMENT.Icon = "entities/att/mxl.png"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "", 
    TFA.AttachmentColors["+"], "+50% Clipsize", 
    TFA.AttachmentColors["-"], "-5% Mouvement", 
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["magxl"] = {
			["active"] = true
		},	
		["mag"] = {
			["active"] = false
		},	
	},
	["WElements"] = {
		["magxl"] = {
			["active"] = true
		},	
		["mag"] = {
			["active"] = false
		},	
	},
	["Primary"] = {
		["ClipSize"] = function(wep,stat) return stat*1.5 end,
	},
    ["MoveSpeed"] = function(wep,stat) return stat*0.95 end,
    ["IronSightsMoveSpeed"] = function(wep,stat) return stat*0.95 end,
}

function ATTACHMENT:Attach(wep)
	wep:Unload()
end

function ATTACHMENT:Detach(wep)
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
