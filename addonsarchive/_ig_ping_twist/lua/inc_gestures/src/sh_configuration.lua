-- developed for gmod.store
-- from incredible-gmod.ru with love <3
-- https://www.gmodstore.com/market/view/gestures

local MaterialWhite = CLIENT and Material("debug/debugvertexcolor")

function INC_GESTURES:Add(name, data)
	data.Name = name

	if CLIENT then
		if string.IsURL(data.Icon) then
			data.Material = MaterialWhite
			self:DownloadMaterial(data.Icon, function(mat)
				data.Material = mat
			end)
		else
			data.Material = Material(data.Icon or "error", "smooth mips")
		end

		if data.Sound and string.IsURL(data.Sound) then
			INC_GESTURES:DownloadSound(data.Sound, function(path)
				data.SoundPath = "data/".. path
			end)
		elseif data.Sound then
			local path = "sound/".. data.Sound
			if data.Sound:sub(1, 6) ~= "sound/" and file.Exists(path, "GAME") then
				data.SoundPath = path
			elseif file.Exists(data.Sound, "GAME") then
				data.SoundPath = data.Sound
			end
		end

		if data.SoundVolume and tonumber(data.SoundVolume) then
			data.SoundVolume = tonumber(data.SoundVolume)
		end
	end

	data.id = table.insert(self.Sections, data)
	return data.id
end


hook.Add("IncGestures/ConfigIncluded", "LuaRefresh", function()
	INC_GESTURES.Sections = {}
end)

hook.Add("IncGestures/ConfigLoaded", "LuaRefresh", function()
	local themes = {}

	for i, fname in pairs(file.Find("inc_gestures/themes/*.lua", "LUA")) do
		local path = "inc_gestures/themes/".. fname
		AddCSLuaFile(path)
		if CLIENT then
			themes[fname:match("(.+)%..+")] = include(path)
		end
	end

	INC_GESTURES.Colors = themes[INC_GESTURES.Theme] or themes.regular

	local langs = {}

	for i, fname in pairs(file.Find("inc_gestures/langs/*.lua", "LUA")) do
		local path = "inc_gestures/langs/".. fname
		AddCSLuaFile(path)
		if CLIENT then
			langs[fname:match("(.+)%..+")] = include(path)
		end
	end

	INC_GESTURES._Lang = langs[INC_GESTURES.Lang] or langs.en

	if CLIENT then
		language.Add("tool.inc_gestures.desc", INC_GESTURES._Lang.ToolDescription or "ToolDescription translation not set!")
		language.Add("Tool.inc_gestures.left", INC_GESTURES._Lang.ToolLeftClick or "ToolLeftClick translation not set!")
		language.Add("Tool.inc_gestures.right", INC_GESTURES._Lang.ToolRightClick or "ToolRightClick translation not set!")
	end
end)