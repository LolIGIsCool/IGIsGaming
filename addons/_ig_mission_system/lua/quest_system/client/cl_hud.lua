surface.CreateFont("IGVANILLAFontSmall", {
    font = "Acumin Pro",
    size = ScreenScale(6)
})

local questmat = Material("defcon/vanilla_mission.png")
local balmat = Material("defcon/vanilla_balance.png")
hook.Add("HUDPaint", "QUEST_SYSTEM_Quest_Progress", function()
    if (QUEST_SYSTEM.Quests[LocalPlayer().QUEST_SYSTEM_ActiveQuest]) then
        surface.SetDrawColor(Color(255, 255, 255, 255))
        surface.SetMaterial(questmat)
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
        draw.DrawText("Mission: " .. QUEST_SYSTEM.Quests[LocalPlayer().QUEST_SYSTEM_ActiveQuest]["Name"], "IGVANILLAFontSmall", ScrW() / 1.17, ScrH() / 2.35, color_white, TEXT_ALIGN_LEFT)
        local strItem = ""

        if (QUEST_SYSTEM.Quests[LocalPlayer().QUEST_SYSTEM_ActiveQuest]["Item"]) then
            strItem = QUEST_SYSTEM.Quests[LocalPlayer().QUEST_SYSTEM_ActiveQuest]["Item"]["Name"]
        end

        if (QUEST_SYSTEM.Quests[LocalPlayer().QUEST_SYSTEM_ActiveQuest]["Entity"]) then
            strItem = QUEST_SYSTEM.Quests[LocalPlayer().QUEST_SYSTEM_ActiveQuest]["Entity"]
        end

        draw.DrawText("Progress: " .. LocalPlayer().QUEST_SYSTEM_QuestProgress .. "/" .. QUEST_SYSTEM.Quests[LocalPlayer().QUEST_SYSTEM_ActiveQuest]["Amount"] .. " " .. strItem, "IGVANILLAFontSmall", ScrW() / 1.17, ScrH() / 2.28, color_white, TEXT_ALIGN_LEFT)

        if (timer.Exists(LocalPlayer().QUEST_SYSTEM_ActiveQuest)) then
            draw.DrawText("Time Left: " .. string.Comma(math.Round(timer.TimeLeft(LocalPlayer().QUEST_SYSTEM_ActiveQuest))), "IGVANILLAFontSmall", ScrW() / 1.17, ScrH() / 2.22, color_white, TEXT_ALIGN_LEFT)
        end
    end
end)

--[[hook.Add("HUDDrawScoreBoard", "QUEST_SYSTEM_CreditsTabShow", function()
    surface.SetMaterial(balmat)
    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    draw.DrawText(LocalPlayer():SH_GetStandardPoints() .. " points", "IGVANILLAFontSmall", 5, ScrH() / 1.109, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    draw.DrawText(LocalPlayer():SH_GetPremiumPoints() .. " credits", "IGVANILLAFontSmall", 5, ScrH() / 1.095, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    draw.DrawText(LocalPlayer():GetNWInt("igquestpoints") .. " quest points", "IGVANILLAFontSmall",  5, ScrH() / 1.08, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
end)]]
