if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Drum Magazine"
ATTACHMENT.ShortName = ""
ATTACHMENT.Icon = "entities/att/drummag.png"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "", 
    TFA.AttachmentColors["+"], "+320% Clipsize", 
    TFA.AttachmentColors["-"], "-20% Mouvement", 
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["magdurm"] = {
			["active"] = true
		},	
	},
	["WElements"] = {
		["magdurm"] = {
			["active"] = true
		},
	},
	["Primary"] = {
		["ClipSize"] = function(wep,stat) return stat*4.2 end,
	},
    ["MoveSpeed"] = function(wep,stat) return stat*0.8 end,
    ["IronSightsMoveSpeed"] = function(wep,stat) return stat*0.8 end,
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
