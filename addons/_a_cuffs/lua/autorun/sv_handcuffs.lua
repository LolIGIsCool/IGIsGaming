-----------------------------------------------------
-------------------------------------

---------------- Cuffs --------------

-------------------------------------

-- Copyright (c) 2015 Nathan Healy --

-------- All rights reserved --------

-------------------------------------

-- sv_handcuffs.lua         SERVER --

--                                 --

-- Server-side handcuff stuff.     --

-------------------------------------



if CLIENT then return end



util.AddNetworkString( "Cuffs_GagPlayer" )

util.AddNetworkString( "Cuffs_BlindPlayer" )

util.AddNetworkString( "Cuffs_FreePlayer" )

util.AddNetworkString( "Cuffs_DragPlayer" )



util.AddNetworkString( "Cuffs_TiePlayers" )

util.AddNetworkString( "Cuffs_UntiePlayers" )



local function GetTrace( ply )

	local tr = util.TraceLine( {start=ply:EyePos(), endpos=ply:EyePos()+(ply:GetAimVector()*100), filter=ply} )

	if IsValid(tr.Entity) and tr.Entity:IsPlayer() then

		local cuffed,wep = tr.Entity:IsHandcuffed()

		if cuffed then return tr,wep end

	end

end





// Standard hooks //

CreateConVar( "cuffs_restrictsuicide", 1, {FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE} )

hook.Add( "CanPlayerSuicide", "Cuffs RestrictSuicide", function( ply )

	if ply:IsHandcuffed() and cvars.Bool("cuffs_restrictsuicide") then return false end

end)

CreateConVar( "cuffs_restrictteams", 1, {FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE} )

hook.Add( "PlayerCanJoinTeam", "Cuffs RestrictTeam", function( ply )

	if ply:IsHandcuffed() and cvars.Bool("cuffs_restrictteams") then return false end

end)

hook.Add( "PlayerCanSeePlayersChat", "Cuffs ChatGag", function( _,_,_, ply )

	if not IsValid(ply) then return end

	

	local cuffed,wep = ply:IsHandcuffed()

	if cuffed and wep:GetIsGagged() then return false end

end)


// DarkRP //

CreateConVar( "cuffs_restrictwarrant", 1, {FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE,FCVAR_REPLICATED} )

hook.Add( "canRequestWarrant", "Cuffs PreventWarrant", function( crim, cop, reason ) if cvars.Bool("cuffs_restrictwarrant") and cop:IsHandcuffed() then return false,"You can issue warrants when cuffed!" end end)

hook.Add( "canWanted", "Cuffs PreventWarrant", function( crim, cop, reason ) if cvars.Bool("cuffs_restrictwarrant") and cop:IsHandcuffed() then return false,"You can issue warrants when cuffed!" end end)



CreateConVar( "cuffs_autoarrest", 0, {FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE} )

CreateConVar( "cuffs_restrictarrest", 1, {FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE} )

hook.Add( "canArrest", "Cuffs RestrictArrest", function( cop, crim ) // DarkRP Arrest hook

	if IsValid(crim) and cvars.Bool("cuffs_restrictarrest") and not crim:IsHandcuffed() then return false,"You must handcuff a suspect to arrest them!" end

end)

hook.Add( "playerCanChangeTeam", "Cuffs RestrictTeam", function( ply, tm, force )

	if ply:IsHandcuffed() and cvars.Bool("cuffs_restrictteams") and not force then return false,"You can't change jobs when cuffed!" end

end)

hook.Add( "CanChangeRPName", "Cuffs RestrictName", function( ply )

	if ply:IsHandcuffed() then return false,"You can't change your name when cuffed!" end

end)





// Think //

local NextTieHookCleanup

// Cuffed player interaction //

net.Receive( "Cuffs_FreePlayer", function(_,ply)

	if (not IsValid(ply)) or ply:IsHandcuffed() then return end

	

	local target = net.ReadEntity()

	if (not IsValid(target)) or target==ply then return end

	

	local cuffed, cuffs = target:IsHandcuffed()

	if not (cuffed and IsValid(cuffs)) then return end

	if IsValid(cuffs:GetFriendBreaking()) then return end

	

	local tr = GetTrace(ply)

	if not (tr and tr.Entity==target) then return end
	if not ply:Alive() or not target:Alive() then return end

	

	cuffs:SetFriendBreaking( ply )

end)

net.Receive( "Cuffs_DragPlayer", function(_,ply)

	if (not IsValid(ply)) or ply:IsHandcuffed() then return end

	

	local target = net.ReadEntity()

	if (not IsValid(target)) or target==ply then return end
	if not ply:Alive() or not target:Alive() then return end
	

	local cuffed, cuffs = target:IsHandcuffed()

	if not (cuffed and IsValid(cuffs) and cuffs:GetRopeLength()>0) then return end

	

	local tr = GetTrace(ply)

	if not (tr and tr.Entity==target) then return end

	

	local shouldDrag = net.ReadBit()==1

	if shouldDrag then

		if not (IsValid(cuffs:GetKidnapper())) then

			cuffs:SetKidnapper( ply )

			hook.Call( "OnHandcuffStartDragging", GAMEMODE, ply, target, cuffs )

		end

	else

		if ply==cuffs:GetKidnapper() then

			cuffs:SetKidnapper( nil )

			hook.Call( "OnHandcuffStopDragging", GAMEMODE, ply, target, cuffs )

		end

	end

end)



local HookModel = Model("models/props_c17/TrapPropeller_Lever.mdl")

net.Receive( "Cuffs_TiePlayers", function(_,ply)

	if (not IsValid(ply)) or ply:IsHandcuffed() then return end

	

	local DraggedCuffs = {}

	for _,c in pairs(ents.FindByClass("weapon_handcuffed")) do

		if c:GetRopeLength()>0 and c:GetKidnapper()==ply then

			table.insert( DraggedCuffs, c )

		end

	end

	if #DraggedCuffs<=0 then return end

	

	local tr = util.TraceLine( {start=ply:EyePos(), endpos=ply:EyePos()+(ply:GetAimVector()*100), filter=ply} )

	if not tr.Hit then return end

	

	if IsValid(tr.Entity) then // Pass to another player

		if tr.Entity:IsPlayer() then

			for i=1,#DraggedCuffs do

				if DraggedCuffs[i].Owner==tr.Entity then

					DraggedCuffs[i]:SetKidnapper(nil)

					hook.Call( "OnHandcuffStopDragging", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i] )

				else

					DraggedCuffs[i]:SetKidnapper(tr.Entity)

					hook.Call( "OnHandcuffStopDragging", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i] )

					hook.Call( "OnHandcuffStartDragging", GAMEMODE, tr.Entity, DraggedCuffs[i].Owner, DraggedCuffs[i] )

				end

			end

			return

		elseif tr.Entity.IsHandcuffHook and tr.Entity.TiedHandcuffs then

			for i=1,#DraggedCuffs do

				DraggedCuffs[i]:SetKidnapper(tr.Entity)

				table.insert( tr.Entity.TiedHandcuffs, DraggedCuffs[i] )

				hook.Call( "OnHandcuffStopDragging", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i] )

				hook.Call( "OnHandcuffTied", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i], tr.Entity )

			end

			return

		end

	end

	

	local hk = ents.Create("prop_physics")

	hk:SetPos( tr.HitPos + tr.HitNormal )

	local ang = tr.HitNormal:Angle()

	ang:RotateAroundAxis( ang:Up(), -90 )

	hk:SetAngles( ang )

	hk:SetModel( HookModel )

	hk:Spawn()

	

	-- hk:SetMoveType( MOVETYPE_NONE )

	if IsValid(tr.Entity) then

		hk:SetParent( tr.Entity )

		hk:SetMoveType( MOVETYPE_VPHYSICS )

	else

		hk:SetMoveType( MOVETYPE_NONE )

	end

	hk:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	

	hk:SetNWBool("Cuffs_TieHook", true)

	hk.IsHandcuffHook = true

	hk.TiedHandcuffs = {}

	

	for i=1,#DraggedCuffs do

		DraggedCuffs[i]:SetKidnapper( hk )

		table.insert( hk.TiedHandcuffs, DraggedCuffs[i] )

		hook.Call( "OnHandcuffStopDragging", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i] )

		hook.Call( "OnHandcuffTied", GAMEMODE, ply, DraggedCuffs[i].Owner, DraggedCuffs[i], hk )

	end

end)



local function DoUntie( ply, ent )

	for i=1,#ent.TiedHandcuffs do

		if not IsValid(ent.TiedHandcuffs[i]) then continue end

		

		ent.TiedHandcuffs[i]:SetKidnapper( ply )

		hook.Call( "OnHandcuffUnTied", GAMEMODE, ply, ent.TiedHandcuffs[i].Owner, ent.TiedHandcuffs[i], ent )

		hook.Call( "OnHandcuffStartDragging", GAMEMODE, ply, ent.TiedHandcuffs[i].Owner, ent.TiedHandcuffs[i] )

	end

	

	ent:Remove()

end

net.Receive( "Cuffs_UntiePlayers", function(_,ply)

	if (not IsValid(ply)) or ply:IsHandcuffed() then return end

	

	local tr = util.TraceLine( {start=ply:EyePos(), endpos=ply:EyePos()+(ply:GetAimVector()*100), filter=ply} )

	if IsValid(tr.Entity) and tr.Entity.IsHandcuffHook and tr.Entity.TiedHandcuffs then

		DoUntie( ply, tr.Entity )

	end

end)

hook.Add( "AllowPlayerPickup", "Cuffs UntieHook", function(ply,ent)

	if IsValid(ent) and ent.IsHandcuffHook and ent.TiedHandcuffs then

		if (not IsValid(ply)) or ply:IsHandcuffed() then return end

		

		DoUntie( ply, ent )

		return false

	end

end)

// SAdmin Uncuff //
local UncuffCommands = {
	["!uncuff"] = true, ["/uncuff"] = true,
}
hook.Add( "PlayerSay", "Cuffs AdminUncuff", function( ply, str )
	if not (IsValid(ply) and ply:IsSuperAdmin()) then return end
	
	if UncuffCommands[ str:lower():Trim() ] then
		local isCuffed, cuffs = ply:IsHandcuffed()
		if not IsValid(cuffs) then return end
		
		cuffs:Uncuff()
	end
end)

// Anti-Physgun //
--[[
hook.Add( "PhysgunPickup", "Cuffs AntiPhysgunTies", function( ply, ent )

	if not IsValid(ent) then return end

	

	local ties = {}

	for _,ent in pairs(ents.GetAll()) do

		if IsValid(ent) and ent.IsHandcuffHook then

			table.insert( ties, ent )

		end

	end

	if #ties==0 then return end

	

	local const = constraint.GetAllConstrainedEntities( ent )

	

	for _,v in pairs( ties ) do

		if const[ v:GetParent() ] then

			local eff = EffectData()

			eff:SetOrigin( v:GetPos() )

			eff:SetStart( v:GetPos() )

			eff:SetScale( 1 )

			eff:SetRadius( 1 )

			eff:SetMagnitude( 1 )

			eff:SetNormal( v:GetRight() )

			

			util.Effect( "Sparks", eff, true, true )

			

			v:Remove()

		end

	end

end)]]