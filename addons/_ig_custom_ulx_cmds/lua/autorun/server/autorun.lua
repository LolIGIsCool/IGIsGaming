resource.AddFile("resource/fonts/anakinmono.ttf")
resource.AddFile("materials/transmission/orders_displayIMP.png")
resource.AddFile("sound/transmission/officer.wav")
resource.AddFile("sound/transmission/launch.wav")
resource.AddFile("sound/transmission/close.wav")
resource.AddFile("sound/transmission/beep.wav")
resource.AddFile("sound/defcon/ignewalarm.mp3")
resource.AddFile("materials/defcon/1_defcon.png")
resource.AddFile("materials/defcon/2_defcon.png")
resource.AddFile("materials/defcon/3_defcon.png")
resource.AddFile("materials/defcon/4_defcon.png")
resource.AddFile("materials/defcon/5_defcon.png")
--New defcon sounds
resource.AddFile("sound/vanilla/defcon/battlestations.ogg")
resource.AddFile("sound/vanilla/defcon/evacuation.ogg")
resource.AddFile("sound/vanilla/defcon/fulllockdown.ogg")
resource.AddFile("sound/vanilla/defcon/hazardalarm.ogg")
resource.AddFile("sound/vanilla/defcon/intruderalert.ogg")
resource.AddFile("sound/vanilla/defcon/protocol13.ogg")
resource.AddFile("sound/vanilla/defcon/regularduties.ogg")
resource.AddFile("sound/vanilla/defcon/standbyalert.ogg")
local eventmaster

if not file.Exists("eventmaster.txt", "DATA") then
    eventmaster = "none"
    file.Write("eventmaster.txt", eventmaster)
else
    eventmaster = file.Read("eventmaster.txt", "DATA")
end

hook.Add("IGPlayerSay", "PlayerGetEventMaster", function(ply, text, team)
    if (string.sub(string.lower(text), 1, 12) == "!eventmaster") then
        if eventmaster == "none" then
            ply:ChatPrint("There is no event currently active")
        else
            ply:ChatPrint("The event master for this event is: " .. eventmaster)
        end
    end
end)

hook.Add("IGPlayerSay", "PlayerSetEventMaster", function(ply, text, team)
    if not ply:IsAdmin() then return end

    if (string.sub(string.lower(text), 1, 6) == "!setem") then
        eventmaster = string.sub(text, 8)
        file.Write("eventmaster.txt", eventmaster)
    end
end)

--PATRON
local function UpdatePatron(ply)
    local jsonTable = file.Read("patronlist.json","DATA");
    local patronTable = util.JSONToTable(jsonTable);

    net.Start("vanillaUpdatePatron");
    net.WriteTable(patronTable);
    net.WriteTable(IG_CHARACTER_PURCHASED);
    net.Send(ply);
end

--receive updated patron list, save it and send back to client
net.Receive("vanillaUpdatePatron", function(len, ply)
    if not ply:IsAdmin() then return end

    local steamID = net.ReadString();
    local name = net.ReadString();
    local bool = net.ReadBool();
    local jsonPatronTable = file.Read("patronlist.json","DATA");
    local patronList = util.JSONToTable(jsonPatronTable);

    if bool then
        //add patron
        //dumbass prevention
        for k, v in pairs(patronList) do
            if v.id == steamID then
                RunConsoleCommand("ulx", "asay", "[DUMBASS-ALERT]", steamID, "IS", "ALREADY", "A", "PATRON.");
                return
            end
        end

        //create a temp table with info
        local timeStamp = os.time();
        local tempDay = tonumber(os.date("%d",timeStamp));
        local tempMonth = tonumber(os.date("%m",timeStamp));

        //calculate day
        tempDay = math.Clamp(tempDay,1,28);

        //calculate month
        if tempMonth < 11 then
            tempMonth = tempMonth + 2;
        elseif tempMonth == 11 then
            tempMonth = 1;
        else
            tempMonth = 2;
        end

        local tempPatronTable = {
            id = steamID, //steam id
            nick = name,
            day = tempDay, //day
            month = tempMonth //month
        }

        //insert new player into list and save it
        table.insert(patronList,#patronList + 1,tempPatronTable);
        jsonPatronTable = util.TableToJSON(patronList,true);
        file.Write("patronlist.json", jsonPatronTable );

        RunConsoleCommand("ulx", "asay", steamID, "has", "been", "given", "patron.");
    else
        //remove patron
        local found = false;

        for k, v in pairs(patronList) do
            if v.id == steamID then
                found = true;
                table.RemoveByValue(patronList,v);

                jsonPatronTable = util.TableToJSON(patronList,true);
                file.Write("patronlist.json", jsonPatronTable );

                RunConsoleCommand("ulx", "asay", steamID, "has", "been", "removed", "from", "patron.");
            end
        end

        if found == false then
            RunConsoleCommand("ulx", "asay", "[DUMBASS-ALERT]", steamID, "IS", "NOT", "A", "PATRON.");
        end
    end

    local jsonTable = file.Read("patronlist.json","DATA");
    local patronTable = util.JSONToTable(jsonTable);

    net.Start("vanillaUpdatePatron");
    net.WriteTable(patronTable);
    net.WriteTable(IG_CHARACTER_PURCHASED);
    net.Send(ply);
end)
