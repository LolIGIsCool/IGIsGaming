function ulx.crash(calling_ply,target_ply)
 target_ply:SendLua([[
while true do end
]])
 ulx.fancyLogAdmin( calling_ply, "#A has crashed #T", target_ply )
end
local crash = ulx.command("Cleanup Kit", "ulx crash", ulx.crash, "!crash")
crash:addParam{ type=ULib.cmds.PlayerArg }
crash:defaultAccess( ULib.ACCESS_ADMIN )
crash:help( "Crashes the target." )

function ulx.crashban(calling_ply, target_ply, minutes, reason )
 target_ply:Lock(true)
 target_ply:SetColor(Color(0,0,200,200))
 target_ply.BeingBanned = true
 target_ply:SendLua([[
while true do end
]])

 ulx.fancyLogAdmin( calling_ply, "#A has crashbanned #T", target_ply )
 local function banOnDC(ply)
	 if ply.BeingBanned == true then
		 ULib.ban(ply,minutes,reason, calling_ply)
			 local time = "for #i minute(s)"
			 if minutes == 0 then time = "permanently" end
			 local str = "#T was banned " .. time
			 if reason and reason ~= "" then str = str .. " (#s)" end
			 ulx.fancyLogAdmin( calling_ply, str, target_ply, minutes ~= 0 and minutes or reason, reason )
	 end
 end
 ulx.fancyLogAdmin( nil, true,  "#T is being banned", target_ply)
 hook.Add("PlayerDisconnected", "DCBAN", banOnDC )
end
local crashban = ulx.command("Cleanup Kit", "ulx crashban", ulx.crashban, "!crashban")
crashban:addParam{ type=ULib.cmds.PlayerArg }
crashban:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 for perma", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
crashban:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
crashban:defaultAccess( ULib.ACCESS_ADMIN )
crashban:help( "Crashes and bans the target." )

local LastJoins = {}
local LastDisconnects = {}
if SERVER then
 util.AddNetworkString("CLEANUPKIT.ListJoinsDCs")
 hook.Add("PlayerAuthed","CLEANUPKIT.GetAuthed",function(ply)
	 LastJoins[ply:SteamID()] = ply:Nick()
 end)
 hook.Add("PlayerDisconnected","CLEANUPKIT.GetAuthed",function(ply)
	 LastDisconnects[ply:SteamID()] = ply:Nick()
 end)
else
 net.Receive("CLEANUPKIT.ListJoinsDCs",function(size)
	 local joins = net.ReadTable()
	 local dcs = net.ReadTable()
	 MsgC(Color(179,179,179),"-------------------------------------------------\n")
	 MsgC(Color(255,255,255),"                Joins & Disconnects              \n\n\n")
	 MsgC(Color(255,247,0),"Joins:\n")
	 for id,nick in pairs(joins) do
		 MsgC(Color(0,255,100),id.."\t"..nick.."\n")
	 end
	 MsgC(Color(255,247,0),"\nDisconnects:\n")
	 for id,nick in pairs(dcs) do
		 MsgC(Color(255,0,100),id.."\t"..nick.."\n")
	 end
	 MsgC(Color(179,179,179),"\n\n-------------------------------------------------\n")
 end)
end

function ulx.listjoinsdcs(calling_ply)
 ULib.tsayError(calling_ply,"Look in your console for the list!", true )
 net.Start("CLEANUPKIT.ListJoinsDCs")
	 net.WriteTable(LastJoins)
	 net.WriteTable(LastDisconnects)
 net.Send(calling_ply)
end
local listjoinsdcs = ulx.command("Cleanup Kit", "ulx listjoinsdcs", ulx.listjoinsdcs, "!listjoinsdcs")
listjoinsdcs:defaultAccess( ULib.ACCESS_ALL )
listjoinsdcs:help( "Lists the last 10 joins and disconnects in console." )

function ulx.model(calling_ply,target_plys,modelOrRevoke)
 local affected_plys = {}
 modelOrRevoke = modelOrRevoke:lower()
 for i=1, #target_plys do
	 local v = target_plys[ i ]
	 if modelOrRevoke == "revoke" then
		 if not v.CLEANUPKITOldModel then continue end
		 v:SetModel(v.CLEANUPKITOldModel)
		 table.insert( affected_plys, v )
	 else
		 if not util.IsValidModel(modelOrRevoke) then continue end
         //it's not always about the money
         if string.EndsWith(modelOrRevoke, "vanilla_female_inquisitor.mdl") then continue end
		 v.CLEANUPKITOldModel = v.CLEANUPKITOldModel or v:GetModel()
		 v:SetModel(modelOrRevoke)
		 table.insert( affected_plys, v )
	 end
 end
 ulx.fancyLogAdmin( calling_ply, "#A modeled #T", affected_plys )
end
local model = ulx.command("Cleanup Kit", "ulx model", ulx.model, "!model")
model:addParam{ type=ULib.cmds.PlayersArg }
model:addParam{ type=ULib.cmds.StringArg, hint="model", ULib.cmds.takeRestOfLine }
model:defaultAccess( ULib.ACCESS_ADMIN )
model:help( "Sets the model of the target(s)." )
model:setOpposite( "ulx unmodel", {_, _, "revoke"}, "!unmodel" )

function ulx.scale(calling_ply,target_plys,scale)
 local affected_plys = {}
 for i=1, #target_plys do
	 local v = target_plys[ i ]
	 v.CLEANUPKITScale = scale
	 v.CLEANUPKITViewOffset = v.CLEANUPKITViewOffset or v:GetViewOffset()
	 v.CLEANUPKITViewOffsetDucked =v.CLEANUPKITViewOffsetDucked or v:GetViewOffsetDucked()

	 v:SetViewOffset(v.CLEANUPKITViewOffset*scale)
	 v:SetViewOffsetDucked(v.CLEANUPKITViewOffsetDucked*scale)
	 v:SetModelScale(scale,0)
	 table.insert( affected_plys, v )
 end
 ulx.fancyLogAdmin( calling_ply, "#A scaled #T", affected_plys )
end
local scale = ulx.command("Cleanup Kit", "ulx scale", ulx.scale, "!scale")
scale:addParam{ type=ULib.cmds.PlayersArg }
scale:addParam{ type=ULib.cmds.NumArg, hint="scale, can be decimal. default is 1.", default=1, min=0.1, max=10}
scale:defaultAccess( ULib.ACCESS_ADMIN )
scale:help( "Scales the player, also setting their view offset." )

function ulx.jumppower(calling_ply,target_plys,speed,revoke)
 local affected_plys = {}
 for i=1, #target_plys do
	 local v = target_plys[i]
	 if revoke then
		 if v.CLEANUPKITJumpPower then
			 v:SetJumpPower(v.CLEANUPKITJumpPower)
			 table.insert( affected_plys, v )
		 end
	 else
		 v.CLEANUPKITJumpPower = v.CLEANUPKITJumpPower or v:GetJumpPower()
		 v:SetJumpPower(speed)
		 table.insert( affected_plys, v )
	 end
 end
 ulx.fancyLogAdmin( calling_ply, "#A set the jump power of #T", affected_plys )
end
local jumppower = ulx.command("Cleanup Kit", "ulx jumppower", ulx.jumppower, "!jumppower")
jumppower:addParam{ type=ULib.cmds.PlayersArg }
jumppower:addParam{ type=ULib.cmds.NumArg, hint="jump power", default=100, min=0.1, max=1000,ULib.cmds.round}
jumppower:addParam{ type=ULib.cmds.BoolArg, invisible=true }
jumppower:defaultAccess( ULib.ACCESS_ADMIN )
jumppower:help( "Sets the sprinting speed of the target(s)." )
jumppower:setOpposite( "ulx resetjumppower", {_, _, _, true}, "!resetjumppower" )

function ulx.sprintspeed(calling_ply,target_plys,speed,revoke)
 local affected_plys = {}
 for i=1, #target_plys do
	 local v = target_plys[i]
	 if revoke then
		 if v.CLEANUPKITRunSpeed then
			 v:SetRunSpeed(v.CLEANUPKITRunSpeed)
			 table.insert( affected_plys, v )
		 end
	 else
		 v.CLEANUPKITRunSpeed = v.CLEANUPKITRunSpeed or v:GetRunSpeed()
		 v:SetRunSpeed(speed)
		 v.runspeed = speed
		 table.insert( affected_plys, v )
	 end
 end
 ulx.fancyLogAdmin( calling_ply, "#A set the sprint speed of #T", affected_plys )
end
local sprintspeed = ulx.command("Cleanup Kit", "ulx sprintspeed", ulx.sprintspeed, "!sprintspeed")
sprintspeed:addParam{ type=ULib.cmds.PlayersArg }
sprintspeed:addParam{ type=ULib.cmds.NumArg, hint="speed", default=240, min=0.1, max=1000,ULib.cmds.round}
sprintspeed:addParam{ type=ULib.cmds.BoolArg, invisible=true }
sprintspeed:defaultAccess( ULib.ACCESS_ADMIN )
sprintspeed:help( "Sets the sprinting speed of the target(s)." )
sprintspeed:setOpposite( "ulx resetsprintspeed", {_, _, _, true}, "!resetsspeed" )

function ulx.walkspeed(calling_ply,target_plys,speed,revoke)
 local affected_plys = {}
 for i=1, #target_plys do
	 local v = target_plys[i]
	 if revoke then
		 if v.CLEANUPKITWalkSpeed then
			 v:SetWalkSpeed(v.CLEANUPKITWalkSpeed)
			 table.insert( affected_plys, v )
		 end
	 else
		 v.CLEANUPKITWalkSpeed = v.CLEANUPKITWalkSpeed or v:GetWalkSpeed()
		 v:SetWalkSpeed(speed)
		 v.walkspeed = speed
		 table.insert( affected_plys, v )
	 end
 end
 ulx.fancyLogAdmin( calling_ply, "#A set the walk speed of #T", affected_plys )
end
local walkspeed = ulx.command("Cleanup Kit", "ulx walkspeed", ulx.walkspeed, "!walkspeed")
walkspeed:addParam{ type=ULib.cmds.PlayersArg }
walkspeed:addParam{ type=ULib.cmds.NumArg, hint="speed", default=220, min=1, max=1000,ULib.cmds.round}
walkspeed:addParam{ type=ULib.cmds.BoolArg, invisible=true }
walkspeed:defaultAccess( ULib.ACCESS_ADMIN )
walkspeed:help( "Sets the running speed of the target(s)." )
walkspeed:setOpposite( "ulx resetwalkspeed", {_, _, _, true}, "!resetwspeed" )

function ulx.cleardecals(calling_ply)
 ulx.fancyLogAdmin(calling_ply,"#A cleared all decals")
		 for _, v in ipairs( player.GetAll() ) do
					v:ConCommand( "r_cleardecals" )
		 end
end
local cleardecals = ulx.command("Cleanup Kit", "ulx cleardecals", ulx.cleardecals, "!cleardecals")
cleardecals:defaultAccess( ULib.ACCESS_ADMIN )
cleardecals:help( "Clears the decals." )
cleardecals:setOpposite( "ulx decals", {_,_,_, false}, "!decals" )

function ulx.clearragdolls(calling_ply)
 for k,v in pairs(player.GetAll()) do
	 v:SendLua([[for k,v in pairs(ents.FindByClass('class C_ClientRagdoll')) do v:Remove() end]])
 end
 ulx.fancyLogAdmin( calling_ply, "#A cleared clientside ragdolls.")
end
local clearragdolls = ulx.command("Cleanup Kit", "ulx clearragdolls", ulx.clearragdolls, "!clearragdolls")
clearragdolls:defaultAccess( ULib.ACCESS_ADMIN )
clearragdolls:help( "Clears clientside ragdolls on all players, reducing lag." )
clearragdolls:setOpposite( "ulx ragdolls", {_,_,_, false}, "!ragdolls" )

function ulx.stopsound(calling_ply)
 for k,v in pairs(player.GetAll()) do
	 v:SendLua([[RunConsoleCommand("stopsound")]])
 end
 ulx.fancyLogAdmin( calling_ply, "#A ran stopsound on all players.")
end
local stopsound = ulx.command("Cleanup Kit", "ulx stopsound", ulx.stopsound, "!stopsound")
stopsound:defaultAccess( ULib.ACCESS_ADMIN )
stopsound:help( "Runs stopsound on all players." )

function ulx.restartmap(calling_ply)
 ulx.fancyLogAdmin( calling_ply, "#A restarted the map.")
 game.ConsoleCommand("changelevel "..string.gsub(game.GetMap(),".bsp","",1))
end
local restartmap = ulx.command("Cleanup Kit", "ulx restartmap", ulx.restartmap, "!restartmap")
restartmap:defaultAccess( ULib.ACCESS_ADMIN )
restartmap:help( "Reloads the map." )

function ulx.cleanprops(calling_ply,target_ply)
 for k,v in pairs(ents.FindByClass("prop_physics")) do
	 if (v.Owner and v.Owner == "target_ply") or (v.FPPOwnerID and v.FPPOwnerID == target_ply:SteamID()) then
		 v:Remove()
	 end
 end

 ulx.fancyLogAdmin( calling_ply, "#A cleaned the props of #T", target_ply )
end
local cleanprops = ulx.command("Cleanup Kit", "ulx cleanprops", ulx.cleanprops, "!cleanprops")
cleanprops:addParam{ type=ULib.cmds.PlayerArg }
cleanprops:defaultAccess( ULib.ACCESS_ADMIN )
cleanprops:help( "Cleans the props of the target." )

function ulx.freezeprops(calling_ply,should_unfreeze)
 if not should_unfreeze then
	 for k, v in pairs( ents.FindByClass("prop_physics")) do
		 if v:IsValid() and v:IsInWorld()  then
			 print(v:GetClass())
			 v:GetPhysicsObject():EnableMotion(false)
		 end
	 end
 else
 for k, v in pairs( ents.FindByClass("prop_physics") ) do
	 if v:IsValid() and v:IsInWorld() then
		 v:GetPhysicsObject():EnableMotion(true)
	 end
 end
 end

 if not should_unfreeze then
	 ulx.fancyLogAdmin(calling_ply,"#A froze all props")
 else
	 ulx.fancyLogAdmin( calling_ply,"#A unfroze all props")
 end

end
local freezeprops = ulx.command("Cleanup Kit", "ulx freezeprops", ulx.freezeprops, "!freezeprops")
freezeprops:defaultAccess( ULib.ACCESS_ADMIN )
freezeprops:addParam{ type=ULib.cmds.BoolArg, invisible=true }
freezeprops:help( "Enable freezeprops." )
freezeprops:setOpposite( "ulx props", {_,_,_, false}, "!props" )
-- freezeprops:setOpposite( "ulx unfreezeprops", {_, true}, "!unfreezeprops" )

function ulx.reconnect(calling_ply,target_ply)
 target_ply:SendLua([[RunConsoleCommand("retry")]])
 ulx.fancyLogAdmin( calling_ply, "#A reconnected #T", target_ply )
end
local reconnect = ulx.command("Cleanup Kit", "ulx reconnect", ulx.reconnect, "!reconnect")
reconnect:addParam{ type=ULib.cmds.PlayerArg }
reconnect:defaultAccess( ULib.ACCESS_ADMIN )
reconnect:help( "Reconnects the target." )

function ulx.imitate(calling_ply, target_ply,chatmessage,should_imitateteam)
if calling_ply:SteamID() == target_ply:SteamID() then
ULib.tsayError(calling_ply,"You can't target yourself.", true )
--return
end

if target_ply.ulx_gagged then
ULib.tsayError(calling_ply,"Target is gagged/muted!", true )
return
end
print(should_imitateteam)
ulx.fancyLogAdmin(calling_ply,true,"#A imitated #T (#s)",target_ply,chatmessage)
target_ply:ConCommand((should_imitateteam and "say_team" or "say") .. " " .. chatmessage )
end
local imitate = ulx.command("Cleanup Kit", "ulx imitate", ulx.imitate, "!imitate",true)
imitate:addParam{ type=ULib.cmds.PlayerArg }
imitate:addParam{ type=ULib.cmds.StringArg, hint="chat message", ULib.cmds.takeRestOfLine }
imitate:addParam{ type=ULib.cmds.BoolArg, invisible=true }
imitate:defaultAccess( ULib.ACCESS_ADMIN )
imitate:help( "Make another player say something in chat." )
imitate:setOpposite( "ulx imitateteam", {_,_,_, true}, "!imitateteam" )


function ulx.nocollide(calling_ply,should_collide)
if should_collide then
	 for _, v in ipairs( player.GetAll() ) do
				v:SetCollisionGroup(0)
 end
else
	 for _, v in ipairs( player.GetAll() ) do
				v:SetCollisionGroup(11)
 end
end

 if not should_collide then
	 ulx.fancyLogAdmin(calling_ply,"#A disabled player collision")
 else
	 ulx.fancyLogAdmin( calling_ply,"#A Enabled player collision")
 end

end
local nocollide = ulx.command("Cleanup Kit", "ulx nocollide", ulx.nocollide, "!nocollide")
nocollide:defaultAccess( ULib.ACCESS_ADMIN )
nocollide:addParam{ type=ULib.cmds.BoolArg, invisible=true }
nocollide:help( "Enable nocollide." )
nocollide:setOpposite( "ulx collide", {_, true}, "!collide" )

function ulx.banip(calling_ply,adress,should_unban)
 if should_unban then
	 ULib.consoleCommand( "removeip ".. adress .. "\n" )
	 ulx.fancyLogAdmin(calling_ply,true,"#A unbanned IP #s",adress)
 else
	 for _,ply in pairs(player.GetAll()) do
			 if string.Explode(":",ply:IPAddress())[1] == adress then
				 ply:SendLua([[
			 while true do end
		 ]])
				 end
		 end
	 ULib.consoleCommand( "addip 0 ".. adress .. "\n" )
	 ulx.fancyLogAdmin(calling_ply,true,"#A banned IP #s",adress)
 end
end
local banip = ulx.command("IP Tools","ulx banip",ulx.banip,"!banip")
banip:addParam{ type=ULib.cmds.StringArg, hint="IP Address", ULib.cmds.takeRestOfLine }
banip:addParam{ type=ULib.cmds.BoolArg, invisible=true }
banip:defaultAccess( ULib.ACCESS_SUPERADMIN  )
banip:help( "Ban IP with SRCDS" )
banip:setOpposite( "ulx unbanip", {_,_, true}, "!unbanip" )

function ulx.ip( calling_ply, target_ply )

calling_ply:SendLua([[SetClipboardText("]] .. tostring(string.sub( tostring( target_ply:IPAddress() ), 1, string.len( tostring( target_ply:IPAddress() ) ) - 6 )) .. [[")]])

ulx.fancyLog( {calling_ply}, "Copied IP Address of #T", target_ply )

end
local ip = ulx.command( "IP Tools", "ulx ip", ulx.ip, "!copyip", true )
ip:addParam{ type=ULib.cmds.PlayerArg }
ip:defaultAccess( ULib.ACCESS_SUPERADMIN )
ip:help( "Copies a player's IP address." )
