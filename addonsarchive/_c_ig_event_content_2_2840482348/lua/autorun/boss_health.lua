
bossHealthSystem = bossHealthSystem or {}

if SERVER then
	util.AddNetworkString("add_boss")
	util.AddNetworkString("remove_boss")
	util.AddNetworkString("boss_data")
end

// Getters and setters
function bossHealthSystem:GetBoss()
	return self.bossEntity
end

function bossHealthSystem:GetMult()
	return self.bossDmgscale
end

function bossHealthSystem:AddBoss(ent, maxHealth, health, name, label, dmgscale, icon)
	if SERVER then
		ent:SetHealth(health)
		ent:SetMaxHealth(maxHealth)
	end

	self.bossEntity = ent
	self.bossName = name
	self.bossLabel = label
	self.bossDmgscale = dmgscale
	self.bossIcon = icon
	
	if SERVER then
		net.Start("add_boss")
			net.WriteEntity(self.bossEntity)
			net.WriteString(name)
			net.WriteString(label)
			net.WriteString(icon)
		net.Broadcast()

		net.Start("boss_data")
			net.WriteEntity(self.bossEntity)
			net.WriteString(name)
			net.WriteString(label)
			net.WriteString(icon)
		net.Broadcast()
	end
end

function bossHealthSystem:RemoveBoss()
	self.bossEntity = nil

	if SERVER then
		net.Start("remove_boss")
		net.Broadcast()
	end
end

function bossHealthSystem:IsValidBoss()
	return IsValid(self.bossEntity)
end

if CLIENT then
	net.Receive("add_boss", function(len) 
		local ent = net.ReadEntity()
		local name = net.ReadString()
		local label = net.ReadString()
		local icon = net.ReadString()

		bossHealthSystem:AddBoss(ent, name, label, icon)
	end)

	net.Receive("remove_boss", function(len)
		bossHealthSystem:AddBoss(NULL)
	end)
end

--SERVER HOOKS!!!!!!--
hook.Add("OnNPCKilled","BossNPCDeath",function(npc)
	if not IsValid(bossHealthSystem:GetBoss()) then return end
	if npc == bossHealthSystem:GetBoss() then
		bossHealthSystem:RemoveBoss()
	end
end)

hook.Add("PlayerDeath","BossDeath",function(victim)
	if not IsValid(bossHealthSystem:GetBoss()) then return end
	if victim == bossHealthSystem:GetBoss() then
		bossHealthSystem:RemoveBoss()
	end
end)

hook.Add("EntityRemoved","BossRemoved",function(ent)
	if not IsValid(bossHealthSystem:GetBoss()) then return end
	if ent == bossHealthSystem:GetBoss() then
		bossHealthSystem:RemoveBoss()
	end
end)

hook.Add("PlayerDisconnected","BossDisconnected",function(ply)
	if not IsValid(bossHealthSystem:GetBoss()) then return end
	if ply == bossHealthSystem:GetBoss() then
		bossHealthSystem:RemoveBoss()
	end
end)

hook.Add("EntityTakeDamage","BossDamageMult",function(ply,dmg)
	if not IsValid(bossHealthSystem:GetBoss()) then return end
	local bossent = dmg:GetAttacker()
	if bossent == bossHealthSystem:GetBoss() then
		dmg:ScaleDamage(bossHealthSystem:GetMult())
	end
end) 