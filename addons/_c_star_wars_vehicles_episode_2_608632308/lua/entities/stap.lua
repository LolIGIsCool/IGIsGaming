ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Base = "speeder_base"
ENT.Type = "vehicle"

ENT.PrintName = "STAP Speeder"
ENT.Author = "Liam0102"
ENT.Category = "Star Wars Vehicles: CIS"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

ENT.Vehicle = "STAP";
ENT.EntModel = "models/stap/stap1.mdl";
ENT.StartHealth = 1000;
list.Set("SWVehicles", ENT.PrintName, ENT);

if SERVER then

ENT.NextUse = {Use = CurTime(),Fire = CurTime()};
ENT.FireSound = Sound("weapons/xwing_shoot.wav");


AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
	local e = ents.Create("stap");
	e:SetPos(tr.HitPos + Vector(0,0,10));
	e:SetAngles(Angle(0,pl:GetAimVector():Angle().Yaw+180,0));
	e:Spawn();
	e:Activate();
	return e;
end

function ENT:Initialize()
	self.SeatClass = "phx_seat3";
	self.BaseClass.Initialize(self);
	local driverPos = self:GetPos()+self:GetUp()*47.5+self:GetForward()*40;
	local driverAng = self:GetAngles()+Angle(0,90,0);
	self:SpawnChairs(driverPos,driverAng,false)
	
	self.ForwardSpeed = -500;
	self.BoostSpeed = -750
	self.AccelSpeed = 8;
	self.HoverMod = 25;
	self.StartHover = 20;
	self.WeaponLocations = {
		self:GetPos()+self:GetUp()*75+self:GetForward()*-45+self:GetRight()*10,
		self:GetPos()+self:GetUp()*75+self:GetForward()*-45+self:GetRight()*-10,
	}
	self.WeaponDir = self:GetAngles():Forward()*-1;
	self:SpawnWeapons();
	self.StandbyHoverAmount = 0;
	self.Bullet = CreateBulletStructure(60,"red");
	self.CanShoot = true;
	
end

function ENT:OnTakeDamage(dmg) --########## Shuttle's aren't invincible are they? @RononDex

	local health=self:GetNetworkedInt("Health")-(dmg:GetDamage()/2)

	self:SetNWInt("Health",health);
	
	if(health<100) then
		self.CriticalDamage = true;
		self:SetNWBool("CriticalDamage",true);
	end
	
	
	if((health)<=0) then
		self:Bang() -- Go boom
	end
end


local ZAxis = Vector(0,0,1);

function ENT:PhysicsSimulate( phys, deltatime )
	self.BackPos = self:GetPos()+self:GetUp()*20
	self.FrontPos = self:GetPos()+self:GetUp()*10+self:GetForward()*-30
	self.MiddlePos = self:GetPos()+self:GetUp()*10+self:GetForward()*-5;
	if(self.Inflight) then
		local UP = ZAxis;
		self.RightDir = self.Entity:GetForward():Cross(UP):GetNormalized();
		self.FWDDir = self.Entity:GetForward();	
		
		self:RunTraces();

		self.ExtraRoll = Angle(0,0,self.YawAccel / 2);
		if(!self.WaterTrace.Hit) then
			if(self.FrontTrace.HitPos.z >= self.BackTrace.HitPos.z) then
				self.PitchMod = Angle(math.Clamp((self.BackTrace.HitPos.z - self.FrontTrace.HitPos.z),-45,45)/2*-1,0,0)
			else
				self.PitchMod = Angle(math.Clamp(-(self.FrontTrace.HitPos.z - self.BackTrace.HitPos.z),-45,45)/2*-1,0,0)
			end
		end
	end

	
	self.BaseClass.PhysicsSimulate(self,phys,deltatime);
	

end

end

if CLIENT then
	ENT.Sounds={
		Engine=Sound("vehicles/stap/stap_engine.wav"),
	}
	
	local Health = 0;
	function ENT:Think()
		self.BaseClass.Think(self);
		local p = LocalPlayer();
		local Flying = p:GetNWBool("Flying"..self.Vehicle);
		if(Flying) then
			Health = self:GetNWInt("Health");
		end
		
	end
    ENT.HasCustomCalcView = true;
	local View = {}
	function CalcView()
		
		local p = LocalPlayer();
		local self = p:GetNWEntity("STAP", NULL)
		local DriverSeat = p:GetNWEntity("DriverSeat",NULL);

		if(IsValid(self)) then

			if(IsValid(DriverSeat)) then
				if(DriverSeat:GetThirdPersonMode()) then
					local pos = self:GetPos()+self:GetForward()*270+self:GetUp()*100;
					//local face = self:GetAngles() + Angle(0,180,0);
					local face = ((self:GetPos() + Vector(0,0,100))- pos):Angle();
						View.origin = pos;
						View.angles = face;
					return View;
				end
			end

		end
	end
	hook.Add("CalcView", "STAPView", CalcView)

	
	hook.Add( "ShouldDrawLocalPlayer", "STAPDrawPlayerModel", function( p )
		local self = p:GetNWEntity("STAP", NULL);
		local DriverSeat = p:GetNWEntity("DriverSeat",NULL);
		local PassengerSeat = p:GetNWEntity("PassengerSeat",NULL);
		if(IsValid(self)) then
			if(IsValid(DriverSeat)) then
				if(DriverSeat:GetThirdPersonMode()) then
					return true;
				end
			elseif(IsValid(PassengerSeat)) then
				if(PassengerSeat:GetThirdPersonMode()) then
					return true;
				end
			end
		end
	end);
	
	function STAPReticle()
	
		local p = LocalPlayer();
		local Flying = p:GetNWBool("FlyingSTAP");
		local self = p:GetNWEntity("STAP");
		if(Flying and IsValid(self)) then
			local WeaponsPos = {self:GetPos()};
			
			SW_Speeder_Reticles(self,WeaponsPos)
			SW_Speeder_DrawHull(1000)
			SW_Speeder_DrawSpeedometer()
		end
	end
	hook.Add("HUDPaint", "STAPReticle", STAPReticle)
	
	
end