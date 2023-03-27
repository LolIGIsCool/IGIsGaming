SummeLibrary.Commands = SummeLibrary.Commands or {}

function SummeLibrary:RegisterCommand(data)
    if not data then return end
    SummeLibrary.Commands[data.key] = data
end

hook.Add("PlayerSay", "SummeLibrary.ChatCommands", function(ply, msg)
    local arguments = string.Split(msg, " ")
    local command = table.remove(arguments, 1)

    for key, data in pairs(SummeLibrary.Commands) do
        if table.HasValue(data.commandList, string.lower(command)) then
            if not data.allowedRanks or table.HasValue(data.allowedRanks, string.lower(ply:GetUserGroup())) then

                data.func(ply, arguments)

                return ""
            else
                SummeLibrary:Notify(ply, "warning", "Not enough permissions", "You do not have sufficient rights to execute command "..command)
                return ""
            end
        end
    end
end)

SummeLibrary:RegisterCommand({
    key = "test",
    commandList = {"!test"},
    allowedRanks = false,
    func = function(ply, arguments)
        print("Dill")
    end,
})