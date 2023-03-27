if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Holosights"
ATTACHMENT.ShortName = "H"
ATTACHMENT.Icon = "entities/dc17m_holosight.png"
ATTACHMENT.Description = { 
    TFA.AttachmentColors["="], "Add a Holographic Ironsight.", 
    TFA.AttachmentColors["+"], "+20% View Speed",
    TFA.AttachmentColors["+"], "-15% Spread Increment",
    TFA.AttachmentColors["+"], "+15% Spread Recovery",
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["dc17m_holosight"] = {["active"] = true},
		["dc17m_holosight_holo"] = {["active"] = true},
	},
	["WElements"] = {
		["dc17m_holosight"] = {["active"] = true},
		["dc17m_holosight_holo"] = {["active"] = true},
	},
	["Primary"] = {
		["SpreadIncrement"] = function(wep,stat) return stat/1.15 end,
		["SpreadRecovery"] = function(wep,stat) return stat*1.15 end,
	},
	["BlowbackVector"] = Vector(0,-0.75,-0.01),
	["IronSightsPos"] = function( wep, val ) return wep.ScopeHoloPos or val, true end,
	["IronSightsAng"] = function( wep, val ) return wep.ScopeHoloAng or val, true end,
	["IronSightTime"] = function( wep, val ) return val * 0.8 end,
	["IronSightMoveSpeed"] = function(stat) return stat * 1.5 end,
}

function ATTACHMENT:Attach(wep)
end

function ATTACHMENT:Detach(wep)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
