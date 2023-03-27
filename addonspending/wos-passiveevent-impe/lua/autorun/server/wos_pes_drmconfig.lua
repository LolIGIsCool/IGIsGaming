--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--


/*
	Please supply your Token and License if you are having
	any issues with the addon!
*/
local Token = "a300c6587a5bee5"
local License = "wOS-29f7f6b8c611981"

----------------------------------------------------------------
local RegistryInt = -1;
 
require( "wos_crypt" )
resource.AddFile("materials/wos/pes/bg.png")
wOS = wOS or {}
wOS.PES = wOS.PES or {}

local reset = GetConVar( "sv_hibernate_think" ):GetString()

local function GetDirectoryPath()
	local results = debug.getinfo( wOS.PES.Initialize, "S" )
	if not results then return end
	local path = results.source
	if not path then return end
	local pos = string.find( path, "/autorun", 2 )
	return string.sub( path, 2, pos )
end

function wOS.PES:Initialize()
	local path = GetDirectoryPath()
	if not path then return end
	print( "[wOS-PES] Successfully found addon path!", path )
	RegistryInt = cwyptOS.SetDirectory( path, reset )
end

function wOS.PES:ServerInclude( filepath )
	if RegistryInt < 0 then return end
	cwyptOS.include( filepath, RegistryInt )
end

hook.Add( "wOS.PES.OnLoaded", "wOS.PES.LoadServerside", function()
	timer.Create( "wOS.PES.Loader", 0.3, 0, function()
		if not cwyptOS.IsReady() then return end
		timer.Destroy( "wOS.PES.Loader" )
		if RegistryInt < 0 then return end
		cwyptOS.Initialize( Token, License, RegistryInt ) 
		hook.Call( "wOS.PES.PostLoaded" )
	end )
end )

wOS.PES:Initialize()

AddCSLuaFile("wos/pes/loader/loader.lua")
include("wos/pes/loader/loader.lua")