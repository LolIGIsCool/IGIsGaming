ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = '3D Online Radio'
ENT.Category="[HDS|IG] Hideyoshi's Private Entities"
ENT.Author = 'Kinoshita (HDS)'

ENT.Purpose = 'This radio connects to multiple services including Dropbox, YouTube and Soundcloud to stream music directly to Garry\'s Mod'
ENT.Instructions = '[Converter licensed to "INSERTSERVERNAME"]'

ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()

	-- Management Controllers
	self:NetworkVar( "String", 0, "hds_Queue" ) -- The queue of songs to play {JSON String}
	self:NetworkVar( "String", 1, "hds_ownerSteamID" ) -- The queue of songs to play {JSON String}

	-- Global Sound Settings
	self:NetworkVar("Bool", 0, "hds_Loop")

	if SERVER then
		self:Sethds_Queue( "{}" ) -- Set the queue to an empty JSON string

		self:Sethds_Loop(false)
	end

end

--[[
	Autoloader for the music player
]]

local function AddFile( File, directory )
	local prefix = string.lower( string.Left( File, 3 ) )

	if SERVER and prefix == "sv_" then
		include( directory .. File )
		print( "[HDS_MP - AUTOLOAD] SERVER INCLUDE: " .. File )
	elseif prefix == "sh_" then
		if SERVER then
			AddCSLuaFile( directory .. File )
			print( "[HDS_MP - AUTOLOAD] SHARED ADDCS: " .. File )
		end
		include( directory .. File )
		print( "[HDS_MP - AUTOLOAD] SHARED INCLUDE: " .. File )
	elseif prefix == "cl_" then
		if SERVER then
			AddCSLuaFile( directory .. File )
			print( "[HDS_MP - AUTOLOAD] CLIENT ADDCS: " .. File )
		elseif CLIENT then
			include( directory .. File )
			print( "[HDS_MP - AUTOLOAD] CLIENT INCLUDE: " .. File )
		end
	end
end

local function IncludeDir( directory )
	directory = directory .. "/"

	local files, directories = file.Find( directory .. "*", "LUA" )

	for _, v in ipairs( files ) do
		if string.EndsWith( v, ".lua" ) then
			AddFile( v, directory )
		end
	end

	for _, v in ipairs( directories ) do
		print( "[HDS_MP - AUTOLOAD] Directory: " .. v )
		IncludeDir( directory .. v )
	end
end

IncludeDir( "config" )
IncludeDir( "hidehelper" )
IncludeDir( "player" )