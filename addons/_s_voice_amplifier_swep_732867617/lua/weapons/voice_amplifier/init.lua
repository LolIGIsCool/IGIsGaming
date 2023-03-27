AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

SWEP.AutoSwitchFrom = false

SWEP.ReloadTime = CurTime()
SWEP.ReloadRate = 4

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self.Owner.debriefvmode = false
end

function SWEP:PrimaryAttack()
	if self.Owner.debriefvmode then
		self.Owner.debriefvmode = false
		self.Owner:ChatPrint("Voice Comms: Serverwide Mode activated")
	elseif not self.Owner.debriefvmode then
		self.Owner.debriefvmode = true
		self.Owner:ChatPrint("Voice Comms: Debrief Mode activated")
	end
end

function SWEP:SecondaryAttack()
	if self.Owner.debriefvmode then
		self.Owner.debriefvmode = false
		self.Owner:ChatPrint("Voice Comms: Serverwide Mode activated")
	elseif not self.Owner.debriefvmode then
		self.Owner.debriefvmode = true
		self.Owner:ChatPrint("Voice Comms: Debrief Mode activated")
	end
end

function SWEP:Reload()
end
