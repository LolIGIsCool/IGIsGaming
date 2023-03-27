AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_lab/binderblue.mdl") -- placeholder
    self:SetSolid(SOLID_BBOX)
    self:PhysicsInit(SOLID_BBOX)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetUseType(SIMPLE_USE)
    self:SetTrigger(true)
    self:DrawShadow(false)
    self:SetQuestID("NULL") -- placeholder
end

function ENT:StartTouch(theentity)
    if (theentity:IsPlayer() and theentity:Alive() and theentity.QUEST_SYSTEM_ActiveQuest == self:GetQuestID()) then
        local strQuest_ID = self:GetQuestID()
        if (QUEST_SYSTEM.Quests[strQuest_ID] and theentity.QUEST_SYSTEM_QuestProgress >= QUEST_SYSTEM.Quests[strQuest_ID]["Amount"]) then return end
        theentity:QUEST_SYSTEM_Quest_UpdateProgress(theentity.QUEST_SYSTEM_QuestProgress + 1)
        theentity:QUEST_SYSTEM_ChatNotify("Quest", "Picked up '" .. self:GetItemName() .. "' for quest '" .. QUEST_SYSTEM.Quests[theentity.QUEST_SYSTEM_ActiveQuest]["Name"] .. "'.")

        if (theentity.QUEST_SYSTEM_QuestProgress >= QUEST_SYSTEM.Quests[theentity.QUEST_SYSTEM_ActiveQuest]["Amount"]) then
            theentity:QUEST_SYSTEM_Quest_Finish()
        end

        QUEST_SYSTEM.Quest_RespawnItem(strQuest_ID)
        self:EmitSound("npc/turret_floor/ping.wav")
        self:Remove()
    end
end

local function QuestItemPickup(ply, ent)
    if (ent:GetClass():lower() == "quest_item") then return false end
end

hook.Add("PhysgunPickup", "StopQuestITEMPickup", QuestItemPickup)

local function CarryItemPickup(ply, ent)
    if (ent:GetClass():lower() == "carry_item") then return false end
end

hook.Add("PhysgunPickup", "StopCarryITEMPickup", CarryItemPickup)