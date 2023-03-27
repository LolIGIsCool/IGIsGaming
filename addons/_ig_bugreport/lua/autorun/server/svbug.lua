util.AddNetworkString("igbug_openuserpanel")
util.AddNetworkString("igbug_openadminpanel")
util.AddNetworkString("igbug_reporthandler")
util.AddNetworkString("igbug_reports")

if not file.IsDir("igbugreports", "DATA") then
    file.CreateDir("igbugreports")
end

if not file.Exists("igbugreports/bugreports.txt", "DATA") then
    file.Write("igbugreports/bugreports.txt", util.TableToJSON({}))
end

local reports = util.JSONToTable(file.Read("igbugreports/bugreports.txt", "DATA")) or {}

net.Receive("igbug_reporthandler", function(len, ply)
    if ((ply.reporthandlercd or 0) > CurTime()) then
        ply:ChatPrint("Please wait before submitting another report!")

        return
    end

    ply.reporthandlercd = CurTime() + 60
    local ReportReason = net.ReadString()

    if not ReportReason or not isstring(ReportReason) then
        ply:ChatPrint("No Bug Report found.")

        return
    elseif string.len(ReportReason) > 1500 then
        ply:ChatPrint("Bug Report too long, contact management directly if the bug is that sophisticated.")

        return
    elseif string.len(ReportReason) < 20 then
        ply:ChatPrint("Please include more detail into your report!")

        return
    end

    table.insert(reports, ply:Nick() .. "("..ply:SteamID()..") reported the bug: " .. ReportReason .. " | Reported on " .. os.date("%m:%d:%Y %I:%M %p"))
    ig_fwk_db:PrepareQuery("INSERT into bugs ( steamid, nick, actualbug, date ) VALUES ( " .. sql.SQLStr(ply:SteamID()) .. "," .. sql.SQLStr(ply:Nick()) .. " , " .. sql.SQLStr(ReportReason) .. "," .. sql.SQLStr(os.date("%m:%d:%Y %I:%M %p")) .. " );")
    local tablejson = util.TableToJSON(reports, false)
    file.Write("igbugreports/" .. "bugreports" .. ".txt", tablejson)
    ply:ChatPrint("Thank you for submitting a bug report! You may be rewarded when the bug is fixed!")
end)

function netbugreport(ply, text)
    if (string.lower(text) == "!bug") then
        net.Start("igbug_openuserpanel")
        net.Send(ply)
    end
end

hook.Add("IGPlayerSay", "openbugreport", netbugreport)

concommand.Add("bugsystem", function(ply)
    if ply:IsAdmin() then
        net.Start("igbug_openadminpanel")
        net.Send(ply)
        net.Start("igbug_reports")
        net.WriteTable(reports)
        net.Send(ply)
    else
        net.Start("igbug_openuserpanel")
        net.Send(ply)
    end
end)