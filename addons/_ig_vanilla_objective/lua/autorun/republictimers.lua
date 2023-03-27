if SERVER then
	---Precaching network messages---
	util.AddNetworkString("start_countdown")
	util.AddNetworkString("abort_countdown")
	util.AddNetworkString("cd_check")
	util.AddNetworkString("cd_start")
	util.AddNetworkString("cd_abort")
	---------Main functions----------
	local Countdown = {}
		Countdown.Start = function ()
			fixed_time	= SVTable.Time
			cd_in_progress = true
			MsgC (Color (17,236,116,255),"[Imperial Countdowns] Countdown \""..SVTable.Title.."\"started for "..fixed_time.." seconds with <"..SVTable.Command.."> concommand to be executed!\n")
			timer.Create ("countdown", SVTable.Time, 1, function ()
				comtable = string.Explode(" ", SVTable.Command)
				SVTable.Starter:ConCommand (comtable[1], unpack(comtable,2))
				MsgC (Color(17,236,116,255),"[Imperial Countdowns] Countdown \""..SVTable.Title.."\" for "..fixed_time.." seconds with <"..SVTable.Command.."> concommand has just finished!\n")
				cd_in_progress = false
			end)
			timeleft = SVTable.Time
			timer.Create ("countdown4connected", 1, timeleft, function ()
				timeleft = timeleft - 1
				if timeleft == 0 then 
					timer.Stop ("countdown4connected")
				end
			end)
			net.Start ("cd_start")
			net.WriteTable (SVTable)
			net.Broadcast ()
		end
		Countdown.Stop = function ()
			timer.Stop ("countdown")
			timer.Stop ("countdown4connected")
			if cd_in_progress == true then MsgC (Color (255,130,100,255),"[SERVER COUNTDOWNER] Countdown was aborted!\n") end
			cd_in_progress = false
			net.Start ("cd_abort")
			net.Broadcast ()
		end
	------------Messaging-------------
	net.Receive ("start_countdown", function (len, ply)
		if ply:IsAdmin() or ply:IsEventMaster() then
			SVTable = net.ReadTable ()
			Countdown.Start ()
		end
	end)

	net.Receive ("abort_countdown", function (len, ply)
		if ply:IsAdmin() or ply:IsEventMaster() then
			Countdown.Stop ()
		end
	end)

	net.Receive ("cd_check", function (len, ply)
		if cd_in_progress == true then
			net.Start ("cd_start")
			SVTable.Time = timeleft
			net.WriteTable (SVTable)
			net.Send(ply)
		end
	end)
	------------Concommands------------
	concommand.Add ("countdown_start", function (ply, cmd, args)
		if ply:IsAdmin() or ply:IsEventMaster() then
			SVTable = {}
			SVTable.Starter = ply
			SVTable.Time = tonumber (args[1])
			SVTable.Title = args[2]
			SVTable.Command = args[3]
			if SVTable.Command == nil then SVTable.Command = "" end
			SVTable.Color = Color (100,130,255,255)
			SVTable.Theme = "Dark"
			SVTable.Warning = true
			Countdown.Start()
		else
			MsgC (Color (17,236,116,255),"[Imperial Countdowns] You do not have permission to run a timer!")
		end
	end, nil, "First argument sets the time, second sets the text to display, third is a concommand should be ran. \nExample - countdown_start 60 Cleanup gmod_admin_cleanup")

	concommand.Add ("countdown_stop", function () Countdown.Stop() end, nil, "Aborts the countdown.")
else
	DefColor = Color (100,130,255,255)
	RepublicColor = Color (255,255,255,255)
	WarColor = Color (255,100,70,255)
	local function Countdowner ()
	
	---------------BODY-----------------
	
	CountdownerBody = vgui.Create ("DFrame")
		CountdownerBody:SetPos(ScrW() * 0.745,ScrH() * 0.05)
		CountdownerBody:SetSize(ScrW() * 0.245, ScrH() * 0.07)
		CountdownerBody:SetTitle ("")
		CountdownerBody:SetVisible (true)
		CountdownerBody:SetDraggable (false)
		CountdownerBody:ShowCloseButton (false)
	
		CountdownerBody.Paint = function (self,w,h)
			_G.vanillaBlurPanel(0,0,w,h,Color(0,0,0,100));
	
			surface.SetDrawColor( 255, 255, 255, 200 );
			surface.DrawRect(w * 0.02, h * 0.5, w * 0.96, h * 0.033);
		end
	
	CountdownerMainLabel = vgui.Create ("DLabel", CountdownerBody)
		CountdownerMainLabel:SetSize (utf8.len(cd_text)*30, 40)
		CountdownerMainLabel:SetX(ScrW() * 0.005 )
		CountdownerMainLabel:SetY(ScrH() * 0.035)
		CountdownerMainLabel:SetText (cd_text)
		CountdownerMainLabel:SetFont ("Trebuchet18")
		CountdownerMainLabel:SetColor (Color(255,255,255,200))
	
	CountdownerNum = vgui.Create ("DLabel", CountdownerBody)
		CountdownerNum:Center()
		CountdownerNum:SetPos(ScrW() * 0.0025, ScrH() * -0.007)
		CountdownerNum:SetSize (200,55)
		CountdownerNum:SetFont ("vanilla_font_info")
		CountdownerNum:SetColor (Color(255,255,255,200))
		CountdownerNum:SetText (" XX:XX:XX")
	
	-------------MAIN COUNTDOWNER-------------
	local function CountdownerEnum () 
		timer.Create ("cd_countdowner", 1, cd_time, function ()
			cd_time = cd_time - 1
			sd_hours = math.floor(cd_time/3600)
			sd_minutes = math.floor(cd_time/60 - sd_hours*60)
			sd_seconds = math.floor(cd_time - sd_hours*3600 - sd_minutes*60)
				if sd_hours < 10 then tostring(sd_hours) sd_hours = ("0"..sd_hours) end
				if sd_minutes < 10 then tostring(sd_minutes) sd_minutes = ("0"..sd_minutes) end
				if sd_seconds < 10 then tostring(sd_seconds) sd_seconds = ("0"..sd_seconds) end
					if cd_theme == "Dark" then
						CountdownerNum:SetText (" "..sd_hours..":"..sd_minutes..":"..sd_seconds) 
					end
			-----------IMMENT----------
				if cd_time <= 0 then 
				CountdownerNum:SetText ("TIME UP!") 
				CountdownerClose() end
			end) 
		end
		CountdownerEnum ()
	end 
	
	function CountdownerClose()
		CountdownerBody:Remove()
		timer.Stop ("cd_countdowner")
	end
	
	net.Receive ("cd_abort", function (len,ply)
		if IsValid(CountdownerBody) then
			if CountdownerBody:IsVisible (true) then
				CountdownerMainLabel:SetPos ((ScrW()-300)/2,8)
				CountdownerMainLabel:SetSize (300,40)
				CountdownerMainLabel:SetText ("Countdown aborted.")
				CountdownerNum:SetText ("") 
				CountdownerClose()
			end
		end
	end)
	
	net.Receive ("cd_start", function (len, ply)
		CDData = net.ReadTable ()
		cd_text = CDData.Title
		cd_time = CDData.Time
		cd_color = CDData.Color
		cd_theme = CDData.Theme
		cd_warning = CDData.Warning
		if IsValid(CountdownerBody) then
			if CountdownerBody:IsVisible (true) then
				timer.Stop ("cd_closecountdowner")
				timer.Create ("cd_cdreopener1", 1, 1, function () CountdownerBody:SetVisible (false) end )
				timer.Create ("cd_cdreopener2", 1.1, 1, function () Countdowner () end )
			else
				Countdowner ()
			end
		else
			Countdowner ()
		end
	end)
	
	net.Start ("cd_check")
	net.SendToServer()
end