SummeLibrary.IngameConfig = SummeLibrary.IngameConfig or {}
SummeLibrary.IngameConfig.Data = SummeLibrary.IngameConfig.Data or {}


function SummeLibrary:CreateAddonConfig(addonClass, sort)
    
end

-- T Y P E S:
-- string
-- float
-- integer
-- select
-- multiselect
-- color
-- boolean

function SummeLibrary:AddConfigOption(addonClass, name, type)

end

local src = "https://raw.githubusercontent.com/SummeGaming/SummeLibrary/main/data/addons.json"


function SummeLibrary:CheckRecentVersion(addonClass, callback)
    http.Fetch(src,
    function(body, length, headers, code)
        local data = util.JSONToTable(body)

        if data[addonClass] then
            local versionNum = data[addonClass][1].version

            local currentVersion = SummeLibrary.Addons[addonClass].version
            currentVersion = tonumber(currentVersion)

            callback(versionNum <= currentVersion and "LATEST" or "OLD")

            return "N/A"
        end

        callback(false)
        return
    end,
    function(errorMsg)
        
    end)
end