ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Base = "fighter_base"
ENT.Type = "vehicle"

ENT.PrintName = "Sentinel-Class Landing Craft"
ENT.Author = "Liam0102"
ENT.Category = "Star Wars Vehicles: Empire"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

ENT.EntModel = "models/sentinel_land.mdl";
ENT.FlyModel = "models/sl/sl1.mdl";
ENT.Vehicle = "Sentinel"
ENT.Allegiance = "Empire";
ENT.StartHealth = 5000;
list.Set("SWVehicles", ENT.PrintName, ENT);

if SERVER then

ENT.FireSound = Sound("weapons/tie_shoot.wav");
ENT.NextUse = {Wings = CurTime(),Use = CurTime(),Fire = CurTime(),Doors = CurTime(),};


AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
	local e = ents.Create("sentinel");
	e:SetPos(tr.HitPos + Vector(0,0,10));
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
	self.BoostSpeed = 1750;
	self.ForwardSpeed = 1000;
	self.UpSpeed = 500;
	self.AccelSpeed = 7;
	self.CanBack = true;
	self.HasLookaround = true;
	self.Cooldown = 2;
	self.CanShoot = true;
	self.Bullet = CreateBulletStructure(50,"green");
	
	self.HasWings = true;

    self.HasSeats = true;
	self.SeatPos = {
        {
            self:GetPos()+self:GetForward()*370+self:GetUp()*140+self:GetRight()*-23,
            self:GetAngles()+Angle(0,-90,0),
            Vector(-490,0,90),
        }
    };
	
	self.ExitModifier = {x=300,y=0,z=50};


	self.PilotVisible = true;
	self.PilotPosition = {x=23,y=370,z=90}

	self.BaseClass.Initialize(self);
	
	self:SetModelScale(0.65);
end


function ENT:ToggleModels(fly)

	if(!fly) then
		self:SetModel(self.EntModel);
		self:SetModelScale(0.65);
		//self:PhysicsInit(6);
	else
		self:SetModel(self.FlyModel);
		self:SetModelScale(1);
		self:SetPos(self:GetPos()+Vector(0,0,10));
		//self:PhysicsInit(6);
	end
end

function ENT:Enter(p)
	self:ToggleModels(true);
	self.BaseClass.Enter(self,p);
end

function ENT:Exit()
	self:ToggleModels(false);
	self.BaseClass.Exit(self);
end


end

if CLIENT then


	ENT.EnginePos = {}
	ENT.CanFPV = true;
    ENT.ViewDistance = 800;
    ENT.ViewHeight = 350;
    ENT.FPVPos = Vector(370,-20,117.5);
	ENT.Sounds={
		//Engine=Sound("ambient/atmosphere/ambience_base.wav"),
		Engine=Sound("vehicles/laat/laat_fly2.wav"),
	}
	
	function ENT:FlightEffects()
		local normal = (self:GetForward() * -1):GetNormalized()
		local roll = math.Rand(-90,90)
		local p = LocalPlayer()		
		local FWD = self:GetForward();
		local id = self:EntIndex();

		self.EnginePos = {
			self:GetPos()+self:GetForward()*-445+self:GetUp()*130+self:GetRight()*97.5,
			self:GetPos()+self:GetForward()*-445+self:GetUp()*130+self:GetRight()*-97.5,
		}
		
		for k,v in pairs(self.EnginePos) do
			
			local blue = self.FXEmitter:Add("sprites/bluecore",v)
			blue:SetVelocity(normal)
			blue:SetDieTime(FrameTime()*1.25)
			blue:SetStartAlpha(255)
			blue:SetEndAlpha(200)
			blue:SetStartSize(35)
			blue:SetEndSize(30)
			blue:SetRoll(roll)
			blue:SetColor(255,255,255)
			
			local dynlight = DynamicLight(id + 4096 * k);
			dynlight.Pos = v+FWD*-5;
			dynlight.Brightness = 5;
			dynlight.Size = 150;
			dynlight.Decay = 1024;
			dynlight.R = 100;
			dynlight.G = 100;
			dynlight.B = 255;
			dynlight.DieTime = CurTime()+1;
			
		end
	
	end

	local FPV = false;
	local Health = 0;
	local Overheat = 0;
	local Overheated = false;
	ENT.NextView = CurTime();
	ENT.NextPV = CurTime();
	function ENT:Think()
		//self.BaseClass.Think(self);
		local p = LocalPlayer();
		local Flying = self:GetNWBool("Flying"..self.Vehicle);
		local IsFlying = p:GetNWBool("Flying"..self.Vehicle);		
		local IsDriver = p:GetNWEntity(self.Vehicle) == self.Entity;	
		
		if(Flying) then
			self:FlightEffects();
		end
		
		if(IsFlying and IsDriver) then
			Health = self:GetNWInt("Health");
			Overheat = self:GetNWInt("Overheat");
			Overheated = self:GetNWBool("Overheated");
		end
		
		self.BaseClass.Think(self);
	end
	
	hook.Add("ScoreboardShow","SentinelScoreDisable", function()
		local p = LocalPlayer();	
		local Flying = p:GetNWBool("FlyingSentinel");
		if(Flying) then
			return false;
		end
	end)

	hook.Add( "ShouldDrawLocalPlayer", "SentinelDrawPlayerModel", function( p )
		local self = p:GetNWEntity("Sentinel", NULL);
		local PassengerSeat = p:GetNWEntity("SentinelSeat",NULL);
		if(IsValid(self)) then
			if(IsValid(PassengerSeat)) then
				if(PassengerSeat:GetThirdPersonMode()) then
					return true;
				end
			end
		end
	end);

	function SentinelReticle()
		
		local p = LocalPlayer();
		local Flying = p:GetNWBool("FlyingSentinel");
		local self = p:GetNWEntity("Sentinel");
		
		if(IsValid(self) and Flying) then
			if(self:GetFPV()) then
				SW_HUD_WingsIndicator("shuttle",x,y);
			end
		
			SW_HUD_DrawHull(5000);
			
			local pos = self:GetPos()+self:GetUp()*105+self:GetForward()*395;
			local x,y = SW_XYIn3D(pos);

			SW_HUD_Compass(self,x,y);
			SW_HUD_DrawSpeedometer();
			if(Flying) then
				
				SW_WeaponReticles(self);
				SW_HUD_DrawOverheating(self);

			end
		end
	end
	hook.Add("HUDPaint", "SentinelReticle", SentinelReticle)

end