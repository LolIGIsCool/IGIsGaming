--                                                  --
--        Hideyoshi's Revamped Music Player         --
--                                                  --

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName= "Hideyoshi's [SWRP] Music Revamped Player v3"
ENT.Category="[HDS|IG] Hideyoshi's Private Entities"

ENT.Author= "Hideyoshi"
ENT.Contact= "Hideyoshi#0014"
ENT.Purpose= "To Play Star Wars Music"

ENT.Spawnable = true
ENT.AdminSpawnable = true
include('hds_mp/sh_playlist.lua')

--[[
    Network Entity Values
]]--
function ENT:SetupDataTables()
    self:NetworkVar( "String", 1, "ent_plyspawner")
    self:NetworkVar( "String", 2, "queueConstruct")
end


--[[function ENT:SetupDataTables()

    self:NetworkVar( "String", 1, "CurrentSongName" )
    self:NetworkVar( "String", 2, "Artist" )
    self:NetworkVar( "String", 3, "Source")
    self:NetworkVar( "String", 4, "CurrentSongMP3" )

    self:NetworkVar( "Int", 6, "SongVolume" )
    self:NetworkVar( "Int", 7, "HideyoshiSoundDistance" )
    self:NetworkVar( "Int", 8, "Hideyoshi_RandomNumber" )
    if ( SERVER ) then
        self:SetSongVolume(100)
    end
end]]--