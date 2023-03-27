function processQueueAdition(songName, songValue, isExternal, hideMusic)
    local menu = DermaMenu() 
        local option = menu:AddOption( "Add to Queue", function() 
            local queueConstruct = {
                songName = songName,
                songLocate = songValue,
                isExternal = isExternal,
                entIndex = hideMusic.instance:EntIndex()
            }
            --PrintTable(queueConstruct)

            net.Start("hdsmp_submitQueue")
                net.WriteTable(queueConstruct)
            net.SendToServer()
        end )
        option:SetIcon("icon16/add.png")
    menu:Open()
end

function hdsmp_handleNotification()
    local entIndex = net.ReadInt(21)
end
net.Receive("hdsmp_notifyHost", hdsmp_handleNotification)