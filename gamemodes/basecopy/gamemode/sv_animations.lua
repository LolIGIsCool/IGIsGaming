function GM:UpdateAnimation()
end

function GM:CalcMainActivity( ply )
	return ply.CalcIdeal, -1
end

function GM:PlayerCanHearPlayersVoice( _, ply )
	local ply = ply
	if ply.Checked == CurTime() then return end
	ply.Checked         = CurTime()
	ply.CalcIdeal       = ACT_MP_STAND_IDLE
	ply.m_bInSwim       = false

	if ply:Crouching() then
		if ply:GetVelocity():Length2DSqr() > 0.25 then
			ply.CalcIdeal = ACT_MP_CROUCHWALK
		else
			ply.CalcIdeal = ACT_MP_CROUCH_IDLE
		end
	elseif ply:WaterLevel() > 2 and !ply:OnGround() then
		ply.CalcIdeal = ACT_MP_SWIM
		ply.m_bInSwim = true
	else
		local len2d = ply:GetVelocity():Length2DSqr()
		if len2d > 22500 then
			ply.CalcIdeal = ACT_MP_RUN
		elseif len2d > 0.25 then
			ply.CalcIdeal = ACT_MP_WALK
		end
	end
	-- Allow voice to be controlled through hooks.
end

function GM:TranslateActivity()
end