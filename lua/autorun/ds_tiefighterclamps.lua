-- Created by Oninoni
-- Expanded upon to work with LFS by Jakob Sailer aka KingPommes

if game.GetMap() ~= "rp_deathstar_v1_2" then return end

-- Number of Clamps
local clampCount = 18

-- Name used for the clamps. Followed by a number.
local clampName = "clamp"

-- SWV and LFS entity names
local SWVEntity = "kingpommes_swv_tie_fighter"
local LFSEntity = "kingpommes_lfs_tie_fighter"

if CLIENT then

end

if SERVER then
    hook.Add("Think", "TieFighterClamps.Think", function()
        for i=1, clampCount, 1 do
            local clampNameNumbered = clampName .. i
            local clamps =  ents.FindByName(clampNameNumbered)
            if #clamps ~= 1 then continue end
            local clamp = clamps[1]

            local angles = clamp:GetAngles()
            local up = angles:Up()
            local right = angles:Forward()
            local forward = -angles:Right()

            local translatedPos = clamp:GetPos() - up * 83
            local leftPos = translatedPos - right * 96
            local rightPos = translatedPos + right * 96

            local leftTrace = util.TraceLine({
                start = leftPos,
                endpos = leftPos - up * 20
            })

            local rightTrace = util.TraceLine({
                start = rightPos,
                endpos = rightPos - up * 20
            })

            if leftTrace.Hit and rightTrace.Hit then
				if IsValid(leftTrace.Entity) and IsValid(rightTrace.Entity) then
					if leftTrace.Entity == rightTrace.Entity then
						
						-- SWV
						if leftTrace.Entity:GetClass() == SWVEntity then
							print("asd")
							local tieFighter = leftTrace.Entity
							if not clamp.Closed then
								if not tieFighter.Inflight then
									tieFighter:GetPhysicsObject():EnableMotion(false)
		
									clamp.Closed = true
									clamp:Fire("setanimation", "close")
									tieFighter:ResetSequence(tieFighter:LookupSequence("TopOpen"))
									
									local pilots = ents.FindInBox(translatedPos - Vector(150, 150, 100), translatedPos + Vector(150, 150, 50))
									for _, ply in pairs(pilots) do
										if IsValid(ply) and ply:IsPlayer() then
											local exitPos = clamp:GetAttachment(clamp:LookupAttachment("exit")).Pos
				
											ply:SetPos(exitPos)
										end
									end
								end
							else
								if tieFighter.Inflight then
									clamp.Closed = false
									clamp:Fire("setanimation", "open")
			
									tieFighter:ResetSequence(tieFighter:LookupSequence("TopClose"))
								end
							end

						-- LFS
						elseif leftTrace.Entity:GetClass() == LFSEntity then
							local tieFighter = leftTrace.Entity
							if not clamp.Closed or (clamp.Closed and not clamp.Exited and tieFighter:GetDriver() == NULL) then
								-- check if TIE has its engines on
								if not tieFighter:GetEngineActive() then
								
									-- disable TIEs motion and set clamps to closed
									if not clamp.Closed then
										tieFighter:GetPhysicsObject():EnableMotion(false)
										clamp.Closed = true
										clamp:Fire("setanimation", "close")
									end
									
									-- TODO: Only fire this when the player exits the vehicle
									if tieFighter:GetDriver() == NULL then
										local pilots = ents.FindInBox(translatedPos - Vector(300, 150, 100), translatedPos + Vector(300, 150, 50))
										for _, ply in pairs(pilots) do
											if IsValid(ply) and ply:IsPlayer() then
												local exitPos = clamp:GetAttachment(clamp:LookupAttachment("exit")).Pos
					
												ply:SetPos(exitPos)
												clamp.Exited = true
											end
										end
									end
								end
							else
								-- there might be a player in the TIE with its engines off
								if IsValid(tieFighter:GetDriver()) then
									clamp.Exited = false
								end
								-- if the TIE has active engines release it
								if tieFighter:GetEngineActive() then
									tieFighter:GetPhysicsObject():EnableMotion(true)
									clamp.Closed = false
									clamp:Fire("setanimation", "open")
								end
							end
						end
		
						continue
					end
				end
            end

			-- init the clamps
            if clamp.Closed or clamp.Closed == nil then
				print("Im firing for some reason", i)
                clamp.Closed = false
                clamp:Fire("setanimation", "open")
            end
        end
    end)
end