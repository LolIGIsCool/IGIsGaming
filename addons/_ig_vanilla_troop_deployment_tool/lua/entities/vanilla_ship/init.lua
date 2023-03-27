AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal * 0 )
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:KeyValue(k,v)
	if k == "droidcount" then
		self.droidcount = tonumber(v)
	end
	if k == "droidtype" then
		self.droidtype = v
	end
	if k == "ship" then
		self.ship = v
	end
	if k == "gun" then
		self.gun = v
	end
	if k == "health" then
		self.health = tonumber(v)
	end
	if k == "player" then
		self.player = tobool(v)
	end
	if k == "name" then
		self.name = v
	end
	if k == "height" then
		self.height = tonumber(v)
	end
end

function ENT:RunOnSpawn()
	self:SetCollisionGroup(COLLISION_GROUP_VEHICLE_CLIP)
	self.spawnlocation = self:GetPos()
	self.shouldspawn = 0
	local NPCList = list.Get( "NPC" )
	if self.player == false then
		self.NPCData = NPCList[ self.droidtype ]
	else
		self.NPCData = NPCList[ "npc_combine_s" ]
	end

	if self.NPCData == nil then
		print("[Vanilla's Troop Deployment Tool] NPC Class not valid.")
		self:Remove()
		self:GetVar("dest"):Remove()
		return
	end
	local spawnedEntity = ents.Create(self.NPCData.Class)
	spawnedEntity:SetPos(self.spawnlocation)
    spawnedEntity:SetKeyValue( "spawnflags", bit.bor( SF_NPC_NO_WEAPON_DROP ) )
	spawnedEntity:Spawn()

	if IsValid( spawnedEntity ) then
		if IsValid( spawnedEntity:GetPhysicsObject() ) then
			local min, max = spawnedEntity:GetPhysicsObject():GetAABB() or Vector(), Vector()
			local entPos = spawnedEntity:GetPos() or Vector()
			local offset = ((max - entPos) - (min - entPos))
			self.bbX = math.ceil(offset.x)
			self.bbY = math.ceil(offset.y)
		end
		spawnedEntity:Remove()
	end

	self:SetPos(self:GetPos() + Vector(-1500,0,self.height))
	self:SetAngles(self:GetAngles() + Angle(45,0,0))

	self:SetModel(self.ship)

end


function ENT:SpawnTroops()
	local xCount = math.ceil(math.sqrt(self.droidcount))
	local pCount = 0
	local playerlist = {}
	if self.player == true then
		for k, v in pairs(player.GetAll()) do
			if string.StartWith(v:Nick(),self.name) and v:GetRegiment() == "Event" then
				pCount = pCount + 1
				table.insert(playerlist,v)
			end
		end
		xCount = pCount
	end
	local yCount = xCount
	local xGap = 25
	local yGap = xGap
	local playerIndex = 1

	if self.shouldspawn == 1 && SERVER then
		timer.Simple(2.6,function()
			if not self:IsValid() then return end
			function doSquareSpawn(x, y)
	            local localPos = Vector( (x * (xGap + self.bbX)) - ((xCount - 1) * (xGap + self.bbX) / 2), (y * (yGap + self.bbY)) - ((yCount - 1) * (yGap + self.bbY) / 2), spawnHeight)
				local spawnedEntity = ents.Create(self.NPCData.Class)
				spawnedEntity:SetPos(localPos + (self.spawnlocation - Vector(0,0,0)))
				if ( self.NPCData.Model ) then
					spawnedEntity:SetModel( self.NPCData.Model )
				end

				if ( self.NPCData.Material ) then
					spawnedEntity:SetMaterial( self.NPCData.Material )
				end
				spawnedEntity:Spawn()
				if self.player == false then
					spawnedEntity:SetHealth(self.health)
					spawnedEntity:Give(self.gun)
					--spawnedEntity:SetKeyValue( "spawnflags", "8192" )
				end
				if self.player == true then
					local pos = spawnedEntity:GetPos()
					spawnedEntity:Remove()
					if not IsValid(playerlist[playerIndex]) then return end
					playerlist[playerIndex]:SetPos(pos)
					playerIndex = playerIndex + 1
				end
	        end

	        for x = 0, xCount - 1 do
	            for y = 0, yCount - 1 do
	                doSquareSpawn(x, y)
	            end
	        end
		end)
			timer.Simple(10,function()
				if not IsValid(self) then return end
				if not IsValid(self:GetVar("dest")) then return end
				self:Remove()
				self:GetVar("dest"):Remove()
			end)
	end
end

function ENT:OnTick()
	if self.InRangeForSpawn == true then
		self.shouldspawn = self.shouldspawn + 1
		self:SpawnTroops()
	else
		self.shouldspawn = 0
	end
end
