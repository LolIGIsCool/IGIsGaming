if SERVER then
	util.AddNetworkString("StonemanNPC_SendToServer")
	util.AddNetworkString("StonemanNPC_SyncToClient")
	util.AddNetworkString("StonemanNPC_GetServerTable")
	util.AddNetworkString("StonemanNPC_SendBack")
	util.AddNetworkString("StonemanNPC_DeleteServerTable")
	util.AddNetworkString("StonemanNPC_InitClient")
end

function MCS.GetFiles()
	local server_files = file.Find("mac_npc_server/*", "DATA")
	return server_files
end
function MCS.RemakeSpawns()
	MCS.Spawns = {}
	for k, v in pairs(MCS.GetFiles()) do
		local jsontable = file.Read("mac_npc_server/" .. v, "DATA")
		local localnpc = util.JSONToTable(jsontable)

		local fixtbl = localnpc.dialogs
		for k, v in pairs(fixtbl) do
			for a, b in pairs(v["Answers"]) do
				if not isnumber(b[2]) then
					local newstring = string.Trim(b[2], '"')
					b[2] = newstring
				end
			end
		end

		MCS.Spawns[localnpc.uid] = {
			name = tostring(localnpc.name),
			model = tostring(localnpc.model),
			namepos = localnpc.namepos,
			theme = tostring(localnpc.theme),
			scale = localnpc.scale,
			questNPC = localnpc.questNPC,
			pos = localnpc.pos,
			sequence = tostring(localnpc.sequence),
			uselimit = localnpc.uselimit,
			skin = localnpc.skin,
			bgr = localnpc.bgr,
			ClModels = localnpc.ClModels,

			dialogs = fixtbl,
		}
	end

	MCS.SpawnAllNPCs()

	net.Start("StonemanNPC_SyncToClient")
		net.WriteTable(MCS.Spawns)
		net.WriteTable(MCS.GetFiles())
	net.Broadcast()
end

function MCS.ReloadSync(ply)
	net.Start("StonemanNPC_SyncToClient")
	net.WriteTable(MCS.Spawns)
	net.WriteTable(MCS.GetFiles())
	net.Send(ply)
end

function MCS.FetchNPCData(newfile, ply_select)
	local jsontable = file.Read("mac_npc_server/" .. newfile, "DATA")
	net.Start("StonemanNPC_SendBack")
		net.WriteString(jsontable)
	net.Send(ply_select)
end

function MCS.DeleteNPCData(newfile, ply_select)
	file.Delete("mac_npc_server/" .. newfile, "DATA")
	ply_select:ChatPrint("Deleted NPC file: "..newfile)
	MCS.ReloadSync(ply_select)
	MCS.RemakeSpawns()
end


if SERVER then
	net.Receive("StonemanNPC_GetServerTable", function(len, ply_selecter)
		local selected = net.ReadString()
		MCS.FetchNPCData(selected, ply_selecter)
	end)

	net.Receive("StonemanNPC_DeleteServerTable", function(len, ply_selecter)
		local selected = net.ReadString()
		MCS.DeleteNPCData(selected, ply_selecter)
	end)

	net.Receive("StonemanNPC_SendToServer", function()
		if not file.Exists("mac_npc_server", "DATA") then
			file.CreateDir("mac_npc_server")
		end

		local sv_localnpc = net.ReadTable()
		file.Write("mac_npc_server/" .. sv_localnpc.uid .. ".txt", util.TableToJSON(sv_localnpc, true))
		
		MCS.RemakeSpawns()
		
	end)
	
	hook.Add("InitPostEntity","StonemanNPC_Init", function()
		MCS.RemakeSpawns()
	end)
end

if CLIENT then
	hook.Add("InitPostEntity", "MCS.PlayerJoinedSync", function()
		net.Start("StonemanNPC_InitClient")
		net.SendToServer()
	end)
end

if SERVER then
	net.Receive("StonemanNPC_InitClient", function( len, ply )
		MCS.ReloadSync(ply)
	end)
end