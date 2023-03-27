AddCSLuaFile( "cl_init.lua" )
 AddCSLuaFile( "shared.lua" )
 include('shared.lua')
 util.AddNetworkString("DeleteThisPls")
 
 SWEP.Weight		= 5
 SWEP.AutoSwitchTo	= true
 SWEP.AutoSwitchFrom	= false