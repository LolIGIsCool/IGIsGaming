SWEP.Author = "[IG] Goliath"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Reload()
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
    local Own = self.Owner
    local tr = self.Owner:GetEyeTrace()
    if (not SERVER) then return end

    if Own:GetPos():DistToSqr(tr.HitPos) <= 100 * 100 then
        local HasTur = false

        for k, v in pairs(ents.FindByClass("lfs_vanilla_portableturret")) do
            if v:GetOwner() == Own then
                HasTur = true
                break
            end
        end

        if not HasTur then
            Own:PrintMessage(3, "You deploy the turret")
            local ent = ents.Create("lfs_vanilla_portableturret")
            ent:SetPos(tr.HitPos + Vector(0, 0, 40))
            ent:SetAngles(Angle(0, Own:GetAngles().y, 0))
            ent:Spawn()
            ent:DropToFloor()
            ent:SetOwner(Own)
        else
            Own:PrintMessage(3, "You already have a turret deployed")
        end
    else
        Own:PrintMessage(3, "You need to place the turret closer to you")
    end
end

--function SWEP:SecondaryAttack()
--    if (not SERVER) then return end
--    local tr = self.Owner:GetEyeTrace()
--
--    if IsValid(tr.Entity) then
--        if (tr.Entity:GetOwner() == self.Owner) and (tr.Entity:GetClass() == "lfs_vanilla_portableturret") then
--            self.Owner:PrintMessage(3, "You pack up the turret")
--            tr.Entity:Remove()
--        end
--    end
--end

function SWEP:SecondaryAttack()
    if (not SERVER) then return end

    for k, v in pairs(ents.FindByClass("lfs_vanilla_portableturret")) do
        if v:GetOwner() == self.Owner then
            SafeRemoveEntity(v)
            self.Owner:ChatPrint("Turret Packed up")
            return
        end
    end
    self.Owner:ChatPrint("You do not have an active Turret!")
end