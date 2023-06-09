--[[
Only allowed to use in Addons by
​Mattis 'Mattzimann' Krämer
]]--

SWEP.Purpose				= "You can now high five!"
SWEP.Instructions 			= "Click to high five."

SWEP.Category 				= "EGM Animation SWEPs"
SWEP.PrintName				= "High Five"
SWEP.Spawnable				= true
SWEP.deactivateOnMove		= 110
SWEP.Slot							= 5
SWEP.SlotPos						= 100

SWEP.Base = "animation_swep_base"

if CLIENT then
	function SWEP:GetGesture()
		return {
	        ["ValveBiped.Bip01_L_Forearm"] = Angle(25,-65,25),
	        ["ValveBiped.Bip01_L_UpperArm"] = Angle(-70,-180,70),
	    }
	end
end
