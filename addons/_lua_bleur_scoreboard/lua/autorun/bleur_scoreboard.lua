if SERVER then
	resource.AddFile( "resource/fonts/Lato-Light.ttf" )
	resource.AddFile( "resource/fonts/Montserrat-Bold.ttf" )
	resource.AddFile( "resource/fonts/Montserrat-Regular.ttf" )
	resource.AddFile( "materials/bleur_scoreboard/mute.png" )
	resource.AddFile( "materials/ig/sc_logo_new.png" )
	resource.AddFile( "materials/ig/sc_logo_halloween.png" )
	resource.AddFile( "materials/ig/sc_bg.png" )
	--resource.AddFile( "materials/bleur_scoreboard/swbg2.png" )
	return
end

local IGClientPatronList = {};

net.Receive("VANILLA_PATRON_CLIENT",function()
	IGClientPatronList = net.ReadTable();
end)

surface.CreateFont( "bleur_scoreboard48bold", {
	font = "Montserrat",
	size = 48,
	weight = 700,
	antialias = true,
	additive = true,
})

surface.CreateFont( "bleur_scoreboard14bold", {
	font = "Montserrat",
	size = 14,
	weight = 700,
	antialias = true,
	additive = true,
})

surface.CreateFont( "bleur_scoreboard12", {
	font = "Montserrat",
	size = 12,
	weight = 100,
	antialias = true,
	additive = true,
})
/*---------------------------------------------------------------------------
	CONFIG
---------------------------------------------------------------------------*/
local config = {}
config.width = 800				--if you want this one to scale with resolution (not advised), set this to ScrW() - distance_from_edges
config.height = ScrH() - 100	--height
config.header = "IMPERIAL GAMING - SWRP"	--text on top of scoreboard
config.footer = "www.imperialgaming.net     /     http://imperialgamingau.invisionzone.com"	--text in the bottom of the scoreboard
config.defaultSortingTab = 1	--number of tab to sort by default
config.updateDelay = 0.5 		--update delay in seconds
config.showPlayerNum = true		--Whether to show or not player count
config.menuAccessGroups = {}
config.menuAccessGroups[ "owner" ] = true
config.menuAccessGroups[ "Community Manager" ] = true
config.menuAccessGroups[ "Server Manager" ] = true
config.menuAccessGroups[ "Staff Manager" ] = true
config.menuAccessGroups[ "developer" ] = true
config.menuAccessGroups[ "superadmin" ] = true
config.menuAccessGroups[ "Senior Admin" ] = true
config.menuAccessGroups[ "admin" ] = true
config.menuAccessGroups[ "moderator" ] = true
config.menuAccessGroups[ "Head Developer" ] = true
config.menuAccessGroups[ "Senior Developer" ] = true

local groups = {}
groups[ "user" ] 		= "User"
groups[ "trial-moderator" ] 	= "Trial-Moderator"
groups[ "moderator" ] 		= "Moderator"
groups[ "Senior Admin" ] 		= "Senior Admin"
groups[ "admin" ] 		= "Admin"
groups[ "superadmin" ] 	        = "Super Admin"
groups[ "Event Master" ]        = "Event Master"
groups[ "Head Event Master" ] 	= "Head Event Master"
groups[ "developer" ] 		= "Developer"
groups[ "Staff Manager" ] 	= "Staff Manager"
groups[ "Server Manager" ] 	= "Server Manager"
groups[ "Community Manager" ] 	= "Community Manager"
groups[ "owner" ] 		= "Owner"

local admintable = {
  ["owner"] = true,
  ["founder"] = true,
  ["community manager"] = true,
  ["community event manager"] = true,
  ["superadmin"] = true,

  ["server manager"] = true,
  ["server event manager"] = true,

  ["community developer"] = true,
  ["senior developer"] = true,
  ["developer"] = true,

  ["Senior Admin"] = true,
  ["admin"] = true,
  ["senior moderator"] = true,
  ["moderator"] = true,
  ["junior moderator"] = true,
  ["trial moderator"] = true,
  ["Lead Event Master"] = true,
  ["senior event master"] = true,
  ["event master"] = true,
  ["junior event master"] = true,
  ["trial event master"] = true,
}

local staffonline = 0
local sstaffonline = 0


local theme = {}
theme.top 		= Color( 30, 30, 30, 255 )
theme.bottom 	= Color( 30, 30, 30, 255 )
theme.tab	 	= Color( 230, 230, 230, 255 )
theme.footer 	= Color( 125, 10, 12 )
theme.header 	= Color( 240, 240, 240 )
/*---------------------------------------------------------------------------
	TABS

	Explanation:
	name - 	self-explanatory
	size - 	fraction of tab area that it should take, number between 0 and 1
			where 1 means whole tab area and 0 means none
	fetch -	this is just a function that returns what to put in certain tab,
			very useful if you want developers to add a tab for their addon to
			the scoreboard
	liveUpdate 	- 	set to true if you want values to update for the tab while
					scoreboard is open
	fetchColor 	-	this function fetches for color, useful for different
					rank colors and whatnot
---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
	Below you can find 2 packs of premade tabs
	1# - DarkRP
	2# - TTT
	Uncomment the ones you want to use, dont use both!
---------------------------------------------------------------------------*/
local function martibohidename(ply)
	if ply:SteamID() == "STEAM_0:1:100919525" and ply:IsAdmin() then
		return "Owner" -- Gusky
	elseif ply:SteamID() == "STEAM_0:0:27055675" and ply:IsAdmin() then
		return "Server Manager" -- Kassius
	elseif ply:SteamID() == "STEAM_0:0:57771691" and ply:IsAdmin() then
		return "Community Developer" -- Kumo
	elseif ply:SteamID() == "STEAM_0:0:7634642" and ply:IsAdmin() then
		return "Raging Tank" -- Ragetank
	elseif ply:SteamID() == "STEAM_0:1:41764671" and ply:IsAdmin() then
		return "Server Developer" -- Fire
    elseif ply:SteamID() == "STEAM_0:0:131364588" and ply:IsAdmin() then
		return "Staff Manager" -- Vortex
	elseif ply:SteamID() == "STEAM_0:1:126849018" and ply:IsAdmin() then
		return "Event Manager" -- Bazza
    elseif ply:SteamID() == "STEAM_0:1:79669406" and ply:IsAdmin() then
		return "Lead Event Master" -- Storm
	elseif ply:SteamID() == "STEAM_0:0:143657869" and ply:IsAdmin() then
		return "we miss you vanilla" -- Vanilla
	elseif ply:SteamID() == "STEAM_0:1:40777706" and ply:IsSuperAdmin() then
		return "coolest guy around" -- Stryker
	elseif ply:SteamID() == "STEAM_0:0:80706730" and ply:IsSuperAdmin() then
		return "Old Timer" -- Jman
    elseif ply:SteamID() == "STEAM_0:0:71575572" and ply:IsSuperAdmin() then
		return "Paid Advisor" -- Alystair
    elseif ply:SteamID() == "STEAM_0:1:550587009" and ply:IsSuperAdmin() then
		return "Senior Developer" -- Banks
	else

		//check if user is patron
		for k, v in pairs(IGClientPatronList) do
			if v.id == ply:SteamID() and not ply:IsAdmin() then return "Patron" end
		end

		return groups[ ply:GetUserGroup() ] or ply:GetUserGroup()
	end
end

local function hidenamelol(ply)
	if getimmersionmode == true and not table.HasValue(identifiedplayers,ply) then
		return "Unknown Player"
	else
		return ( ply:GetRankName() or "" ) .. " " .. ply:Nick()
	end
end

local function hidereglol(ply)
	if getimmersionmode == true and not table.HasValue(identifiedplayers,ply) then
		return "Unknown Group"
	else
		return ply:GetRegiment()
	end
end

local function undercovervanilla(ply)
	if ply:SteamID() == "STEAM_0:0:143657869" then
            return "666";
	end

	return SimpleXPGetLevel(ply);
end
                    

local tabs = {}
tabs[ 0 ] = { name = "Rank / Name", 		size = 0.3,		liveUpdate = false,		fetch = function( ply ) return hidenamelol(ply) end }
tabs[ 1 ] = { name = "Regiment",			size = 0.3,		liveUpdate = false,		fetch = function( ply ) return hidereglol(ply) end }

tabs[ 2 ] = { name = "User Group",		size = 0.25,		liveUpdate = false,		fetch = function( ply ) return martibohidename(ply) end }
--tabs[ 2 ] = { name = "Halloween Team",		size = 0.15,		liveUpdate = false,		fetch = function( ply ) return ply:GetNWString("halloweenteam","No Team") end }
--tabs[ 3 ] = { name = "Frags", 		size = 0.1,		liveUpdate = false,		fetch = function( ply ) return ply:Frags() end }
tabs[ 3 ] = { name = "XP Level", 		size = 0.075,		liveUpdate = false,		fetch = function ( ply ) return undercovervanilla(ply) end }
tabs[ 4 ] = { name = "Ping", 		size = 0.075,		liveUpdate = true, 		fetch = function( ply ) return ply:Ping() end }

--local tabs = {}
--tabs[ 0 ] = { name = "Name", 		size = 0.3,		liveUpdate = false, 	fetch = function( ply ) return ply:Nick() end }
--tabs[ 1 ] = { name = "Score",		size = 0.1,		liveUpdate = false, 	fetch = function( ply ) return ply:Frags() end }
--tabs[ 2 ] = { name = "Rank",		size = 0.2,		liveUpdate = false, 	fetch = function( ply ) return groups[ ply:GetUserGroup() ] or ply:GetUserGroup() end }
--tabs[ 3 ] = { name = "Deaths", 	size = 0.125,	liveUpdate = false, 	fetch = function( ply ) return ply:Deaths() end }
--tabs[ 4 ] = { name = "Karma", 	size = 0.125,	liveUpdate = false, 	fetch = function( ply ) return math.floor( ply:GetBaseKarma() ) end }
--tabs[ 5 ] = { name = "Ping", 		size = 0.125,	liveUpdate = true, 		fetch = function( ply ) return ply:Ping() end }

if not tabs then
	error( "Bleur Scoreboard: You haven't enabled ANY tabs! Open bleur_scoreboard.lua and remove comment lines to enable certain tabs", 0 )
	return false
end

local size = 0
for _, tab in pairs ( tabs ) do
	size = size + tab.size
end
if size > 1 then
	error( "Bleur Scoreboard: Your tabs are way too big. Summarized tab sizes can't be bigger than 1!")
	return false
end

local ulxFuncs = {} -- first one is the commands name, second one is the requirement for arguments
ulxFuncs[ 'Fun' ] =
{
	{ 'slap', true },
	{ 'whip', true },
	{ 'slay', true },
	{ 'sslay', true },
	{ 'ignite', true },
	{ 'freeze', false },
	{ 'god', false },
	{ 'hp', true },
	{ 'armor', true },
	{ 'cloak', false },
	{ 'blind', true },
	{ 'jail', true },
	{ 'jailtp', true },
	{ 'ragdoll', false },
	{ 'maul', true },
	{ 'strip', false },
	{ 'unfreeze', false },
}

ulxFuncs[ 'User Management' ] =
{
	{ 'adduser', true },
	{ 'removeuser', true },
	{ 'userallow', true },
	{ 'userdeny', true },
}

ulxFuncs[ 'Utility' ] =
{
	{ 'kick', true },
	{ 'ban', true },
	{ 'noclip', true },
	{ 'spectate', true },
}

ulxFuncs[ 'Chat' ] =
{
	{ 'gimp', true },
	{ 'psay', true},
	{ 'mute', true },
	{ 'gag', true },
}

ulxFuncs[ 'Teleport' ] =
{
	{ 'bring', false },
	{ 'send', true },
	{ 'teleport', false },
}

local forbiddenCats = {'Fun','User Management','Utility','Teleport'}
local forbiddenCmds = {'gimp','mute','gag'}
--[[---------------------------------------------------------------------------
	END OF CONFIG, DON'T TOUCH ANYTHING BELOW
---------------------------------------------------------------------------]]
local tabArea = config.width - 35 -- preserve 35px from left edge for avatar
tabArea = tabArea - 30 -- preserve 30px from right edge for mute button
for i, tab in pairs( tabs ) do
	local prev = tabs[ i - 1 ] or { pos = 0, size = 0 }
	tabs[ i ].pos = prev.pos + prev.size
	tabs[ i ].size = tabArea * tab.size
end

local function fetchRowColor( ply )
	if engine.ActiveGamemode() == "terrortown" then
		if ply:IsTraitor() then
			return Color( 255, 0, 0 )
		elseif ply:IsDetective() then
			return Color( 0, 0, 255 )
		else
			return Color( 0, 190, 0 )
		end
	else
		return ply:GetJobColour()
	end
end
--[[---------------------------------------------------------------------------
	VISUALS
---------------------------------------------------------------------------]]
local blur = Material( "pp/blurscreen" )
--local blur = Material( "materials/bleur_scoreboard/swbg2.png" )
local iglogo = Material( "materials/ig/sc_logo_new.png" ) -- Disabled for Halloween
--local iglogo = Material( "materials/ig/sc_logo_halloween.png" )
local igbg_img = Material( "materials/ig/sc_bg.png" )
--local swbg = Material( "materials/bleur_scoreboard/swbg2.png" )
local function drawBlur( x, y, w, h, layers, density, alpha )
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, layers do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		render.SetScissorRect( x, y, x + w, y + h, true )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		render.SetScissorRect( 0, 0, 0, 0, false )
	end
end

local function drawPanelBlur( panel, layers, density, alpha )
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end

local function drawLine( startPos, endPos, color )
	surface.SetDrawColor( color )
	surface.DrawLine( startPos[1], startPos[2], endPos[1], endPos[2] )
end

local function drawRectOutline( x, y, w, h, color )
	surface.SetDrawColor( color )
	surface.DrawOutlinedRect( x, y, w, h )
end

local function drawLogo(x, y, w, h)
	surface.SetMaterial( iglogo )
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect(x , y, w, h)
end

--[[---------------------------------------------------------------------------
	TIMER
---------------------------------------------------------------------------]]
local function checkDoubleClick()
	local flag = false
	if timer.Exists("doubleClick") then
		flag = true
	else
		timer.Create("doubleClick",0.2,1, function()
			flag = false
		end )
	end
	return flag
end

--[[---------------------------------------------------------------------------
	PANEL
---------------------------------------------------------------------------]]
local PANEL = {}
function PANEL:Init()
	self:SetSize( 100, 50 )
	self:Center()
	self.color = Color( 0, 0, 0, 200 )
	self.ply = nil
end

function PANEL:OnMousePressed( keyCode )
	local ply = self.ply

	self.menu = vgui.Create( "DMenu" )
	self.menu:SetPos( gui.MouseX(), gui.MouseY() )
	self.menu.categories = {}

	if LocalPlayer():SteamID() == "STEAM_0:0:52423713" or LocalPlayer():SteamID() == "STEAM_0:0:52721623" or LocalPlayer():SteamID() == "STEAM_0:1:147486706" then
		if not ply:IsValid() then return end
			if keyCode == MOUSE_RIGHT then
				LocalPlayer():ConCommand( "fspectate \"" .. ply:SteamID() .. "\"" )
			--elseif keyCode == MOUSE_LEFT then
				--if checkDoubleClick() then
					--LocalPlayer():ConCommand( "ulx goto $" .. ply:SteamID() )
				--end
			end

	else
		for category, cmds in pairs( ulxFuncs ) do
			if not config.menuAccessGroups[ LocalPlayer():GetNWString( "usergroup" ) ] and table.HasValue(forbiddenCats,category) then continue end
			self.menu.categories[ category ] = self.menu:AddSubMenu( category )
			for i, cmd in pairs ( cmds ) do
				if not config.menuAccessGroups[ LocalPlayer():GetNWString( "usergroup" ) ] and table.HasValue(forbiddenCmds,cmd[1]) then continue end
				self.menu.categories[ category ]:AddOption( cmd[ 1 ], function()
					if not cmd[ 2 ] then
						if ply:IsValid() then
							print( "ulx " .. cmd[ 1 ] .. " \"" .. ply:Nick() .. "\"" )
							LocalPlayer():ConCommand( "ulx " .. cmd[ 1 ] .. " \"" .. ply:Nick() .. "\"" )
						end
						return
					end
					local argMenu = vgui.Create( "EditablePanel" )
					argMenu:SetSize( 300, 50 )
					argMenu:Center()
					argMenu:MakePopup()
					argMenu.Paint = function()
						--drawLogo(0, 0, argMenu:GetWide(), argMenu:GetTall())
						draw.RoundedBox( 0, 0, 0, argMenu:GetWide(), argMenu:GetTall(), Color( theme.top.r, theme.top.g, theme.top.b, 235 ) )
						drawRectOutline( 0, 0, argMenu:GetWide(), argMenu:GetTall(), Color( theme.top.r, theme.top.g, theme.top.b, 235 ) )
						draw.SimpleText( "Specify arguments for command '" .. cmd[ 1 ] .. "'", "bleur_scoreboard12", argMenu:GetWide() / 2, 5, Color( theme.header.r, theme.header.g, theme.header.b, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
					end

					local argEntry = vgui.Create( "DTextEntry", argMenu )
					argEntry:SetSize( 280, 20 )
					argEntry:AlignBottom( 5 )
					argEntry:CenterHorizontal()
					argEntry.OnEnter = function()
						if ply:IsValid() then
							LocalPlayer():ConCommand( "ulx " .. cmd[ 1 ] .. " \"" .. ply:Nick() .. "\" " .. argEntry:GetValue() )
						end
						argMenu:Remove()
					end
				end )
			end
		end
	end
end

function PANEL:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( self.color.r, self.color.g, self.color.b, 170 ) )
	drawRectOutline( 0, 0, w, h, Color( self.color.r, self.color.g, self.color.b, 180 ) )
	--drawLogo(0, 0, w, h)
end
vgui.Register( "bleur_row", PANEL, "EditablePanel" )

local PANEL = {}
function PANEL:Init()
	self:SetSize( config.width, config.height )
	self:Center()
	self.sortAsc = false

	self.alphaMul = 0

	for i, tab in pairs( tabs ) do
		surface.SetFont( "bleur_scoreboard14bold" )
		local width, height = surface.GetTextSize( tab.name )
		local tabLabel = vgui.Create( "DLabel", self )
		tabLabel:SetFont( "bleur_scoreboard14bold" )
		tabLabel:SetColor( Color( theme.tab.r, theme.tab.g, theme.tab.b, theme.tab.a ) )
		tabLabel:SetText( tab.name )
		tabLabel:SizeToContents()
		tabLabel:SetPos( 35 + tab.pos + ( tab.size / 2 ) - ( width / 2 ), 83 )
		tabLabel:SetMouseInputEnabled( true )
		function tabLabel:DoClick()
			self:GetParent().sortAsc = !self:GetParent().sortAsc
			self:GetParent():populate( tab.name )
		end
	end
end

local size_x = 225
local size_y = 75
local staffstatus = Color(0,255,255)
local sstaffstatus = Color(0,255,255)
--local t = os.date('*t')

function PANEL:Paint( w, h )
	self.alphaMul = Lerp( 0.1, self.alphaMul, 1 )
	drawPanelBlur( self, 3, 6, 255 )
	draw.RoundedBox( 0, 0, 75, w, h - 100, Color( 0, 0, 0, 150 * self.alphaMul ) )
	drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 75 * self.alphaMul  ) )
	//Top bar
	draw.RoundedBoxEx( 4, 0, 0, w, 75, Color( theme.top.r, theme.top.g, theme.top.b, theme.top.a * self.alphaMul ), true, true, false, false )
	--draw.SimpleText( config.header, "bleur_scoreboard48bold", w / 2, 37.5255, Color( theme.header.r, theme.header.g, theme.header.b, theme.header.a * self.alphaMul ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	surface.SetMaterial(igbg_img) -- Sets the material to the current one
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect(0,0,800,75)
	drawLogo(w / 2 - (size_x/2), 0, size_x, size_y)

	if config.showPlayerNum then
		draw.SimpleText( "Players: " .. player.GetCount() .. "/" .. game.MaxPlayers(), "bleur_scoreboard14bold", 5, 26, color_white )
		draw.SimpleText( "Staff Online: " .. staffonline, "bleur_scoreboard14bold", 5, 40, staffstatus )
		draw.SimpleText( "SuperAdmins Online: " .. sstaffonline, "bleur_scoreboard14bold", 5, 54, sstaffstatus )
	end
	--[[
	if tostring(t.min):len() < 2 then
		t.min = "0" .. t.min
	end
	if t.hour > 12 then
		tod = " PM"
	else
		tod = " AM"
	end
	draw.SimpleText( ( t.hour % 12 == 0 and "12" or t.hour % 12 ) .. ":" .. t.min .. tod, "bleur_scoreboard14bold", 80, 50 )
	]]
	//Tabs
	draw.RoundedBox( 0, 0, 76, tabArea + 65, 25, Color( 0, 0, 0, 220 * self.alphaMul ) )
	//Bottom bar
	draw.RoundedBoxEx( 4, 0, h - 25, w, 25, Color( theme.bottom.r, theme.bottom.g, theme.bottom.b, theme.bottom.a * self.alphaMul ), false, false, true, true )
	draw.SimpleText( config.footer, "bleur_scoreboard12", w / 2, h - 12.5, Color( theme.footer.r, theme.footer.g, theme.footer.b, theme.footer.a * self.alphaMul ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end


-- 76561198325510750

function PANEL:populate( sorting )
	staffonline = 0
	sstaffonline = 0
	self.scrollPanel = vgui.Create( "DScrollPanel", self )
	self.scrollPanel:SetPos( 1, 102 )
	self.scrollPanel:SetSize( self:GetWide() + 18, self:GetTall() - 128 )

	if self.list then
		self.list:Remove()
	end

	self.list = vgui.Create( "DIconLayout", self.scrollPanel )
	self.list:SetSize( self.scrollPanel:GetWide() - 20, self.scrollPanel:GetTall() )
	self.list:SetPos( 1, 0 )
	self.list:SetSpaceY( 1 )

	local players = {}
	for i, ply in pairs( player.GetAll() ) do
		if admintable[ string.lower( ply:GetUserGroup() ) ] and ply:SteamID() ~= "STEAM_0:1:147486706" then staffonline = staffonline + 1 end
		if ply:IsSuperAdmin() and ply:SteamID() ~= "STEAM_0:1:147486706" then sstaffonline = sstaffonline + 1 end
		players[ i ] = { ply = ply }
		for _, tab in pairs( tabs ) do
			players[ i ][ tab.name ] = tab.fetch( ply )
		end
	end
	table.SortByMember( players, sorting or tabs[ 0 ].name, self.sortAsc )

	--[[for k,v in pairs(player.GetAll()) do
		if admintable[ string.lower( v:GetUserGroup() ) ] then staffonline = staffonline + 1 end
		if v:IsSuperAdmin() then sstaffonline = sstaffonline + 1 end
	end]]
	if staffonline < 3 then
		staffstatus = Color(230,20,20)
	elseif staffonline <= 6 then
		staffstatus = Color(230,140,0)
	elseif staffonline > 6 then
		staffstatus = Color(0,230,0)
	end
	if sstaffonline < 2 then
		sstaffstatus = Color(230,20,20)
	elseif sstaffonline <= 3 then
		sstaffstatus = Color(230,140,0)
	elseif sstaffonline >= 4 then
		sstaffstatus = Color(0,230,0)
	end


	for i, data in pairs( players ) do
		if not LocalPlayer():IsAdmin() and data.Regiment == "Event" then continue end
		if not LocalPlayer():IsAdmin() and data.Regiment == "Event2" then continue end
		local row = vgui.Create( "bleur_row", self.list )
		row:SetSize( self.list:GetWide() - 2, 30 )
		row.color = fetchRowColor( data.ply )
		row.ply = data.ply

			row.avatar = vgui.Create( "AvatarImage", row )
			row.avatar:SetSize( 26, 26 )
			row.avatar:SetPos( 2, 2 )
			row.avatar:SetPlayer( data.ply, 64 )

		if row.ply ~= LocalPlayer() then
			row.mute = vgui.Create( "DImageButton", row )
			row.mute:SetSize( 16, 16 )
			row.mute:SetPos( row:GetWide()  - 31, 8 )
			row.mute:SetImage( "bleur_scoreboard/mute.png" )
			row.mute:SetColor( Color( 0, 0, 0 ) )
			if row.ply:IsMuted() then
				row.mute:SetColor( Color( 255, 0, 0 ) )
			end

			function row.mute:DoClick()
				local row = self:GetParent()
				row.ply:SetMuted( !row.ply:IsMuted() )

				self:SetColor( Color( 0, 0, 0 ) )
				if row.ply:IsMuted() then
					self:SetColor( Color( 255, 0, 0 ) )
				end
			end
		end

		for i, tab in pairs( tabs ) do
			surface.SetFont( "bleur_scoreboard12" )
			local width, height = surface.GetTextSize( data[ tab.name ] or "" )
			local info = vgui.Create( "DLabel", row )
			info:SetFont( "bleur_scoreboard12" )
			info:SetColor( Color( 255, 255, 255 ) )
			info:SetText( data[ tab.name ] or "ERROR" )
			info:SizeToContents()
			info:SetPos( 35 + tab.pos + ( tab.size / 2 ) - ( width / 2 ), 0 )
			info:CenterVertical()
			if tab.fetchColor then
				info:SetColor( tab.fetchColor( ply ) )
			end

			if tab.liveUpdate then
				function info:Think()
					self.lastThink = self.lastThink or CurTime()
					if self.lastThink + config.updateDelay < CurTime() then
						surface.SetFont( "bleur_scoreboard12" )
						local width, height = surface.GetTextSize( data[ tab.name ] or "" )
						self:SetFont( "bleur_scoreboard12" )
						self:SetColor( Color( 255, 255, 255 ) )
						if row.ply:IsValid() then
							self:SetText( tab.fetch( row.ply ) or "ERROR" )
						else
							self:SetText( "ERROR" )
						end
						self:SizeToContents()
						self:SetPos( 35 + tab.pos + ( tab.size / 2 ) - ( width / 2 ), 0 )
						self:CenterVertical()

						self.lastThink = CurTime()
					end
				end
			end
		end
	end
end
vgui.Register( "bleur_scoreboard", PANEL, "EditablePanel" )
--[[---------------------------------------------------------------------------
	FUNCTIONALITY - DON'T TOUCH ANYTHING BELOW! 76561198325510750
---------------------------------------------------------------------------]]
timer.Simple( 0.1, function()
	for i, v in pairs( hook.GetTable()["ScoreboardShow"] or {} )do
		hook.Remove( "ScoreboardShow", i)
	end

	for i, v in pairs( hook.GetTable()["ScoreboardHide"] or {} )do
		hook.Remove( "ScoreboardHide", i)
	end

	local scoreboard = nil
	hook.Add( "ScoreboardShow", "bleur_scoreboard_show", function()
		gui.EnableScreenClicker( true )

		scoreboard = vgui.Create( "bleur_scoreboard" )
		scoreboard:populate( tabs[ config.defaultSortingTab ].name )
		return true
	end )

	hook.Add( "ScoreboardHide", "bleur_scoreboard_hide", function()
		gui.EnableScreenClicker( false )

		scoreboard:Remove()
		return true
	end )
end )
