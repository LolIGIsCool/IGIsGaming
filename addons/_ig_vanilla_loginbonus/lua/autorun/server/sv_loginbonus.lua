//net msgs
util.AddNetworkString("VANILLALOGIN_net_OpenSplash")
util.AddNetworkString("VANILLALOGIN_net_ClientReady")
util.AddNetworkString("VANILLALOGIN_net_PrettyText")
util.AddNetworkString("VANILLALOGIN_net_RequestClaim")

//import images
resource.AddFile("materials/vanilla/login/augment.png")
resource.AddFile("materials/vanilla/login/credits.png")
resource.AddFile("materials/vanilla/login/divider.png")
resource.AddFile("materials/vanilla/login/credxp.png")
resource.AddFile("materials/vanilla/login/credaug.png")

//create storage directories
if not file.IsDir("vanilla_loginbonus", "DATA") then
    file.CreateDir("vanilla_loginbonus")
end

if not file.Exists("vanilla_loginbonus/daycount.txt","DATA") then
	file.Write("vanilla_loginbonus/daycount.txt","1")
end

//Creates .json file for player
local function UpdateLoginBonusData(ply)

    local number = file.Read("vanilla_loginbonus/daycount.txt","DATA")

    if not file.Exists("vanilla_loginbonus/" .. ply:SteamID64() .. ".json","DATA") then

        local plydata = {
            day = 1,
            currentStreak = 1,
            longestStreak = 1,
            lastCheck = number,
            claimed = false,
            claimed2 = false
        }

        file.Write("vanilla_loginbonus/" .. ply:SteamID64() .. ".json",util.TableToJSON(plydata, true))
    else
        local plydata = util.JSONToTable(file.Read("vanilla_loginbonus/" .. ply:SteamID64() .. ".json","DATA"))
        
        if (plydata.lastCheck == "" or plydata.lastCheck == " ") then
            plydata.lastCheck = "0"
        end

        if tonumber(plydata.lastCheck) ~= tonumber(number) then
            if (tonumber(plydata.lastCheck) + 1) == tonumber(number) then
                if tonumber(plydata.day) + 1 == 8 then
                    //Set day back to 1
                    plydata.day = 1
                    plydata.currentStreak = plydata.currentStreak + 1
                else
                    //Advance the days by 1
                    plydata.day = plydata.day + 1
                    plydata.currentStreak = plydata.currentStreak + 1
                end
                if plydata.currentStreak > plydata.longestStreak then plydata.longestStreak = plydata.currentStreak end
            else
                //Reset the days
                plydata.day = 1
                plydata.currentStreak = 1
            end

            plydata.lastCheck = number
            plydata.claimed = false
            plydata.claimed2 = false
            //Save data
            file.Write("vanilla_loginbonus/" .. ply:SteamID64() .. ".json",util.TableToJSON(plydata, true))
        end
    end
end
hook.Add("PlayerInitialSpawn", "VANILLALOGIN_hook_UpdateLoginBonusData", UpdateLoginBonusData)

local function OpenSplashScreen(ply)
    if not IsValid(ply) then return end
    if not file.Exists("vanilla_loginbonus/" .. ply:SteamID64() .. ".json","DATA") then return end

    local table = util.JSONToTable(file.Read("vanilla_loginbonus/" .. ply:SteamID64() .. ".json","DATA"))
    net.Start("VANILLALOGIN_net_OpenSplash")
    net.WriteTable(table)
    net.Send(ply)
end

//Client is ready, send the splash screen
net.Receive("VANILLALOGIN_net_ClientReady", function(len,ply)
    OpenSplashScreen(ply)
end)

//Client is claiming rewards
net.Receive("VANILLALOGIN_net_RequestClaim",function(len, ply)
    local shimakaze = net.ReadBool()
    local plydata = util.JSONToTable(file.Read("vanilla_loginbonus/" .. ply:SteamID64() .. ".json","DATA"))

    if shimakaze == false then
        if plydata.claimed == true then return end

        //Reward daily reward
        local exploded = string.Explode(" ",vanillaIGLoginRewards[plydata.day].Reward1)
        if exploded[1] == "0" then
            //award augment points
            local holycrapiaccidentallymadethatfunctionglobalhowhasthatnotconflictedwithanything = ReadPlayerData(ply:SteamID64())
            local exploded2 = string.Explode(" ",vanillaIGLoginRewards[plydata.day].Reward2)
            holycrapiaccidentallymadethatfunctionglobalhowhasthatnotconflictedwithanything.Points = holycrapiaccidentallymadethatfunctionglobalhowhasthatnotconflictedwithanything.Points + exploded2[1]
            SavePlayerData(ply:SteamID64(),holycrapiaccidentallymadethatfunctionglobalhowhasthatnotconflictedwithanything)
        else
            //award credits
            ply:SH_AddPremiumPoints(exploded[1], nil, false, false)
        end
        net.Start("VANILLALOGIN_net_PrettyText")
        net.WriteTable(vanillaIGLoginRewards[plydata.day])
        net.Send(ply)

        plydata.claimed = true
    else
        if plydata.claimed2 == true then return end

        //Streak reward
        for k, v in pairs(vanillaIGLoginRewards) do
            if v.Day == plydata.currentStreak and v.Day > 7 then
                //credits
                local creds = string.Explode(" ",v.Reward1)
                ply:SH_AddPremiumPoints(creds[1], nil, false, false)
                //augment points
                local augmentData = ReadPlayerData(ply:SteamID64())
                local augs = string.Explode(" ",v.Reward2)
                augmentData.Points = augmentData.Points + augs[1]
                SavePlayerData(ply:SteamID64(),augmentData)

                net.Start("VANILLALOGIN_net_PrettyText")
                net.WriteTable(v)
                net.Send(ply)
            end
        end

        plydata.claimed2 = true
    end
    file.Write("vanilla_loginbonus/" .. ply:SteamID64() .. ".json",util.TableToJSON(plydata, true))
end)

//Open login bonus command
hook.Add("PlayerSay","VANILLALOGIN_hook_SplashCommand",function(ply,txt)
    if string.sub(string.lower(txt),1,6) == "!login" then
        OpenSplashScreen(ply)
        return false
    end
end)

//console command for the server to advance the day via scheduled commands
concommand.Add("vanilla_advance_day", function(ply)
    //Ensure that it is the console that is running this
    if not IsValid(ply) then
        //Increment day
        local number = file.Read("vanilla_loginbonus/daycount.txt","DATA")
        number = tonumber(number) + 1
        file.Write("vanilla_loginbonus/daycount.txt",tostring(number))

        //Reward all players.
        for k, v in pairs(player.GetAll()) do
            UpdateLoginBonusData(v)
        end
    end
end)

//daily reest thing by kumo
if not file.Exists("daycheck.txt", "DATA") then
    local dateFormat = {
        day = os.date("%d", os.time()),
        week = os.date("%a", os.time()),
        done = false
    }
    local table = util.TableToJSON(dateFormat,true);
    file.Write("daycheck.txt", table);
end

timer.Create("VANILLALOGIN_timer_DailyANDWeeklySkinningChildren", 600, 0, function()
    local curDate = file.Read("daycheck.txt");
    local table = util.JSONToTable(curDate);

    if table.week == "Sun" and table.done == false then
        table.done = true;

        RunConsoleCommand( "vanilla_reset_food" );
        RunConsoleCommand( "vanilla_reset_weeklies" );
    elseif table.week ~= "Sun" then
        table.done = false;
    end

    if table.day ~= os.date("%d", os.time()) then
        table.day = os.date("%d", os.time());
        RunConsoleCommand( "vanilla_reset_dailies" );
        RunConsoleCommand( "vanilla_advance_day" );
    end

    file.Write("daycheck.txt", util.TableToJSON(table,true));
end)
