include('shared.lua')
 
SWEP.PrintName          = "Hideyoshi's Defibrillator"
SWEP.Slot               = 5
SWEP.SlotPos            = 1
SWEP.DrawAmmo           = false
SWEP.DrawCrosshair      = true

hook.Add("HUDPaint", "Hideyoshi_DrawIGDefibHUD", function()
    local isDefib = LocalPlayer():GetActiveWeapon().PrintName == "Hideyoshi's Defibrillator"
    if isDefib then
        for k, v in pairs(ents.GetAll()) do
            local otherply = v:GetRagdollOwner()

            if v:GetClass() == "class C_HL2MPRagdoll" then
                local dist = LocalPlayer():GetPos():Distance(v:GetPos())

                if dist <= 500 then
                    cam.Start2D()
                        local bodyPos = v:GetPos()
                        local heartPos = (bodyPos + Vector(0, 0, 30 + dist / 20)):ToScreen()
                        heartPos.x = heartPos.x - (28 - (dist / 100))
                        surface.SetDrawColor(255, 255, 255, 255)
                        surface.SetMaterial(Material("vgui/revive.png"))
                        local size = math.Round(math.max(80 - (dist / 100) * 4.2, 5))
                        surface.DrawTexturedRect(heartPos.x, heartPos.y, size, size)
                    cam.End2D()
                end
            end
        end
    end
end)

net.Receive("Hideyoshi_BeginDefibSearch", function()
    for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 164)) do
        if v:GetClass() == "class C_HL2MPRagdoll" and LocalPlayer():GetPos():Distance(v:GetPos()) <= 80 and LocalPlayer():GetEyeTrace().HitPos:Distance(v:GetPos()) < 80 then
            net.Start("Hideyoshi_BeginDefib")
                net.WriteEntity(v:GetRagdollOwner())
            net.SendToServer()
            break
        elseif table.Count(ents.FindInSphere(LocalPlayer():GetPos(), 164)) == k then
            chat.AddText(Color(255, 0, 0), "ERROR 34B - SUBJECT INVALID")
        end
    end
end)

net.Receive("Hideyoshi_defibfx", function(len)
    local globalwep = weapons.GetStored("weapon_defibrillator")
    local ent = net.ReadEntity()
    local entpos = net.ReadVector()
    local fx = net.ReadString()
    local ply = net.ReadEntity()

    if fx == "spark" then
        local sparkData = EffectData()
        sparkData:SetStart(LocalPlayer():GetShootPos() + LocalPlayer():GetForward(50))
        sparkData:SetEntity(LocalPlayer())
        sparkData:SetOrigin(entpos)
        util.Effect("StunstickImpact", sparkData)
    end
end)

