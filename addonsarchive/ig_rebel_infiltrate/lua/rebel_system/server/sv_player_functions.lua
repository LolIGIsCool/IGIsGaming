
local ply = FindMetaTable("Player")

function ply:TargetHit()
	if not CLIENT then return end
	net.Start('TargetHit')
	net.SendToServer()
end

local isHacking = {}

function ply:NoLongerHacking()
	if not CLIENT then return end
	if not isHacking[self:SteamID64()] then return end 
	isHacking[self:SteamID64()] = nil
end

function ply:InitStartHackPoint()
	if not CLIENT then return end 
	if isHacking[self:SteamID64()] then return end
	isHacking[self:SteamID64()] = true
	net.Start("RebelTargetAreaCountdown")
	net.SendToServer()
end

local points = {}

function ply:MultiplePoints(point)
	if (CLIENT) then return end
	points[self:SteamID64()] = point
end

-- get and remove an element from the points list
function ply:SelectNextPoint()
	if (CLIENT) then return end
	if not points[self:SteamID64()] then return nil end
	local point, index = table.Random(points[self:SteamID64()])
	if index == nil then return nil end
	points[self:SteamID64()][index] = nil
	return point
end 

function ply:RemoveSubPoints()
	if (CLIENT) then return end
	if not points[self:SteamID64()] then return end 
	points[self:SteamID64()] = nil 
end 

function ply:SendNewMissionDetails(info, time, reward, startCountdown)
	net.Start("RebelMissionDetils")
	net.WriteString(info)
	net.WriteInt(time, 8)
	net.WriteInt(reward, 18)
	net.WriteBool(startCountdown)
	net.Send(self)
end

function ply:StartRebelMissionCountdown()
	net.Start("BeginRebelCountdown")
	net.Send(self)
end
function ply:AbortMission()
	net.Start("RebelHUDAbort")
	net.Send(self)
end 