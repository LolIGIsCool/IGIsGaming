AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/griim/christmas/present_colourable.mdl")
    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetUseType(SIMPLE_USE)
    self:DrawShadow(false)
    self:SetOpened(false)
end

function ENT:Use(activator, caller)
    if caller:GetNWFloat("forcejumptime",0) >= CurTime() then caller:ChatPrint("fuck off dog") return end
    if (caller:IsPlayer() and caller:Alive() and not self:GetOpened()) then
        self:SetOpened(true)
        local reward = self:GetReward()

        for k, v in pairs(player.GetAll()) do
            v:QUEST_SYSTEM_ChatNotify("Presents", caller:Nick() .. " has found a present and won " .. IGPresentTable[reward]["Text"] .. " [" .. IGPresentTable[reward]["Chance"] .. "% chance]")
        end
        print("[IG-PRESENTS] "..caller:Nick() .. " has found a present and won " .. IGPresentTable[reward]["Text"] .. " [" .. IGPresentTable[reward]["Chance"] .. "% chance]")

        file.Append("presentslog.txt", "\n[" .. os.date('%d-%m-%Y - %I:%M:%S %p', os.time()) .. "] " ..caller:Nick() .. " has found a present and won " .. IGPresentTable[reward]["Text"] .. " [" .. IGPresentTable[reward]["Chance"] .. "% chance]")
        
        local rewardtype = IGPresentTable[reward]["Type"]

        if rewardtype == "credits" then
            caller:SH_AddPremiumPoints(IGPresentTable[reward]["Amount"], nil, false, false)
        elseif rewardtype == "points" then
            caller:SH_AddPremiumPoints(IGPresentTable[reward]["Amount"], nil, false, false)
        elseif rewardtype == "xp" then
            SimpleXPAddXPText(caller, IGPresentTable[reward]["Amount"], "PRESENT REWARD", true)
        elseif rewardtype == "special" then
            caller:SH_AddItem("candy_cane", false, false)
        else
            caller:QUEST_SYSTEM_ChatNotify("Presents", "Invalid Reward")
        end

        timer.Simple(0.01, function()
            ParticleEffectAttach("mortar_burst_halloween_demon", PATTACH_POINT, self, 2)
        end)

        sound.Play("fireworks/mortar_fire.wav", self:GetPos(), 75, 100, 1)
        sound.Play("items/ammocrate_open.wav", self:GetPos(), 75, 100, 1)

        timer.Simple(2, function()
            self:Remove()
        end)
    end
end

local function PresentItemPickup(ply, ent)
    if (ent:GetClass():lower() == "ig_present") then return false end
end

hook.Add("PhysgunPickup", "StopPresentITEMPickup", PresentItemPickup)