local PLAYER = FindMetaTable("Player")

-- Misc --
function PLAYER:QUEST_SYSTEM_ChatNotify(strType, strMsg)
    net.Start("QUEST_SYSTEM_ChatNotify_Player")
    net.WriteString(strType)
    net.WriteString(strMsg)
    net.Send(self)
end

-- Quest --
function PLAYER:QUEST_SYSTEM_Quest_Accept(strQuest_ID)
    if not (QUEST_SYSTEM.Quests[strQuest_ID]) then return end
    if not (QUEST_SYSTEM.AvailableQuests[strQuest_ID]) then return end
    if (self.QUEST_SYSTEM_ActiveQuest) then
        self:QUEST_SYSTEM_ChatNotify("Missions", "You already have an active mission!")

        return
    end

    QUEST_SYSTEM.Quests[strQuest_ID]:OnStarted(self, strQuest_ID, true)
end

function PLAYER:QUEST_SYSTEM_Quest_Finish()
    if (self.QUEST_SYSTEM_ActiveQuest) then
        local reward = QUEST_SYSTEM.Quests[self.QUEST_SYSTEM_ActiveQuest]["Reward"]
        //if self:GetNWInt("igprogressp", 0) >= 2 then
        //    reward = reward * 1.3
        //end
        local qid = QUEST_SYSTEM.Quests[self.QUEST_SYSTEM_ActiveQuest]["ID"]

        if (reward and reward > 0) then
            self:SH_AddPremiumPoints(reward, nil, false, false)
            self:QUEST_SYSTEM_ChatNotify("Missions", "You have been rewarded: " .. reward .. " credits")
        elseif (reward and reward <= 0) then
            self:QUEST_SYSTEM_ChatNotify("Missions", "There was no reward for this mission!")
        else
            self:QUEST_SYSTEM_ChatNotify("Missions", "ERROR: See Kumo")
        end
        //IGHALLOWEEN:UpdatePoints(self:GetNWString("halloweenteam"),1,self,"completing a mission")
        //self:ProgressQuest("Missions", 1)
        //self:ProgressQuest("Missions", 2)
        //self:ProgressQuest("Missions", 3)
        //if string.match(qid,"carry") then
        //    self:ProgressQuest("Carry Missions", 1)
        //    self:ProgressQuest("Carry Missions", 2)
        //    self:ProgressQuest("Carry Missions", 3)
        //end
        //if string.match(qid,"retrieval") then
        //    self:ProgressQuest("Collection Missions", 1)
        //    self:ProgressQuest("Collection Missions", 2)
        //    self:ProgressQuest("Collection Missions", 3)
        //end
        _G.AdvanceQuest(self,"Daily","Logistics Connoisseur I")
        _G.AdvanceQuest(self,"Daily","Logistics Connoisseur II")
        _G.AdvanceQuest(self,"Weekly","Logistics Lord")

        QUEST_SYSTEM.Quests[self.QUEST_SYSTEM_ActiveQuest]:OnFinished(self)
    end
end

function PLAYER:QUEST_SYSTEM_Quest_Abort()
    if (self.QUEST_SYSTEM_ActiveQuest) then
        local penalty = QUEST_SYSTEM.Quests[self.QUEST_SYSTEM_ActiveQuest]["Penalty"]

        if (penalty and penalty > 0) then
            self:SH_AddPremiumPoints(penalty * -1, nil, false, false)
            self:QUEST_SYSTEM_ChatNotify("Missions", "You have been penalized for: " .. penalty .. " credits due to your failure.")

            if self:SH_GetPremiumPoints() < 0 then
                self:SH_SetPremiumPoints(0, nil, false, false)
            end
        elseif (penalty and penalty <= 0) then
            self:QUEST_SYSTEM_ChatNotify("Missions", "There was no penalty for this mission!")
        else
            self:QUEST_SYSTEM_ChatNotify("Missions", "ERROR: See Kumo")
        end

        QUEST_SYSTEM.Quests[self.QUEST_SYSTEM_ActiveQuest]:OnAborted(self)
    end
end

function PLAYER:QUEST_SYSTEM_Quest_UpdateQuest(strQuest_ID)
    self.QUEST_SYSTEM_ActiveQuest = strQuest_ID
    net.Start("QUEST_SYSTEM_Quest_Client")
    net.WriteString(strQuest_ID)
    net.Send(self)
end

function PLAYER:QUEST_SYSTEM_Quest_UpdateProgress(numProgress)
    self.QUEST_SYSTEM_QuestProgress = numProgress
    net.Start("QUEST_SYSTEM_Quest_Progress")
    net.WriteInt(numProgress, 32)
    net.Send(self)
end
