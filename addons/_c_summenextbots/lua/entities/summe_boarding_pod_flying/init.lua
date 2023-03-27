--[[
   _____ _    _ __  __ __  __ ______                   
  / ____| |  | |  \/  |  \/  |  ____|                  
 | (___ | |  | | \  / | \  / | |__                     
  \___ \| |  | | |\/| | |\/| |  __|                    
  ____) | |__| | |  | | |  | | |____                   
 |_____/_\____/|_| _|_|_|__|_|______|___ _______ _____ 
 | \ | |  ____\ \ / /__   __|  _ \ / __ \__   __/ ____|
 |  \| | |__   \ V /   | |  | |_) | |  | | | | | (___  
 | . ` |  __|   > <    | |  |  _ <| |  | | | |  \___ \ 
 | |\  | |____ / . \   | |  | |_) | |__| | | |  ____) |
 |_| \_|______/_/ \_\  |_|  |____/ \____/  |_| |_____/ 
                                                       
    Created by Summe: https://steamcommunity.com/id/DerSumme/ 
    Purchased content: https://discord.gg/k6YdMwj9w2
]]--

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include("shared.lua")
 

function ENT:Initialize()
 
	self:SetModel("models/summe/drochclass/pod.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end
    
    self:SetPos(self:GetPos() + Vector(0, 0, 10000))

end

function ENT:Think()

    if self:GetLanded() then
        local ents_ = ents.FindInSphere(self.TargetPos, 20)
        if table.HasValue(ents_, self) then
            local pod = ents.Create("summe_boarding_pod_landed")
            pod:SetPos(self:GetPos())
            pod:SetAngles(self:GetAngles())
            pod.NPCList = self.NPCList or {}

            self:Remove()

            pod:Spawn()
            return 
        end
        self:SetPos(self:GetPos() + Vector(0, 0, -10))
        self:EmitSound("summe/officer_boost/drill.mp3", 140, 100, 1, CHAN_AUTO)

        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos())
        util.Effect("ManhackSparks", effectdata)
    end
end

function ENT:PhysicsCollide( data, phys )
    if 20 < data.Speed and 0.25 < data.DeltaTime then

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableMotion(false)
        end

        self:SetLanded(true)
        self:EmitSound("phx/explode05.wav", 140, 100, 1, CHAN_AUTO)
    end
end

function ENT:PhysicsUpdate( phys )
    phys:ApplyForceCenter( Vector( 0, 0, -100000000 ) )
end