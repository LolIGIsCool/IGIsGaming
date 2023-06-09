local __L_mods = {}
local function __L_define(name, init)
	__L_mods[name] = init
end
local function __L_load(name)
	return __L_mods[name]()
end
__L_define("back_mysqloo.lua", function()
local MysqlOO = {}
MysqlOO.__index = MysqlOO

function MysqlOO.new(opts)
	return setmetatable({}, MysqlOO)
end

return MysqlOO end)__L_define("promise.lua", function()
-- Port of https://github.com/rhysbrettbowen/promise_impl/blob/master/promise.js
-- and https://github.com/rhysbrettbowen/Aplus
--
local queue = {}

local State = {
  PENDING   = 'pending',
  FULFILLED = 'fulfilled',
  REJECTED  = 'rejected',
}

local passthrough = function(x) return x end
local errorthrough = function(x) error(x) end

local function callable_table(callback)
  local mt = getmetatable(callback)
  return type(mt) == 'table' and type(mt.__call) == 'function'
end

local function is_callable(value)
  local t = type(value)
  return t == 'function' or (t == 'table' and callable_table(value))
end

local transition, resolve, run

local Promise = {
  is_promise = true,
  state = State.PENDING
}
Promise.mt = { __index = Promise }

local do_async = function(callback)
  if Promise.async then
    Promise.async(callback)
  else
    table.insert(queue, callback)
  end
end

local reject = function(promise, reason)
  transition(promise, State.REJECTED, reason)
end

local fulfill = function(promise, value)
  transition(promise, State.FULFILLED, value)
end

transition = function(promise, state, value)
  if promise.state == state
    or promise.state ~= State.PENDING
    or ( state ~= State.FULFILLED and state ~= State.REJECTED )
    or value == nil
  then
    return
  end

  promise.state = state
  promise.value = value
  run(promise)
end

function Promise:next(on_fulfilled, on_rejected)
  local promise = Promise.new()

  table.insert(self.queue, {
    fulfill = is_callable(on_fulfilled) and on_fulfilled or nil,
    reject = is_callable(on_rejected) and on_rejected or nil,
    promise = promise
  })

  run(self)

  return promise
end

resolve = function(promise, x)
  if promise == x then
    reject(promise, 'TypeError: cannot resolve a promise with itself')
    return
  end
  
  local x_type = type(x)

  if x_type ~= 'table' then
    fulfill(promise, x)
    return
  end
  
  -- x is a promise in the current implementation
  if x.is_promise then 
    -- 2.3.2.1 if x is pending, resolve or reject this promise after completion
    if x.state == State.PENDING then
      x:next(
        function(value)
          resolve(promise, value)
        end,
        function(reason)
          reject(promise, reason)
        end
      )
      return
    end
    -- if x is not pending, transition promise to x's state and value
    transition(promise, x.state, x.value)
    return
  end

  local called = false
  -- 2.3.3.1. Catches errors thrown by __index metatable
  local success, reason = pcall(function()
    local next = x.next
    if is_callable(next) then
      next(
        x,
        function(y) 
          if not called then
            resolve(promise, y)
            called = true
          end
        end,
        function(r)
          if not called then
            reject(promise, r)
            called = true
          end
        end
      )
    else
      fulfill(promise, x)
    end
  end)

  if not success then
    if not called then
      reject(promise, reason)
    end
  end
end

run = function(promise)
  if promise.state == State.PENDING then return end

  do_async(function()
    while true do
      local obj = table.remove(promise.queue, 1)
      if not obj then
        break
      end

      local success, result = pcall(function()
        local success = obj.fulfill or passthrough
        local failure = obj.reject or errorthrough
        local callback = promise.state == State.FULFILLED and success or failure
        return callback(promise.value)
      end)

      if not success then
        reject(obj.promise, result)
      else
        resolve(obj.promise, result)
      end
    end
  end)
end

function Promise.new(callback)
  local instance = {
    queue = {}
  }
  setmetatable(instance, Promise.mt)

  if callback then
    callback(
      function(value)
        resolve(instance, value)
      end,
      function(reason)
        reject(instance, reason)
      end
    )
  end

  return instance
end

function Promise:catch(callback)
  return self:next(nil, callback)
end

function Promise:resolve(value)
  fulfill(self, value)
end

function Promise:reject(reason)
  reject(self, reason)
end

function Promise.update()
  while true do
    local async = table.remove(queue, 1)

    if not async then
      break
    end

    async()
  end
end

-- resolve when all promises complete
function Promise.all(...)
  local promises = {...}
  local results = {}
  local state = State.FULFILLED
  local remaining = #promises

  local promise = Promise.new()

  local check_finished = function()
    if remaining > 0 then
      return
    end
    transition(promise, state, results)
  end

  for i,p in ipairs(promises) do
    p:next(
      function(value)
        results[i] = value
        remaining = remaining - 1
        check_finished()
      end,
      function(value)
        results[i] = value
        remaining = remaining - 1
        state = State.REJECTED
        check_finished()
      end
    )
  end

  check_finished()

  return promise
end

-- resolve with first promise to complete
function Promise.race(...)
  local promises = {...}
  local promise = Promise.new()

  Promise.all(...):next(nil, function(value)
    reject(promise, value)
  end)

  local success = function(value)
    fulfill(promise, value)
  end

  for _,p in ipairs(promises) do
    p:next(success)
  end

  return promise
end

-- ADDITIONS IN METSO:

function Promise.async(callback)
	timer.Simple(0, callback)
end

function Promise:done(on_fulfilled)
	self:next(on_fulfilled, function(err)
		-- error() in a timer is silent?
		ErrorNoHalt("Promise failed: " .. tostring(err))
	end)
end

-- END ADDITIONS

return Promise
 end)__L_define("metso.lua", function()
local TOML = __L_load("toml.lua")
local Connection = __L_load("connection.lua")

local metso = {}

metso._backends = {
	mysqloo = __L_load("back_mysqloo.lua"),
	sqlite = __L_load("back_sqlite.lua"),
}

-- Creates a database from table that contains connection data (credentials, dbtype) 
function metso.create(opts)
	local driver = opts.driver or "sqlite"

	local driverClass = metso._backends[driver]
	assert(not not driverClass, "driver '" .. driver .. "' not implemented.")

	local driverObj = driverClass.new(opts)

	return Connection.new(driverObj)
end

function metso._onConfigUpdate()
end

metso._config = {}

function metso._reloadConfig()
	local cfg = file.Read("metsodb.toml", "GAME")
	if not cfg then
		-- cfg not found, this is ok
		return
	end

	local b, parsed = pcall(TOML.parse, cfg)
	if not b then
		-- we want to extend default error message with a bit more information
		error("Parsing metsodb.toml failed: " .. parsed)
	end

	metso._config = parsed
	metso._onConfigUpdate()
end
metso._reloadConfig()

-- The fallback configurations in case named database is not found
metso._fallbacks = {}

function metso.provideFallback(name, opts)
	assert(type(name) == "string", "fallback database name must be a string")
	assert(type(opts) == "table", "fallback opts must be a table")

	metso._fallbacks[name] = opts
end

--- Map of connections already established to specific db names
metso._connCache = {}

--- Gets (or creates) a database connection to given database name.
--- The name comes from the table name of a database specified in metsodb.toml
function metso.get(dbname)
	assert(type(dbname) == "string", "dbname must be a string")

	local cachedConnection = metso._connCache[dbname]
	if cachedConnection then
		return cachedConnection
	end

	-- Search first from configurations, then from fallbacks
	local dbconfig = metso._config[dbname] or metso._fallbacks[dbname]
	assert(not not dbconfig, "attempted to get inexistent database '" .. dbname .. "'. Make sure it is properly configured in metsodb.toml")

	local conn = metso.create(dbconfig)
	metso._connCache[dbname] = conn
	return conn
end

return metso end)__L_define("toml.lua", function()
local TOML = {
	-- denotes the current supported TOML version
	version = 0.31,

	-- sets whether the parser should follow the TOML spec strictly
	-- currently, no errors are thrown for the following rules if strictness is turned off:
	--   tables having mixed keys
	--   redefining a table
	--   redefining a key within a table
	strict = true,
}

-- converts TOML data into a lua table
TOML.parse = function(toml, options)
	options = options or {}
	local strict = (options.strict ~= nil and options.strict or TOML.strict)

	-- the official TOML definition of whitespace
	local ws = "[\009\032]"
	
	-- stores text data
	local buffer = ""

	-- the current location within the string to parse
	local cursor = 1

	-- the output table
	local out = {}

	-- the current table to write to
	local obj = out

	-- returns the next n characters from the current position
	local function char(n)
		n = n or 0
		return toml:sub(cursor + n, cursor + n)
	end

	-- moves the current position forward n (default: 1) characters
	local function step(n)
		n = n or 1
		cursor = cursor + n
	end

	-- move forward until the next non-whitespace character
	local function skipWhitespace()
		while(char():match(ws)) do
			step()
		end
	end

	-- remove the (Lua) whitespace at the beginning and end of a string
	local function trim(str)
		return str:gsub("^%s*(.-)%s*$", "%1")
	end

	-- divide a string into a table around a delimiter
	local function split(str, delim)
		if str == "" then return {} end
		local result = {}
		local append = delim
		if delim:match("%%") then
			append = delim:gsub("%%", "")
		end
		for match in (str .. append):gmatch("(.-)" .. delim) do
			table.insert(result, match)
		end
		return result
	end

	-- produce a parsing error message
	-- the error contains the line number of the current position
	local function err(message, strictOnly)
		if not strictOnly or (strictOnly and strict) then
			local line = 1
			local c = 0
			for l in toml:gmatch("(.-)\n") do
				c = c + l:len()
				if c >= cursor then
					break
				end
				line = line + 1
			end
			error("TOML: " .. message .. " on line " .. line .. ".", 4)
		end
	end

	-- prevent infinite loops by checking whether the cursor is
	-- at the end of the document or not
	local function bounds()
		return cursor <= toml:len()
	end

	local function parseString()
		local quoteType = char() -- should be single or double quote

		-- this is a multiline string if the next 2 characters match
		local multiline = (char(1) == char(2) and char(1) == char())

		-- buffer to hold the string
		local str = ""

		-- skip the quotes
		step(multiline and 3 or 1)

		while(bounds()) do
			if multiline and char() == "\n" and str == "" then
				-- skip line break line at the beginning of multiline string
				step()
			end

			-- keep going until we encounter the quote character again
			if char() == quoteType then
				if multiline then
					if char(1) == char(2) and char(1) == quoteType then
						step(3)
						break
					end
				else
					step()
					break
				end
			end

			if char() == "\n" and not multiline then
				err("Single-line string cannot contain line break")
			end

			-- if we're in a double-quoted string, watch for escape characters!
			if quoteType == '"' and char() == "\\" then
				if multiline and char(1) == "\n" then
					-- skip until first non-whitespace character
					step(1) -- go past the line break
					while(bounds()) do
						if char() ~= " " and char() ~= "\t" and char() ~= "\n" then
							break
						end
						step()
					end
				else
					-- all available escape characters
					local escape = {
						b = "\b",
						t = "\t",
						n = "\n",
						f = "\f",
						r = "\r",
						['"'] = '"',
						["/"] = "/",
						["\\"] = "\\",
					}
					-- utf function from http://stackoverflow.com/a/26071044
					-- converts \uXXX into actual unicode
					local function utf(char)
						local bytemarkers = {{0x7ff, 192}, {0xffff, 224}, {0x1fffff, 240}}
						if char < 128 then return string.char(char) end
						local charbytes = {}
						for bytes, vals in pairs(bytemarkers) do
							if char <= vals[1] then
								for b = bytes + 1, 2, -1 do
									local mod = char % 64
									char = (char - mod) / 64
									charbytes[b] = string.char(128 + mod)
								end
								charbytes[1] = string.char(vals[2] + char)
								break
							end
						end
						return table.concat(charbytes)
					end

					if escape[char(1)] then
						-- normal escape
						str = str .. escape[char(1)]
						step(2) -- go past backslash and the character
					elseif char(1) == "u" then
						-- utf-16
						step()
						local uni = char(1) .. char(2) .. char(3) .. char(4)
						step(5)
						uni = tonumber(uni, 16)
						str = str .. utf(uni)
					elseif char(1) == "U" then
						-- utf-32
						step()
						local uni = char(1) .. char(2) .. char(3) .. char(4) .. char(5) .. char(6) .. char(7) .. char(8)
						step(9)
						uni = tonumber(uni, 16)
						str = str .. utf(uni)
					else
						err("Invalid escape")
					end
				end
			else
				-- if we're not in a double-quoted string, just append it to our buffer raw and keep going
				str = str .. char()
				step()
			end
		end

		return {value = str, type = "string"}
	end

	local function parseNumber()
		local num = ""
		local exp
		local date = false
		while(bounds()) do
			if char():match("[%+%-%.eE0-9]") then
				if not exp then
					if char():lower() == "e" then
						-- as soon as we reach e or E, start appending to exponent buffer instead of
						-- number buffer
						exp = ""
					else
						num = num .. char()
					end
				elseif char():match("[%+%-0-9]") then
					exp = exp .. char()
				else
					err("Invalid exponent")
				end
			elseif char():match(ws) or char() == "#" or char() == "\n" or char() == "," or char() == "]" then
				break
			elseif char() == "T" or char() == "Z" then
				-- parse the date (as a string, since lua has no date object)
				date = true
				while(bounds()) do
					if char() == "," or char() == "]" or char() == "#" or char() == "\n" or char():match(ws) then
						break
					end
					num = num .. char()
					step()
				end
			else
				err("Invalid number")
			end
			step()
		end

		if date then
			return {value = num, type = "date"}
		end

		local float = false
		if num:match("%.") then float = true end

		exp = exp and tonumber(exp) or 0
		num = tonumber(num)

		if not float then
			return {
				-- lua will automatically convert the result
				-- of a power operation to a float, so we have
				-- to convert it back to an int with math.floor
				value = math.floor(num * 10^exp),
				type = "int",
			}
		end

		return {value = num * 10^exp, type = "float"}
	end

	local parseArray, getValue
	
	function parseArray()
		step() -- skip [
		skipWhitespace()

		local arrayType
		local array = {}

		while(bounds()) do
			if char() == "]" then
				break
			elseif char() == "\n" then
				-- skip
				step()
				skipWhitespace()
			elseif char() == "#" then
				while(bounds() and char() ~= "\n") do
					step()
				end
			else
				-- get the next object in the array
				local v = getValue()
				if not v then break end

				-- set the type if it hasn't been set before
				if arrayType == nil then
					arrayType = v.type
				elseif arrayType ~= v.type then
					err("Mixed types in array", true)
				end

				array = array or {}
				table.insert(array, v.value)
				
				if char() == "," then
					step()
				end
				skipWhitespace()
			end
		end
		step()

		return {value = array, type = "array"}
	end

	local function parseBoolean()
		local v
		if toml:sub(cursor, cursor + 3) == "true" then
			step(4)
			v = {value = true, type = "boolean"}
		elseif toml:sub(cursor, cursor + 4) == "false" then
			step(5)
			v = {value = false, type = "boolean"}
		else
			err("Invalid primitive")
		end

		skipWhitespace()
		if char() == "#" then
			while(char() ~= "\n") do
				step()
			end
		end

		return v
	end

	-- figure out the type and get the next value in the document
	function getValue()
		if char() == '"' or char() == "'" then
			return parseString()
		elseif char():match("[%+%-0-9]") then
			return parseNumber()
		elseif char() == "[" then
			return parseArray()
		else
			return parseBoolean()
		end
		-- date regex (for possible future support):
		-- %d%d%d%d%-[0-1][0-9]%-[0-3][0-9]T[0-2][0-9]%:[0-6][0-9]%:[0-6][0-9][Z%:%+%-%.0-9]*
	end

	-- buffer for table arrays
	local tableArrays = {}
	
	-- parse the document!
	while(cursor <= toml:len()) do

		-- skip comments and whitespace
		if char() == "#" then
			while(char() ~= "\n") do
				step()
			end
		end

		if char() == "\n" or char() == "\r" then
			-- skip
		end

		if char() == "=" then
			step()
			skipWhitespace()
			
			-- trim key name
			buffer = trim(buffer)

			if buffer == "" then
				err("Empty key name")
			end

			local v = getValue()
			if v then
				-- if the key already exists in the current object, throw an error
				if obj[buffer] then
					err("Cannot redefine key " .. buffer, true)
				end
				obj[buffer] = v.value
			end
			
			-- clear the buffer
			buffer = ""

			-- skip whitespace and comments
			skipWhitespace()
			if char() == "#" then
				while(bounds() and char() ~= "\n") do
					step()
				end
			end

			-- if there is anything left on this line after parsing a key and its value,
			-- throw an error
			if char() ~= "\n" and cursor < toml:len() then
				err("Invalid primitive")
			end
		elseif char() == "[" then
			buffer = ""
			step()
			local tableArray = false

			-- if there are two brackets in a row, it's a table array!
			if char() == "[" then
				tableArray = true
				step()
			end

			while(bounds()) do
				buffer = buffer .. char()
				step()
				if char() == "]" then
					if tableArray and char(1) ~= "]" then
						err("Mismatching brackets")
					elseif tableArray then
						step() -- skip second bracket
					end
					break
				end
			end
			step()

			buffer = trim(buffer)

			obj = out
			local spl = split(buffer, "%.")
			for i, tbl in pairs(spl) do
				if tbl == "" then
					err("Empty table name")
				end

				if i == #spl and obj[tbl] and not tableArray and #obj[tbl] > 0 then
					err("Cannot redefine table", true)
				end

				-- set obj to the appropriate table so we can start filling
				-- it with values!
				if tableArrays[tbl] then
					if buffer ~= tbl and #spl > 1 then
						obj = tableArrays[tbl]
					else
						obj[tbl] = obj[tbl] or {}
						obj = obj[tbl]
						if tableArray and i == #spl then
							table.insert(obj, {})
							obj = obj[#obj]
						end
					end
				else
					obj[tbl] = obj[tbl] or {}
					obj = obj[tbl]
					if tableArray and i == #spl then
						table.insert(obj, {})
						obj = obj[#obj]
					end
				end

				tableArrays[buffer] = obj
			end

			buffer = ""
		end

		buffer = buffer .. char()
		step()
	end

	return out
end

TOML.encode = function(tbl)
	local toml = ""

	local cache = {}

	local function parse(tbl)
		for k, v in pairs(tbl) do
			if type(v) == "boolean" then
				toml = toml .. k .. " = " .. tostring(v) .. "\n"
			elseif type(v) == "number" then
				toml = toml .. k .. " = " .. tostring(v) .. "\n"
			elseif type(v) == "string" then
				local quote = '"'
				v = v:gsub("\\", "\\\\")

				-- if the string has any line breaks, make it multiline
				if v:match("^\n(.*)$") then
					quote = quote:rep(3)
					v = "\\n" .. v
				elseif v:match("\n") then
					quote = quote:rep(3)
				end

				v = v:gsub("\b", "\\b")
				v = v:gsub("\t", "\\t")
				v = v:gsub("\f", "\\f")
				v = v:gsub("\r", "\\r")
				v = v:gsub('"', '\\"')
				v = v:gsub("/", "\\/")
				toml = toml .. k .. " = " .. quote .. v .. quote .. "\n"
			elseif type(v) == "table" then
				local array, arrayTable = true, true
				local first = {}
				for kk, vv in pairs(v) do
					if type(kk) ~= "number" then array = false end
					if type(vv) ~= "table" then
						v[kk] = nil
						first[kk] = vv
						arrayTable = false
					end
				end

				if array then
					if arrayTable then
						-- double bracket syntax go!
						table.insert(cache, k)
						for kk, vv in pairs(v) do
							toml = toml .. "[[" .. table.concat(cache, ".") .. "]]\n"
							for k3, v3 in pairs(vv) do
								if type(v3) ~= "table" then
									vv[k3] = nil
									first[k3] = v3
								end
							end
							parse(first)
							parse(vv)
						end
						table.remove(cache)
					else
						-- plain ol boring array
						toml = toml .. k .. " = [\n"
						for kk, vv in pairs(v) do
							toml = toml .. tostring(vv) .. ",\n"
						end
						toml = toml .. "]\n"
					end
				else
					-- just a key/value table, folks
					table.insert(cache, k)
					toml = toml .. "[" .. table.concat(cache, ".") .. "]\n"
					parse(first)
					parse(v)
					table.remove(cache)
				end
			end
		end
	end
	
	parse(tbl)
	
	return toml:sub(1, -2)
end

return TOML

 end)__L_define("connection.lua", function()
local Connection = {}
Connection.__index = Connection

--- Escapes string so that it can be added into a SQL query without problems.
--- This method MUST ALWAYS add quotations around the string.
function Connection:_escapeString(str)
	-- TODO per-backend
	return sql.SQLStr(str)
end

--- Parses given SQL. In practice this consists of
--- 1. Replacing placeholders with values from params
--- 2. Escaping objects that need escaping in parameters
--- 3. Failing if met with unknown types (fail fast!)
function Connection:_parseQuery(sql, params)
	local i = 1
	return sql:gsub("%?", function()
		local param = params[i]
		assert(not not param, "param #" .. i .. " nil in query")

		i = i + 1

		if type(param) == "string" then
			return self:_escapeString(param)
		elseif type(param) == "number" then
			return tostring(param)
		else
			error("unknown type given to sql query: " .. type(param))
		end
	end)
end

--- Submits a query in non-blocking manner.
--- Returns a promise that contains the rows
function Connection:query(sql, params)
	assert(type(sql) == "string", "query sql must be a string")

	params = params or {}
	assert(type(params) == "table", "query params must be a table")

	local finalSql = self:_parseQuery(sql, params)

	return self._backend:query(finalSql)
end

--- Equal to conn:query(), except the promise has the inserted ID
--- as the value
function Connection:insert(sql, params)
	return self:query(sql, params):next(function()
		return self._backend:queryLastInsertedId()
	end)
end

function Connection.new(backend)
	assert(not not backend, "backend required")
	return setmetatable({_backend = backend}, Connection)
end
return Connection end)__L_define("back_sqlite.lua", function()
local Promise = __L_load("promise.lua")

local SQLite = {}
SQLite.__index = SQLite

function SQLite:query(query)
	local data = sql.Query(query)
	local promise = Promise.new()

	if data == false then -- error!
		local err = sql.LastError()
		promise:reject(err)
	elseif data == nil then -- no data
		promise:resolve({})
	else
		promise:resolve(data)
	end

	return promise
end

function SQLite:queryLastInsertedId()
	return tonumber(sql.Query("SELECT last_insert_rowid() id")[1].id)
end

function SQLite.new(opts)
	local username, password, database = opts.username, opts.password, opts.database
	if username or password or database then
		ErrorNoHalt("Warning: username/password/database specified when using sqlite as the driver")
	end
	return setmetatable({}, SQLite)
end

return SQLite end)return __L_load("metso.lua")