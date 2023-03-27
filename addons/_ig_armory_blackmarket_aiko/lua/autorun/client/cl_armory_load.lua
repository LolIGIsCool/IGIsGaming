if not CLIENT then return end

MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blacklist] ", Color(115, 255,0), "Loading Clientside Load Files", "\n")
folders = {"starwars_armory", "starwars_blackmarket"}
for _, Folder in ipairs(folders) do
	for _, File in ipairs(file.Find(Folder .. "/load/*.lua", "LUA")) do
		MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blacklist] ", Color(255, 208,0), Folder .. "/load/" .. File, "\n")
		include(Folder .. "/load/" .. File)
	end
end
MsgC(Color(0, 195,255), "[Si-Fi Armoury and Blacklist] ", Color(115, 255,0), "Loaded Clientside Load Files", "\n")