if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Magazine XXL"
ATTACHMENT.ShortName = ""
ATTACHMENT.Icon = "entities/att/mxxl.png"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "", 
    TFA.AttachmentColors["+"], "+110% Clipsize", 
    TFA.AttachmentColors["-"], "-10% Mouvement", 
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["magxxl"] = {
			["active"] = true
		},	
		["mag"] = {
			["active"] = false
		},	
	},
	["WElements"] = {
		["magxxl"] = {
			["active"] = true
		},	
		["mag"] = {
			["active"] = false
		},	
	},
	["Primary"] = {
		["ClipSize"] = function(wep,stat) return stat*2.1 end,
	},
    ["MoveSpeed"] = function(wep,stat) return stat*0.9 end,
    ["IronSightsMoveSpeed"] = function(wep,stat) return stat*0.9 end,
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
