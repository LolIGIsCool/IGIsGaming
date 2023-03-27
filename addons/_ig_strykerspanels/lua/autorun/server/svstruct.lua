util.AddNetworkString("NETORANKMenu")
util.AddNetworkString("NETOSTRUCTMenu")
util.AddNetworkString("NETONOTICEMenu")
util.AddNetworkString("networkrankboard")
util.AddNetworkString("broadcastrankboard")
util.AddNetworkString("networknoticeboard")
util.AddNetworkString("broadcastnoticeboard")

IGRANKS = {}
IGRANKS.grandadmiralrank = "Grand Admiral"
IGRANKS.grandadmiralname = "Thrawn"
--IGRANKS.administratorrank = ""
IGRANKS.administratorname = "Wilhuff Tarkin"
IGRANKS.compnordirectorrank = "COMPNOR Director"
IGRANKS.compnordirectorname = "Armand Isard"
IGRANKS.grandgeneralrank = "Grand General"
IGRANKS.grandgeneralname = "Hammer"
IGRANKS.counselorrank = "Counselor"
IGRANKS.counselorname = "Gallius Rax"
IGRANKS.general1name = "Ursarka E. Creed"
IGRANKS.general1rank = "Surface Marshal"
IGRANKS.general2name = "Decra Grif"
IGRANKS.general2rank = "High General"
IGRANKS.general3name = "Arcturusious"
IGRANKS.general3rank = "General"
IGRANKS.general4name = "Theta"
IGRANKS.general4rank = "Lieutenant General"
IGRANKS.general5name = "Tank"
IGRANKS.general5rank = "Lieutenant General"
IGRANKS.general6name = "Loki"
IGRANKS.general6rank = "Major General"
IGRANKS.general7name = "Loki"
IGRANKS.general7rank = "Major General"
IGRANKS.navy1rank = "Admiral"
IGRANKS.navy1name = "K. Konstantine"
IGRANKS.navy2rank = "Rear Admiral"
IGRANKS.navy2name = "[VACANT]"
IGRANKS.engineerrank = "Deputy Director"
IGRANKS.engineername = "Rad Cop"
IGRANKS.govrank1 = "Moff"
IGRANKS.govname1 = "Nile Owen"
IGRANKS.govrank2 = "Governor"
IGRANKS.govname2 = "Stathi Ach'illes"
IGRANKS.tarkinadjutantrank = "General (Tarkin's Adjutant)"
IGRANKS.tarkinadjutantname = "Hurst Romodi"
IGRANKS.isbdirectorrank = "Director"
IGRANKS.isbdirectorname = "Krennic"
IGRANKS.isbrank1 = "Bureau Chief"
IGRANKS.isbname1 = "Weiss"
IGRANKS.isbrank2 = "Chief"
IGRANKS.isbname2 = "Arathilion .X"
IGRANKS.isbadmiralrank = "[VACANT]"
IGRANKS.isbadmiralname = "[VACANT]"
IGRANKS.sovprotrank = "Sovereign Protector"
IGRANKS.sovprotname = "[VACANT]"
IGRANKS.cfprank = "Prefect"
IGRANKS.cfpname = "[VACANT]"
IGRANKS.cfrank = "Sub-Command General"
IGRANKS.cfname = "[VACANT]"

if file.Exists("saveigranks.txt", "DATA") then
    IGRANKS = util.JSONToTable(file.Read("saveigranks.txt", "DATA"))
else
    file.Write("saveigranks.txt", util.TableToJSON(IGRANKS))
end

hook.Add("PlayerInitialSpawn", "BroadcastIGStructure", function(ply)
    net.Start("broadcastrankboard")
    net.WriteTable(IGRANKS)
    net.Send(ply)
end)

local safetableoptions = {"grandadmiralrank", "grandadmiralname", "grandmoffrank", "grandmoffname", "compnordirectorrank", "compnordirectorname", "counselorrank", "counselorname", "grandgeneralrank", "grandgeneralname", "general1name", "general1rank", "general2name", "general2rank", "general3name", "general3rank", "general4name", "general4rank", "general5name", "general5rank", "general6name", "general6rank", "general7name", "general7rank", "navy1rank", "navy1name", "navy2rank", "navy2name", "engineerrank", "engineername", "govrank1", "govname1", "govrank2", "govname2", "tarkinadjutantrank", "tarkinadjutantname", "isbdirectorrank", "isbdirectorname", "isbrank1", "isbname1", "isbrank2", "isbname2", "isbadmiralrank", "isbadmiralname", "sovprotrank", "sovprotname", "cfprank", "cfpname", "cfrank", "cfname"}

net.Receive("networkrankboard", function(len, ply)
    if not ply:IsAdmin() then return end
    local option = net.ReadString()
    --if not table.HasValue(safetableoptions,option) then return end -- wtf bro your staff and tryna exploit heck off (also stops unpredicted behaviour)
    -- , let me exploit all i want >:( - Hideyoshi
    local name = net.ReadString()
    RunString([[IGRANKS.]] .. option .. [[ = "]] .. name .. [["]])
    file.Write("saveigranks.txt", util.TableToJSON(IGRANKS))
    net.Start("broadcastrankboard")
    net.WriteTable(IGRANKS)
    net.Broadcast()
end)

IGNOTICES = {}
IGNOTICES.notice1title = "Insert Notice Title Here"
IGNOTICES.notice1 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice12 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice13 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice14 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice2title = "Insert Notice Title Here"
IGNOTICES.notice2 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice22 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice23 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice24 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice3title = "Insert Notice Title Here"
IGNOTICES.notice3 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice32 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice33 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice34 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice4title = "Insert Notice Title Here"
IGNOTICES.notice4 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice42 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice43 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice44 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice5title = "Insert Notice Title Here"
IGNOTICES.notice5 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice52 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice53 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice54 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice6title = "Insert Notice Title Here"
IGNOTICES.notice6 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice62 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice63 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice64 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice7title = "Insert Notice Title Here"
IGNOTICES.notice7 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice72 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice73 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice74 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice8title = "Insert Notice Title Here"
IGNOTICES.notice8 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice82 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice83 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice84 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice9title = "Insert Notice Title Here"
IGNOTICES.notice9 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice92 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice93 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice94 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice10title = "Insert Notice Title Here"
IGNOTICES.notice10 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice102 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice103 = "Notice text will display here, this is a good line size text!!!"
IGNOTICES.notice104 = "Notice text will display here, this is a good line size text!!!"

if file.Exists("saveignotices.txt", "DATA") then
    IGNOTICES = util.JSONToTable(file.Read("saveignotices.txt", "DATA"))
else
    file.Write("saveignotices.txt", util.TableToJSON(IGNOTICES))
end

hook.Add("PlayerInitialSpawn", "BroadcastIGNotices", function(ply)
    local compressedTbl = util.Compress(util.TableToJSON(IGNOTICES))
    local size = string.len(compressedTbl)
    net.Start("broadcastnoticeboard")
    net.WriteUInt(size, 32)
    net.WriteData(compressedTbl, size)
    net.Broadcast()
end)

local safenoticetableoptions = {"notice1title", "notice1", "notice12", "notice13", "notice14", "notice2title", "notice2", "notice22", "notice23", "notice24","notice3title", "notice3", "notice32", "notice33", "notice34","notice4title", "notice4", "notice42", "notice43", "notice44","notice5title", "notice5", "notice52", "notice53", "notice54","notice6title", "notice6", "notice62", "notice63", "notice64","notice7title", "notice7", "notice72", "notice73", "notice74","notice8title", "notice8", "notice82", "notice83", "notice84","notice9title", "notice9", "notice92", "notice93", "notice94","notice10title", "notice10", "notice102", "notice103", "notice104"}

net.Receive("networknoticeboard", function(len, ply)
    if not ply:IsAdmin() then return end
    local noticeoption = net.ReadString()
    if not table.HasValue(safenoticetableoptions,noticeoption) then return end -- wtf bro your staff and tryna exploit heck off (also stops unpredicted behaviour)
    local noticename = net.ReadString()
    if not noticename or not isstring(noticename) then return end
    RunString([[IGNOTICES.]] .. noticeoption .. [[ = "]] .. noticename .. [["]])
    file.Write("saveignotices.txt", util.TableToJSON(IGNOTICES))
    local compressedTbl = util.Compress(util.TableToJSON(IGNOTICES))
    local size = string.len(compressedTbl)
    net.Start("broadcastnoticeboard")
    net.WriteUInt(size, 32)
    net.WriteData(compressedTbl, size)
    net.Broadcast()
end)



concommand.Add("rankmenuopen",function(ply) 
if ply:IsSuperAdmin() or ply:SteamID() == "STEAM_0:1:40777706"  then
net.Start("NETORANKMenu")
net.Send(ply)
end
end)

concommand.Add("noticemenuopen",function(ply) 
if ply:IsSuperAdmin() or ply:SteamID() == "STEAM_0:1:40777706"  then
net.Start("NETONOTICEMenu")
net.Send(ply)
end
end)

function netrankopen(ply, text)
    if (string.lower(text) == "!structranks") then
	if ply:IsSuperAdmin() or ply:SteamID() == "STEAM_0:1:40777706"  then
            net.Start("NETORANKMenu")
            net.Send(ply)
    end
end
end

function netstructopen(ply, text)
    if (string.lower(text) == "!structure") then
            net.Start("NETOSTRUCTMenu")
            net.Send(ply)
    end
end

function netnoticeopen(ply, text)
    if (string.lower(text) == "!notice") then
	if ply:IsSuperAdmin()or ply:SteamID() == "STEAM_0:1:40777706"  then
            net.Start("NETONOTICEMenu")
            net.Send(ply)
    end
end
end
hook.Add("PlayerSay", "openrankmenu", netrankopen)
hook.Add("PlayerSay", "openstructmenu", netstructopen)
hook.Add("PlayerSay", "opennoticemenu", netnoticeopen)