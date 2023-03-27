if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Overload Cell"
ATTACHMENT.ShortName = "OvC"
ATTACHMENT.Icon = "entities/atts/dc15sa_overload_cell.png"
ATTACHMENT.Description = {
    TFA.AttachmentColors["+"], "+225% Cell Charge", 
    TFA.AttachmentColors["-"], "-30% Damages", 
}

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["ClipSize"] = function(wep,stat) return stat*2.25 end,
		["Damage"] = function(wep,stat) return stat*0.7 end,
	},
	["KickUp"] = function(wep,stat) return stat*7 end,
	["KickDown"] = function(wep,stat) return stat*7 end,
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
