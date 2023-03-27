local spawnpositions = {}
local bunkspawnpositions = {}
local vecPos = nil

if game.GetMap() == "rp_deathstar" then
    spawnpositions = {Vector(278.33, -13266.62, -703.96), Vector(-438.87, -13303.52, -703.96), Vector(-175.29, -12205.87, -703.96), Vector(-1589.67, -12594.64, -703.96), Vector(-1484.79, -14011, -703.96), Vector(-666.16, -12219.11, 544.03), Vector(283.69, -12649.63, 592.03), Vector(1753.57, -12280.27, 592.03), Vector(1146.79, -12276.76, -2982.28), Vector(1503.75, -11190.18, -703.95), Vector(1185.73, -10791.33, -1263.95), Vector(346.5, -10585.65, -2306), Vector(3276.56, -12690.5, -303.96), Vector(1731.90, -13742.51, -415.96), Vector(-2864.67, -13635.84, -1103.96), Vector(-3334.33, -13641.38, -1095.96)}
    bunkspawnpositions = {Vector(278.33, -13266.62, -703.96), Vector(-438.87, -13303.52, -703.96), Vector(-175.29, -12205.87, -703.96), Vector(-1589.67, -12594.64, -703.96), Vector(-1484.79, -14011, -703.96), Vector(-666.16, -12219.11, 544.03), Vector(283.69, -12649.63, 592.03), Vector(1753.57, -12280.27, 592.03), Vector(1146.79, -12276.76, -2982.28), Vector(1503.75, -11190.18, -703.95), Vector(1185.73, -10791.33, -1263.95), Vector(346.5, -10585.65, -2306), Vector(3276.56, -12690.5, -303.96), Vector(1731.90, -13742.51, -415.96), Vector(-2864.67, -13635.84, -1103.96), Vector(-3334.33, -13641.38, -1095.96)}
elseif game.GetMap() == "rp_stardestroyer_v2_6_inf" then
    spawnpositions = {Vector(-1770.46, 833.76, -6015.97), Vector(-1956.62, 839.43, -6015.97), Vector(-2196.2, 837.88, -6015.97), Vector(-2411.79, 843.88, -6015.97), Vector(-2741.6, 849.47, -6015.97), Vector(-2791.38, 1239.94, -6015.97), Vector(-2803.1, 450.36, -6015.97), Vector(-2808.27, 78.04, -6015.97), Vector(-2805.73, -413.33, -6015.97), Vector(-2799.81, -754.84, -6015.97), Vector(-2784.02, -1273.76, -6015.97), Vector(-2797.43, -1691.83, -6015.97), Vector(-2183.7, -1740.24, -6015.97), Vector(-1867.39, -1742, -6015.97), Vector(-1792.26, -1272.83, -6015.97), Vector(-2047.09, -846.09, -6015.97), Vector(-2051.61, -128.02, -6015.97), Vector(-716.95, -1736.12, -5759.97), Vector(-310.26, -1752.25, -5567.97), Vector(57.64, -2196.3, -5567.97), Vector(922.13, -1787.34, -5567.97), Vector(4061.44, -1796.46, -5567.97), Vector(4097.16, -1405.79, -5567.97), Vector(4105.98, -902.9, -5567.97), Vector(3896.15, -799.38, -5375.97), Vector(4117.36, -820.01, -5375.97), Vector(5048.29, -1029.27, -5375.97), Vector(5584.21, -177.31, -5375.97), Vector(5565.86, 1039.73, -5375.97), Vector(5122.97, 1037.32, -5375.97), Vector(5250.49, 1878.23, -5375.97), Vector(4077.39, 826.51, -5375.97), Vector(4114.38, 1348.22, -5567.97), Vector(-5.02, -1809.87, -4863.97), Vector(-543.71, -1722.63, -4863.97), Vector(-987.06, -1720.13, -4863.97), Vector(-1690.29, -1733.88, -4863.97), Vector(-2229.85, -1670.83, -4863.97), Vector(-2297.74, -1107.67, -4863.97), Vector(-2041.07, -836.87, -4863.97), Vector(-2046.05, -263.75, -4863.97), Vector(-2058.78, 596.72, -4863.97), Vector(-2039.58, 793.68, -4863.97), Vector(-1717.91, 860.73, -4863.97), Vector(-1695.97, 1262.19, -4863.97), Vector(-2331.58, -829.81, -4863.97), Vector(-2755.86, -833.04, -4863.97), Vector(-2822.47, -1072.76, -4863.97)}
    bunkspawnpositions = {Vector(-1699.93, -550.98, -5983.72), Vector(-2406.17, 551.06, -5871.72), Vector(-1867.3, -549.92, -5983.47), Vector(-2237.7, 546.37, -5871.47), Vector(-2227.88, 549.98, -5929.47), Vector(-1867.39, -547.34, -5929.47), Vector(-2390.73, 545.63, -5929.72), Vector(-1702.38, -551.99, -5929.72), Vector(-2390.35, 551.48, -5983.72), Vector(-2223.54, 551.14, -5983.47), Vector(-1702.21, -545.32, -5871.72), Vector(-2223.02, 347.54, -5983.47), Vector(-1864.64, -547.78, -5871.47), Vector(-2221.52, 342.1, -5929.47), Vector(-2233.08, 346.02, -5871.47), Vector(-1651.81, -446.52, -6015.97), Vector(-2398.19, 342.57, -5871.47), Vector(-2394.19, 334.64, -5929.47), Vector(-1700, -341, -5983.47), Vector(-2400.42, 346.43, -5983.47), Vector(-1880.67, -342.49, -5983.47), Vector(-1875.94, -346.12, -5929.47), Vector(-2454.92, 448.14, -6015.97), Vector(-1875.52, -348.31, -5871.47), Vector(-1707.94, -345.28, -5871.47), Vector(-1646.16, 450.05, -6015.97), Vector(-1702.29, -342.48, -5929.47), Vector(-2213.84, -550.85, -5983.47), Vector(-1693.59, 344.25, -5983.72), Vector(-1705.87, 351.76, -5929.72), Vector(-2397.42, -548.84, -5983.47), Vector(-1703.12, 347.81, -5871.72), Vector(-2399.89, -553.09, -5929.47), Vector(-1867.43, 344.23, -5871.47), Vector(-1875.96, 341.91, -5929.47), Vector(-1872.79, 346.83, -5983.47), Vector(-2226.43, -546.37, -5929.47), Vector(-2227.6, -546.53, -5871.47), Vector(-2379.75, -542.65, -5871.47), Vector(-1869.77, 554.79, -5983.47), Vector(-1870.15, 557.53, -5929.47), Vector(-1863.61, 542.93, -5871.47), Vector(-1699.13, 546.03, -5871.47), Vector(-1702.34, 559.05, -5929.47), Vector(-1695.92, 547.39, -5983.47), Vector(-2445.4, -448.9, -6015.97), Vector(-2401.47, -341.7, -5983.72), Vector(-2226.97, -345.97, -5983.47), Vector(-2226, -334.5, -5929.47), Vector(-1642.44, 166.83, -6015.97), Vector(-1712.7, 259.14, -5983.47), Vector(-2395.81, -344.01, -5929.72), Vector(-1704.83, 260.07, -5929.47), Vector(-2395.95, -341.6, -5871.72), Vector(-1700.13, 260.11, -5871.47), Vector(-2233.98, -342.41, -5871.47), Vector(-1863.8, 264.33, -5871.47), Vector(-1880.01, 272.01, -5929.47), Vector(-1880.8, 262.65, -5983.47), Vector(-1707.15, 59.67, -5983.72), Vector(-1705.01, 55.22, -5929.72), Vector(-1699.14, 53.17, -5871.72), Vector(-1868.4, 57.77, -5871.47), Vector(-1879.52, 58.77, -5929.47), Vector(-1883.49, 59.03, -5983.47), Vector(-2448.25, 160.23, -6015.97), Vector(-2386.34, 261.25, -5983.72), Vector(-2386.28, 265.8, -5929.72), Vector(-2399.54, 253.91, -5871.72), Vector(-1873.47, -48.61, -5983.47), Vector(-2238.1, 255.31, -5871.47), Vector(-2211.82, 262.28, -5929.47), Vector(-1707.46, -49.4, -5983.47), Vector(-2213.6, 257.11, -5983.47), Vector(-2221.58, 64.25, -5983.47), Vector(-1867.47, -270.49, -5983.47), Vector(-2219.05, 62.62, -5929.47), Vector(-2228.54, 50.91, -5871.47), Vector(-1716.33, -257.41, -5983.72), Vector(-2397.25, 62.58, -5871.47), Vector(-1648.03, -159.24, -6015.97), Vector(-2398.68, 55.95, -5929.47), Vector(-2398.37, 63.45, -5983.47), Vector(-2452.46, 155.15, -6015.97), Vector(-1702.52, -54.4, -5929.47), Vector(-1864.68, -60.16, -5929.47), Vector(-1864.09, -55, -5871.47), Vector(-1708.32, -57.9, -5871.47), Vector(-1697.48, -256.29, -5871.72), Vector(-1848.93, -261.63, -5871.47), Vector(-2234.81, -262.1, -5983.47), Vector(-2410.66, -260.89, -5983.47), Vector(-2400.48, -262.84, -5929.47), Vector(-2231.09, -263.3, -5929.47), Vector(-2232.31, -262.35, -5871.47), Vector(-2388.62, -266.5, -5871.47), Vector(-2431.57, -156.69, -6015.97), Vector(-2387.81, -56.02, -5983.72), Vector(-2392, -63.1, -5929.72), Vector(-2400.69, -51.5, -5871.72), Vector(-2234.66, -56.81, -5871.47), Vector(-2225.04, -64.42, -5929.47), Vector(-2225.71, -56.18, -5983.47)}
elseif game.GetMap() == "rp_lothal" then
    spawnpositions =    {Vector(11323.17, -1847.96, -15231.96),
                        Vector(10580.859375, -1847.68, -15231.96),
                        Vector(10572.040039, -3082.195068, -15231.968750),
                        Vector(10260.806641, -2172.863525, -15231.968750),
                        Vector(9614.331055, -1208.535767, -15231.968750),
                        Vector(11156.175781, -572.742676, -15231.968750),
                        Vector(10564.033203, 18.100580, -15231.968750),
                        Vector(9189.724609, -1210.770752, -14335.968750),
                        Vector(10561.049805, -1766.459106, -14335.968750),
                        Vector(10560.125000, -513.433899, -14335.968750),
                        Vector(12002.685547, -617.894592, -15231.968750),
                        Vector(12145.623047, -1853.528809, -15231.968750)
                    }
    bunkspawnpositions = {Vector(11323.17, -1847.96, -15231.96)}
else
    spawnpositions = {Vector(0, 0, 0)}
    bunkspawnpositions = {Vector(0, 0, 0)}
end

-- Quest --
function QUEST_SYSTEM.Quest_CreateItem(strQuest_ID)
    if strQuest_ID == "inspection_1" or strQuest_ID == "inspection_2" or strQuest_ID == "inspection_3" or strQuest_ID == "inspection_4" or strQuest_ID == "inspection_5" then
        vecPos = table.Random(bunkspawnpositions)
    else
        vecPos = table.Random(spawnpositions)
    end

    local thequestitem = ents.Create("quest_item")
    thequestitem:SetPos(vecPos + Vector(0, 0, 15))
    thequestitem:Spawn()
    thequestitem:DropToFloor()
    thequestitem:SetModel(QUEST_SYSTEM.Quests[strQuest_ID]["Item"]["Model"])
    thequestitem:SetQuestID(strQuest_ID)
    thequestitem:SetItemName(QUEST_SYSTEM.Quests[strQuest_ID]["Item"]["Name"])
end

function QUEST_SYSTEM.Quest_RespawnItem(strQuest_ID)
    timer.Simple(QUEST_SYSTEM.Quests[strQuest_ID]["Item"]["Respawn"], function()
        if strQuest_ID == "inspection_1" or strQuest_ID == "inspection_2" or strQuest_ID == "inspection_3" or strQuest_ID == "inspection_4" or strQuest_ID == "inspection_5" then
            vecPos = table.Random(bunkspawnpositions)
        else
            vecPos = table.Random(spawnpositions)
        end

        local thequestitem = ents.Create("quest_item")
        thequestitem:SetPos(vecPos + Vector(0, 0, 15))
        thequestitem:Spawn()
        thequestitem:DropToFloor()
        thequestitem:SetModel(QUEST_SYSTEM.Quests[strQuest_ID]["Item"]["Model"])
        thequestitem:SetQuestID(strQuest_ID)
        thequestitem:SetItemName(QUEST_SYSTEM.Quests[strQuest_ID]["Item"]["Name"])
    end)
end

function QUEST_SYSTEM.Quest_SpawnItems(strQuest_ID)
    local amount = QUEST_SYSTEM.Quests[strQuest_ID]["Amount"]

    for i = 1, amount do
        QUEST_SYSTEM.Quest_CreateItem(strQuest_ID)
    end
end

timer.Create("QUEST_SYSTEM_Quest_Add", 5, 0, function()
    if not QUEST_SYSTEM.AvailableQuests then return end
    if (table.Count(QUEST_SYSTEM.AvailableQuests) < 28) then
        local dataQuest, _ = table.Random(QUEST_SYSTEM.Quests)
        if (QUEST_SYSTEM.AvailableQuests[dataQuest["ID"]]) then return end
        QUEST_SYSTEM.AvailableQuests[dataQuest["ID"]] = dataQuest
        net.Start("QUEST_SYSTEM_Quest_Add")
        net.WriteString(dataQuest["ID"])
        net.Broadcast()
    end
end)

timer.Create("QUEST_SYSTEM_Quest_ClearQuests", 45, 0, function()
    if not QUEST_SYSTEM.AvailableQuests then return end
    if (table.Count(QUEST_SYSTEM.AvailableQuests) > 8) then
        local removeQuest, _ = table.Random(QUEST_SYSTEM.AvailableQuests)
        if not (QUEST_SYSTEM.AvailableQuests[removeQuest["ID"]]) then return end
        QUEST_SYSTEM.AvailableQuests[removeQuest["ID"]] = nil
        net.Start("QUEST_SYSTEM_Quest_Remove")
        net.WriteString(removeQuest["ID"])
        net.Broadcast()
    end
end)