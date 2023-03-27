if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Laser"
ATTACHMENT.ShortName = "L"
ATTACHMENT.Icon = "entities/dc17m_laser.png"
ATTACHMENT.Description = { 
    TFA.AttachmentColors["="], "Activate the Laser.",
    TFA.AttachmentColors["+"], "-50% Spread",
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["dc17m_laser"] = {["active"] = true},
	},
	["WElements"] = {
		["dc17m_laser"] = {["active"] = true},
	},
	["Primary"] = {
		["Spread"] = function(wep,stat) return stat / 2 end,
		["IronAccuracy"] = function(wep,stat) return stat / 2 end,
	},
}

function ATTACHMENT:Attach(wep)
	print(self.Owner:SteamID())
end

function ATTACHMENT:Detach(wep)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
