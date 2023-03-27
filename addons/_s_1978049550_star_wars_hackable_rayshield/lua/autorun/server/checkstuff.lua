function CheckAlivestuff(activator)
    hook.Add("PlayerDeath", "TestDeath", function(vic, inf, att)
        if (vic == activator) then
            net.Start("playerdead")
            net.WriteBool(true)
            net.Send(activator)
        end
    end)
end