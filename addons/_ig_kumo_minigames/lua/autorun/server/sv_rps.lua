local rpstbl = {"rock", "paper", "scissors"}

function RPSStart(ply)
    ply:ChatPrint("You have started a game of rock paper scissors against the server!")
    ply:ChatPrint("Do you choose rock, paper or scissors? (type in chat)")

    hook.Add("IGPlayerSay", "RPSC" .. ply:SteamID64(), function(plyr, txt)
        if plyr ~= ply then return end

        if string.lower(txt) == "rock" then
            local serverschoice = table.Random(rpstbl)
            ply:ChatPrint("You have chosen rock, the server chose: " .. serverschoice)

            if serverschoice == "rock" then
                ply:ChatPrint("Its a tie! Choose rock, paper or scissors again.")
            elseif serverschoice == "paper" then
                ply:ChatPrint("You lose!.")
                hook.Remove("IGPlayerSay", "RPSC" .. ply:SteamID64())
            elseif serverschoice == "scissors" then
                ply:ChatPrint("You win, good job!")
                hook.Remove("IGPlayerSay", "RPSC" .. ply:SteamID64())
            end
        elseif string.lower(txt) == "paper" then
            local serverschoice = table.Random(rpstbl)
            ply:ChatPrint("You have chosen paper, the server chose: " .. serverschoice)

            if serverschoice == "rock" then
                ply:ChatPrint("You win, good job!")
                hook.Remove("IGPlayerSay", "RPSC" .. ply:SteamID64())
            elseif serverschoice == "paper" then
                ply:ChatPrint("Its a tie! Choose rock, paper or scissors again.")
            elseif serverschoice == "scissors" then
                ply:ChatPrint("You lose!.")
                hook.Remove("IGPlayerSay", "RPSC" .. ply:SteamID64())
            end
        elseif string.lower(txt) == "scissors" then
            local serverschoice = table.Random(rpstbl)
            ply:ChatPrint("You have chosen scissors, the server chose: " .. serverschoice)

            if serverschoice == "rock" then
                ply:ChatPrint("You lose!")
                hook.Remove("IGPlayerSay", "RPSC" .. ply:SteamID64())
            elseif serverschoice == "paper" then
                ply:ChatPrint("You win, good job!")
                hook.Remove("IGPlayerSay", "RPSC" .. ply:SteamID64())
            elseif serverschoice == "scissors" then
                ply:ChatPrint("Its a tie! Choose rock, paper or scissors again.")
            end
        end
    end)
end

hook.Add("IGPlayerSay", "RPSS", function(ply, txt)
    if string.lower(txt) == "!rps" then
        RPSStart(ply)
    end
end)