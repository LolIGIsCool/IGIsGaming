ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Base = "speeder_base"
ENT.Type = "vehicle"

ENT.PrintName = "Bloodfin Speeder"
ENT.Author = "Liam0102, Syphadias"
ENT.Category = "Star Wars Vehicles: CIS"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

ENT.Vehicle = "SithSpeed"; // The unique name for the speeder.
ENT.EntModel = "models/sith_speeder/syphadias/sith_speeder.mdl"; // The path to your model
list.Set("SWVehicles", ENT.PrintName, ENT);

ENT.StartHealth = 1000; // Starting Health
if SERVER then

ENT.NextUse = {Use = CurTime(),Fire = CurTime()};
ENT.FireSound = Sound("vehicles/speeder_shoot.wav");


AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
	local e = ents.Create("sith_speeder");
	e:SetPos(tr.HitPos + Vector(0,0,10));
	e:SetAngles(Angle(0,pl:GetAimVector():Angle().Yaw+180,0));
	e:Spawn();
	e:Activate();
	return e;
end

function ENT:Initialize()
	self.BaseClass.Initialize(self);
	self.SeatClass = "phx_seat3";
	local driverPos = self:GetPos()+self:GetForward()*32.5+self:GetUp()*17.5+self:GetRight()*0; // Position of the drivers seat
	local driverAng = self:GetAngles()+Angle(0,90,0); // The angle of the drivers seat
	self:SpawnChairs(driverPos,driverAng,false)
	
	self.ForwardSpeed = -500; //Your speed
	self.BoostSpeed = -850 // Boost Speed
	self.AccelSpeed = 8; // Acceleration
	self.WeaponLocations = {
		Main = self:GetPos()+self:GetRight()*100+self:GetUp()*15, // Position of weapon
	}
	self.HoverMod = 7; // If you're vehicle keeps hitting the floor increase this	
	self.StartHover = 40; // How high you are at flat ground
	self.StandbyHoverAmount = 30; // How high the speeder is when no one is in it	
	self.Bullet = CreateBulletStructure(100,"red"); // First number is damage, second is colour. red or green
	//self:TestLoc(self:GetPos()+self:GetForward()*15+self:GetUp()*5)
end

local ZAxis = Vector(0,0,1);
function ENT:PhysicsSimulate( phys, deltatime )
	self.BackPos = self:GetPos()+self:GetForward()*50+self:GetUp()*5;
	self.FrontPos = self:GetPos()+self:GetForward()*-25+self:GetUp()*5;
	self.MiddlePos = self:GetPos()+self:GetForward()*15+self:GetUp()*5;
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
		Engine=Sound("vehicles/sith_speeder/sith_speeder_loop.wav"),
	}
	ENT.HasCustomCalcView = true;
	//Ignore
	local Health = 0;
	local Speed = 0;
	function ENT:Think()
		self.BaseClass.Think(self);
		local p = LocalPlayer();
		local Flying = p:GetNWBool("Flying"..self.Vehicle);
		if(Flying) then
			Health = self:GetNWInt("Health");
			Speed = self:GetNWInt("Speed");
			self:Effects(); //Call the effects when the ship is flying.
		end
		
	end
	
	function ENT:Initialize()
		self.FXEmitter = ParticleEmitter(self:GetPos())
		self.BaseClass.Initialize(self);
    end
 
 
    function ENT:Effects()
        local normal = (self:GetForward() * -100):GetNormalized() // More or less the direction. You can leave this for the most part (If it's going the opposite way, then change it 1 not -1)
        local roll = math.Rand(-90,90) // Random roll so the effect isn't completely static (Useful for heatwave type)
        local p = LocalPlayer() // Player (duh)
        local id = self:EntIndex(); //Need this later on.
   
        //Get the engine pos the same way you get weapon pos
        self.EnginePos = {
            self:GetPos()+self:GetForward()*60+self:GetUp()*50+self:GetRight()*.68,
            self:GetPos()+self:GetForward()*60.25+self:GetUp()*48+self:GetRight()*.68,
            self:GetPos()+self:GetForward()*60.5+self:GetUp()*46+self:GetRight()*.68,
            self:GetPos()+self:GetForward()*61.45+self:GetUp()*43.5+self:GetRight()*.68,
        }
   
        for k,v in pairs(self.EnginePos) do
   
            local red = self.FXEmitter:Add("sprites/bluecore",v) // This is where you add the effect. The ones I use are either the current or "sprites/bluecore"
            red:SetVelocity(normal) //Set direction we made earlier
            red:SetDieTime(0.015) //How quick the particle dies. Make it larger if you want the effect to hang around
            red:SetStartAlpha(255) // Self explanitory. How visible it is.
            red:SetEndAlpha(255) // How visible it is at the end
            red:SetStartSize(2.99) // Start size. Just play around to find the right size.
            red:SetEndSize(1.5) // End size
            red:SetRoll(roll) // They see me rollin. (They hatin')
            red:SetColor(0,255,0) // Set the colour in RGB. This is more of an overlay colour effect and doesn't change the material source.
 
            local dynlight = DynamicLight(id + 4096 * k); // Create the "glow"
            dynlight.Pos = v; // Position from the table
            dynlight.Brightness = 4.5; // Brightness, Don't go above 10. It's blinding
            dynlight.Size = 20; // How far it reaches
            dynlight.Decay = 500; // Not really sure what this does, but I leave it in
            dynlight.R = 0; // Colour R
            dynlight.G = 255; // Colour G
            dynlight.B = 0; // Colour B
            dynlight.DieTime = CurTime()+1; // When the light should die
        end
    end
	
	local View = {}
	local function CalcView()
		
		local p = LocalPlayer();
		local self = p:GetNWEntity("SithSpeed", NULL) // Set SithSpeed to your unique name
		local DriverSeat = p:GetNWEntity("DriverSeat",NULL);
		local PassengerSeat = p:GetNWEntity("PassengerSeat",NULL);

		if(IsValid(self)) then

			if(IsValid(DriverSeat)) then
				if(DriverSeat:GetThirdPersonMode()) then
					local pos = self:GetPos()+LocalPlayer():GetAimVector():GetNormal()*-250+self:GetUp()*100;

					//local face = self:GetAngles() + Angle(0,180,0);
					local face = ((self:GetPos() + Vector(0,0,100))- pos):Angle();
						View.origin = pos;
						View.angles = face;
					return View;
				end
			end

		end
	end
	hook.Add("CalcView", "SithSpeedView", CalcView) ///Make sure the middle string is unique

	
	hook.Add( "ShouldDrawLocalPlayer", "SithSpeedDrawPlayerModel", function( p )
		local self = p:GetNWEntity("SithSpeed", NULL); // Set this to the unique name and ignore the rest
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
	
	local function SithSpeedReticle()
	
		local p = LocalPlayer();
		local Flying = p:GetNWBool("FlyingSithSpeed");// Flying with your unique name
		local self = p:GetNWEntity("SithSpeed"); // Unique name
		if(Flying and IsValid(self)) then	
			SW_Speeder_DrawHull(1000)
			SW_Speeder_DrawSpeedometer()

		end
	end
	hook.Add("HUDPaint", "SithSpeedReticle", SithSpeedReticle) //Unique names again
	
	
end