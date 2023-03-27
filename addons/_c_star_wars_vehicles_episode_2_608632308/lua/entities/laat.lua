
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Base = "fighter_base"
ENT.Type = "vehicle"

ENT.PrintName = "LAAT"
ENT.Author = "Liam0102"
ENT.Category = "Star Wars Vehicles: Republic"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

ENT.EntModel = "models/ish/starwars/laat/laat_mk2.mdl"
ENT.Vehicle = "LAAT"
ENT.Allegiance = "Republic";
list.Set("SWVehicles", ENT.PrintName, ENT);

if SERVER then

ENT.FireSound = Sound("weapons/tie_shoot.wav");
ENT.NextUse = {Wings = CurTime(),Use = CurTime(),Fire = CurTime(),Doors = CurTime(),};
ENT.StartHealth = 5000;

AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
	local e = ents.Create("laat");
	e:SetPos(tr.HitPos + Vector(0,0,10));
	e:SetAngles(Angle(0,pl:GetAimVector():Angle().Yaw,0));
	e:Spawn();
	e:Activate();
	return e;
end

function ENT:Initialize()


	self:SetNWInt("Health",self.StartHealth);
	
	self.WeaponLocations = {
		Right = self:GetPos()+self:GetForward()*360+self:GetUp()*25+self:GetRight()*58,
		Left = self:GetPos()+self:GetForward()*360+self:GetUp()*25+self:GetRight()*-58,
	}
	self.WeaponsTable = {};
	self.BoostSpeed = 1750;
	self.ForwardSpeed = 1000;
	self.UpSpeed = 500;
	self.AccelSpeed = 7;
	self.CanBack = true;
	self.CanShoot = true;
    self.CanStrafe = true;
	self.AlternateFire = true;
	self.FireGroup = {"Right","Left"}
	
	self.Cooldown = 2;
	self.Overheat = 0;
	self.Overheated = false;
	
	self.Bullet = CreateBulletStructure(70,"green");
	
    self.HasSeats = true;
	self.SeatPos = {
	
		{self:GetPos()+self:GetUp()*31+self:GetRight()*-13.5, self:GetAngles(),Vector(0,47.5,31)},
		{self:GetPos()+self:GetUp()*31+self:GetRight()*13.5,self:GetAngles()+Angle(0,180,0),Vector(-40,-47.5,31)},
		
		{self:GetPos()+self:GetUp()*31+self:GetRight()*-13.5+self:GetForward()*-24, self:GetAngles(),Vector(-24,47.5,31)},
		{self:GetPos()+self:GetUp()*31+self:GetRight()*13.5+self:GetForward()*-24, self:GetAngles()+Angle(0,180,0),Vector(-24,-47.5,31)},
		
		{self:GetPos()+self:GetUp()*31+self:GetRight()*-13.5+self:GetForward()*-45, self:GetAngles(),Vector(-45,47.5,31)},
		{self:GetPos()+self:GetUp()*31+self:GetRight()*13.5+self:GetForward()*-45, self:GetAngles()+Angle(0,180,0),Vector(-45,-47.5,31)},
		
		{self:GetPos()+self:GetUp()*31+self:GetRight()*-13.5+self:GetForward()*-68, self:GetAngles(),Vector(-68,47.5,31)},
		{self:GetPos()+self:GetUp()*31+self:GetRight()*13.5+self:GetForward()*-68, self:GetAngles()+Angle(0,180,0),Vector(-68,-47.5,31)},
		
		{self:GetPos()+self:GetUp()*31+self:GetRight()*-13.5+self:GetForward()*-90, self:GetAngles(),Vector(-75,47.5,31)},
		{self:GetPos()+self:GetUp()*31+self:GetRight()*13.5+self:GetForward()*-90, self:GetAngles()+Angle(0,180,0),Vector(-75,-47.5,31)},
		
		{self:GetPos()+self:GetUp()*31+self:GetRight()*-13.5+self:GetForward()*-113, self:GetAngles(),Vector(-75,47.5,31)},
		{self:GetPos()+self:GetUp()*31+self:GetRight()*13.5+self:GetForward()*-113, self:GetAngles()+Angle(0,180,0),Vector(-75,-47.5,31)},
		
		{self:GetPos()+self:GetUp()*31+self:GetRight()*-13.5+self:GetForward()*-135, self:GetAngles(),Vector(-75,47.5,20)},
		{self:GetPos()+self:GetUp()*31+self:GetRight()*13.5+self:GetForward()*-135, self:GetAngles()+Angle(0,180,0),Vector(-75,-47.5,31)},
	};
	
	self.ExitModifier = {x=0,y=87.5,z=20};

	self.PilotVisible = true;
	self.PilotPosition = {x=0,y=210,z=130};

	self.HasLookaround = true;
	self.BaseClass.Initialize(self);
	
	// Set Bodygroups after loading base initialize, otherwise there's no model set to run the bodygroups on
	self:SetBodygroup(8,1);
	self:SetBodygroup(9,1);
end


function ENT:Use(p)

	self.UsePos = {
		self:GetPos()+self:GetForward()*65+self:GetRight()*-70+self:GetUp()*10,
		self:GetPos()+self:GetForward()*110+self:GetRight()*50+self:GetUp()*140,
	}
	for k,v in pairs(ents.FindInBox(self.UsePos[1],self.UsePos[2])) do
		if(v:IsPlayer() and v == p) then
			if(not self.Inflight) then
				self:Enter(p);
                return;
            else
                self:Passenger(p);
                return;
			end
		end
	end
    self:Passenger(p);
end


function ENT:Think()

	if(self.Inflight) then
		if(IsValid(self.Pilot) and self.Pilot:KeyDown(IN_RELOAD)) then
            self:ToggleDoors();
        end
	end	

	self.BaseClass.Think(self);
end

function ENT:ToggleDoors()

	if(self.NextUse.Doors < CurTime()) then
		if(self.Door) then
			self:SetBodygroup(8,1);
			self.Door = false;
		else
			self:SetBodygroup(8,3);
			self.Door = true;
		end
		self.NextUse.Doors = CurTime() + 1;
	end
end


function ENT:Enter(p)

	self:SetBodygroup(9,0);
	self.BaseClass.Enter(self,p);
	
end

function ENT:Exit()

	self:SetBodygroup(9,1);
	self.BaseClass.Exit(self);
	
end


end

if CLIENT then

	ENT.EnginePos = {}
	ENT.Sounds={
		//Engine=Sound("ambient/atmosphere/ambience_base.wav"),
		Engine=Sound("vehicles/laat/laat_fly2.wav"),
	}
	ENT.CanFPV = true;

	hook.Add("ScoreboardShow","LAATScoreDisable", function()
		local p = LocalPlayer();	
		local Flying = p:GetNWBool("FlyingLAAT");
		if(Flying) then
			return false;
		end
	end)

    ENT.ViewDistance = 950;
    ENT.ViewHeight = 400;
    ENT.FPVPos = Vector(210,0,155);
	
	hook.Add( "ShouldDrawLocalPlayer", "LAATDrawPlayerModel", function( p )
		local self = p:GetNWEntity("LAAT", NULL);
		local PassengerSeat = p:GetNWEntity("LAATSeat",NULL);
		if(IsValid(self)) then
			if(IsValid(PassengerSeat)) then
				if(PassengerSeat:GetThirdPersonMode()) then
					return true;
				end
			end
		end
	end);

	function LAATReticle()
		
		local p = LocalPlayer();
		local Flying = p:GetNWBool("FlyingLAAT");
		local self = p:GetNWEntity("LAAT");
		if(Flying and IsValid(self)) then
			SW_HUD_DrawHull(5000);
			SW_WeaponReticles(self);
			SW_HUD_DrawOverheating(self);
			
			local pos = self:GetPos()+self:GetForward()*240+self:GetUp()*147.5;
			local x,y = SW_XYIn3D(pos);
			
			SW_HUD_Compass(self,x,y);
			SW_HUD_DrawSpeedometer();
		end
	end
	hook.Add("HUDPaint", "LAATReticle", LAATReticle)

end