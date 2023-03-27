if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Ammo Indicator"
ATTACHMENT.ShortName = "AI"
ATTACHMENT.Icon = "entities/att/ammo_indicator.png"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "",
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["base_ind"] = {
			["active"] = true
		},	
		["indic"] = {
			["active"] = true
		},	
		["ammo1"] = {
			["active"] = true
		},	
		["ammo2"] = {
			["active"] = true
		},	
		["ammo3"] = {
			["active"] = true
		},	
		["ammo4"] = {
			["active"] = true
		},	
		["txt_ammo"] = {
			["active"] = true
		},	
		["txt_mod"] = {
			["active"] = true
		},	
	},
	["WElements"] = {
		["indic"] = {
			["active"] = true
		},
	},
}

function ATTACHMENT:Attach(wep)
end

function ATTACHMENT:Detach(wep)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
