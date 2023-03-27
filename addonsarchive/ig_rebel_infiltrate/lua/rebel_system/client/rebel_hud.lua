if not CLIENT then return end
//just insert the correct variables
local questActive = nil
local questInfo = ""
local timeRemaining = 0
local questReward = 0
local countdown = false
local newChange = false 
local function charWrap(text, remainingWidth, maxWidth)
    local totalWidth = 0

    text = text:gsub(".", function(char)
        totalWidth = totalWidth + surface.GetTextSize(char)

        -- Wrap around when the max width is reached
        if totalWidth >= remainingWidth then
            -- totalWidth needs to include the character width because it's inserted in a new line
            totalWidth = surface.GetTextSize(char)
            remainingWidth = maxWidth
            return "\n" .. char
        end

        return char
    end)

    return text, totalWidth
end

local function textWrap(text, font, maxWidth)
    local totalWidth = 0

    surface.SetFont(font)

    local spaceWidth = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
            local char = string.sub(word, 1, 1)
            if char == "\n" or char == "\t" then
                totalWidth = 0
            end

            local wordlen = surface.GetTextSize(word)
            totalWidth = totalWidth + wordlen

            -- Wrap around when the max width is reached
            if wordlen >= maxWidth then -- Split the word if the word is too big
                local splitWord, splitPoint = charWrap(word, maxWidth - (totalWidth - wordlen), maxWidth)
                totalWidth = splitPoint
                return splitWord
            elseif totalWidth < maxWidth then
                return word
            end

            -- Split before the word
            if char == ' ' then
                totalWidth = wordlen - spaceWidth
                return '\n' .. string.sub(word, 2)
            end

            totalWidth = wordlen
            return '\n' .. word
        end)

    return text
end
local newText

local function DrawHUD()
    if questActive then
        if newChange then 
            newText = textWrap(questInfo,"GModToolHelp",ScrW() * 0.18)
            newChange = false 
        end
        local x,y = ScrW() * 0.8,ScrH() * 0.75
        surface.SetDrawColor(171, 39, 39,225)
        surface.DrawRect(x,y,ScrW() * 0.12,ScrH() * 0.01)

        surface.SetFont("GModToolHelp")
        surface.SetTextPos(x,y - ScrH() * 0.02)
        surface.SetTextColor(255, 255, 255)
        surface.DrawText("REBEL MISSION - " .. questReward .. " CREDITS")
        draw.DrawText(newText,"GModToolHelp",x,y + ScrH() * 0.02,Color( 255, 255, 255 ))

        surface.SetTextPos(x + ScrW() * 0.125,y - ScrH() * 0.002)
        surface.DrawText("TIME: " .. math.Round(timeRemaining, 0))
        if countdown then 
            timeRemaining = timeRemaining - RealFrameTime()
        end 
    end
end
hook.Add( "HUDPaint", "RebelQuestSystemHUD", DrawHUD)

net.Receive("RebelMissionDetils", function()
    questInfo = net.ReadString()
    timeRemaining = net.ReadInt(8)
    questReward = net.ReadInt(18)
    countdown = net.ReadBool() 
    questActive = true
    newChange = true
end)

net.Receive("RebelHUDAbort", function()
    questActive = false
    countdown = false 
end)

net.Receive("BeginRebelCountdown", function()
    countdown = true
end)

