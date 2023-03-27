
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Base = "fighter_base"
ENT.Type = "vehicle"

ENT.PrintName = "Storm IV Cloud Car"
ENT.Author = "Liam0102"
ENT.Category = "Star Wars Vehicles: Other"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

ENT.EntModel = "models/stormiv/stormiv1.mdl"
ENT.Vehicle = "Storm"
ENT.StartHealth = 1000;
ENT.Allegiance = "Neutral";
list.Set("SWVehicles", ENT.PrintName, ENT);

if SERVER then

ENT.FireSound = Sound("weapons/xwing_shoot.wav");
ENT.NextUse = {Wings = CurTime(),Use = CurTime(),Fire = CurTime(),};


AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
	local e = ents.Create("storm");
	e:SetPos(tr.HitPos + Vector(0,0,10));
	e:SetAngles(Angle(0,pl:GetAimVector():Angle().Yaw,0));
	e:Spawn();
	e:Activate();
	return e;
end

function ENT:Initialize()


	self:SetNWInt("Health",self.StartHealth);
	
	self.WeaponLocations = {
		Left = self:GetPos()+self:GetForward()*120+self:GetRight()*-90+self:GetUp()*55,
		Right = self:GetPos()+self:GetForward()*120+self:GetRight()*100+self:GetUp()*55,
	}
	self.WeaponsTable = {};
	self.BoostSpeed = 2750;
	self.ForwardSpeed = 1500;
	self.UpSpeed = 700;
	self.AccelSpeed = 8;
	self.CanStandby = true;
	self.CanBack = true;
	self.CanRoll = false;
	self.CanStrafe = true;
	self.Cooldown = 2;
	self.CanShoot = true;
	self.Bullet = CreateBulletStructure(75,"red");
	self.FireDelay = 0.2;
	self.AlternateFire = true;
	self.FireGroup = {"Left","Right",};

	//self:TestLoc(self:GetPos()+self:GetForward()*120+self:GetRight()*-90+self:GetUp()*55);
	self.ExitModifier = {x=0,y=225,z=100};
	
	self.BaseClass.Initialize(self);
end

end

if CLIENT then
	
	ENT.CanFPV = false;
	ENT.Sounds={
		Engine=Sound("ambient/atmosphere/ambience_base.wav"),
	}
	
    ENT.ViewDistance = 700;
    ENT.ViewHeight = 200;
	
	function StormReticle()
		
		local p = LocalPlayer();
		local Flying = p:GetNWBool("FlyingStorm");
		local self = p:GetNWEntity("Storm");
		if(Flying and IsValid(self)) then
			SW_HUD_DrawHull(1000);
			SW_WeaponReticles(self);
			SW_HUD_DrawOverheating(self);

			SW_HUD_Compass(self);
			SW_HUD_DrawSpeedometer();
		end
	end
	hook.Add("HUDPaint", "StormReticle", StormReticle)

end