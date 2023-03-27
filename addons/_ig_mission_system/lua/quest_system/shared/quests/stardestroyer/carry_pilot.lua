QUEST.Name = "Pilots Pet"
QUEST.Instruction = "Take this pilot gear to the TIE bays." -- %s will equal the amount
QUEST.Info = "Take the pilot gear to the TIE bays, look for the blue sphere."
QUEST.Reward = 200 -- credit reward
QUEST.Time = 120 -- how long, in seconds, a player has to complete the quest. 0 = infinite
QUEST.Amount = 1 -- how many actions required to complete quest
QUEST.Penalty = 20 -- penalty reward

QUEST.CarryItem = {
    ["Name"] = "Pilot Gear",
    ["Model"] = "models/kingpommes/emperors_tower/imp_crates/imp_crate_single_closed_static.mdl"
}

-- called when a player accepts the quest
function QUEST:OnStarted(player, strQuest_ID, acceptedOnline)
    if (acceptedOnline) then
        QUEST_SYSTEM.AvailableQuests[strQuest_ID] = nil
        net.Start("QUEST_SYSTEM_Quest_Remove")
        net.WriteString(strQuest_ID)
        net.Broadcast()
    end

    local carryitem = ents.Create("carry_item")
    carryitem:SetPos(player:GetPos() + Vector(0, 0, 50))
    carryitem:SetNWString("carryentid", player:SteamID64())
    carryitem:SetNWString("carryentname", QUEST_SYSTEM.Quests[strQuest_ID]["CarryItem"]["Name"])
    carryitem:SetNWString("carryentmodel", QUEST_SYSTEM.Quests[strQuest_ID]["CarryItem"]["Model"])
    carryitem:Spawn()
    player:QUEST_SYSTEM_Quest_UpdateQuest(strQuest_ID)
    player:QUEST_SYSTEM_Quest_UpdateProgress(0)
    player:QUEST_SYSTEM_ChatNotify("Mission", "You have begun your mission, best of luck. Type !abort to abort and !missioninfo for more information.")

    if (QUEST_SYSTEM.Quests[strQuest_ID]["Time"] > 0) then
        timer.Create(player.QUEST_SYSTEM_ActiveQuest .. "_" .. player:SteamID64(), QUEST_SYSTEM.Quests[strQuest_ID]["Time"], 1, function()
            if (IsValid(player)) then
                player:QUEST_SYSTEM_Quest_Abort()
            end
        end)
    end
end

-- called when a player finishes the quest
function QUEST:OnFinished(player)
    if (player.QUEST_SYSTEM_QuestProgress < QUEST_SYSTEM.Quests[player.QUEST_SYSTEM_ActiveQuest]["Amount"]) then return end

    if (timer.Exists(player.QUEST_SYSTEM_ActiveQuest .. "_" .. player:SteamID64())) then
        timer.Remove(player.QUEST_SYSTEM_ActiveQuest .. "_" .. player:SteamID64())
    end

    -- REWARD FUNCTION GOES HERE ^^^^
    for k, v in pairs(ents.GetAll()) do
        if v:GetClass() == "carry_item" and v:GetNWString("carryentid") == player:SteamID64() then
            v:Remove()
        end
    end

    player.QUEST_SYSTEM_ActiveQuest = nil
    player:QUEST_SYSTEM_Quest_UpdateProgress(0)
    net.Start("QUEST_SYSTEM_Quest_Finish")
    net.Send(player)
    player:EmitSound("vo/coast/odessa/male01/nlo_cheer01.wav")
    player:QUEST_SYSTEM_ChatNotify("Missions", "You have completed the mission, enjoy your reward.")
end

-- called when a player aborts(or time runs out) the quest
function QUEST:OnAborted(player)
    if (timer.Exists(player.QUEST_SYSTEM_ActiveQuest .. "_" .. player:SteamID64())) then
        timer.Remove(player.QUEST_SYSTEM_ActiveQuest .. "_" .. player:SteamID64())
    end

    for k, v in pairs(ents.GetAll()) do
        if v:GetClass() == "carry_item" and v:GetNWString("carryentid") == player:SteamID64() then
            v:Remove()
        end
    end

    player.QUEST_SYSTEM_ActiveQuest = nil
    player:QUEST_SYSTEM_Quest_UpdateProgress(0)
    net.Start("QUEST_SYSTEM_Quest_Finish")
    net.Send(player)
    player:QUEST_SYSTEM_ChatNotify("Missions", "Mission Aborted, better luck next time.")
end

local pos = Vector(3036.17, -1616.25, -5135.96)

if (SERVER) then
    timer.Create("isiteminzoneTIE", 1, 0, function()
        for k, v in pairs(ents.FindInSphere(Vector(pos), 150)) do
            if (v:GetClass() == "carry_item") then
                local playertoreward = player.GetBySteamID64(v:GetNWString("carryentid"))

                if (playertoreward.QUEST_SYSTEM_ActiveQuest == "carry_pilot") then
                    playertoreward:QUEST_SYSTEM_Quest_UpdateProgress(playertoreward.QUEST_SYSTEM_QuestProgress + 1)

                    if (playertoreward.QUEST_SYSTEM_QuestProgress >= QUEST_SYSTEM.Quests[playertoreward.QUEST_SYSTEM_ActiveQuest]["Amount"]) then
                        playertoreward:QUEST_SYSTEM_Quest_Finish()
                    end
                end
            end
        end
    end)
end

if (CLIENT) then
    hook.Add("PostDrawTranslucentRenderables", "DrawSphereTIECarry", function(bDepth, bSkybox)
        if (bSkybox) then return end
        if not (LocalPlayer().QUEST_SYSTEM_ActiveQuest == "carry_pilot") then return end
        render.SetColorMaterial()
        render.DrawSphere(pos, 150, 30, 30, Color(0, 144, 238, 144))
    end)
end
