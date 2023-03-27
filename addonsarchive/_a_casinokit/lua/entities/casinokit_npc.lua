AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	if SERVER then
		if self.Model then
			self:SetModel(self.Model)
		end

		self:SetUseType(SIMPLE_USE)
		self:SetHealth(1e7)

		self.loco:SetStepHeight(10)
	end
end

function ENT:GetEyePos()
	return (self:GetPos() + Vector(5, 0, 68))
end

function ENT:LookAtAngRaw(ang)
    local yaw = math.Clamp(math.NormalizeAngle(ang.y - self:GetAngles().y), -60, 60)
    local pitch = math.Clamp(math.NormalizeAngle(ang.p), -15, 15)

	-- Causes visual artifacts if done in a draw hook, thus actual change is applied in Think
	self.PendingHeadPoseChange = { yaw = yaw, pitch = pitch, roll = 0 }
end

function ENT:LookAtAngInstant(ang)
	self:LookAtAngRaw(ang)
    self:SetEyeTarget(self:GetEyePos() + ang:Forward() * 100)
end

function ENT:LookAt(pos)
    local ang = (pos - self:GetEyePos()):Angle()
	self._LookTargetAngle = ang
end

function ENT:LookAtClosestPlayer()
	if not self.NextClosestPlyUpdate or self.NextClosestPlyUpdate < CurTime() then
		local possible_ents = player.GetAll()
		table.sort(possible_ents, function(a, b)
			local mypos = self:GetPos()
			return mypos:Distance(a:GetPos()) < mypos:Distance(b:GetPos())
		end)
		self.ClosestPly = possible_ents[1]

		self.NextClosestPlyUpdate = CurTime() + 1
	end

	local targetEnt = self.ClosestPly
	if IsValid(targetEnt) then
		self:LookAt(targetEnt:EyePos())
		return true
	end
	return false
end

if CLIENT then
	function ENT:Think()
		if self.PendingHeadPoseChange then
			local phpc = self.PendingHeadPoseChange

			self:SetPoseParameter("head_yaw", phpc.yaw)
			self:SetPoseParameter("head_pitch", phpc.pitch)
			self:SetPoseParameter("head_roll", phpc.roll)
			self:InvalidateBoneCache()

			self.PendingHeadPoseChange = nil
		end

		if IsValid(self.VoiceChan) then
			if self.VoiceChan:GetState() ~= GMOD_CHANNEL_STOPPED then
				self.FFT = self.FFT or {}
				local freqBins = self.VoiceChan:FFT(self.FFT, FFT_256)

				local accum = 0
				for i=1,freqBins do accum = accum + self.FFT[i] end

				local finalWeight = accum / 3

				self:SetFlexWeight(43, finalWeight)
			else
				self:SetFlexWeight(43, 0)
				self.VoiceChan = nil
			end
		end
	end

	function ENT:Draw()
		self:DrawModel()

		local doEyeOp = LocalPlayer():EyePos():Distance(self:GetPos()) < 512

		-- TODO figure out how to optimize this better
		if doEyeOp and self._LookTargetAngle then
			self._LookCurAngle = self._LookCurAngle or Angle(0, 0, 0)

			local approachSpeed = FrameTime() * 300

			self._LookCurAngle.p = math.ApproachAngle(self._LookCurAngle.p, self._LookTargetAngle.p, approachSpeed)
			self._LookCurAngle.y = math.ApproachAngle(self._LookCurAngle.y, self._LookTargetAngle.y, approachSpeed)
			self._LookCurAngle.r = math.ApproachAngle(self._LookCurAngle.r, self._LookTargetAngle.r, approachSpeed)

			self:LookAtAngRaw(self._LookCurAngle)
			self:SetEyeTarget(self:GetEyePos() + self._LookTargetAngle:Forward() * 100)
		end
	end

	surface.CreateFont("CKitNPCOverheadTextx", {
		font = "Roboto",
		size = 75,
		weight = 800
	})
	function ENT:DrawOverheadText(text)
		local ang = LocalPlayer():EyeAngles()
		ang:RotateAroundAxis(ang:Right(), 90)
		ang:RotateAroundAxis(ang:Up(), -90)
		cam.Start3D2D(self:GetPos() + Vector(0, 0, 82), ang, 0.1)
		draw.SimpleTextOutlined(text, "CKitNPCOverheadTextx", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER, nil, 3, Color(0, 0, 0))
		cam.End3D2D()
	end

	function ENT:SpeakFile(file)
		sound.PlayFile(file, "3d", function(chan)
			if IsValid(self.VoiceChan) then self.VoiceChan:Stop() end

			chan:SetPos(self:GetPos() + Vector(0, 0, 80))
			self.VoiceChan = chan
		end)
	end
	function ENT:SpeakUrl(url)
		sound.PlayURL(url, "3d", function(chan)
			if IsValid(self.VoiceChan) then self.VoiceChan:Stop() end

			chan:SetPos(self:GetPos() + Vector(0, 0, 80))
			self.VoiceChan = chan
		end)
	end

	net.Receive("casinokit_dealersound", function(len, cl)
		local dealer = net.ReadEntity()
		local sound = net.ReadString()
		local isFile = net.ReadBool()
		if IsValid(dealer) then
			if isFile then dealer:SpeakFile(sound) else dealer:SpeakUrl(sound) end
		end
	end)
end
if SERVER then
	function ENT:RunBehaviour()
		self:StartActivity(ACT_IDLE)
		while true do
			coroutine.wait(1e7)
			coroutine.yield()
		end
	end

	util.AddNetworkString("casinokit_dealersound")
	function ENT:SpeakFile(sound)
		net.Start("casinokit_dealersound")
		net.WriteEntity(self)
		net.WriteString(sound)
		net.WriteBool(true)
		net.SendPAS(self:GetPos())
	end
	function ENT:SpeakUrl(sound)
		net.Start("casinokit_dealersound")
		net.WriteEntity(self)
		net.WriteString(sound)
		net.WriteBool(false)
		net.SendPAS(self:GetPos())
	end
end
