if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Tibanna Cartridge Extended"
ATTACHMENT.ShortName = "TCtdEx"
ATTACHMENT.Icon = "entities/dc17m_magext.png"
ATTACHMENT.Description = {
    TFA.AttachmentColors["+"], "+60% Tibanna Gaz", 
    TFA.AttachmentColors["-"], "-5% Movement Speed", 
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["rifle_mag"] = {["active"] = false},
		["rifle_magext"] = {["active"] = true},
	},
	["WElements"] = {
		["rifle_mag"] = {["active"] = false},
		["rifle_magext"] = {["active"] = true},
	},

	["Primary"] = {
		["ClipSize"] = function(wep,stat) return stat * 1.6 end,
	},
	["MoveSpeed"] = 0.95,
}

function ATTACHMENT:Attach(wep)
	wep:Unload()
	wep:Reload( true )
end

function ATTACHMENT:Detach(wep)
	wep:Unload()
	wep:Reload( true )
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
