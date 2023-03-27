if not file.IsDir("ig_character_v1", "DATA") then
	print("[IG CHARACTER] Creating Load Out Directory...")
	file.CreateDir("ig_character_v1")
end

if not file.IsDir("ig_character_v1/data", "DATA") then
	print("[IG CHARACTER]  Creating Data Directory...")
	file.CreateDir("ig_character_v1/data")
end

if not file.IsDir("ig_character_v1/data/player", "DATA") then
	print("[IG CHARACTER]  Creating Player Data Directory...")
	file.CreateDir("ig_character_v1/data/player")
end

if not file.Exists("ig_character_v1/data/log.txt", "DATA") then
	print("[IG CHARACTER]  Creating logs file...")
	local tablelog = {
		"Start of Logs",
	}
	file.Write("ig_character_v1/data/log.txt", util.TableToJSON(tablelog,true))
end

IG_CHARACTER_PURCHASED = {}
if IG_CHARACTER_PURCHASED then
	print("[IG CHARACTER] Table Initialised")
end