local editorRanks = {
    ["Lead Event Master"] = true,
    ["Senior Admin"] = true,
    ["Senior Developer"] = true,
    ["superadmin"] = true,
    ["Senior Event Master"] = true,
    ["Admin"] = true
}

local function IsEditor(ply)
    if editorRanks[ply:GetUserGroup()] then 
        return true;
    else 
        return false;
    end
end

if SERVER then
    util.AddNetworkString("VANILLASHIP_net_OpenMenu");
    util.AddNetworkString("VANILLASHIP_net_ShipSpawnRequest");
    util.AddNetworkString("VANILLASHIP_net_ShipRemoveRequest");

    util.AddNetworkString("VANILLASHIP_net_FileSave");

    if not file.IsDir("vanilla_ships", "DATA") then
        file.CreateDir("vanilla_ships");
    end

    net.Receive("VANILLASHIP_net_ShipSpawnRequest", function(len, ply)
        local zone = net.ReadString();
        local pool = net.ReadString();
        local shipClass = net.ReadString();

        local zoneFile = file.Read("vanilla_ships/" .. pool .. ".json", "DATA");
        zoneFile = util.JSONToTable(zoneFile);

        //reg check
        local allowedRegs = string.Split(zoneFile[shipClass].reg,",");
        local foundRegiment = false;
        for _, v in ipairs(allowedRegs) do
            if ply:GetRegiment() == v then
                foundRegiment = true;
                break
            end
        end

        //pilot license check
        local allowedLicenses = string.Split(zoneFile[shipClass].pl,",");
        local licenseSplit = string.Split(ply:GetNWString("license"), " | ");
        local foundLicense = false;
        for _, v in ipairs(allowedLicenses) do
            for _, p in ipairs(licenseSplit) do
                if p == v then
                    foundLicense = true;
                    break;
                end
            end
        end

        //awr check
        local foundAWR = false;

        if zoneFile[shipClass].awr then
            local awrLicenses = util.JSONToTable(file.Read("awr_clearances/awr_personnel.txt", "DATA"));
            for k, _ in pairs(awrLicenses) do
                if ply:SteamID() == k then
                    foundAWR = true;
                    break;
                end
            end
        else
            foundAWR = true;
        end
            
        if ply:IsAdmin() then
			foundRegiment = true;
            foundLicense = true;
            foundAWR = true;
        end

        if not foundRegiment or not foundLicense or not foundAWR then return end

        for _, v in ipairs(ents.GetAll()) do
            if v:GetClass() == "vanilla_shipzone" and v:GetZoneID() == zone then
                //create code
                local ship = ents.Create(shipClass);
                    ship:SetPos(v:GetPos() + Vector(0,0,zoneFile[shipClass].height));
                    ship:SetAngles(v:GetAngles());

                    //custom variable, to let us know if the ship should be returnable.
                    ship:SetVar("VANILLA_ZoneSpawned", true);

                    ship:Spawn();
                ship:Activate();

                zoneFile[shipClass].count = tostring(tonumber(zoneFile[shipClass].count) - 1);
                file.Write("vanilla_ships/" .. pool .. ".json", util.TableToJSON(zoneFile, true));

                undo.Create("spawnedShip");
                    undo.AddEntity(ship);
                    undo.SetPlayer(ply);
                    undo.SetCustomUndoText("Undone Spawned Ship");
                undo.Finish();

                break; // break to save performance, because normally there shouldn't be more than one zone for each spawner
            end
        end
    end)

    net.Receive("VANILLASHIP_net_ShipRemoveRequest", function(len, ply)
        local zone = net.ReadString();
        local pool = net.ReadString();

        local zoneFile = file.Read("vanilla_ships/" .. pool .. ".json", "DATA");
        zoneFile = util.JSONToTable(zoneFile);

        for _, v in pairs(ents.GetAll()) do
            if v:GetClass() == "vanilla_shipzone" and v:GetZoneID() == zone then
                local pos = v:GetPos();
                local searchArea = ents.FindInBox(pos + Vector(50,50,50), pos + Vector(-50,-50,-50));

                for _, w in pairs(searchArea) do
                    if w:GetVar("VANILLA_ZoneSpawned", false) then
                                
                        local shipClass = w:GetClass();
                                
                        //reg check
                        local allowedRegs = string.Split(zoneFile[shipClass].reg,",");
                        local foundRegiment = false;
                        for _, v in ipairs(allowedRegs) do
                            if ply:GetRegiment() == v then
                                foundRegiment = true;
                                break
                            end
                        end

                        //pilot license check
                        local allowedLicenses = string.Split(zoneFile[shipClass].pl,",");
                        local licenseSplit = string.Split(ply:GetNWString("license"), " | ");
                        local foundLicense = false;
                        for _, v in ipairs(allowedLicenses) do
                            for _, p in ipairs(licenseSplit) do
                                if p == v then
                                    foundLicense = true;
                                    break;
                                end
                            end
                        end

                        //awr check
                        local foundAWR = false;

                        if zoneFile[shipClass].awr then
                            local awrLicenses = util.JSONToTable(file.Read("awr_clearances/awr_personnel.txt", "DATA"));
                            for k, _ in pairs(awrLicenses) do
                                if ply:SteamID() == k then
                                    foundAWR = true;
                                    break;
                                end
                            end
                        else
                            foundAWR = true;
                        end

                        if ply:IsAdmin() then
                            foundRegiment = true;
                            foundLicense = true;
                            foundAWR = true;
                        end

                        if not foundRegiment or not foundLicense or not foundAWR then return end
                                
                        zoneFile[w:GetClass()].count = tostring(tonumber(zoneFile[w:GetClass()].count) + 1);
                        file.Write("vanilla_ships/" .. pool .. ".json", util.TableToJSON(zoneFile, true));

                        w:Remove();
                        break;
                    end
                end
            end
        end
    end)

    net.Receive("VANILLASHIP_net_FileSave",function(len, ply)
        if not IsEditor(ply) then return end

        local pool = net.ReadString();
        local zoneFile = net.ReadTable();

        file.Write("vanilla_ships/" .. pool .. ".json", util.TableToJSON(zoneFile, true));
    end)
else //CLIENT ------------------------------------------------------------------------------------------------------------------------------------------//
    local col = {
        panel = Color(40, 40, 40, 255),
        bg = Color(40, 40, 40, 200),
        highlight = Color(255, 168, 238, 255),
        text = Color(255, 255, 255, 255)
    }

    local scrw = ScrW();
    local scrh = ScrH();

    net.Receive("VANILLASHIP_net_OpenMenu", function()
        local pool = net.ReadString();
        local zone = net.ReadString();
        local zoneFile = net.ReadTable();

        local frame = vgui.Create("DFrame");
        frame:SetSize(scrw * 0.5, scrh * 0.5);
        frame:Center();
        frame:SetTitle("");
        frame:MakePopup();
        frame.Paint = function(self, w, h)
            //background panel
            surface.SetDrawColor(col.bg);
            surface.DrawRect(0, 0, w, h);

            //left panel
            surface.SetDrawColor(col.panel);
            surface.DrawRect(0, 0, w * 0.25, h);

            //title text
            surface.SetFont("Trebuchet24");
            surface.SetTextColor(col.highlight);
            surface.SetTextPos(w * 0.05, h * 0.02);
            surface.DrawText("SHIP MANAGER");

            //zone text
            surface.SetFont("Trebuchet18");
            surface.SetTextColor(col.text);
            surface.SetTextPos(w * 0.05, h * 0.07);
            surface.DrawText("ZONE: " .. zone);

            //pool text
            surface.SetTextPos(w * 0.05, h * 0.1);
            surface.DrawText("POOL: " .. pool);

            //info text
            surface.SetTextColor(col.highlight);
            surface.SetTextPos(w * 0.02, h * 0.5);
            surface.DrawText("Click on a button to spawn a ship.");

            //remove info
            surface.SetTextPos(w * 0.02, h * 0.77);
            surface.DrawText("Park a spawned ship on the zone");
            surface.SetTextPos(w * 0.02, h * 0.8);
            surface.DrawText("and then click 'REMOVE SHIP'.");
        end

        local width, height = frame:GetSize();

        local removeButton = vgui.Create("DButton", frame);
        removeButton:SetPos(width * 0.02, height * 0.85);
        removeButton:SetSize(width * 0.21, height * 0.08);
        removeButton:SetText("");
        removeButton.Paint = function(self, w, h)
            //background
            surface.SetDrawColor(col.highlight);
            surface.DrawRect(0, 0, w, h);

            //text
            draw.SimpleText("REMOVE SHIP", "Trebuchet18", w * 0.5, h * 0.5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
        end
        removeButton.DoClick = function()
            net.Start("VANILLASHIP_net_ShipRemoveRequest");
            net.WriteString(zone);
            net.WriteString(pool);
            net.SendToServer();

            frame:Close();
        end

        local scrollBar = vgui.Create("DScrollPanel", frame);
        scrollBar:SetPos( width * 0.29, height * 0.144);
        scrollBar:SetSize( width * 0.7, height * 0.8 );

        local xOff = width * 0.01;
        local yOff = height * 0.01;

        local prevNum = 1;
        local i = 0;
        for k, p in pairs(zoneFile) do
            i = i + 1;
            if i == prevNum + 3 then
                yOff = yOff + height * 0.4;
                xOff = width * 0.01;
                prevNum = i;
            end

            local nameText = k;
            local stockText = "Stock: 0";

            //find the material for the button
            local mat = Material("materials/entities/" .. k .. ".png");

            //find the classname of the entity
            for _, v in pairs(scripted_ents.GetList()) do
                if v and istable(v.t) and v.t.Spawnable and v.t.Base and (string.StartWith(v.t.Base:lower(), "lunasflightschool_basescript") or string.StartWith(v.t.Base:lower(), "lvs_")) and v.t.PrintName and v.t.ClassName == k then
                    nameText = v.t.PrintName;
                    stockText = "Stock: " .. zoneFile[k].count;
                end
            end

            local button = vgui.Create("DImageButton", scrollBar);
            button:SetPos(xOff, yOff);
            button:SetSize(width * 0.18, width * 0.18);
            button.Paint = function(self, w, h)
                surface.SetDrawColor(255,255,255);
                surface.SetMaterial(mat);
                surface.DrawTexturedRect(0,0,w,h);

                draw.SimpleTextOutlined(nameText, "Trebuchet18", w * 0.5, h * 0.1, col.highlight, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0,0,0));
                draw.SimpleTextOutlined(stockText, "Trebuchet18", w * 0.5, h * 0.95, col.highlight, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, Color(0,0,0));
                        
                if string.EndsWith(stockText, "0") then
                     surface.SetDrawColor(0,0,0,80);
                     surface.DrawRect(0,0,w,h);
                end
            end
            button.DoClick = function()
                if tonumber(p.count) < 1 then return end

                net.Start("VANILLASHIP_net_ShipSpawnRequest");
                net.WriteString(zone);
                net.WriteString(pool);
                net.WriteString(k);
                net.SendToServer();

                frame:Close();
            end

            xOff = xOff + width * 0.22;
        end

        local adminButton = vgui.Create("DButton", frame);
        adminButton:SetPos(width * 0.02, height * 0.3);
        adminButton:SetSize(width * 0.2, height * 0.1);
        adminButton:SetText("Admin menu");
        adminButton.DoClick = function()
            local newFrame = vgui.Create("DFrame");
            newFrame:SetSize(scrw * 0.5, scrh * 0.5);
            newFrame:Center();
            newFrame:SetTitle("");
            newFrame:MakePopup();

            local fuckWidth, fuckHeight = newFrame:GetSize();

            local list = vgui.Create("DListView", newFrame);
            list:SetPos(fuckWidth * 0.03, fuckHeight * 0.03);
            list:SetSize(fuckWidth * 0.5, fuckHeight * 0.95);
            list:AddColumn("Class");
            list:AddColumn("Count");
            list:AddColumn("Regiments");
            list:AddColumn("Pilot Licenses");
            list:AddColumn("AWR");
            list:AddColumn("Height");

            for k, v in pairs(zoneFile) do
                list:AddLine(k, v.count, v.reg, v.pl, v.awr, v.height);
            end

            local nameEntry = vgui.Create("DTextEntry", newFrame);
            nameEntry:SetPos(fuckWidth * 0.535, fuckHeight * 0.1);
            nameEntry:SetSize(fuckWidth * 0.2, fuckHeight * 0.05);
            nameEntry:SetPlaceholderText("ship class");

            local nameLabel = vgui.Create("DLabel", newFrame);
            nameLabel:SetPos(fuckWidth * 0.74, fuckHeight * 0.1);
            nameLabel:SetSize(fuckWidth * 0.2, fuckHeight * 0.05);
            nameLabel:SetText("e.g. lunasflightschool_bf109");

            local countEntry = vgui.Create("DTextEntry", newFrame);
            countEntry:SetPos(fuckWidth * 0.535, fuckHeight * 0.15);
            countEntry:SetSize(fuckWidth * 0.2, fuckHeight * 0.05);
            countEntry:SetNumeric(true);
            countEntry:SetPlaceholderText("ship count");

            local countLabel = vgui.Create("DLabel", newFrame);
            countLabel:SetPos(fuckWidth * 0.74, fuckHeight * 0.15);
            countLabel:SetSize(fuckWidth * 0.2, fuckHeight * 0.05);
            countLabel:SetText("e.g. 2");

            local regEntry = vgui.Create("DTextEntry", newFrame);
            regEntry:NoClipping(true);
            regEntry:SetPos(fuckWidth * 0.535, fuckHeight * 0.2);
            regEntry:SetSize(fuckWidth * 1, fuckHeight * 0.05);
            regEntry:SetPlaceholderText("allowed regiments");

            local regLabel = vgui.Create("DLabel", newFrame);
            regLabel:SetPos(fuckWidth * 0.74, fuckHeight * 0.2);
            regLabel:SetSize(fuckWidth * 0.3, fuckHeight * 0.05);
            regLabel:SetText("e.g. Imperial Navy,Imperial Starfighter Corps,Inferno Squad");

            local heightEntry = vgui.Create("DTextEntry", newFrame);
            heightEntry:SetPos(fuckWidth * 0.535, fuckHeight * 0.25);
            heightEntry:SetSize(fuckWidth * 0.2, fuckHeight * 0.05);
            heightEntry:SetNumeric(true);
            heightEntry:SetPlaceholderText("spawn height");

            local heightLabel = vgui.Create("DLabel", newFrame);
            heightLabel:SetPos(fuckWidth * 0.74, fuckHeight * 0.25);
            heightLabel:SetSize(fuckWidth * 0.3, fuckHeight * 0.05);
            heightLabel:SetText("e.g. 420");

            local plEntry = vgui.Create("DTextEntry", newFrame);
            plEntry:SetPos(fuckWidth * 0.535, fuckHeight * 0.3);
            plEntry:SetSize(fuckWidth * 0.2, fuckHeight * 0.05);
            plEntry:SetPlaceholderText("pilot licenses");

            local plLabel = vgui.Create("DLabel", newFrame);
            plLabel:SetPos(fuckWidth * 0.74, fuckHeight * 0.3);
            plLabel:SetSize(fuckWidth * 0.3, fuckHeight * 0.05);
            plLabel:SetText("e.g. NPL,BPL,EPL");

            local awrBox = vgui.Create("DCheckBoxLabel", newFrame);
            awrBox:SetPos(fuckWidth * 0.535, fuckHeight * 0.35);
            awrBox:SetText("Requires AWR Clearance");

            local entryButton = vgui.Create("DButton", newFrame);
            entryButton:SetPos(fuckWidth * 0.6, fuckHeight * 0.8);
            entryButton:SetSize(fuckWidth * 0.2, fuckHeight * 0.05);
            entryButton:SetText("submit");
            entryButton.DoClick = function()
                local table = {
                    count = countEntry:GetValue(),
                    reg = regEntry:GetValue(),
                    height = heightEntry:GetValue(),
                    pl = plEntry:GetValue(),
                    awr = awrBox:GetChecked()
                }
                zoneFile[nameEntry:GetValue()] = table;

                net.Start("VANILLASHIP_net_FileSave");
                net.WriteString(pool);
                net.WriteTable(zoneFile);
                net.SendToServer();

                newFrame:Close();
                frame:Close();
            end

            local removeButton2 = vgui.Create("DButton", newFrame);
            removeButton2:SetPos(fuckWidth * 0.6, fuckHeight * 0.9);
            removeButton2:SetSize(fuckWidth * 0.2, fuckHeight * 0.05);
            removeButton2:SetText("remove");
            removeButton2.DoClick = function()
                zoneFile[nameEntry:GetValue()] = nil;

                net.Start("VANILLASHIP_net_FileSave");
                net.WriteString(pool);
                net.WriteTable(zoneFile);
                net.SendToServer();

                newFrame:Close();
                frame:Close();
            end

            list.OnRowSelected = function(_, _, pnl)
                nameEntry:SetText(pnl:GetColumnText(1));
                countEntry:SetText(pnl:GetColumnText(2));
                regEntry:SetText(pnl:GetColumnText(3));
                plEntry:SetText(pnl:GetColumnText(4));
                awrBox:SetValue(tobool(pnl:GetColumnText(5)));
                heightEntry:SetText(pnl:GetColumnText(6));
            end
        end

        if not IsEditor(LocalPlayer()) then
            adminButton:Remove();
        end
    end)
end
