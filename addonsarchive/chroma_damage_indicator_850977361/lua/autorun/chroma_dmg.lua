if SERVER then
	util.AddNetworkString("TFA_ChromaDMG")

	hook.Add("EntityTakeDamage","ChromaDMG_ETD",function(ent,dmg)
		if ent:IsPlayer() then
			net.Start("TFA_ChromaDMG")
			if dmg:IsExplosionDamage() then
				net.WriteFloat( dmg:GetDamage() * 4 )
			else
				net.WriteFloat( dmg:GetDamage() )
			end
			net.Send( ent )
		end
	end)
end
if CLIENT then
	local intensity = 0
	local its
	local ply

	local mindmg = 25 -- minimum simulated damage
	local multiplier = 1 / 32 * 3.28 / 255 * 10 --DMG * this
	local maxints = multiplier * 100
	local healthdamagesim = 50 --Simulate missing health at [this] much damage constantly
	local fade = maxints * 2 / 3--Fade per second; fades out an avg bullet hit in 0.25 seconds

	local lrss

	local cv_enabled = CreateClientConVar("cl_tfa_chromadmg_enable","1",true,false,"Enable the effect?")
	local cv_strength = CreateClientConVar("cl_tfa_chromadmg_strength","1",true,false,"Strength multiplier of the chromA damage effect.")
	local cv_recovery = CreateClientConVar("cl_tfa_chromadmg_recovery","1",true,false,"Recovery multiplier of the chromA damage effect.")
	local cv_min = CreateClientConVar("cl_tfa_chromadmg_minimum","1",true,false,"Minimum effect intensity upon receiving damage.")
	local cv_max = CreateClientConVar("cl_tfa_chromadmg_maximum","1",true,false,"Maximum cumulative value of the chromA damage effect.")
	local cv_hp = CreateClientConVar("cl_tfa_chromadmg_healthscale","1",true,false,"Scale of the low-HP chromA effect.")

	net.Receive("TFA_ChromaDMG",function()
		if not cv_enabled:GetBool() then return end
		local dmg = net.ReadFloat()
		if dmg then
			intensity = math.max( intensity + dmg * multiplier * cv_strength:GetFloat(), multiplier * mindmg * cv_strength:GetFloat() * cv_min:GetFloat() )
		end
	end)
	hook.Add("RenderScreenspaceEffects","ChromaDMG_Checker",function()
		if not TFA_DrawChroma then
			hook.Remove("RenderScreenspaceEffects","ChromaDMG")
			hook.Remove("HUDShouldDraw","ChromaDMG_HideHUD")
			if IsValid( LocalPlayer() ) then
				LocalPlayer():ChatPrint("You are missing Unreal Enhancements!  Your ChromA Damage Indicator will not work.")
				hook.Remove("RenderScreenspaceEffects","ChromaDMG_Checker")
			end
		else
			hook.Remove("RenderScreenspaceEffects","ChromaDMG_Checker")
		end
	end)
	hook.Add("RenderScreenspaceEffects","ChromaDMG",function()
		if not cv_enabled:GetBool() then return end
		if not IsValid(ply) then
			ply = LocalPlayer()
			return
		end
		if not lrss then
			lrss = SysTime()
		end
		local delta = SysTime() - lrss
		intensity = math.Clamp( intensity - fade * delta * math.sqrt( intensity / maxints ) * cv_recovery:GetFloat(), 0, maxints * cv_max:GetFloat() )
		its = intensity + multiplier * math.pow( math.Clamp( 100 -  ply:Health(), 0 , 100 ) / 100, 2 ) * healthdamagesim * cv_hp:GetFloat()
		lrss = SysTime()
		if its > 0.01 then
			TFA_DrawChroma( 255 * its, 0 * its, 0 * its, 255 * its, 208 * its, 0 * its )
		end
	end)

	local hide = {
		CHudDamageIndicator = true
	}

	hook.Add( "HUDShouldDraw", "ChromaDMG_HideHUD", function( name )
		if not cv_enabled:GetBool() then return end
		if ( hide[ name ] ) then return false end

		-- Don't return anything here, it may break other addons that rely on this hook.
	end )

end