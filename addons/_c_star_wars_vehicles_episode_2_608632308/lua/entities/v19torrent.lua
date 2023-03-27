ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.Base = "fighter_base"
ENT.Type = "vehicle"

ENT.PrintName = "V-19 Torrent"
ENT.Author = "Liam0102"
ENT.Category = "Star Wars Vehicles: Republic"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

ENT.EntModel = "models/sweaw/ships/rep_v19torrent.mdl"
ENT.Vehicle = "V19Torrent"
ENT.StartHealth = 3000;
ENT.Allegiance = "Republic";
list.Set("SWVehicles", ENT.PrintName, ENT);

if SERVER then

ENT.FireSound = Sound("weapons/xwing_shoot.wav");
ENT.NextUse = {Wings = CurTime(),Use = CurTime(),Fire = CurTime(),};


AddCSLuaFile();
function ENT:SpawnFunction(pl, tr)
	local e = ents.Create("v19torrent");
	e:SetPos(tr.HitPos + Vector(0,0,20));
	e:SetAngles(Angle(0,pl:GetAimVector():Angle().Yaw,0));
	e:Spawn();
	e:Activate();
	return e;
end

function ENT:Initialize()


	self:SetNWInt("Health",self.StartHealth);
	
	self.WeaponLocations = {
		Right = self:GetPos()+self:GetForward()*270+self:GetUp()*125+self:GetRight()*400,
		Left = self:GetPos()+self:GetForward()*270+self:GetUp()*125+self:GetRight()*-400,
	}
	
	self.WeaponsTable = {};
	self.BoostSpeed = 2000;
	self.ForwardSpeed = 1000;
	self.UpSpeed = 500;
	self.AccelSpeed = 8;
	self.CanBack = true;
	self.CanRoll = false;
    self.CanStrafe = true;
	self.CanStandby = true;
	self.Cooldown = 2;
	self.Overheat = 0;
	self.Overheated = false;
	
	self.CanShoot = true;
	self.ExitModifier = {x=0,y=140,z=40};
	
	self.Bullet = CreateBulletStructure(100,"blue_noion");
        
	self.BaseClass.Initialize(self);
end


end

if CLIENT then

	function ENT:Draw() self:DrawModel() end
	
	ENT.EnginePos = {}
	ENT.Sounds={
		Engine=Sound("vehicles/laat/laat_fly2.wav"),
	}
    
    local matPlasma	= Material( "effects/strider_muzzle" )
	function ENT:Draw() 
		self:DrawModel()		
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
						render.AddBeam( vOffset, 60, scroll, Color( 0, 255, 255, 255) )
						render.AddBeam( vOffset + self:GetForward()*-5, 45, scroll + 0.01, Color( 255, 255, 255, 255) )
						render.AddBeam( vOffset + self:GetForward()*-40, 30, scroll + 0.02, Color( 0, 255, 255, 0) )
					render.EndBeam()
					
					scroll = scroll * 0.9
					
					render.StartBeam( 3 )
						render.AddBeam( vOffset, 60, scroll, Color( 0, 255, 255, 255) )
						render.AddBeam( vOffset + self:GetForward()*-5, 45, scroll + 0.01, Color( 255, 255, 255, 255) )
						render.AddBeam( vOffset + self:GetForward()*-40, 30, scroll + 0.02, Color( 0, 255, 255, 0) )
					render.EndBeam()
					
					scroll = scroll * 0.9
					
					render.StartBeam( 3 )
						render.AddBeam( vOffset, 60, scroll, Color( 0, 255, 255, 255) )
						render.AddBeam( vOffset + self:GetForward()*-5, 45, scroll + 0.01, Color( 255, 255, 255, 255) )
						render.AddBeam( vOffset + self:GetForward()*-40, 30, scroll + 0.02, Color( 0, 255, 255, 0) )
					render.EndBeam()
					
					
				end
			end
		end
	end
		
		
	ENT.EnginePos = {}
	function ENT:FlightEffects()
		local normal = (self:GetForward() * -1):GetNormalized()
		local roll = math.Rand(-90,90)
		local p = LocalPlayer()		
		local FWD = self:GetForward();
		local id = self:EntIndex();

		for k,v in pairs(self.EnginePos) do
			
			local blue = self.FXEmitter:Add("sprites/bluecore",v)
			blue:SetVelocity(normal)
			blue:SetDieTime(0.025)
			blue:SetStartAlpha(255)
			blue:SetEndAlpha(255)
			blue:SetStartSize(20)
			blue:SetEndSize(15)
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


	function ENT:Think()
	
		self.BaseClass.Think(self)
		
		local p = LocalPlayer();
		local Flying = self:GetNWBool("Flying".. self.Vehicle);
		local TakeOff = self:GetNWBool("TakeOff");
		local Land = self:GetNWBool("Land");
		if(Flying) then
			self.EnginePos = {
                self:GetPos()+self:GetForward()*-62.5+self:GetUp()*122.5,
                self:GetPos()+self:GetForward()*-135+self:GetUp()*340+self:GetRight()*122.5,
                self:GetPos()+self:GetForward()*-135+self:GetUp()*340+self:GetRight()*-122.5
			}
			if(!TakeOff and !Land) then
				self:FlightEffects();
			end
		end
		
	end

    ENT.ViewDistance = 1000;
    ENT.ViewHeight = 500;

	function V19TorrentReticle()
		
		local p = LocalPlayer();
		local Flying = p:GetNWBool("FlyingV19Torrent");
		local self = p:GetNWEntity("V19Torrent");
		if(Flying and IsValid(self)) then
			local WeaponsPos = {
                self:GetPos()+self:GetForward()*270+self:GetUp()*125+self:GetRight()*400,
                self:GetPos()+self:GetForward()*270+self:GetUp()*125+self:GetRight()*-400,
			}
			
			SW_HUD_DrawHull(3000);
			SW_WeaponReticles(self);
			SW_HUD_DrawOverheating(self);
			
			local x = ScrW()/4*0.6;
			local y = ScrH()/4*0.825;
			SW_HUD_Compass(self,x,y);
			SW_HUD_DrawSpeedometer();
		end
	end
	hook.Add("HUDPaint", "V19TorrentReticle", V19TorrentReticle)

end