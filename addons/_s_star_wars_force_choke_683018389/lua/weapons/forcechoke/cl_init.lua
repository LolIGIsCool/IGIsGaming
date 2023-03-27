include('shared.lua')


--SWEP STUFF
SWEP.PrintName = "Force Choke"
SWEP.Slot = 1
SWEP.SlotPos = 1
if (file.Exists("../materials/weapons/weapon_mad_deagle.vmt", "GAME")) then
SWEP.WepSelectIcon = surface.GetTextureID("weapons/weapon_mad_deagle")
end