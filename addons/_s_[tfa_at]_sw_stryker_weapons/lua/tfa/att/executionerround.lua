if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Mori Rounds"
ATTACHMENT.ShortName = "MORI"
ATTACHMENT.Icon = "entities/orangeenergyblast.png"
ATTACHMENT.Description = { 
    TFA.AttachmentColors["="], "Changes to Mori Rounds", 
	TFA.AttachmentColors["+"], "2x Damage",
    TFA.AttachmentColors["-"], "10 Second Cooldown",
}

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["ClipSize"] = function( wep, stat ) return stat * .1 end,
		["Damage"] = function(wep,stat) return stat*2 end,
	},
	["TracerName"] = "rw_sw_laser_orange",
}

function ATTACHMENT:Attach(wep)
	wep.ImpactEffect = "rw_sw_impact_orange"
	wep:Unload()
end

function ATTACHMENT:Detach(wep)
	wep.ImpactEffect = "rw_sw_impact_red"
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
