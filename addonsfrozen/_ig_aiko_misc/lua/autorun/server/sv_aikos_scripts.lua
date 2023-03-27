if (game.GetMap() == "rp_batuu_v1") then
    timer.Create("AOSZoneRestrictor", 2, 0, function()
        for k, v in pairs(ents.FindInBox(Vector(-16081.982422, -15527.603516, -12772.232422), Vector(12662.054688, 13389.164063, -17008.806641))) do
            if (v:IsPlayer() and v:IsAOS()) then
                v:SetPos(Vector(-8115.286621, 13823.553711, -5610.968750))
                v:QUEST_SYSTEM_ChatNotify("Training Area Overwatch", "The Training Area has high ranking personnel watching it at all times, surely you aren't that dumb to hide in there.")
            end
        end
    end)
end