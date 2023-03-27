
local nextTopUpdate = {}
local playerResults = {}

local function InitChessLeaderboard()
	sql.Begin()
		local query = sql.Query( [[CREATE TABLE ChessLeaderboard (SteamID varchar(255), Username varchar(255), Elo int, DraughtsElo int);]] )
	sql.Commit()
	
	if query==false then else print("Chess: Created Elo table") end
end
InitChessLeaderboard()

function Chess_UpdateElo( ply )
	if not IsValid(ply) then return end
	
	local SelStr = [[SELECT * FROM ChessLeaderboard WHERE SteamID==]].. sql.SQLStr(ply:SteamID()) ..[[;]]
	sql.Begin()
		local Select = sql.Query( SelStr )
	sql.Commit()
	
	local UpdateStr
	if Select==false then
		Error( "Chess: Save failed for player "..ply:Nick().." - Query error. "..sql.LastError().."\n" )
	elseif Select==nil then
		UpdateStr = [[INSERT INTO ChessLeaderboard (SteamID, Username, Elo, DraughtsElo) VALUES (]]..sql.SQLStr(ply:SteamID())..[[,]]..sql.SQLStr(ply:Nick())..[[,]]..sql.SQLStr(ply:GetChessElo())..[[,]]..sql.SQLStr(ply:GetDraughtsElo())..[[);]]
	else
		UpdateStr = [[UPDATE ChessLeaderboard SET Username=]]..sql.SQLStr(ply:GetName())..[[,Elo=]]..sql.SQLStr(ply:GetChessElo())..[[,DraughtsElo=]]..sql.SQLStr(ply:GetDraughtsElo())..[[ WHERE SteamID==]]..sql.SQLStr(ply:SteamID())..[[;]]
	end
	
	sql.Begin()
		local Update = sql.Query( UpdateStr )
	sql.Commit()
	
	if Update==false then
		Error( "Chess: Update failed for player "..ply:Nick().." - Query error. "..sql.LastError().."\n" )
	end
	
	nextTopUpdate = {}
	playerResults = {}
end

function Chess_GetRank( ply, typ )
	local query = string.gsub([[SELECT (
				SELECT  COUNT(*)+1
				FROM    ChessLeaderboard ordered
				WHERE   (ordered.{ELO}) > (uo.{ELO})
				) AS Rank, (SELECT COUNT(*) FROM ChessLeaderboard) AS Count
			FROM ChessLeaderboard uo WHERE SteamID==]]..sql.SQLStr(ply:SteamID())..[[;]], "{ELO}", (typ=="Draughts" and [[DraughtsElo]] or [[Elo]]) )
	sql.Begin()
		local rank = sql.Query( query )
	sql.Commit()
	
	if not (rank and rank[1] and rank[1].Rank and rank[1].Count) then return false end
	
	return rank and rank[1] and rank[1].Rank, rank and rank[1] and rank[1].Count
end

util.AddNetworkString( "Chess Top10" )
local ValidType = {["Chess"] = true, ["Draughts"] = true}

local TopTable = {}
net.Receive( "Chess Top10", function( len, ply )
	if not IsValid(ply) then return end
	
	local typ = net.ReadString()
	if not (typ and ValidType[typ]) then typ = "Chess" end
	if not playerResults[typ] then playerResults[typ] = {} end
	
	if playerResults[typ][ply] and (CurTime()<(playerResults[typ][ply].nextUpdate or 0)) then
		net.Start( "Chess Top10" )
			net.WriteString( typ )
		net.Send( ply )
		
		return
	end
	
	if CurTime()>(nextTopUpdate[typ] or 0) then
		local query = string.gsub([[SELECT Username, SteamID, {ELO} as Elo, (
					SELECT  COUNT(*)+1
					FROM    ChessLeaderboard ordered
					WHERE   (ordered.{ELO}) > (uo.{ELO})
					) AS Rank
				FROM ChessLeaderboard uo ORDER BY {ELO} DESC LIMIT 10;]], "{ELO}", (typ=="Draughts" and [[DraughtsElo]] or [[Elo]]) )
		sql.Begin()
			local Top10 = sql.Query( query )
		sql.Commit()
		
		if Top10==false then
			Error( "Chess: Top10 retrieval failed - Query error. "..sql.LastError().."\n" )
			return
		elseif Top10==nil then
			Error( "Chess: Top10 retrieval failed - No data." )
			return
		end
		
		TopTable = Top10
		
		table.Empty(playerResults[typ])
		nextTopUpdate[typ] = CurTime() + 120
	end
	
	local str = ""
	if (not playerResults[typ][ply]) or CurTime()<(playerResults[typ][ply].nextUpdate) then
		local rank,total = Chess_GetRank(ply, typ)
		playerResults[typ][ply] = {rank = rank, total = total}
	end
	local res = playerResults[typ][ply]
	str = (res.rank and res.total and res.rank.." of "..res.total) or res.rank or "N/A"
	
	net.Start( "Chess Top10" )
		net.WriteString( typ )
		net.WriteTable( TopTable )
		
		net.WriteString( str )
		net.WriteString(math.floor(nextTopUpdate[typ] - 120))
	net.Send( ply )
	
	playerResults[typ][ply].nextUpdate = CurTime() + 30
end)

-- function TestElo()
	-- local typ = ""
	
	-- local query = string.gsub([[SELECT *,(
				-- SELECT  COUNT(*)+1
				-- FROM    ChessLeaderboard ordered
				-- WHERE   (ordered.{ELO}) > (uo.{ELO})
				-- ) AS Rank, (SELECT COUNT(*) FROM ChessLeaderboard) AS Count
			-- FROM ChessLeaderboard uo ORDER BY {ELO} DESC;]], "{ELO}", (typ=="Draughts" and [[DraughtsElo]] or [[Elo]]) )
	-- sql.Begin()
		-- local Top10 = sql.Query( query )
	-- sql.Commit()
	
	-- if Top10 then
		-- print( Top10 )
		-- PrintTable( Top10 )
		
		-- print( Top10[1].Rank, type(Top10[1].Rank) )
	-- else
		-- print( sql.LastError() )
	-- end
-- end
