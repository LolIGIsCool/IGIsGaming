zbl = zbl or {}
zbl.f = zbl.f or {}

local function NicePrint(txt)
	if SERVER then
		MsgC(Color(98, 141, 193), txt .. "\n")
	else
		MsgC(Color(193, 193, 98), txt .. "\n")
	end
end

local IgnoreFileTable = {}
function zbl.f.PreLoadFile(fdir,afile,info)
	IgnoreFileTable[afile] = true
	zbl.f.LoadFile(fdir,afile,info)
end

function zbl.f.LoadFile(fdir,afile,info)

	if info then
		local nfo = "// [ Initialize ]: " .. afile .. string.rep( " ", 25 - afile:len() ) .. "//"
		NicePrint(nfo)
	end

	if SERVER then
		AddCSLuaFile(fdir .. afile)
	end

	include(fdir .. afile)
end

function zbl.f.LoadAllFiles(fdir)
	local files, dirs = file.Find(fdir .. "*", "LUA")

	for _, afile in ipairs(files) do
		if string.match(afile, ".lua") and not IgnoreFileTable[afile] then
			zbl.f.LoadFile(fdir,afile,true)
		end
	end

	for _, dir in ipairs(dirs) do
		zbl.f.LoadAllFiles(fdir .. dir .. "/")
	end
end

// Initializes the Script
function zbl.f.Initialize()
	NicePrint("//////////////////////////////////////////////")
	NicePrint("/////////////// Zeros GenLab /////////////////")
	NicePrint("//////////////////////////////////////////////")

	zbl.f.PreLoadFile("zblood/sh/","zbl_materials.lua",true)
	zbl.f.PreLoadFile("zblood/sh/","zbl_quests_sh.lua",true)
	zbl.f.PreLoadFile("zblood/sh/","zbl_config.lua",true)

	zbl.f.LoadAllFiles("zbl_languages/")


	zbl.f.LoadAllFiles("zblood/sh/")
	if SERVER then
		zbl.f.LoadAllFiles("zblood/sv/")
	end
	zbl.f.LoadAllFiles("zblood/cl/")

	NicePrint("//////////////////////////////////////////////")
	NicePrint("//////////////////////////////////////////////")
end

if SERVER then
	hook.Add("PostGamemodeLoaded", "zbl_Initialize_sv", function()
		zbl.f.Initialize()
	end)
else


	// This needs to be called instantly on client since client settings wont work otherwhise
	zbl.f.PreLoadFile("zblood/sh/","zbl_materials.lua",false)
	zbl.f.PreLoadFile("zblood/cl/","zbl_fonts.lua",false)
	zbl.f.PreLoadFile("zblood/cl/","zbl_settings_menu.lua",false)

	hook.Add("InitPostEntity", "zbl_Initialize_cl", function()
		zbl.f.Initialize()
	end)
end


if GAMEMODE then
	zbl.f.Initialize()
end
