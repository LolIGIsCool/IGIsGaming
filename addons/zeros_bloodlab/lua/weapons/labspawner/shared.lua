SWEP.Author			= "Goliath"
SWEP.Contact			= ""
SWEP.Purpose			= ""
SWEP.Instructions		= "Left click spawns a biolab"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_pistol.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

local ShootSound = Sound( "Metal.SawbladeStick" )

function SWEP:Reload()
end

function SWEP:Think()
end


function SWEP:PrimaryAttack()
    if (not SERVER) then return end
    local HasLab = false

    for k, v in pairs(ents.FindByClass("zbl_lab")) do
        if v:GetOwner() == self.Owner then
            HasLab = true
        end
    end

    if not HasLab then
        local tr = self.Owner:GetEyeTrace()
        local ent = ents.Create("zbl_lab")
        if self.Owner:GetPos():Distance(tr.HitPos) >= 125 then self.Owner:ChatPrint("You can not deploy the lab that far away") return end
        zbl.f.SetOwner(ent, self.Owner)
        ent:SetPos(tr.HitPos)
        local spawnvector = Angle(0,(self.Owner:EyeAngles().y+180)%360,0)
        ent:SetAngles(spawnvector)
        ent:SetOwner(self.Owner)
        ent:Spawn()
        undo.Create("Medical Lab")
          undo.AddEntity(ent)
          undo.SetPlayer(self.Owner)
        undo.Finish()
    else
        self.Owner:PrintMessage(3, "You already have a lab, ask staff for tools to move it or delete it by right clicking with this tool")
    end
end

function SWEP:SecondaryAttack()
    if (not SERVER) then return end

    for k, v in pairs(ents.FindByClass("zbl_lab")) do
        if v:GetOwner() == self.Owner then
            SafeRemoveEntity(v)
            self.Owner:ChatPrint("Lab Removed")
            return
        end
    end
    self.Owner:ChatPrint("You do not have an active lab!")
end
