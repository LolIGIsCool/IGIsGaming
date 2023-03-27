-- developed for gmod.store
-- from incredible-gmod.ru with love <3
-- https://www.gmodstore.com/market/view/gestures

local MaterialWhite = Material("debug/debugvertexcolor")
local WebMaterialCache = {}

local Material = Material
local function _Material(path)
	return Material("data/".. path, "smooth mips")
end

file.CreateDir("inc_gestures")

function INC_GESTURES:DownloadMaterial(url, cback, cback_err)
	local uid = util.CRC(url)

	if WebMaterialCache[uid] then return cback(WebMaterialCache[uid]) end

	local path = "inc_gestures/".. uid .."_".. url:match("([^/]+)$")

	if file.Exists(path, "DATA") then
		WebMaterialCache[uid] = _Material(path)
		return cback(WebMaterialCache[uid])
	end

	http.Fetch(url, function(body)
		if not body or body == "" then return end

		file.Write(path, body)
		WebMaterialCache[uid] = _Material(path)
		cback(WebMaterialCache[uid])
	end, cback_err)
end

local allowed_sound_ext = {
	[".mp3"] = ".mp3",
	[".ogg"] = ".ogg",
	[".wav"] = ".wav"
}

function INC_GESTURES:DownloadSound(url, cback)
	local uid = util.CRC(url)
	local path = "inc_gestures/".. uid .."_".. url:match("([^/]+)$"):match("(.+)%..+"):gsub("%p", "") .. (allowed_sound_ext[url:match("^.+(%..+)$")] or ".ogg")

	if file.Exists(path, "DATA") then
		return cback(path)
	end

	http.Fetch(url, function(body)
		if not body or body == "" then return end

		file.Write(path, body)
		cback(path)
	end)
end

function INC_GESTURES:PrepareJob()
end

function string.IsURL(str)
	return str:find("https?://[%w-_%.%?%.:/%+=&]+") and true or false
end

hook.Add("IncGestures/ConfigLoaded", "LuaRefresh/Fonts", function()
	for name, data in pairs(INC_GESTURES.Fonts) do
		data.extended = true
		surface.CreateFont(name, data)
	end
end)

INC_GESTURES:DownloadMaterial("https://incredible-gmod.ru/gmodstore/gestures/content/vendor_spawnmenu_icon.png", function(mat)
	mat:SetInt("$flags", bit.bor(mat:GetInt("$flags"), 32768))
	INC_GESTURES.ToolBackground = mat
end) -- prepare spawnmenu icon & tool background

INC_GESTURES:DownloadMaterial("https://incredible-gmod.ru/gmodstore/gestures/content/sound.png", function(mat)
	INC_GESTURES.SoundMaterial = mat
end)