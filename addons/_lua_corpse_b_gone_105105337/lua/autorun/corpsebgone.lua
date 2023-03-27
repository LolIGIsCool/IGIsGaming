if CLIENT then
	--user clean
	function VNUtilsClClCat(Panel)
		Panel:ClearControls()
		
		local corpseclean = vgui.Create("DButton")
		corpseclean:SetText("Clean Corpses")
		corpseclean:SetParent(Panel)
		corpseclean:SetPos(25, 50)
		corpseclean:SetSize( 250, 30)
		corpseclean.DoClick = function()
			local props = ents.FindByClass("class C_ClientRagdoll")
			for k,v in pairs(props) do
				v:Remove()
			end
			GAMEMODE:AddNotify("Corpses Cleared!", NOTIFY_CLEANUP, 5)
			surface.PlaySound("buttons/button15.wav")
		end
		
		local decalclean = vgui.Create("DButton")
		decalclean:SetText("Clean Decals")
		decalclean:SetParent(Panel)
		decalclean:SetPos(25, 100)
		decalclean:SetSize( 250, 30)
		decalclean.DoClick = function()
			RunConsoleCommand("r_cleardecals")
			GAMEMODE:AddNotify("Decals Cleared!", NOTIFY_CLEANUP, 5)
			surface.PlaySound("buttons/button15.wav")
		end

	end

	--admin clean
	function VNUtilsSvClCat(Panel)
		Panel:ClearControls()
		
		local corpseclean = vgui.Create("DButton")
		corpseclean:SetText("Clean Corpses")
		corpseclean:SetParent(Panel)
		corpseclean:SetPos(25, 50)
		corpseclean:SetSize( 250, 30)
		if !LocalPlayer():IsAdmin() then 
		corpseclean:SetEnabled(false) 
		end
		corpseclean.DoClick = function()
			RunConsoleCommand("vn_fclearcorpse")
			GAMEMODE:AddNotify("Corpses Cleared!", NOTIFY_CLEANUP, 5)
			surface.PlaySound("buttons/button15.wav")
		end
		
		local decalclean = vgui.Create("DButton")
		decalclean:SetText("Clean Decals")
		decalclean:SetParent(Panel)
		decalclean:SetPos(25, 100)
		decalclean:SetSize( 250, 30)
		if !LocalPlayer():IsAdmin() then 
		decalclean:SetEnabled(false) 
		end
		decalclean.DoClick = function()
			RunConsoleCommand("vn_fcleardecals")
			GAMEMODE:AddNotify("Decals Cleared!", NOTIFY_CLEANUP, 5)
			surface.PlaySound("buttons/button15.wav")
		end

	end

	function VNUtilsPop()
		spawnmenu.AddToolMenuOption("Utilities",
			"Corpse B Gone",   
			"VNUtilsSvClCat",  
			"Admin Clean",    "",    "",    
			VNUtilsSvClCat,
			{})
		spawnmenu.AddToolMenuOption("Utilities",
			"Corpse B Gone",   
			"VNUtilsClClCat",  
			"User Clean",    "",    "",    
			VNUtilsClClCat,
			{})
	end
	hook.Add("PopulateToolMenu", "VNUtilsPop", VNUtilsPop)

	local function VNUtils()	
		spawnmenu.AddToolCategory("Utilities", "Corpse B Gone", "Corpse B Gone")
	end
	hook.Add("AddToolMenuTabs", "VNUtils", VNUtils)
else
	AddCSLuaFile("corpsebgone.lua")
	
	function fcleardecals(pl, comm, args)
		if !pl:IsAdmin() then return end
		
		for k, v in pairs(player.GetAll()) do
		   v:ConCommand("r_cleardecals")
		end
	end
	concommand.Add("vn_fcleardecals", fcleardecals)
	
	function fclearcorpse(pl, comm, args)
		if !pl:IsAdmin() then return end
		
		local temp = GetConVarNumber("g_ragdoll_maxcount")
		RunConsoleCommand("g_ragdoll_maxcount", "0")
		timer.Simple(1, function() RunConsoleCommand( "g_ragdoll_maxcount", tostring(temp) ) end )
	end
	concommand.Add("vn_fclearcorpse", fclearcorpse)
end