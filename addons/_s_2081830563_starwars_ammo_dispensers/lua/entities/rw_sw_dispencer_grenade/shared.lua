ENT.Type = "anim"
ENT.Base = "base_gmodentity"

local dispencer_health = GetConVar("rw_sw_dispencer_health"):GetInt()
ENT.BaseHealth = dispencer_health

ENT.PrintName		= "Ammo Dispencer (Grenades)"
ENT.Author			= "ChanceSphere574"
ENT.Category		= "StarWars Reworked Armory"
ENT.Spawnable 		= true
ENT.AdminSpawnable	= true