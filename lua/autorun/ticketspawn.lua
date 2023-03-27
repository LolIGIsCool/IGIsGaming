--[[if SERVER then
    local Tickets = 0
    local TicketMode = false
    local Hardcore = false
	local delay = 20
	local nextOccurance = 0
    local function UpdateTicketNW()
        SetGlobalBool("TicketMode", TicketMode)
        SetGlobalBool("Hardcore", Hardcore)
        SetGlobalString("Tickets", tostring(Tickets))
    end

    hook.Add("IGPlayerSay", "TicketModeCommands", function(ply, txt, tem)
        string.lower(txt)
        local tabletext = string.Explode(" ", txt)
		-- ply:IsEventMaster() or
        if (ply:IsSuperAdmin() and (tabletext[1] == "!ticketmode")) then
            Tickets = 0
            TicketMode = not TicketMode
            Hardcore = false
            ply:ChatPrint("You have changed Ticket Mode to " .. tostring(TicketMode)) -- update return messages
            UpdateTicketNW()

            return ""
        elseif (ply:IsSuperAdmin() and (tabletext[1] == "!addtickets")) and TicketMode then
            if tonumber(tabletext[2]) then
                Tickets = Tickets + tonumber(tabletext[2])

                if Tickets < 0 then
                    Tickets = 0
                end
            end

            ply:ChatPrint("You have changed the number of tickets to " .. tostring(Tickets))
            UpdateTicketNW()

            return ""
        elseif (ply:IsSuperAdmin() and (tabletext[1] == "!settickets")) and TicketMode then
            print("Working")
            if tonumber(tabletext[2]) then
                Tickets = tonumber(tabletext[2])

                if Tickets < 0 then
                    Tickets = 0
                end
            end

            ply:ChatPrint("You have changed the number of tickets to " .. tostring(Tickets))
            UpdateTicketNW()

            return ""
        elseif (ply:IsSuperAdmin() and (tabletext[1] == "!taketickets")) and TicketMode then
            if tonumber(tabletext[2]) then
                Tickets = Tickets - tonumber(tabletext[2])

                if Tickets < 0 then
                    Tickets = 0
                end
            end

            ply:ChatPrint("You have changed the number of tickets to " .. tostring(Tickets))
            UpdateTicketNW()

            return ""
        elseif (ply:IsSuperAdmin() and (tabletext[1] == "!ticketshardcore")) and TicketMode then
            Hardcore = not Hardcore
            ply:ChatPrint("You have changed Hardcore Mode to " .. tostring(Hardcore))
            UpdateTicketNW()

            return ""
        elseif tabletext[1] == "!tickets" then
            if TicketMode then
                ply:ChatPrint("Ticket Mode is enabled")
                ply:ChatPrint("There is " .. tostring(Tickets) .. " ticket(s) remaining")

                if Hardcore then
                    ply:ChatPrint("Hardcode mode is enabled")
                else
                    ply:ChatPrint("Hardcore mode is disabled")
                end
            else
                ply:ChatPrint("Ticket Mode is disabled")
            end

            return ""
        elseif tabletext[1] == "!tickethelp" then
            ply:ChatPrint("!ticketmode - enables the ticket counter")
            ply:ChatPrint("!addtickets X - adds X tickets to the counter")
            ply:ChatPrint("!settickets X - sets the number of tickets to X")
            ply:ChatPrint("!taketickets X - removes x tickets from the counter")
            ply:ChatPrint("!ticketshardcore - if the ticket counter reaches 0, players will not be able to respawn!")

            return ""
        end
    end)

    hook.Add("PlayerSpawn", "DeathTickets", function(pl)
        if pl:GetRegiment() ~= "Event" then
            Tickets = Tickets - 1
            UpdateTicketNW()
        end

        if Tickets < 0 then
            Tickets = 0
        end

        print(pl:Nick() .. " (" .. pl:SteamID() .. ") has respawned, there are now " .. Tickets .. " tickets left")
    end)

    hook.Add("PlayerDeathThink", "TicketSpawn", function(pl)
        if Hardcore and TicketMode and (Tickets <= 0) and (pl:GetRegiment() ~= "Event") then 
			local timeLeft = nextOccurance - CurTime()
			if timeLeft < 0 then
				pl:ChatPrint("Respawn Tickets have been exhausted.")
				nextOccurance = CurTime() + delay
			end
			return false 
		end
    end)
end]]
