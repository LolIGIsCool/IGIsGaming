

SWEP.PrintName      = "Passive Event Tool"
SWEP.Author	        = "Oliver (wiltOS)"
SWEP.Instructions   = "Reload: Open Menu"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Slot			= 1
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.Category = "[wOS] Passive Event"

SWEP.ViewModel			= "models/weapons/v_toolgun.mdl"
SWEP.WorldModel			= "models/weapons/w_toolgun.mdl"

function SWEP:Reload()
    if self.Owner:KeyPressed(IN_RELOAD) then
        if (self.firstReload || 0 ) < CurTime() then
            self.firstReload = CurTime() + 1
            wOS.PES.OpenMenu()
        end
    end
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end

    if wOS.PES.IsEditingVar() then
        local element = wOS.PES.GetEditingVar()

        local varTable = element.varTable
        local varType = wOS.PES.Vars:Get(varTable.Type)
        if varType and varType.PrimaryAttack then
            varType.PrimaryAttack(self, self.Owner, element)
        end
    end
    return true
end

function SWEP:SecondaryAttack()
    if not IsFirstTimePredicted() then return end

    if wOS.PES.IsEditingVar() then
        local element = wOS.PES.GetEditingVar()

        local varTable = element.varTable
        local varType = wOS.PES.Vars:Get(varTable.Type)
        if varType and varType.SecondaryAttack then
            varType.SecondaryAttack(self, self.Owner, element)
        end
    end
    return true
end

function SWEP:DrawHUD()
    if wOS.PES.IsEditingVar() then
        draw.SimpleText("Editing Variable","DermaLarge", ScrW()/2, ScrH()- 100, color_white, 1)

        local element = wOS.PES.GetEditingVar()

        local varTable = element.varTable
        local varType = wOS.PES.Vars:Get(varTable.Type)
        if varType and varType.DrawHUD then
            varType.DrawHUD(self, self.Owner, element)
        end

    end
end

hook.Add("PostDrawOpaqueRenderables", "wOS.CombatSim.EditingVar", function()
	local ply = LocalPlayer()

	local weapon = ply:GetActiveWeapon()
	if not (IsValid(weapon) and weapon:GetClass() == "pes_tool") then return end

    if wOS.PES.IsEditingVar() then
        local element = wOS.PES.GetEditingVar()

        local varTable = element.varTable
        local varType = wOS.PES.Vars:Get(varTable.Type)
        if varType and varType.Draw3D then
            varType.Draw3D(weapon, weapon.Owner, element)
        end
    end
end)
