if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Holosight"
ATTACHMENT.ShortName = "H"
ATTACHMENT.Icon = "entities/atts/dc15sa_holo.png"
ATTACHMENT.Description = {
    TFA.AttachmentColors["="], "Display informations",
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["holosight"] = {["active"] = true},	
		["dc15sa_iron"] = {["active"] = false},	
		["txt_ammo"] = {["active"] = true},	
		["txt_range"] = {["active"] = true},		
		["txt_mod"] = {["active"] = true},
	},
	["WElements"] = {
		["holosight"] = {["active"] = true},	
		["dc15sa_iron"] = {["active"] = false},	
		["txt_ammo"] = {["active"] = true},	
		["txt_range"] = {["active"] = true},	
		["txt_mod"] = {["active"] = true},	
	},
	["IronSightsPos"] = function( wep, val ) return wep.HoloSightsPos or val, true end,
	["IronInSound"] = Sound ("w/irons/dc15sa_iron_in.wav"),
	["IronOutSound"] = Sound ("w/irons/dc15sa_iron_out.wav"),
}

function ATTACHMENT:Attach(wep)
end

function ATTACHMENT:Detach(wep)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
