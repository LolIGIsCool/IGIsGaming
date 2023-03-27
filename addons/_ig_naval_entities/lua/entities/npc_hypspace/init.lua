AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("ig_hyp_terminal_open")
util.AddNetworkString("ig_hyp_terminal_recieve")
util.AddNetworkString("ig_hyp_terminal_cancel")


IG_HYPERSPACE_CHECK = false

function ENT:Initialize()
	self:SetModel("models/kingpommes/starwars/misc/bridge_console4.mdl")
	self:SetUseType(SIMPLE_USE)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType( MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)    
    local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end
end

// Regiments and Clearance Levels able to open the RFA menu
	local regiments = {
		"Imperial High Command",
		"Imperial Starfighter Corps",
		"Imperial Naval Engineer",
		"Imperial Navy",
	}
	local clearancelevel = {
		"5",
		"6",
		"ALL ACCESS",
		"CLASSIFIED",
	}

function ENT:AcceptInput( name, activator, caller )	
	if name == "Use" and caller:IsPlayer() then
		if table.HasValue(regiments, caller:GetRegiment()) or table.HasValue(clearancelevel, caller:GetJobTable().Clearance) then
			net.Start("ig_hyp_terminal_open")
				net.WriteBool(IG_HYPERSPACE_CHECK)
			net.Send(caller)
		end
	end
end

net.Receive("ig_hyp_terminal_cancel", function()
		local starsexit = ents.Create("hyperstars")
			starsexit:SetPos(Vector( 2145.157471, -6592.291992, 13732.274414) )
			starsexit:SetAngles(Angle(0,0,0))

		timer.Simple(2, function()
			if IG_HYPERSPACE_CHECK == true then
				starsexit:Spawn()
				local seq = starsexit:LookupSequence("out")
				starsexit:ResetSequence(seq)
				starsexit:SetSequence(seq)
				util.ScreenShake( Vector(0, 0, 0), 5, 5, 4, 10000 )
			end
		end)

		timer.Simple(2.3, function()
			if IG_HYPERSPACE_CHECK == true then
				for k,v in pairs(ents.FindByClass("hyperplanet"))do
					v:Remove()
				end
				for k,v in pairs(ents.FindByClass("hypertunnel"))do
					v:Remove()
				end
				starsexit:Remove()
				IG_HYPERSPACE_CHECK = false
			end
		end)
end)

net.Receive("ig_hyp_terminal_recieve", function()
	local hyptable = net.ReadTable()
	local lply = net.ReadEntity()

	RunConsoleCommand("ulx", "asay", lply:Nick().." has used the Hyperspace Entity")

	IG_HYPERSPACE_CHECK = true
	-- Creating Entities
		local starsenter = ents.Create("hyperstars")
			starsenter:SetPos(Vector( 2145.157471, -6592.291992, 13732.274414) )
			starsenter:SetAngles(Angle(180,0,0))
			starsenter:Spawn()
		local starsexit = ents.Create("hyperstars")
			starsexit:SetPos(Vector( 2145.157471, -6592.291992, 13732.274414) )
			starsexit:SetAngles(Angle(0,0,0))
		local hyperspace = ents.Create("hypertunnel")
			hyperspace:SetPos(Vector( 2145.157471, -6592.291992, 13732.274414) )
			hyperspace:SetAngles(Angle(0,0,0))

	-- Hyperspace
		util.ScreenShake( Vector(0, 0, 0), 5, 5, 4, 10000 )
		timer.Simple(1, function()	
			local seq = starsenter:LookupSequence("out")
			starsenter:ResetSequence(seq)
			starsenter:SetSequence(seq)
			hyperspace:Spawn()
			for k,v in pairs(ents.FindByClass("hyperplanet"))do
				v:Remove()
			end
		end)

		timer.Simple(1.3, function()
			local seq = starsenter:LookupSequence("out")
			starsenter:ResetSequence(seq)	
			starsenter:Remove()
		end)
		
			timer.Simple(hyptable.num + 2, function()
				if hyptable.inf == "false" then
					if IG_HYPERSPACE_CHECK == true then
						starsexit:Spawn()
						local seq = starsexit:LookupSequence("out")
						starsexit:ResetSequence(seq)
						starsexit:SetSequence(seq)
						util.ScreenShake( Vector(0, 0, 0), 5, 5, 4, 10000 )
					end
				end
			end)

			timer.Simple(hyptable.num + 2.3, function()
				if hyptable.inf == "false" then
					if IG_HYPERSPACE_CHECK == true then
						starsexit:Remove()
						hyperspace:Remove()
						IG_HYPERSPACE_CHECK = false
						if hyptable.planet >= 0 then
							if hyptable.planet < 9 then
								local leftright = -7500
								if hyptable.left == "Right" then
									leftright = -7500
								elseif hyptable.left == "Left" then
									leftright = -5500
								end
								local planetpos = Vector(4401, leftright, 13954.990234)

								if hyptable.position == "Close" then
									planetpos = Vector(2401, leftright, 13954.990234)
								elseif hyptable.position == "Far" then
									planetpos = Vector(7401, leftright, 13954.990234)
								end

								local planethyp = ents.Create("hyperplanet")
								planethyp:SetPos(planetpos)
								planethyp:SetSkin(hyptable.planet)
								planethyp:Spawn()
								if hyptable.left == "Left" then
									planethyp:SetAngles(Angle(0,120,0))
								elseif hyptable.left == "Right" then
									planethyp:SetAngles(Angle(0,60,0))
								end
							else
								local leftright = -6800
								if hyptable.left == "Right" then
									leftright = -6800
								elseif hyptable.left == "Left" then
									leftright = -6500
								end
								local planetpos = Vector(2401, leftright, 13700)

								if hyptable.position == "Close" then
									planetpos = Vector(2000, leftright, 13750)
								elseif hyptable.position == "Far" then
									planetpos = Vector(3400, leftright, 13750)
								end

								local planethyp = ents.Create("hyperplanet")
								planethyp:SetPos(planetpos)
								planethyp:Spawn()
								planethyp:SetModel("models/lordtrilobite/starwars/isd/isd_wreck2_128.mdl")
								if hyptable.left == "Left" then
									planethyp:SetAngles(Angle(0,160,0))
								elseif hyptable.left == "Right" then
									planethyp:SetAngles(Angle(0,70,0))
								end
							end
						end
					end
				end
			end)
end)

hook.Add("PlayerSay", "IG_LoadOut_Check", function( ply, text )
	if string.sub(text,1, 4) == "fart" then
		print(ply:GetPos())
	end
end)