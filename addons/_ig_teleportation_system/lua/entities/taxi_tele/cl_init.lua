include('shared.lua')

function ENT:Draw()
	self:DrawModel()
	
	local LP = LocalPlayer()
	local LPPos = LP:GetPos()
	if LPPos:Distance(self:GetPos()) < 600 then
		local LPAng,SelfAng = LP:EyeAngles(),self:GetAngles()
		cam.Start3D2D( self:GetPos()+(SelfAng:Up()*210)-(SelfAng:Forward()*22)+(SelfAng:Right()*25), Angle(0, LPAng.y-90, 90), .3 )
			draw.SimpleTextOutlined(Taxi_SH.EntTitle,"Taxi_Close",0,0,Color(255,255,100,240),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER, 1, Color(0,0,0,150) )
			draw.SimpleTextOutlined(Taxi_SH.EntDesc,"Taxi_Title",0,45,Color(255,255,100,160),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER, 1, Color(0,0,0,50) )
		cam.End3D2D()
	end
end

function ENT:Think()	
end

function ENT:Initialize()
end
