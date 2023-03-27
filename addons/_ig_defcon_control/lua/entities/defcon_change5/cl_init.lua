 include('shared.lua')

function announcearrest()
	victim = net.ReadString()
    chat.AddText(Color( 128, 0, 0 ), "CT Commander Thorn", Color( 255, 255, 255 ), ": AOS ", victim, ", Unauthorised changing of defcons and Tresspassing.")
end


function ENT:Draw()

    self:DrawModel() 
    self:SetModelScale( 0.8 )
end

net.Receive("arrestannounce", announcearrest)
