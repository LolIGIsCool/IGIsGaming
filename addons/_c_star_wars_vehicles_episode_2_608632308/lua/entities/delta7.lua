
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Base = "fighter_base"
ENT.Type = "vehicle"

ENT.PrintName = "Delta 7"
ENT.Author = "Liam0102"
ENT.Category = "Star Wars Vehicles: Republic"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

ENT.EntModel = "models/jedi1/jedi1.mdl"
ENT.Vehicle = "Delta7"
ENT.StartHealth = 1500;
ENT.Allegiance = "Republic";
list.Set("SWVehicles", ENT.PrintName, ENT);

if SERVER then

ENT.FireSound = Sound("weapons/xwing_shoot.wav");
ENT.NextUse = {Wings = CurTime(),Use = CurTime(),Fire = CurTime(),};


AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
	local e = ents.Create("delta7");
	e:SetPos(tr.HitPos + Vector(0,0,10));
	e:SetAngles(Angle(0,pl:GetAimVector():Angle().Yaw,0));
	e:Spawn();
	e:Activate();
	return e;
end

function ENT:Initialize()

	self:SetNWInt("Health",self.StartHealth);
	self.CanRoll = true;
	self.WeaponLocations = {
		BottomLeft = self:GetPos()+self:GetUp()*12+self:GetRight()*-25,
		TopLeft = self:GetPos()+self:GetUp()*27+self:GetRight()*-25+self:GetForward()*75,
		BottomRight = self:GetPos()+self:GetUp()*12+self:GetRight()*23,
		TopRight = self:GetPos()+self:GetUp()*27+self:GetRight()*23+self:GetForward()*75,
	}
	self.WeaponsTable = {};
	self.BoostSpeed = 2000;
	self.ForwardSpeed = 1500;
	self.UpSpeed = 750;
	self.AccelSpeed = 9;
	
	self.Bullet = CreateBulletStructure(80,"red");
	self.FireDelay = 0.2;
	self.CanShoot = true;
	self.CanStandby = true;
	self.AlternateFire = true;
	self.FireGroup = { "BottomRight" , "BottomLeft", "TopLeft", "TopRight"};
	self:LadderTest();
	self.BaseClass.Initialize(self);

end

end

function ENT:LadderTest()

	
	local e = ents.Create("func_useableladder");
	e:SetPos(self:GetPos());
	//e:SetKeyValue( "Start", self:GetPos() )
	//e:SetKeyValue( "End","")
	e:SetParent(self);
	e:Spawn();
	e:Activate();

end

if CLIENT then
	local matPlasma	= Material( "sprites/tfaenginered" )
	function ENT:Draw() 
		self:DrawModel()
		/*
		local Flying = self:GetNWBool("Flying".. self.Vehicle);
		local TakeOff = self:GetNWBool("TakeOff");
		local Land = self:GetNWBool("Land");
		local vel = self:GetVelocity():Length();
		if(vel > 150) then
			if(Flying and !TakeOff and !Land) then
				for i=1,2 do
					local vOffset = self.EnginePos[i] 
					local scroll = CurTime() * -20
						
					render.SetMaterial( matPlasma )
					scroll = scroll * 0.9
					
					render.StartBeam( 3 )
						render.AddBeam( vOffset, 26, scroll, Color( 0, 255, 255, 255) )
						render.AddBeam( vOffset + self:GetForward()*-5, 22, scroll + 0.01, Color( 255, 255, 255, 255) )
						render.AddBeam( vOffset + self:GetForward()*-40, 18, scroll + 0.02, Color( 0, 255, 255, 0) )
					render.EndBeam()
					
					scroll = scroll * 0.9
					
					render.StartBeam( 3 )
						render.AddBeam( vOffset, 26, scroll, Color( 0, 255, 255, 255) )
						render.AddBeam( vOffset + self:GetForward()*-5, 22, scroll + 0.01, Color( 255, 255, 255, 255) )
						render.AddBeam( vOffset + self:GetForward()*-40, 18, scroll + 0.02, Color( 0, 255, 255, 0) )
					render.EndBeam()
					
					scroll = scroll * 0.9
					
					render.StartBeam( 3 )
						render.AddBeam( vOffset, 26, scroll, Color( 0, 255, 255, 255) )
						render.AddBeam( vOffset + self:GetForward()*-5, 22, scroll + 0.01, Color( 255, 255, 255, 255) )
						render.AddBeam( vOffset + self:GetForward()*-40, 18, scroll + 0.02, Color( 0, 255, 255, 0) )
					render.EndBeam()
				end
			end
		end
		*/
	end
	
	ENT.EnginePos = {}
	ENT.Sounds={
		Engine=Sound("vehicles/eta/eta_fly.wav"),
	}


	function ENT:FlightEffects()
		local normal = (self:GetForward() * -1):GetNormalized()
		local roll = math.Rand(-90,90)
		local p = LocalPlayer()		
		local FWD = self:GetForward();
		local id = self:EntIndex();

		for k,v in pairs(self.EnginePos) do
			
			local blue = self.FXEmitter:Add("sprites/orangecore1",v+FWD*-5)
			blue:SetVelocity(normal)
			blue:SetDieTime(FrameTime()*1.25)
			blue:SetStartAlpha(255)
			blue:SetEndAlpha(255)
			blue:SetStartSize(12)
			blue:SetEndSize(10)
			blue:SetRoll(roll)
			blue:SetColor(255,255,255)
			
			local dynlight = DynamicLight(id + 4096*k);
			dynlight.Pos = v+FWD*-25;
			dynlight.Brightness = 5;
			dynlight.Size = 100;
			dynlight.Decay = 1024;
			dynlight.R = 255;
			dynlight.G = 225;
			dynlight.B = 75;
			dynlight.DieTime = CurTime()+1;
			
		end
	
	end
	
	function ENT:Think()
	
		self.BaseClass.Think(self)
		
		local p = LocalPlayer();
		local Flying = self:GetNWBool("Flying".. self.Vehicle);
		local TakeOff = self:GetNWBool("TakeOff");
		local Land = self:GetNWBool("Land");
		if(Flying) then
			self.EnginePos = {
				self:GetPos()+self:GetForward()*-132.5+self:GetUp()*16+self:GetRight()*18,
				self:GetPos()+self:GetForward()*-132.5+self:GetUp()*16+self:GetRight()*-21,
			}
			if(!TakeOff and !Land) then
				self:FlightEffects();
			end
		end
		
	end
	
    ENT.ViewDistance = 500;
    ENT.ViewHeight = 150;
	
	ENT.CanFPV = false;
	local HUD = surface.GetTextureID("vgui/delta7_cockpit")
	function Delta7Reticle()
		
		local p = LocalPlayer();
		local Flying = p:GetNWBool("FlyingDelta7");
		local self = p:GetNWEntity("Delta7");
		if(Flying and IsValid(self)) then
		
			local FPV = self:GetFPV();
			if(FPV) then
				SW_HUD_FPV(HUD);
			end
			SW_HUD_DrawHull(1500);
			SW_WeaponReticles(self);
			SW_HUD_DrawOverheating(self);
			SW_HUD_Compass(self);
			SW_HUD_DrawSpeedometer();
		end
	end
	hook.Add("HUDPaint", "Delta7Reticle", Delta7Reticle)

end