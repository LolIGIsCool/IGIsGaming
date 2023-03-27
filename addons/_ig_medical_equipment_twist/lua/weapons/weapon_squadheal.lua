
AddCSLuaFile()

SWEP.ViewModel = Model('models/weapons/c_slam.mdl')
SWEP.UseHands = true
SWEP.WorldModel = ""

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.PrintName	= "Squad Healer"
SWEP.Category	= "IG Medical Equipment"

SWEP.Slot		= 4
SWEP.SlotPos	= 1

SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.Spawnable		= true
SWEP.AdminOnly		= false

if SERVER then
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

function SWEP:Initialize()
	self:SetHoldType('normal')
	if CLIENT then return end
end



function SWEP:Reload() end

function SWEP:PrimaryAttack()
	if CLIENT then return end
	if not timer.Exists(self.Owner:SteamID() .. "SquadHealTimer") then
		if self.Owner:GetNWInt('IG_Squad_Shield_Cooldown') <= 0 then
			self.Owner:SetNWInt('IG_Squad_Shield_Cooldown',20)
			local tr = util.TraceHull({
				start=self.Owner:GetShootPos(),
				endpos=self.Owner:GetShootPos()-Vector(0,0,1024),
				filter=self.Owner,
				mins=self.Owner:OBBMins(),
				maxs=self.Owner:OBBMaxs(),
				mask=MASK_PLAYERSOLID
			})
			if !self.Owner:IsOnGround() or !tr.HitWorld then return end
			local shield = ents.Create('twist_squad_heal')
			shield:SetPos(self.Owner:GetPos())
			shield:Initialize(self.Owner)
			shield:SetOwner(self.Owner)
			shield:Spawn()
			timer.Create("RemoveCoolDown",1,50, function()
				if self.Owner:GetNWInt('IG_Squad_Shield_Cooldown') <= 0 then
					shield:Remove()
					timer.Stop("RemoveCoolDown")
					timer.Create(self.Owner:SteamID() .. "SquadHealTimer", 30, 1, function()
						net.Start("IG_Squad_Heal_ChatPrint")
							net.WriteString("3")
						net.Send(self.Owner)
					end)
				else
					self.Owner:SetNWInt('IG_Squad_Shield_Cooldown',self.Owner:GetNWInt('IG_Squad_Shield_Cooldown')-1)
				end
			end)
		else
			net.Start("IG_Squad_Heal_ChatPrint")
				net.WriteString("1")
			net.Send(self.Owner)
		end
	else
		net.Start("IG_Squad_Heal_ChatPrint")
			net.WriteString("2")
		net.Send(self.Owner)
	end
end

function SWEP:SecondaryAttack() end

function SWEP:Deploy() return true end

function SWEP:ShouldDropOnDie() return false end

function SWEP:OnRemove() end

function SWEP:OnDrop() end


if SERVER then return end

--function SWEP:DrawHUD() end
--function SWEP:PrintWeaponInfo( x, y, alpha ) end

--function SWEP:HUDShouldDraw( name )
	--if ( name == "CHudWeaponSelection" ) then return true end
	--if ( name == "CHudChat" ) then return true end
	--return false
--end