if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Stun Charge"
ATTACHMENT.ShortName = "S-M" --Abbreviation, 5 chars or less please
--ATTACHMENT.ID = "base" -- normally this is just your filename
ATTACHMENT.Description = { 
	TFA.AttachmentColors["+"],"Stunned for 10 Seconds",
	TFA.AttachmentColors["+"],"Special Regenerative Ammo",
}
ATTACHMENT.Icon = "entities/att/stun_mod.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["AmmoConsumption"] = 100,
		["StatusEffect"] = "stun",
		["StatusEffectDmg"] = 20,
		["StatusEffectDur"] = 10,
		["StatusEffectParticle"] = true,
		["Damage"] = 10,
		["ClipSize"] = 100,
		["Ammo"] = "x",
		["SpreadMultiplierMax"] = 1,
	},
	["TracerName"] = "rw_sw_laser_white",
}

function ATTACHMENT:Attach(wep)
	wep.CustomBulletCallbackOld = wep.CustomBulletCallbackOld or wep.CustomBulletCallback
	wep.CustomBulletCallback = function(a, tr, dmg)
		local wep = dmg:GetInflictor()
		if wep:GetStat("Primary.StatusEffect") then
			GMSNX:AddStatus(tr.Entity, wep:GetOwner(), wep:GetStat("Primary.StatusEffect"), wep:GetStat("Primary.StatusEffectDur"), wep:GetStat("Primary.StatusEffectDmg"), wep:GetStat("Primary.StatusEffectParticle"))
		end
	end
	wep.ImpactEffect = "rw_sw_impact_white"
	wep:Unload()
end

function ATTACHMENT:Detach(wep)
	wep.CustomBulletCallback = wep.CustomBulletCallbackOld
	wep.CustomBulletCallbackOld = nil
	wep.ImpactEffect = "rw_sw_impact_blue"
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end