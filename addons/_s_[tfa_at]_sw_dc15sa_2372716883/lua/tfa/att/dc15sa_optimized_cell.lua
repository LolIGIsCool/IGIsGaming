if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Optimized Cell"
ATTACHMENT.ShortName = "OpC"
ATTACHMENT.Icon = "entities/atts/dc15sa_optimized_cell.png"
ATTACHMENT.Description = { 
    TFA.AttachmentColors["+"], "+50% Cell Charge", 
    TFA.AttachmentColors["-"], "-15% Damages", 
}

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["ClipSize"] = function(wep,stat) return stat*1.5 end,
		["Damage"] = function(wep,stat) return stat*0.85 end,
	},
	["KickUp"] = function(wep,stat) return stat*3 end,
	["KickDown"] = function(wep,stat) return stat*3 end,
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
