//HOW TO PROPERLY MAKE AN ADDITIONAL SHIP ADDON OFF OF MINE.
 
//Do not copy everything out of my addon. You don't need it. Shall explain later.
 
//Leave this stuff the same
ENT.RenderGroup = RENDERGROUP_OPAQUE;
ENT.Base = "fighter_base";
ENT.Type = "vehicle";
 
//Edit appropriatly. I'd prefer it if you left my name (Since I made the base, and this ConsularC)
ENT.PrintName = "Consular-class Cruiser";
ENT.Author = "Liam0102";
 
// Leave the same
ENT.Category = "Star Wars Vehicles: Republic"; // Techincally you could change this, but personally I'd leave it so they're all in the same place (Looks more proffesional).
ENT.AutomaticFrameAdvance = true;
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.AdminOnly = true; //Set to true for an Admin vehicle.
 
ENT.EntModel = "models/consular_c/syphadias/consular_c_m.mdl" //The oath to the model you want to use.
ENT.Vehicle = "ConsularC" //The internal name for the ship. It cannot be the same as a different ship.
ENT.StartHealth = 6000; //How much health they should have.
ENT.Allegiance = "Republic";
list.Set("SWVehicles", ENT.PrintName, ENT);
    
if SERVER then
 
ENT.FireSound = Sound("weapons/xwing_shoot.wav"); // The sound to make when firing the weapons. You do not need the sounds folder at the start
ENT.NextUse = {Wings = CurTime(),Use = CurTime(),Fire = CurTime(),LightSpeed=CurTime(),Switch=CurTime(),}; //Leave this alone for the most part.
ENT.HyperDriveSound = Sound("vehicles/hyperdrive.mp3");
 
AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
    local e = ents.Create("consular"); // This should be the same name as the file
    local spawn_height = 20; // How high above the ground the vehicle spawns. Change if it's spawning too high, or spawning in the ground.
   
    e:SetPos(tr.HitPos + Vector(0,0,spawn_height));
    e:SetAngles(Angle(0,pl:GetAimVector():Angle().Yaw,0));
    e:Spawn();
    e:Activate();
    return e;
end
 
function ENT:Initialize()
 
 
    self:SetNWInt("Health",self.StartHealth); // Set the ship health, to the start health as made earlier
   
    //The locations of the weapons (Where we shoot out of), local to the ship. These largely just take a lot of tinkering.
    self.WeaponLocations = {
        Right = self:GetPos() + self:GetForward() * -30 + self:GetRight() * 432 + self:GetUp() * -17.25,
        TopRight = self:GetPos() + self:GetForward() * -30 + self:GetRight() * 432 + self:GetUp() * -17.25,
        TopLeft = self:GetPos() + self:GetForward() * -30 + self:GetRight() * -432 + self:GetUp() * -17.25,
        Left = self:GetPos() + self:GetForward() * -30 + self:GetRight() * -432 + self:GetUp() * -17.25,
    }
    self.WeaponsTable = {}; // IGNORE. Needed to give players their weapons back
    self.BoostSpeed = 2500; // The speed we go when holding SHIFT
    self.ForwardSpeed = 1500; // The forward speed
    self.UpSpeed = 600; // Up/Down Speed
    self.AccelSpeed = 8; // How fast we get to our previously set speeds
    self.CanBack = true; // Can we move backwards? Set to true if you want this.
    self.CanRoll = false; // Set to true if you want the ship to roll, false if not
    self.CanStrafe = true; // Set to true if you want the ship to strafe, false if not. You cannot have roll and strafe at the same time
    self.CanStandby = true; // Set to true if you want the ship to hover when not inflight
    self.CanShoot = false; // Set to true if you want the ship to be able to shoot, false if not
   
    self.AlternateFire = false // Set this to true if you want weapons to fire in sequence (You'll need to set the firegroups below)
    self.FireGroup = {"Left","Right","TopLeft","TopRight"} // In this example, the weapon positions set above will fire with Left and TopLeft at the same time. And Right and TopRight at the same time.
    self.OverheatAmount = 50 //The amount a ship can fire consecutively without overheating. 50 is standard.
    self.DontOverheat = false; // Set this to true if you don't want the weapons to ever overheat. Mostly only appropriate on Admin vehicles.
    self.MaxIonShots = 20; // The amount of Ion shots a vehicle can take before being disabled. 20 is the default.
	self.LandDistance = 800;
   
    self.LandOffset = Vector(0,0,0); // Change the last 0 if you're vehicle is having trouble landing properly. (Make it larger)
    self:SpawnInterior();
    self:SpawnMisc();
	
    self.HasLightspeed = true;
                                                                    
	self.ExitModifier = {x=300,y=0,z=20};
    self.HasSeats = true;                                                             
	self.SeatPos = {
		{self:GetPos()+self:GetForward()*-350+self:GetUp()*200,self:GetAngles(),Vector(300,0,20)},
		{self:GetPos()+self:GetForward()*-350+self:GetUp()*200+self:GetRight()*50,self:GetAngles(),Vector(300,0,20)},
		{self:GetPos()+self:GetForward()*-350+self:GetUp()*200+self:GetRight()*100,self:GetAngles(),Vector(300,0,20)},
		{self:GetPos()+self:GetForward()*-350+self:GetUp()*200+self:GetRight()*150,self:GetAngles(),Vector(300,0,20)},
		{self:GetPos()+self:GetForward()*-350+self:GetUp()*200+self:GetRight()*-50,self:GetAngles(),Vector(300,0,20)},
		{self:GetPos()+self:GetForward()*-350+self:GetUp()*200+self:GetRight()*-100,self:GetAngles(),Vector(300,0,20)},
		{self:GetPos()+self:GetForward()*-350+self:GetUp()*200+self:GetRight()*-150,self:GetAngles(),Vector(300,0,20)},
		
		{self:GetPos()+self:GetForward()*-450+self:GetUp()*200,self:GetAngles(),Vector(300,0,20)},
		{self:GetPos()+self:GetForward()*-450+self:GetUp()*200+self:GetRight()*50,self:GetAngles(),Vector(300,0,20)},
		{self:GetPos()+self:GetForward()*-450+self:GetUp()*200+self:GetRight()*100,self:GetAngles(),Vector(300,0,20)},
		{self:GetPos()+self:GetForward()*-450+self:GetUp()*200+self:GetRight()*150,self:GetAngles(),Vector(300,0,20)},
		{self:GetPos()+self:GetForward()*-450+self:GetUp()*200+self:GetRight()*-50,self:GetAngles(),Vector(300,0,20)},
		{self:GetPos()+self:GetForward()*-450+self:GetUp()*200+self:GetRight()*-100,self:GetAngles(),Vector(300,0,20)},
		{self:GetPos()+self:GetForward()*-450+self:GetUp()*200+self:GetRight()*-150,self:GetAngles(),Vector(300,0,20)},
	}
    self.DisableThirdpersonSeats = true;                                                            
    self.Bullet = CreateBulletStructure(60,"red",false); // The first number is bullet damage, the second colour. green and red are the only options. (Set to blue for ion shot, the damage will be halved but ships will be disabled after consecutive hits). The final one is for splash damage. Set to true if you don't want splashdamage.
   
    self.BaseClass.Initialize(self); // Ignore, needed to work

end
 
function ENT:SpawnInterior()
 
    local e = ents.Create("prop_dynamic");
    e:SetModel("models/consular_c/syphadias/consular_c_f.mdl");
    e:SetPos(self:GetPos());
    e:SetAngles(self:GetAngles());
    e:Spawn();
    e:Activate();
    e:SetParent(self);
    //e:GetPhysicsObject():EnableCollisions(false);
    self.Interior = e;
   
end
 
function ENT:SpawnMisc()
 
    local e = ents.Create("prop_dynamic");
    e:SetModel("models/consular_c/syphadias/consular_c_b.mdl");
    e:SetPos(self:GetPos());
    e:SetAngles(self:GetAngles());
    e:Spawn();
    e:Activate();
    e:SetParent(self);
    //e:GetPhysicsObject():EnableCollisions(false);
    self.Misc = e;
   
end


end
 
if CLIENT then
 
    ENT.CanFPV = false; // Set to true if you want FPV
    ENT.EnginePos = {}
    ENT.Sounds={
        //Engine=Sound("ambient/atmosphere/ambience_base.wav"),
		Engine=Sound("vehicles/mf/mf_fly5.wav"),
    }
 
	local LightSpeed = 0;
	function ENT:Think()
		self.BaseClass.Think(self);
		
		local p = LocalPlayer();
		local Flying = self:GetNWBool("Flying".. self.Vehicle);
		local IsFlying = p:GetNWBool("Flying"..self.Vehicle);
		local TakeOff = self:GetNWBool("TakeOff");
		local Land = self:GetNWBool("Land");
		
		if(Flying) then
			if(!TakeOff and !Land) then
				self:FlightEffects();
			end
			LightSpeed = self:GetNWInt("LightSpeed");
		end

	end
	
	function ENT:FlightEffects()
		self.EnginePos = {
			self:GetPos()+self:GetForward()*-880+self:GetUp()*190,
			self:GetPos()+self:GetForward()*-880+self:GetUp()*190+self:GetRight()*-435,
			self:GetPos()+self:GetForward()*-880+self:GetUp()*190+self:GetRight()*435,
		}
		local normal = (self:GetForward() * -1):GetNormalized()
		local roll = math.Rand(-90,90)
		local p = LocalPlayer()		
		local FWD = self:GetForward();
		local id = self:EntIndex();
		
		for k,v in pairs(self.EnginePos) do
				
			local blue = self.FXEmitter:Add("sprites/bluecore",v)
			blue:SetVelocity(normal)
			blue:SetDieTime(0.03)
			blue:SetStartAlpha(255)
			blue:SetEndAlpha(255)
			blue:SetStartSize(180)
			blue:SetEndSize(100)
			blue:SetRoll(roll)
			blue:SetColor(255,255,255)
			
			local dynlight = DynamicLight(id + 4096 * k);
			dynlight.Pos = v;
			dynlight.Brightness = 5;
			dynlight.Size = 250;
			dynlight.Decay = 1024;
			dynlight.R = 100;
			dynlight.G = 100;
			dynlight.B = 255;
			dynlight.DieTime = CurTime()+1;
			
		end
	end
 
    ENT.ViewDistance = 2000;
    ENT.ViewHeight = 700;

    local function ConsularCReticle() //Make this unique. Again Ship name + Reticle
       
        local p = LocalPlayer();
        local Flying = p:GetNWBool("FlyingConsularC");
        local self = p:GetNWEntity("ConsularC");
        if(Flying and IsValid(self)) then
			SW_HUD_DrawHull(6000);
			SW_HUD_Compass(self);
			SW_HUD_DrawSpeedometer();
        end
		
		if(IsValid(self)) then
			if(LightSpeed == 2) then
				DrawMotionBlur( 0.4, 20, 0.01 );
			end
		end
    end
    hook.Add("HUDPaint", "ConsularCReticle", ConsularCReticle) // Here you need to make the middle argument something unique again. I've set it as what the function is called. Could be anything. And the final arguement should be the function just made.
 
end
 
/*
Put this file in lua/entities/
Then package up the addon like normal and upload.
Now you need to set your addon on the upload page, to require my addon.
This way the only thing in your addon is the unique files, and should I make any changes to fighter_base and the sounds etc. you'll get those changes.
 
Make sure this is the only file in lua/entities/
 
*/