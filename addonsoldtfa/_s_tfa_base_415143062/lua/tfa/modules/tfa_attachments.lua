TFA_ATT = {}
TFA.Attachments = {}
TFA.Attachments.Colors = {
	["active"] = Color(252, 151, 50, 255),
	["error"] = Color(225, 0, 0, 255),
	["background"] = Color(15, 15, 15, 64),
	["primary"] = Color(245, 245, 245, 255),
	["secondary"] = Color(153, 253, 220, 255),
	["+"] = Color(128, 255, 128, 255),
	["-"] = Color(255, 128, 128, 255),
	["="] = Color(192, 192, 192, 255)
}
TFA.AttachmentsColors = {
	["active"] = Color(252, 151, 50, 255),
	["error"] = Color(225, 0, 0, 255),
	["background"] = Color(15, 15, 15, 64),
	["primary"] = Color(245, 245, 245, 255),
	["secondary"] = Color(153, 253, 220, 255),
	["+"] = Color(128, 255, 128, 255),
	["-"] = Color(255, 128, 128, 255),
	["="] = Color(192, 192, 192, 255)
}
TFA.AttachmentColors = {
	["active"] = Color(252, 151, 50, 255),
	["error"] = Color(225, 0, 0, 255),
	["background"] = Color(15, 15, 15, 64),
	["primary"] = Color(245, 245, 245, 255),
	["secondary"] = Color(153, 253, 220, 255),
	["+"] = Color(128, 255, 128, 255),
	["-"] = Color(255, 128, 128, 255),
	["="] = Color(192, 192, 192, 255)
}
if not TFA_ATTACHMENTS_ENABLED then return end

function TFARegisterAttachment(att)
	local base

	if att.Base then
		base = TFA_ATT[att.Base]
	else
		base = TFA_ATT["base"]
	end

	if base then
		for k, v in pairs(base) do
			if not att[k] then
				att[k] = v
			end
		end
	end

	TFA_ATT[att.ID or att.Name] = att
end

TFA_ATTACHMENT_PATH = "tfa/att/"
TFA_ATTACHMENT_ISUPDATING = false

function TFAUpdateAttachments()
	TFA_ATT = {}
	TFA_ATTACHMENT_ISUPDATING = true
	local tbl = file.Find(TFA_ATTACHMENT_PATH .. "*base*", "LUA", "namedesc")
	local addtbl = file.Find(TFA_ATTACHMENT_PATH .. "*", "LUA", "namedesc")

	for k, v in ipairs(addtbl) do
		if not string.find(v, "base") then
			table.insert(tbl, #tbl + 1, v)
		end
	end

	addtbl = nil

	for k, v in ipairs(tbl) do
		local id = v
		v = TFA_ATTACHMENT_PATH .. v
		ATTACHMENT = {}
		ATTACHMENT.ID = string.Replace(id, ".lua", "")

		if SERVER then
			AddCSLuaFile(v)
			include(v)
		else
			include(v)
		end

		if ATTACHMENT.Model and type(ATTACHMENT.Model) == "string" and ATTACHMENT.Model ~= "" then
			util.PrecacheModel(ATTACHMENT.Model)
		end

		TFARegisterAttachment(ATTACHMENT)
		ATTACHMENT = nil
	end

	TFA_ATTACHMENT_ISUPDATING = false
end

hook.Add("InitPostEntity", "TFAUpdateAttachmentsIPE", TFAUpdateAttachments)

if TFAUpdateAttachments then
	TFAUpdateAttachments()
end

if SERVER then
	util.AddNetworkString("tfa_att")

	net.Receive("tfa_att", function(length, client)
		if IsValid(client) then
			local wep = client:GetActiveWeapon()

			if IsValid(wep) and wep.Attach and wep.Detach then
				local attach = net.ReadBool()
				local attachment = net.ReadString()

				if attach then
					wep:Attach(attachment, true)
				else
					wep:Detach(attachment, true)
				end
			end
		end
	end)
end

-- Breaks Shit smh
--[[hook.Add("PlayerBindPress", "TFA_Attachment_Binds", function(ply, bind, pressed) 
	local first4 = string.sub(bind, 1, 4)
	if IsValid(ply) and pressed and first4 == "slot" then
		local wep = ply:GetActiveWeapon()

		if IsValid(wep) and wep.CLInspectingProgress and wep.CLInspectingProgress > 0.1 then
			--print(string.sub(bind,5,6))
			local slotstr = string.sub(bind, 5, 6)

			if slotstr and tonumber(slotstr) and wep.Attachments and wep.Attachments[slotnum] and wep.Attachments[slotnum].atts then
				local attbl = wep.Attachments[slotnum]
				local curatt = 0
				local newatt

				for k, v in pairs(attbl.atts) do
					if wep.AttachmentCache[v] and wep.AttachmentCache[v].active then
						curatt = k
					end
				end

				newatt = curatt + 1

				if newatt > #attbl.atts + 1 then
					newatt = 1
				end

				if attbl.atts[curatt] then
					wep:Detach(attbl.atts[curatt])
					net.Start("tfa_att")
					net.WriteBool(false)
					net.WriteString(attbl.atts[curatt])
					net.SendToServer()
				end

				if attbl.atts[newatt] then
					wep:Attach(attbl.atts[newatt])
					net.Start("tfa_att")
					net.WriteBool(true)
					net.WriteString(attbl.atts[newatt])
					net.SendToServer()
				end
			end
		end

		return true
	end
end)]]
