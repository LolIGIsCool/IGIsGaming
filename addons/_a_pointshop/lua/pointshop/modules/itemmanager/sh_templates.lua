local ps = SH_POINTSHOP
local easynet = ps.easynet
local MODULE = MODULE or ps.Modules.itemmanager

-- Load templates
local path = "pointshop/modules/itemmanager/templates"
function MODULE:LoadTemplates()
	self.Templates = {}

	local fi = file.Find(path .. "/*", "LUA")
	for _, tmpf in pairs (fi) do
		AddCSLuaFile(path .. "/" .. tmpf)
		include(path .. "/" .. tmpf)
	end
end

function MODULE:ValidateInput(inpts, tmpid)
	local template = self.Templates[tmpid]
	if (!template) then
		return false, "inexisting template"
	end

	if (template.Validators) then
		for id, valfnc in SortedPairs (template.Validators) do
			if (!inpts[id]) then
				return false, "im_missing_or_invalid_info", id
			end

			local ok, why, replace = valfnc(inpts[id])
			if (!ok) then
				return false, why or "im_missing_or_invalid_info", id
			end

			if (replace) then
				inpts[id] = replace
			end
		end
	end

	return true
end

local replacements_to = {
	["\\"] = "\\\\",
	["\""] = "\\\"",
	["\'"] = "\\\'"
}

local replacements_from = {
	["\\\\"] = "\\",
	["\\\""] = "\"",
	["\\\'"] = "\'",
}

function MODULE:Sanitize(s)
	return s:gsub(".", replacements_to)
end

function MODULE:Unsanitize(s)
	return s:gsub(".", replacements_from)
end

MODULE:LoadTemplates()