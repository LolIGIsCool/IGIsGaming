/*
* You can copy this file for your own server/personal use.
* What you can't do is use it in a commercial project without my approval (add me at http://steamcommunity.com/id/shendow/)
* I won't provide much support if you run into trouble editing this file.
*/

local base_table = SH_POINTSHOP
local prefix = "SH_POINTSHOP."

function base_table:DBPrint(s)
	local src = debug.getinfo(1)
	local _, __, name = src.short_src:find("addons/(.-)/")
	MsgC(Color(0, 200, 255), "[" .. name:upper() .. " DB] ", color_white, s, "\n")
end

function base_table:ConnectToDatabase()
		self:DBPrint("Defaulting to sqlite")
		self.m_bConnectedToDB = true

		if (self.DatabaseConnected) then
			self:DatabaseConnected()
		end
end

function base_table:IsConnectedToDB()
	return self.m_bConnectedToDB or true
end

function base_table:Query(query, callback)
	if (!self:IsConnectedToDB()) then
		return end

	local dm = self.DatabaseMode
	local was_off = _SH_QUERY_SILENT or false

	callback = callback or function(q, ok, ret) end

	if (dm == "mysqloo") then
		local q = _G[prefix .. "DB"]:query(query)
		q.onSuccess = function(me, data)
			_SH_QUERY_LAST_INSERT_ID = me:lastInsert()
			callback(query, true, data)
			_SH_QUERY_LAST_INSERT_ID = nil
		end
		q.onError = function(me, err, fq)
			callback(query, false, err .. " (" .. fq .. ")")

			if not (was_off) then
				self:DBPrint(err .. " (" .. fq .. ")")
			end
		end
		q:start()
	else
		local d = sql.Query(query)
		if (d ~= false) then
			callback(query, true, d or {})
		else
			callback(query, false, sql.LastError())

			if not (_SH_QUERY_SILENT) then
				print("sqlite error (" .. query .. "): " .. sql.LastError())
			end
		end
	end
end

function base_table:Escape(s)
	local dm = self.DatabaseMode
	if (dm == "mysqloo") then
		return _G[prefix .. "DB"]:escape(s)
	else
		return sql.SQLStr(s, true)
	end
end

function base_table:BetterQuery(query, args, callback)
	for k, v in pairs (args or {}) do
		if (isstring(v)) then
			v = self:Escape(v)
		elseif (type(v) == "Player") then
			v = self:NetworkID(v)
		else
			v = tostring(v)
		end

		query = query:Replace("{" .. k .. "}", "'" .. v .. "'")
		query = query:Replace("[" .. k .. "]", v)
	end

	self:Query(query, callback)
end

function base_table:NetworkID(ply)
	return ply:SteamID():Replace("STEAM_", ""):Replace(":", "_")
end

function base_table:TryCreateTable(name, code, cb)
	cb = cb or function() end

	local dm = self.DatabaseMode
	if (dm == "mysqloo") then
		self:Query("SHOW TABLES LIKE '" .. name .. "'", function(q, ok, data)
			if (!ok) or (data and table.Count(data) > 0) then
				cb()
				return
			end
			self:Query([[
				CREATE TABLE IF NOT EXISTS `]] .. name .. [[` (]] .. code .. [[) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
			]], function(q2, ok2, data2)
				self:DBPrint("Creating " .. name .. ": " .. tostring(ok2) .. " (" .. tostring(data2) .. ")")
				cb()
			end)
		end)
	elseif (!sql.TableExists(name)) then
		sql.Query([[
			CREATE TABLE `]] .. name .. [[` (]] .. code .. [[)
		]])

		self:DBPrint("Creating " .. name .. ": " .. tostring(sql.TableExists(name)))
		cb()
	end
end

function base_table:TryInsert(query, args, callback)
	query = query:Replace("INSERT INTO", self.DatabaseMode == "mysqloo" and "INSERT IGNORE INTO" or "INSERT OR IGNORE INTO")
	self:BetterQuery(query, args, callback)
end

function base_table:CreateMultipleTables(tables, callback)
	callback = callback or function() end

	local function Advance()
		if (table.Count(tables) > 0) then
			local k = table.GetFirstKey(tables)
			local d = tables[k]
			tables[k] = nil

			self:TryCreateTable(k, d, function()
				Advance()
			end)
		else
			callback()
		end
	end

	Advance()
end

hook.Add("InitPostEntity", prefix .. "ConnectToDatabase", function()
	timer.Simple(1,function()
	base_table:ConnectToDatabase()
	end)
end)

if (_G[prefix .. "DB"]) then
	base_table.m_bConnectedToDB = _G[prefix .. "DB"]:status() == 0
end
