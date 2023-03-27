SummeLibrary.Addons = {}

function SummeLibrary:Print(addon, ...)
    local addonData = SummeLibrary.Addons[addon] or SummeLibrary.Addons["main"]
    local args = {...}

    MsgC(addonData.color or Color(255,1,1), "[", addonData.name or "Error", "] ", color_white, unpack(args) .. "\n")
end

function SummeLibrary:Error(addon, ...)
    local addonData = SummeLibrary.Addons[addon] or SummeLibrary.Addons["main"]
    local args = {...}

    MsgC(addonData.color or Color(255,1,1), "[", addonData.name or "Error", "] ", Color(255,72,72), unpack(args) .. "\n")
end

function SummeLibrary:Success(addon, ...)
    local addonData = SummeLibrary.Addons[addon] or SummeLibrary.Addons["main"]
    local args = {...}

    MsgC(addonData.color or Color(255,1,1), "[", addonData.name or "Error", "] ", Color(72,255,81), unpack(args) .. "\n")
end

function SummeLibrary:Register(data)
    local tbl = {
        name = data.name or "nA",
        color = data.color or Color(255,255,65),
        version = data.version or false,
    }

    SummeLibrary.Addons[data.class] = tbl

    local versionString = ""

    if data.version then
        versionString = " (Version: "..data.version..")"
    end

    SummeLibrary:Print("main", "Registering addon: " .. tbl.name.. versionString)

    hook.Run(tbl.name..".Registered")
end

SummeLibrary:Register(
    {
        class = "main",
        name = "SummeLibrary",
        color = Color(29, 221, 4),
        version = "1.2"
    }
)

hook.Add("SummeLibrary.Loaded", "SummeLibrary.InfoText", function()
    SummeLibrary:Success("main", "Loaded with version "..SummeLibrary.Version)
end)

concommand.Add("summelibrary", function(ply, cmd, args)
    SummeLibrary:Success("main", "This Server is running SummesLibrary with version "..SummeLibrary.Version)
    PrintTable(SummeLibrary.Addons)
end)