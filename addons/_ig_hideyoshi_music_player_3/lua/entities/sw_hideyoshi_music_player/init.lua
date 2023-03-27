--                                                  --
--        Hideyoshi's Revamped Music Player         --
--                                                  --

AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
AddCSLuaFile( 'hds_mp/cl_imgui.lua' )
AddCSLuaFile("hds_mp/cl_jsfunction.lua")
AddCSLuaFile("hds_mp/cl_songprocessor.lua")
AddCSLuaFile("hds_mp/cl_queue.lua")
AddCSLuaFile("vgui/cl_derma.lua")
AddCSLuaFile("hds_mp/sh_playlist.lua")

include('shared.lua')
include('config/sv_config.lua')

util.AddNetworkString("processSongRequest")
util.AddNetworkString("broadcastSongRequest")
util.AddNetworkString("hdsmp_stateChange-sv")
util.AddNetworkString("hdsmp_stateChange-cl")
util.AddNetworkString("hdsmp_sendTimeOrder")
util.AddNetworkString("hdsmp_executeTimeOrder")
util.AddNetworkString("hdsmp_submitQueue")
util.AddNetworkString("hdsmp_pushQueue")
util.AddNetworkString("hdsmp_savePlaylist")
util.AddNetworkString("hdsmp_sendUserPlaylist")
util.AddNetworkString("hdsmp_requestPlaylist")
util.AddNetworkString("hdsmp_deployPlaylist")
util.AddNetworkString("hdsmp_setLooping")

local plySpawnerRaw
local playlistStorage
if (hdsMP_queueConstruct == nil) then
	hdsMP_queueConstruct = {}
end

function ENT:Initialize()

	self:SetModel('models/props_lab/reciever01a.mdl')
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )

	self:Setent_plyspawner(plySpawnerRaw:SteamID())

	hdsMP_queueConstruct[self:EntIndex()] = nil
	self:SetqueueConstruct("{}")

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180

	plySpawnerRaw = ply

	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:SetAngles( SpawnAng )
	ent:Spawn()
	ent:Activate()

	return ent

end

function ENT:Use( activator, caller )
	return
end

function processSongRequest_sv(len, ply)
	-- insert security check here
	if (!ply:IsAdmin()) then return end
	--local netTable = net.ReadTable()
	local ent = Entity(net.ReadInt(21))

	if (IsValid(ent) and ent:GetClass() == "sw_hideyoshi_music_player") then
		--[[
			Global Music Check
		]]--
		local isExternal = net.ReadBool()
		local global = net.ReadBool()
		local rank = ply:GetUserGroup()
		if (global and !table.HasValue(hdsMusic_config.globalMusic_ulx, rank)) then
			return
		end

		local query = net.ReadString()
		local volume = net.ReadInt(11)
		local soundDistance = net.ReadInt(11)

		--[[
			External Music Check
		]]
		if (isExternal and table.HasValue(hdsMusic_config.converterMusic_ulx, rank)) then
			convertURL(
				global,
				query,
				ent,
				volume,
				soundDistance,
				net.ReadString()
			)
			return
		elseif (isExternal) then
			return
		end

		local flags = "noplay noblock"
		if (!global) then
			flags = flags.." 3d"
		end

		local songName = string.Replace(query, ".mp3", ""):gsub("(%a)(%a+)", function(a, b) return string.upper(a) .. string.lower(b) end)

		broadcastSongRequest(
			ent,
			false,
			query,
			flags,
			songName,
			volume,
			soundDistance
		)

	end
end

function convertURL(
	isGlobal,
	url,
	self,
	volume,
	soundDistance,
	_callback)
	--local url = netTable.url
	http.Fetch( hdsMusic_config.convServer.."conversion?key="..hdsMusic_config.accesKey.."&server="..hdsMusic_config.server.."&url="..url,

		function( body, length, headers, code )
			local response = util.JSONToTable(body)
			if (response["success"] ~= nil) then
				local flags = "noplay noblock"
				if (!isGlobal) then
					flags = flags.." 3d"
				end

				broadcastSongRequest(
					self,
					true,
					response.url,
					flags,
					string.Left(response.title, 40),
					volume,
					soundDistance
				)
			end
		end,

		function( message )
			-- We failed. =(
			print( message )
		end,

		{
			["accept-encoding"] = "gzip, deflate",
			["accept-language"] = "fr"
		}

	)
end

net.Receive("processSongRequest", processSongRequest_sv)

function broadcastSongRequest(
	self,
	isExternal,
	query,
	flags,
	songName,
	volume,
	soundDistance
)

	net.Start("broadcastSongRequest")
		net.WriteEntity(self)
		net.WriteBool(isExternal)
		net.WriteString(query)
		net.WriteString(flags)
		net.WriteString(songName)
		net.WriteInt(volume, 11)
		local globalcheckStart, globalcheckEnd = string.find( flags:lower(), "3d" )
		if (globalcheckStart) then
			net.WriteInt(soundDistance, 15)
		end
	net.Broadcast()
end

function hdsmp_getTimeOrder(len, ply)
	if (!ply:IsAdmin()) then return end
	local time = net.ReadInt(32)
	local ent = net.ReadInt(11)


	--if (ent:GetClass() ~= "sw_hideyoshi_music_player") then return end

	net.Start("hdsmp_executeTimeOrder")
		net.WriteInt(time, 32)
		net.WriteInt(ent, 11)
	net.Broadcast()
end
net.Receive("hdsmp_sendTimeOrder", hdsmp_getTimeOrder)

function stateChange_sv(len, ply)
	if (!ply:IsAdmin()) then return end
	local ent = Entity(net.ReadInt(21))

	if (ent:GetClass() ~= "sw_hideyoshi_music_player") then return end

	local state = net.ReadString()
    local validStates = {
        "play",
        "pause",
        "stop"
    }

	if (table.HasValue(validStates, state) and IsValid(ent)) then
		net.Start("hdsmp_stateChange-cl")
			net.WriteEntity(ent)
			net.WriteString(state)
		net.Broadcast()
	end
end
net.Receive("hdsmp_stateChange-sv", stateChange_sv)

function processQueueSubmission(len, ply)
	if (!ply:IsAdmin()) then return end

	local netTable = net.ReadTable()

	local entIndex = netTable.entIndex
	local songLocate = netTable.songLocate
	local songTitle = netTable.songName
	local isExternal = netTable.isExternal

	local rank = ply:GetUserGroup()

	--[[if (isExternal and table.HasValue(hdsMusic_config.converterMusic_ulx, rank)) then
		return
	end]]--

	local ent = Entity(entIndex)
	if (IsValid(ent) and ent:GetClass() == "sw_hideyoshi_music_player") then
		if (hdsMP_queueConstruct[entIndex] == nil) then
			hdsMP_queueConstruct[entIndex] = {}
		end
		table.insert(hdsMP_queueConstruct[entIndex], {
			songTitle,
			songLocate,
			isExternal
		})
		local queueInfoJSON = util.TableToJSON(hdsMP_queueConstruct[entIndex])
		ent:SetqueueConstruct(queueInfoJSON)
		--[[net.Start("hdsmp_notifyHost")
			net.WriteInt(entIndex, 21)
		net.Send(player.GetBySteamID(ent:Getent_plyspawner()))]]--

		//for k,v in ipairs( player.GetAll() ) do
			ply:SendLua([[ if (frameMuse:IsVisible()) then hdsmp_renderQueuePanel() end ]])
		//end
	end

end
net.Receive("hdsmp_submitQueue", processQueueSubmission)

function hdsmp_pushQueue(len, ply)
	if (!ply:IsAdmin()) then return end

	local plyRank = ply:GetUserGroup()

	local pushTimes = net.ReadInt(11)
	local entIndex = net.ReadInt(21)
	local ent = Entity(entIndex)
    if (ent:GetClass() ~= "sw_hideyoshi_music_player") then return end

	local queueJSON = ent:GetqueueConstruct()
	local queue = util.JSONToTable(queueJSON)
	if (#queue == 0) then return end
	--PrintTable(queue)

	local submitName = queue[1][1]
	local sunmitValue = queue[1][2]
	local isExternal = queue[1][3]

	if #queue > 1 then
		table.remove(queue, 1)
	elseif (#queue == 1) then
		queue = {}
	end

	--[[if queueValue == 1 then
		queue = {}
	end]]--
	hdsMP_queueConstruct[entIndex] = queue
	local submitQueue = util.TableToJSON(queue)

	ent:SetqueueConstruct(submitQueue)


	if (isExternal and table.HasValue(hdsMusic_config.converterMusic_ulx, plyRank)) then
		convertURL(
			false,
			sunmitValue,
			ent,
			100,
			200
		)

		return
	elseif (isExternal) then
		return
	end

	--local songName = string.Replace(queue[1][1], ".mp3", ""):gsub("(%a)(%a+)", function(a, b) return string.upper(a) .. string.lower(b) end)

	local flags = "noplay noblock"
	broadcastSongRequest(
		ent,
		false,
		sunmitValue,
		flags,
		submitName,
		100,
		200
	)
end
net.Receive("hdsmp_pushQueue", hdsmp_pushQueue)

function hdsmp_savePlaylist(len, ply)
	if (!ply:IsAdmin()) then return end
	local playlistName = net.ReadString()
	local entIndex = net.ReadInt(21)
	local ent = Entity(entIndex)

    if (ent:GetClass() ~= "sw_hideyoshi_music_player") then return end

	if (table.HasValue(hdsMusic_config.serverPlaylist_ulx, ply:GetUserGroup())) then
		savePlaylist(ent, ply, {name = playlistName})
	end
end
net.Receive("hdsmp_savePlaylist", hdsmp_savePlaylist)

function hdsmp_processPlaylistrequest(len, ply)
	if (!ply:IsAdmin()) then return end

	playlistStorage = getPlaylist(ply)
end
net.Receive("hdsmp_requestPlaylist", hdsmp_processPlaylistrequest)

function hdsmp_deployPlaylist(len, ply)
	if (!ply:IsAdmin()) then return end

	local submitPlaylist
	local deployPlaylist

	local entIndex = net.ReadInt(21)
	local ent = Entity(entIndex)
    if (ent:GetClass() ~= "sw_hideyoshi_music_player") then return end

	local process = net.ReadString()
	if (process == "server" and playlistStorage ~= nil) then
		deployPlaylist = playlistStorage[net.ReadString()]
	elseif (process == "client") then
		deployPlaylist = net.ReadTable()
	end

	if (deployPlaylist ~= nil ) then

		for k,v in pairs(deployPlaylist) do
			if (v[3] == true) then
				if (!table.HasValue(hdsMusic_config.converterMusic_ulx, ply:GetUserGroup())) then
					return false
				end
				break;
			end
		end

		deployPlaylist.Owner = nil
		local submitPlaylist = util.TableToJSON(deployPlaylist)
		hdsMP_queueConstruct[entIndex] = submitPlaylist
		ent:SetqueueConstruct(submitPlaylist)

		for k,v in ipairs( player.GetAll() ) do
			v:SendLua([[ if (IsValid(frameMuse) and frameMuse:IsVisible()) then hdsmp_renderQueuePanel() end ]])
		end

	end
end
net.Receive("hdsmp_deployPlaylist", hdsmp_deployPlaylist)

function hdsmp_setLooping(len, ply)
	if (!ply:IsAdmin()) then return end
	local entIndex = net.ReadInt(21)

	for k,v in ipairs(player.GetAll()) do
		v:SendLua([[ if (!IsValid(Entity(]].. entIndex ..[[).sw_station)) then return end Entity(]].. entIndex ..[[).sw_station:EnableLooping(!Entity(]].. entIndex ..[[).sw_station:IsLooping())]])
	end
end
net.Receive("hdsmp_setLooping", hdsmp_setLooping)

-- yo rock on dude lol tiktok
function isDJ(ply)
	return table.HasValue(hdsMusic_config, value)
end
