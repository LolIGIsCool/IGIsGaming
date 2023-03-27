local CATEGORY_NAME = "Ragetank Addons"
		
	function ulx.pmodel(calling_ply, target_plys)
		print(calling_ply)
		print(target_plys)
		if calling_ply != target_plys then
			calling_ply:ChatPrint("Name: " .. target_plys:Name())
			calling_ply:ChatPrint("Model: " .. target_plys:GetModel())
		else
			local trace =calling_ply:GetEyeTrace().Entity
			calling_ply:ChatPrint("Name: " .. trace:GetName())
			calling_ply:ChatPrint("Model: " .. trace:GetModel())
		end	
	end
	concommand.Remove( "drop" )
	local pmodel = ulx.command("Ragetank Addons", "ulx pmodel", ulx.pmodel, "!pmodel", true)
	pmodel:defaultAccess(ULib.ACCESS_ALL)
	pmodel:addParam{ type=ULib.cmds.PlayerArg, ULib.cmds.optional }
	
	function ulx.scalemodel(calling_ply, amount)
		local trace =calling_ply:GetEyeTrace().Entity
		print("test")
		if trace:GetClass() == "prop_physics" then
			print(amount)
			trace:SetModelScale(amount)
			trace:Activate()
		end
	end
	local scalemodel = ulx.command("Ragetank Addons", "ulx scalemodel", ulx.scalemodel, "!scalemodel", true)
	scalemodel:defaultAccess(ULib.ACCESS_ADMIN )
	scalemodel:addParam{ type=ULib.cmds.NumArg, min=0.1, max=2, hint="size" }