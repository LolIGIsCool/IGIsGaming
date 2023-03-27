
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Base = "fighter_base"
ENT.Type = "vehicle"

ENT.PrintName = "XJ-6 Airspeeder"
ENT.Author = "Liam0102"
ENT.Category = "Star Wars Vehicles: Other"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

ENT.Vehicle = "XJ6";
ENT.EntModel = "models/xj-6/syphadias/xj-6hull.mdl";
ENT.StartHealth = 1000;
list.Set("SWVehicles", ENT.PrintName, ENT);

if SERVER then

ENT.NextUse = {Use = CurTime(),Fire = CurTime()};
ENT.FireSound = Sound("weapons/xwing_shoot.wav");


AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
	local e = ents.Create("xj6");
	e:SetPos(tr.HitPos + Vector(0,0,30));
	e:SetAngles(Angle(0,pl:GetAimVector():Angle().Yaw,0));
	e:Spawn();
	e:Activate();
	return e;
end

function ENT:Initialize()
	self:SetNWInt("Health",self.StartHealth);
	
	self.WeaponLocations = {
		Right = self:GetPos()+self:GetUp()*90+self:GetForward()*200+self:GetRight()*180,
		Left = self:GetPos()+self:GetUp()*90+self:GetForward()*200+self:GetRight()*-180,
	}
	self.WeaponsTable = {};
	self.BoostSpeed = 2250;
	self.ForwardSpeed = 1500;
	self.UpSpeed = 500;
	self.AccelSpeed = 9;
	self.CanBack = true;
	self.HasLookaround = true;
	self.CanShoot = false;
	self.CanStandby = true;
	self.CanStrafe = true;
	
	self.SeatPos = self:GetPos()+self:GetRight()*19+self:GetUp()*-8+self:GetForward()*-5;
	
	self.ExitModifier = {x=-70,y=0,z=5};
	
	self:SpawnSeats();
	self:SpawnInterior();
	self:SpawnMisc();

	self.PilotVisible = true;
	self.PilotPosition = {x=-19,y=-18,z=-8}
	self.PilotAnim = "drive_jeep"
	
	self.TraceFilter = {self,self.Interior,self.Misc,self.Seat}
	self.LandOffset = Vector(0,0,30)
	
	self.BaseClass.Initialize(self);
end

function ENT:SpawnInterior()

	local e = ents.Create("prop_physics");
	e:SetModel("models/xj-6/syphadias/xj-6int.mdl");
	e:SetPos(self:GetPos());
	e:SetAngles(self:GetAngles());
	e:Spawn();
	e:Activate();
	e:SetParent(self);
	e:GetPhysicsObject():EnableCollisions(false);
	self.Interior = e;
	
end

function ENT:SpawnMisc()

	local e = ents.Create("prop_physics");
	e:SetModel("models/xj-6/syphadias/xj-6misc.mdl");
	e:SetPos(self:GetPos());
	e:SetAngles(self:GetAngles());
	e:Spawn();
	e:Activate();
	e:SetParent(self);
	e:GetPhysicsObject():EnableCollisions(false);
	self.Misc = e;
	
end

function ENT:SpawnSeats()

	local e = ents.Create("prop_vehicle_prisoner_pod");
	e:SetPos(self.SeatPos);
	e:SetAngles(self:GetAngles()+Angle(0,-90,0));
	e:SetParent(self);		
	e:SetModel("models/nova/airboat_seat.mdl");
	e:SetRenderMode(RENDERMODE_TRANSALPHA);
	e:SetColor(Color(255,255,255,0));	
	e:Spawn();
	e:Activate();
	e:GetPhysicsObject():EnableMotion(false);
	e:GetPhysicsObject():EnableCollisions(false);
	e.IsXJ6Seat = true;
	e.XJ6 = self;
	
	self.Seat = e;


end

function ENT:Enter(p)

	self.BaseClass.Enter(self,p);
	self.StartPos = self:GetPos();
	self.LandPos = self:GetPos()+Vector(0,0,10);
	
end

hook.Add("PlayerEnteredVehicle","XJ6SeatEnter", function(p,v)
	if(IsValid(v) and IsValid(p)) then
		if(v.IsXJ6Seat) then
			p:SetNetworkedEntity("XJ6Seat",v);
			p:SetNetworkedEntity("XJ6",v:GetParent());
			p:SetNetworkedBool("XJ6Passenger",true);
		end
	end
end);

hook.Add("PlayerLeaveVehicle", "XJ6SeatExit", function(p,v)
	if(IsValid(p) and IsValid(v)) then
		if(v.IsXJ6Seat) then
			local e = v.XJ6;
			p:SetNetworkedEntity("XJ6Seat",NULL);
			p:SetNetworkedEntity("XJ6",NULL);
			p:SetNetworkedBool("XJ6Passenger",false);
			p:SetPos(e:GetPos()+e:GetUp()*5+e:GetRight()*80);
		end
	end
end);

function ENT:Bang()

	local driver = self.Seat:GetPassenger(1);

	self.BaseClass.Bang(self);
	
	if(IsValid(driver)) then
		if(driver:IsPlayer()) then
			driver:Kill();
		end
	end
end

function ENT:Use(p)

	if(not self.Inflight and !p:KeyDown(IN_WALK)) then
		self:Enter(p);
	end
	if(self.Inflight and p != self.Pilot or p:KeyDown(IN_WALK)) then
		p:EnterVehicle(self.Seat);
	end
end

end

if CLIENT then
	ENT.Sounds={
		Engine=Sound("vehicles/landspeeder/t47_fly2.wav"),
	}
	
	ENT.CanFPV = true;

	hook.Add("ScoreboardShow","XJ6ScoreDisable", function()
		local p = LocalPlayer();	
		local Flying = p:GetNWBool("FlyingXJ6");
		if(Flying) then
			return false;
		end
	end)
	
    ENT.ViewDistance = 350;
    ENT.ViewHeight = 100;
    ENT.FPVPos = Vector(-5,19,20);
	
	hook.Add( "ShouldDrawLocalPlayer", "XJ6DrawPlayerModel", function( p )
		local self = p:GetNWEntity("XJ6", NULL);
		local DriverSeat = p:GetNWEntity("XJ6Seat",NULL);
		local PassengerSeat = p:GetNWEntity("PassengerSeat",NULL);
		if(IsValid(self)) then
			if(IsValid(DriverSeat)) then
				if(DriverSeat:GetThirdPersonMode()) then
					return true;
				end
			end
		end
	end);
	
	local function XJ6Reticle()
		
		local p = LocalPlayer();
		local Flying = p:GetNWBool("FlyingXJ6");
		local self = p:GetNWEntity("XJ6");
		
		if(IsValid(self)) then
			SW_HUD_DrawHull(1000);
			SW_HUD_DrawSpeedometer();
		end
	end
	hook.Add("HUDPaint", "XJ6Reticle", XJ6Reticle)
	
end