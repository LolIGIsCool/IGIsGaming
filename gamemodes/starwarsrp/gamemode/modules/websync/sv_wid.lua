hook.Add("IGPlayerSay", "SyncWebsiteStuff", function(ply, text)
    text = string.Explode(" ", text)

    if string.lower(text[1]) == "!websync" then
        local webid = ply:GetIGData("wid","0000")
        local requestedid = string.lower(table.concat(text, " ", 2))

        if webid ~= "0000" then
            http.Fetch("https://imperialgamingau.invisionzone.com/api/core/members/" .. webid .. "?key=3586a4f9835e30f5f46e3d1a1e7da757", function(body)
                local memetable = util.JSONToTable(body)

                if not memetable or not istable(memetable) then
                    print("API REQUEST FAILED")

                    return
                end

                local steamfields = string.gsub(memetable.profileUrl, [[\]], "")
                ply:QUEST_SYSTEM_ChatNotify("IG Web Sync", "You are already synced to a forums account (" .. steamfields .. ")")
                print("already synced")
            end, function()
                ply:QUEST_SYSTEM_ChatNotify("IG Web Sync", "The API is currently unfunctional, please try again later and contact kumo if this error persists")
            end)
        else
            if not text[2] then
                ply:QUEST_SYSTEM_ChatNotify("IG Web Sync", "Please provide a desired forum Account ID or Account URL to sync with ( !websync (url/id) )")
                print("account id not provided")

                return
            end

            if not tonumber(requestedid) then
                if not string.find(requestedid, "%d") or not string.find(requestedid, "-") then
                    ply:ChatPrint("Invalid Profile URL")
                    print("invalid url")

                    return
                end

                requestedid = string.sub(requestedid, string.find(requestedid, "%d"), string.find(requestedid, "-") - 1)
            end

            http.Fetch("https://imperialgamingau.invisionzone.com/api/core/members/" .. requestedid .. "?key=3586a4f9835e30f5f46e3d1a1e7da757", function(body)
                local memetable = util.JSONToTable(body)

                if not memetable or not memetable.customFields or not memetable.customFields[1] or not memetable.customFields[1].fields or not memetable.customFields[1].fields[2] then
                    ply:ChatPrint("Invalid response from API - Ensure the profile ID actually exists and the SteamID field is set properly or use the profile URL")
                    print("user doesnt exist")

                    return
                end

                local steamfields = memetable["customFields"][1]["fields"][2].value

                if steamfields == ply:SteamID64() or steamfields == ply:SteamID() then
                    ply:SetIGData("wid", requestedid)
                    ply:QUEST_SYSTEM_ChatNotify("IG Web Sync", "Website Profile successfully synced! Enjoy your 5000 credits")
                    print("successful sync")
                    ply:SH_AddPremiumPoints(5000, nil, false, false)
                else
                    ply:QUEST_SYSTEM_ChatNotify("IG Web Sync", "Set the SteamID field on your forums account (Account>Profile>Edit Profile>Steam) to your Steam ID 64 (!steamid64 ^) and try again")
                    print("steamid mismatch")
                end
            end, function()
                ply:QUEST_SYSTEM_ChatNotify("IG Web Sync", "The API is currently unfunctional, please try again later and contact kumo if this error persists")
            end)
        end
    end
end)

local plyr = FindMetaTable("Player")
function plyr:GetWebsiteURL()
    http.Fetch("https://imperialgamingau.invisionzone.com/api/core/members/" .. self:GetWebsiteID() .. "?key=3586a4f9835e30f5f46e3d1a1e7da757", function(body)
        local memetable = util.JSONToTable(body)

        if not memetable or not istable(memetable) then
            print("API REQUEST FAILED")

            return
        end

        return string.gsub(memetable.profileUrl, [[\]], "")
    end, function() end)
end

hook.Add("PlayerInitialSpawn","SpawnWebSyncReminder",function(ply)
	timer.Simple(10,function()
		if ply:GetIGData("wid","0000") == "0000" then
			ply:QUEST_SYSTEM_ChatNotify("IG Web Sync", "Receive 5000 credits from syncing you forums account to your steam account! - type !websync for more info")
		end
	end)
end)

timer.Create("SyncReminderIG",1200,0,function()
    for _,ply in pairs(player.GetAll()) do
        if ply:GetIGData("wid","0000") == "0000" then
            ply:QUEST_SYSTEM_ChatNotify("IG Web Sync", "Receive 5000 credits from syncing you forums account to your steam account! - type !websync for more info")
        end
    end
end)

GROUPSID = {
    ["Junior Developer"] = 49,
    ["Lead Event Master"] = 58,
    ["Trial Moderator"] = 9,
    ["Donator"] = 8,
    ["Moderator"] = 29,
    ["Senior Event Master"] = 36,
    ["Junior Event Master"] = 37,
    ["Senior Moderator"] = 34,
    ["Developer"] = 17,
    ["admin"] = 30,
    ["Event Master"] = 11,
    ["Trial Event Master"] = 38,
    ["Junior Moderator"] = 48,
    ["Member"] = 3
}

hook.Add("PostGamemodeLoaded", "GroupsIDRefresh", function()
    http.Fetch("https://imperialgamingau.invisionzone.com/api/core/groups?key=3586a4f9835e30f5f46e3d1a1e7da757&perPage=50", function(body)
        local memetable = util.JSONToTable(body)

        for k, v in pairs(memetable.results) do
            for a,b in pairs(GROUPSID) do
                if b == v.id then
                    print("[WebSync] Found Group Name"..a.." | Website Name: "..v.name)
                end
            end
        end
    end)
end)