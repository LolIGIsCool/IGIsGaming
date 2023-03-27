AddCSLuaFile()
SWEP.VElements = {
	["bacter"] = { type = "Model", model = "models/ig/mandem/bacter_stim.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(-0.5, -0.601, 1.1), angle = Angle(-78.312, 0, 28), size = Vector(1.299, 1.299, 1.299), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["bacter_world"] = { type = "Model", model = "models/ig/mandem/bacter_stim.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.5, 1.399, 1), angle = Angle(-75.974, 3.506, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.HoldType = "slam"
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/starwars/items/bacta_small.mdl"
--SWEP.WorldModel = ""
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0.071, 0, 0) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-0.673, -1.879, 0) },
	["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1.003, 1.003, 1.003), pos = Vector(0, 0, 0), angle = Angle(-37.258, 52.847, 4.78) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(-3.245, 2.427, 0), angle = Angle(14.444, -16.667, 50) }
}

SWEP.PrintName = "Bacta Injector"
SWEP.Author = "robotboy655 & Riddick"
SWEP.Purpose = "Heal people with your primary attack, or yourself with the secondary. Provide ammo with Reload"
SWEP.Slot = 3
SWEP.SlotPos = 3
SWEP.Spawnable = true
--SWEP.ViewModel                = Model( "models/weapons/c_medkit.mdl" )
--SWEP.WorldModel               = Model( "models/weapons/w_medkit.mdl" )
SWEP.ViewModelFOV = 65
SWEP.UseHands = true
SWEP.Primary.ClipSize = 1000
SWEP.Primary.DefaultClip = 1000
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.HealAmount = 50 -- Maximum heal amount per use
SWEP.MaxAmmo = 200 -- Maxumum ammo
local HealSound = Sound("HealthKit.Touch")
local DenySound = Sound("WallHealth.Deny")

function SWEP:Initialize()
    self:SetHoldType("slam")

    --self.Owner:GetViewModel( ):SetMaterial( "materials/reskin/healthkit01.vtf" )
    if (CLIENT) then
        -- Create a new table for every weapon instance
        self.VElements = table.FullCopy(self.VElements)
        self.WElements = table.FullCopy(self.WElements)
        self.ViewModelBoneMods = table.FullCopy(self.ViewModelBoneMods)
        self:CreateModels(self.VElements) -- create viewmodels
        self:CreateModels(self.WElements) -- create worldmodels

        -- init view model bone build function
        if IsValid(self.Owner) then
            local vm = self.Owner:GetViewModel()

            if IsValid(vm) then
                self:ResetBonePositions(vm)

                -- Init viewmodel visibility
                if (self.ShowViewModel == nil or self.ShowViewModel) then
                    vm:SetColor(Color(255, 255, 255, 255))
                else
                    -- we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
                    vm:SetColor(Color(255, 255, 255, 1))
                    -- ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
                    -- however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
                    vm:SetMaterial("Debug/hsv")
                end
            end
        end
    end

    timer.Create("medkit_ammo" .. self:EntIndex(), .2, 0, function()
        if (self:Clip1() < self.MaxAmmo) then
            self:SetClip1(math.min(self:Clip1() + 100, self.MaxAmmo))
        end
    end)
end

-- Kumo & Moose
if (SERVER) then
    hook.Add("EntityTakeDamage", "CheckMedicDamage", function(target, damage)
        if (target:IsPlayer() and target:GetActiveWeapon():IsValid() and target:HasWeapon("weapon_bactainjector")) then
            target.dmgtime = CurTime() + 10
        end
    end)
end

function SWEP:PrimaryAttack()
    if (CLIENT) then return end

    local tr = util.TraceLine({
        start = self.Owner:GetShootPos(),
        endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 128,
        filter = self.Owner
    })

    local ent = tr.Entity
    local need

    -- was 0.25
    if (IsValid(ent)) then
        need = math.min(ent:GetMaxHealth() - ent:Health(), ent:GetMaxHealth() * .20)
    end

    if (IsValid(ent) and self:Clip1() >= 50 and (ent:IsPlayer() or ent:IsNPC()) and ent:Health() < ent:GetMaxHealth()) then
        self:TakePrimaryAmmo(50)

        if _G.HasAugment(ent, "Heal Intake II") then
            need = need * 1.2
            _G.ActivateAugment(ent, "Heal Intake II", 2)
        elseif _G.HasAugment(ent, "Heal Intake I") then
            need = need * 1.1
            _G.ActivateAugment(ent, "Heal Intake I", 2)
        end

        for i = 1, need do
			_G.AdvanceQuest(ent,"Daily","Redemption I");
            _G.AdvanceQuest(ent,"Daily","Redemption II");
            _G.AdvanceQuest(ent,"Daily","Redemption III");
		end

        ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + need))

        if _G.HasAugment(ent, "Swift Recovery") then
            local extraheal = math.random(10, 50)
            local healspersecond = extraheal / 5
            _G.ActivateAugment(ent, "Swift Recovery", 5)

            timer.Create("healperk" .. math.random(1, 9999), 1, 5, function()
                if ent:Health() >= ent:GetMaxHealth() then return end
                local healthtoset = ent:Health() + healspersecond
                ent:SetHealth(healthtoset)
            end)
        end

        if ent.brokenleg then
            ent:ChatPrint("Your broken leg has been healed by the power of bacta!")
            ent.brokenleg = false
            self.Owner:ChatPrint("You have healed this players broken leg.")
            local movespeed = ent:GetJobTable().WalkSpeed
            ent:SetWalkSpeed(movespeed)

            ApplySpeedBoosters(ent)
        end

        hook.Call("healfrombacta", GAMEMODE, self.Owner, need, ent)
        ent:EmitSound(HealSound)
        self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0)
        self.Owner:SetAnimation(PLAYER_ATTACK1)

        -- Even though the viewmodel has looping IDLE anim at all times, we need this to make fire animation work in multiplayer
        timer.Create("weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function()
            if (IsValid(self)) then
                self:SendWeaponAnim(ACT_VM_IDLE)
            end
        end)
    else
        if ent:IsPlayer() and ent.brokenleg then
            ent:ChatPrint("Your broken leg has been healed by the power of bacta!")
            ent.brokenleg = false
            self.Owner:ChatPrint("You have healed this players broken leg.")
            local movespeed = ent:GetJobTable().WalkSpeed

            ent:SetWalkSpeed(movespeed)

            _G.ApplySpeedBoosters(ent)

            ent:EmitSound(HealSound)
        else
            self.Owner:EmitSound(DenySound)
        end

        self:SetNextPrimaryFire(CurTime() + .035) -- Was 0.1
    end
end

function SWEP:Reload()
    if (CLIENT) then return end
    local me = self.Owner
    me:GiveAmmo(1000, "AR2", false)
end

function SWEP:SecondaryAttack()
    if (CLIENT) then return end
    local ent = self.Owner

    if CurTime() < ent.dmgtime then
        ent:ChatPrint("You cannot heal yourself within 10 seconds of taking damage!")
        ent:ChatPrint("Time left: " .. string.ToMinutesSeconds(ent.dmgtime - CurTime()))

        return
    end

    --print (ent:GetMaxHealth())
    local need

    -- was 0.1
    if (IsValid(ent)) then
        need = ent:GetMaxHealth() * .05
    end

    if (IsValid(ent) and self:Clip1() >= need and ent:Health() < ent:GetMaxHealth()) then
        self:TakePrimaryAmmo(need)

        if _G.HasAugment(ent, "Heal Intake II") then
            need = need * 1.2
            _G.ActivateAugment(ent, "Heal Intake II", 2)
        elseif _G.HasAugment(ent, "Heal Intake I") then
            need = need * 1.1
            _G.ActivateAugment(ent, "Heal Intake I", 2)
        end

        for i = 1, need do
			_G.AdvanceQuest(ent,"Daily","Redemption I");
            _G.AdvanceQuest(ent,"Daily","Redemption II");
            _G.AdvanceQuest(ent,"Daily","Redemption III");
		end

        ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + need))
        ent:EmitSound(HealSound)
        self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        --self:SetNextSecondaryFire( CurTime() + self:SequenceDuration() + 1 )
        self:SetNextSecondaryFire(CurTime() + 1)
        self.Owner:SetAnimation(PLAYER_ATTACK1)

        if ent:IsPlayer() and ent.brokenleg then
            ent.brokenleg = false
            self.Owner:ChatPrint("Your broken leg has been healed by the power of bacta!")
            local movespeed = ent:GetJobTable().WalkSpeed

            ent:SetWalkSpeed(movespeed)

            _G.ApplySpeedBoosters(ent)

            ent:EmitSound(HealSound)
        else
            self.Owner:EmitSound(DenySound)
        end

        timer.Create("weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function()
            if (IsValid(self)) then
                self:SendWeaponAnim(ACT_VM_IDLE)
            end
        end)
    else
        ent:EmitSound(DenySound)
        self:SetNextSecondaryFire(CurTime() + 1)
    end
end

function SWEP:OnRemove()
    timer.Stop("medkit_ammo" .. self:EntIndex())
    timer.Stop("weapon_idle" .. self:EntIndex())
    self:Holster()
end

function SWEP:Holster()
    if CLIENT and IsValid(self.Owner) then
        local vm = self.Owner:GetViewModel()

        if IsValid(vm) then
            self:ResetBonePositions(vm)
        end
    end

    timer.Stop("weapon_idle" .. self:EntIndex())

    return true
end

function SWEP:CustomAmmoDisplay()
    self.AmmoDisplay = self.AmmoDisplay or {}
    self.AmmoDisplay.Draw = true
    self.AmmoDisplay.PrimaryClip = self:Clip1()

    return self.AmmoDisplay
end

if CLIENT then
    SWEP.vRenderOrder = nil

    function SWEP:ViewModelDrawn()
        local vm = self.Owner:GetViewModel()
        if not IsValid(vm) then return end
        if (not self.VElements) then return end
        self:UpdateBonePositions(vm)

        if (not self.vRenderOrder) then
            -- we build a render order because sprites need to be drawn after models
            self.vRenderOrder = {}

            for k, v in pairs(self.VElements) do
                if (v.type == "Model") then
                    table.insert(self.vRenderOrder, 1, k)
                elseif (v.type == "Sprite" or v.type == "Quad") then
                    table.insert(self.vRenderOrder, k)
                end
            end
        end

        for k, name in ipairs(self.vRenderOrder) do
            local v = self.VElements[name]

            if (not v) then
                self.vRenderOrder = nil
                break
            end

            if (v.hide) then continue end
            local model = v.modelEnt
            local sprite = v.spriteMaterial
            if (not v.bone) then continue end
            local pos, ang = self:GetBoneOrientation(self.VElements, v, vm)
            if (not pos) then continue end

            if (v.type == "Model" and IsValid(model)) then
                model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
                ang:RotateAroundAxis(ang:Up(), v.angle.y)
                ang:RotateAroundAxis(ang:Right(), v.angle.p)
                ang:RotateAroundAxis(ang:Forward(), v.angle.r)
                model:SetAngles(ang)
                --model:SetModelScale(v.size)
                local matrix = Matrix()
                matrix:Scale(v.size)
                model:EnableMatrix("RenderMultiply", matrix)

                if (v.material == "") then
                    model:SetMaterial("")
                elseif (model:GetMaterial() ~= v.material) then
                    model:SetMaterial(v.material)
                end

                if (v.skin and v.skin ~= model:GetSkin()) then
                    model:SetSkin(v.skin)
                end

                if (v.bodygroup) then
                    for k, v in pairs(v.bodygroup) do
                        if (model:GetBodygroup(k) ~= v) then
                            model:SetBodygroup(k, v)
                        end
                    end
                end

                if (v.surpresslightning) then
                    render.SuppressEngineLighting(true)
                end

                render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
                render.SetBlend(v.color.a / 255)
                model:DrawModel()
                render.SetBlend(1)
                render.SetColorModulation(1, 1, 1)

                if (v.surpresslightning) then
                    render.SuppressEngineLighting(false)
                end
            elseif (v.type == "Sprite" and sprite) then
                local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
                render.SetMaterial(sprite)
                render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
            elseif (v.type == "Quad" and v.draw_func) then
                local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
                ang:RotateAroundAxis(ang:Up(), v.angle.y)
                ang:RotateAroundAxis(ang:Right(), v.angle.p)
                ang:RotateAroundAxis(ang:Forward(), v.angle.r)
                cam.Start3D2D(drawpos, ang, v.size)
                v.draw_func(self)
                cam.End3D2D()
            end
        end
    end

    --[[*************************
        Global utility code
    *************************]]
    -- Fully copies the table, meaning all tables inside this table are copied too and so on (normal table.Copy copies only their reference).
    -- Does not copy entities of course, only copies their reference.
    -- WARNING: do not use on tables that contain themselves somewhere down the line or you'll get an infinite loop
    function table.FullCopy(tab)
        if (not tab) then return nil end
        local res = {}

        for k, v in pairs(tab) do
            if (type(v) == "table") then
                res[k] = table.FullCopy(v) -- recursion ho!
            elseif (type(v) == "Vector") then
                res[k] = Vector(v.x, v.y, v.z)
            elseif (type(v) == "Angle") then
                res[k] = Angle(v.p, v.y, v.r)
            else
                res[k] = v
            end
        end

        return res
    end
end

SWEP.wRenderOrder = nil

function SWEP:DrawWorldModel()
    if (self.ShowWorldModel == nil or self.ShowWorldModel) then
        self:DrawModel()
    end

    if (not self.WElements) then return end

    if (not self.wRenderOrder) then
        self.wRenderOrder = {}

        for k, v in pairs(self.WElements) do
            if (v.type == "Model") then
                table.insert(self.wRenderOrder, 1, k)
            elseif (v.type == "Sprite" or v.type == "Quad") then
                table.insert(self.wRenderOrder, k)
            end
        end
    end

    if (IsValid(self.Owner)) then
        bone_ent = self.Owner
    else
        -- when the weapon is dropped
        bone_ent = self
    end

    for k, name in pairs(self.wRenderOrder) do
        local v = self.WElements[name]

        if (not v) then
            self.wRenderOrder = nil
            break
        end

        if (v.hide) then continue end
        local pos, ang

        if (v.bone) then
            pos, ang = self:GetBoneOrientation(self.WElements, v, bone_ent)
        else
            pos, ang = self:GetBoneOrientation(self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand")
        end

        if (not pos) then continue end
        local model = v.modelEnt
        local sprite = v.spriteMaterial

        if (v.type == "Model" and IsValid(model)) then
            model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
            ang:RotateAroundAxis(ang:Up(), v.angle.y)
            ang:RotateAroundAxis(ang:Right(), v.angle.p)
            ang:RotateAroundAxis(ang:Forward(), v.angle.r)
            model:SetAngles(ang)
            --model:SetModelScale(v.size)
            local matrix = Matrix()
            matrix:Scale(v.size)
            model:EnableMatrix("RenderMultiply", matrix)

            if (v.material == "") then
                model:SetMaterial("")
            elseif (model:GetMaterial() ~= v.material) then
                model:SetMaterial(v.material)
            end

            if (v.skin and v.skin ~= model:GetSkin()) then
                model:SetSkin(v.skin)
            end

            if (v.bodygroup) then
                for k, v in pairs(v.bodygroup) do
                    if (model:GetBodygroup(k) ~= v) then
                        model:SetBodygroup(k, v)
                    end
                end
            end

            if (v.surpresslightning) then
                render.SuppressEngineLighting(true)
            end

            render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
            render.SetBlend(v.color.a / 255)
            model:DrawModel()
            render.SetBlend(1)
            render.SetColorModulation(1, 1, 1)

            if (v.surpresslightning) then
                render.SuppressEngineLighting(false)
            end
        elseif (v.type == "Sprite" and sprite) then
            local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
            render.SetMaterial(sprite)
            render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
        elseif (v.type == "Quad" and v.draw_func) then
            local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
            ang:RotateAroundAxis(ang:Up(), v.angle.y)
            ang:RotateAroundAxis(ang:Right(), v.angle.p)
            ang:RotateAroundAxis(ang:Forward(), v.angle.r)
            cam.Start3D2D(drawpos, ang, v.size)
            v.draw_func(self)
            cam.End3D2D()
        end
    end
end

function SWEP:GetBoneOrientation(basetab, tab, ent, bone_override)
    local bone, pos, ang

    if (tab.rel and tab.rel ~= "") then
        local v = basetab[tab.rel]
        if (not v) then return end
        -- Technically, if there exists an element with the same name as a bone
        -- you can get in an infinite loop. Let's just hope nobody's that stupid.
        pos, ang = self:GetBoneOrientation(basetab, v, ent)
        if (not pos) then return end
        pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
        ang:RotateAroundAxis(ang:Up(), v.angle.y)
        ang:RotateAroundAxis(ang:Right(), v.angle.p)
        ang:RotateAroundAxis(ang:Forward(), v.angle.r)
    else
        bone = ent:LookupBone(bone_override or tab.bone)
        if (not bone) then return end
        pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
        local m = ent:GetBoneMatrix(bone)

        if (m) then
            pos, ang = m:GetTranslation(), m:GetAngles()
        end

        if (IsValid(self.Owner) and self.Owner:IsPlayer() and ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
            ang.r = -ang.r -- Fixes mirrored models
        end
    end

    return pos, ang
end

function SWEP:CreateModels(tab)
    if (not tab) then return end

    -- Create the clientside models here because Garry says we can't do it in the render hook
    for k, v in pairs(tab) do
        if (v.type == "Model" and v.model and v.model ~= "" and (not IsValid(v.modelEnt) or v.createdModel ~= v.model) and string.find(v.model, ".mdl") and file.Exists(v.model, "GAME")) then
            v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)

            if (IsValid(v.modelEnt)) then
                v.modelEnt:SetPos(self:GetPos())
                v.modelEnt:SetAngles(self:GetAngles())
                v.modelEnt:SetParent(self)
                v.modelEnt:SetNoDraw(true)
                v.createdModel = v.model
            else
                v.modelEnt = nil
            end
        elseif (v.type == "Sprite" and v.sprite and v.sprite ~= "" and (not v.spriteMaterial or v.createdSprite ~= v.sprite) and file.Exists("materials/" .. v.sprite .. ".vmt", "GAME")) then
            local name = v.sprite .. "-"

            local params = {
                ["$basetexture"] = v.sprite
            }

            -- make sure we create a unique name based on the selected options
            local tocheck = {"nocull", "additive", "vertexalpha", "vertexcolor", "ignorez"}

            for i, j in pairs(tocheck) do
                if (v[j]) then
                    params["$" .. j] = 1
                    name = name .. "1"
                else
                    name = name .. "0"
                end
            end

            v.createdSprite = v.sprite
            v.spriteMaterial = CreateMaterial(name, "UnlitGeneric", params)
        end
    end
end

local allbones
local hasGarryFixedBoneScalingYet = false

function SWEP:UpdateBonePositions(vm)
    if self.ViewModelBoneMods then
        if (not vm:GetBoneCount()) then return end
        -- !! WORKAROUND !! //
        -- We need to check all model names :/
        local loopthrough = self.ViewModelBoneMods

        if (not hasGarryFixedBoneScalingYet) then
            allbones = {}

            for i = 0, vm:GetBoneCount() do
                local bonename = vm:GetBoneName(i)

                if (self.ViewModelBoneMods[bonename]) then
                    allbones[bonename] = self.ViewModelBoneMods[bonename]
                else
                    allbones[bonename] = {
                        scale = Vector(1, 1, 1),
                        pos = Vector(0, 0, 0),
                        angle = Angle(0, 0, 0)
                    }
                end
            end

            loopthrough = allbones
        end

        -- !! ----------- !! //
        for k, v in pairs(loopthrough) do
            local bone = vm:LookupBone(k)
            if (not bone) then continue end
            -- !! WORKAROUND !! //
            local s = Vector(v.scale.x, v.scale.y, v.scale.z)
            local p = Vector(v.pos.x, v.pos.y, v.pos.z)
            local ms = Vector(1, 1, 1)

            if (not hasGarryFixedBoneScalingYet) then
                local cur = vm:GetBoneParent(bone)

                while (cur >= 0) do
                    local pscale = loopthrough[vm:GetBoneName(cur)].scale
                    ms = ms * pscale
                    cur = vm:GetBoneParent(cur)
                end
            end

            s = s * ms

            -- !! ----------- !! //
            if vm:GetManipulateBoneScale(bone) ~= s then
                vm:ManipulateBoneScale(bone, s)
            end

            if vm:GetManipulateBoneAngles(bone) ~= v.angle then
                vm:ManipulateBoneAngles(bone, v.angle)
            end

            if vm:GetManipulateBonePosition(bone) ~= p then
                vm:ManipulateBonePosition(bone, p)
            end
        end
    else
        self:ResetBonePositions(vm)
    end
end

function SWEP:ResetBonePositions(vm)
    if (not vm:GetBoneCount()) then return end

    for i = 0, vm:GetBoneCount() do
        vm:ManipulateBoneScale(i, Vector(1, 1, 1))
        vm:ManipulateBoneAngles(i, Angle(0, 0, 0))
        vm:ManipulateBonePosition(i, Vector(0, 0, 0))
    end
end

local dist = 600^2 					-- The distance (squared) at which players are tracked

local function LerpColor(frac,from,to)
    local col = Color(
        Lerp(frac,from.r,to.r),
        Lerp(frac,from.g,to.g),
        Lerp(frac,from.b,to.b),
        Lerp(frac,from.a,to.a)
    )
    return col
end

local function LerpColours(frac,colTable)
    local cUnit = 1 / #colTable;

    if (frac <= 0) then frac = 0.001; end

    return LerpColor(frac % cUnit / cUnit, colTable[math.Clamp(math.floor(frac / cUnit),1,3)], colTable[math.Clamp(math.ceil(frac / cUnit),1,3)]);
end

local healthColours = {
        Color(202, 66, 75, 255), //red
        Color(255, 140, 69, 255), //orange
        Color(25, 255, 125, 255) //green
}

function SWEP:DrawHUD()
    for _, v in ipairs(player.GetAll()) do
        if not v:IsValid() then continue end
        if LocalPlayer():GetPos():DistToSqr(v:GetPos()) > dist then continue end --distance check
        if v == LocalPlayer() or not v:Alive() then continue end --self check and alive check
        if v:GetMoveType() == MOVETYPE_NOCLIP or v:GetNWBool("CamoEnabled", false) then continue end --cloak check

        --generate health colour
        local col;
        if (v:Health() > v:GetMaxHealth()) then
            col = Color(95, 195, 220, 255);
        else
            col = LerpColours(v:Health() / v:GetMaxHealth(), healthColours);
        end

        local haloTable = { v };
        halo.Add( haloTable, col, 1, 1, 1, true, false );
    end
end