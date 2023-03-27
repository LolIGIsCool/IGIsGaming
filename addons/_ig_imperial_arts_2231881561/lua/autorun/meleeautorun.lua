--[[----------------Welcome to MELEE ART 2's code!----------------------------------------------------------
          __
     w  c(..)o   (
      \__(-)    __)   Version (idk i dont even change this)
          /\   (
         /(_)___)
         w /|
          | \
          m  m  do whatever with my code, just give me credit. this is a hobby ting.
		  -------------------------------------------------------------------------------------------------------------------
		  === ^ made by original melee arts 2 dude I [Stryker] Just went in and deleted all the stuffs that wern't needed ===
		  -------------------------------------------------------------------------------------------------------------------
--]]-----------------------------------------------------------------------------------------------------------------

CreateConVar( 		"ma2_startwithfists", "0", FCVAR_ARCHIVE, "Sets if the player starts with fists. Default disabled" )
CreateConVar( 		"ma2_togglethrowing", "0", FCVAR_ARCHIVE, "Sets if the player can throw weapons. Default enabled" )
CreateConVar( 		"ma2_togglechargeui", "1", FCVAR_ARCHIVE, "Sets if the player sees the Charge damage numbers. Default enabled" )
CreateConVar( 		"ma2_togglecrosshair", "0", FCVAR_ARCHIVE, "Sets if the player sees the crosshair. Default disabled" )
CreateConVar( 		"ma2_damagemultiplier", "1", FCVAR_ARCHIVE, "Sets the damage multiplier for all melee weapons. Default is 1" )

CreateConVar( 		"ma2_combatantmaxtier", "4", FCVAR_ARCHIVE, "Sets the maximum tier a combatant can be. Default is 4" )

function MA2Settings( Panel )
	Panel:Help( "Welcome to Melee Arts 2 Options!" )

	Panel:Help( " " )
	Panel:ControlHelp( "Weapons" )
    Panel:CheckBox( "Start with fists", "ma2_startwithfists")
	Panel:CheckBox( "Toggle Weapon Throwing", "ma2_togglethrowing")
	Panel:CheckBox( "Toggle Crosshair", "ma2_togglecrosshair")
	Panel:CheckBox( "Toggle Charge UI", "ma2_togglechargeui")
	Panel:Help( "NOTE: It is reccomended to keep this enabled, unless you're doing something cinematic" )
	Panel:NumSlider( "Damage Multiplier", "ma2_damagemultiplier", 0.5, 5,1)

	Panel:Help( " " )
	Panel:ControlHelp( "Combatants" )
	Panel:NumSlider( "Maximum Tier", "ma2_combatantmaxtier", 1, 4,0)
end

function MeleeArt2Menu()
	spawnmenu.AddToolMenuOption( "Options",
	"Melee Arts 2",
	"meleearts2menu",
	"Settings",
	"custom_doitplease",
	"", -- Resource File( Probably shouldn't use )
	MA2Settings )
end

hook.Add( "PopulateToolMenu", "MeleeArts2MenuYe", MeleeArt2Menu )

function Exposed( target, dmginfo )
	if (  target:GetNWBool("MAExpose") == true and target:GetNWInt( 'exposelevel' )!=0 ) then
		target:EmitSound("npc/zombie/claw_strike3.wav")
		if target:GetNWInt( 'exposelevel' )==1 then
			dmginfo:ScaleDamage(1.25)
			target:SetNWBool("MAExpose",false)
			target:SetNWInt( 'exposelevel', 0 )
		elseif target:GetNWInt( 'exposelevel' )==2 then
			dmginfo:ScaleDamage(1.3)
			target:SetNWBool("MAExpose",false)
			target:SetNWInt( 'exposelevel', 0 )
		elseif target:GetNWInt( 'exposelevel' )==3 then
			dmginfo:ScaleDamage(1.4)
			target:SetNWBool("MAExpose",false)
			target:SetNWInt( 'exposelevel', 0 )
		elseif target:GetNWInt( 'exposelevel' )==4 then
			dmginfo:ScaleDamage(1.45)
			target:SetNWBool("MAExpose",false)
			target:SetNWInt( 'exposelevel', 0 )
		elseif target:GetNWInt( 'exposelevel' )==5 then
			dmginfo:ScaleDamage(1.55)
			target:SetNWBool("MAExpose",false)
			target:SetNWInt( 'exposelevel', 0 )
		elseif target:GetNWInt( 'exposelevel' )==6 then
			dmginfo:ScaleDamage(2)
			target:SetNWBool("MAExpose",false)
			target:SetNWInt( 'exposelevel', 0 )
		end
	end
end
hook.Add("EntityTakeDamage", "ExposeMA",  Exposed )

function Guarding( target, dmginfo )
	if (  target:IsPlayer() and target:GetNWBool("MAGuardening") == true and target:Alive()  ) then
		if ( dmginfo:IsDamageType(4) or dmginfo:IsDamageType(128) ) then
			local wep = target:GetActiveWeapon()
			--target:SetNWInt( 'MeleeArts2Stamina', math.floor(target:GetNWInt( 'MeleeArts2Stamina' )-wep.BlockStamina) )
			local w = math.random(1)
			w = math.random(1,2)
			if w == 1 then
				target:EmitSound(wep.Impact1Sound)
			elseif w == 2 then
				target:EmitSound(wep.Impact2Sound)
			end
			dmginfo:ScaleDamage(0.1)
		elseif (dmginfo:IsDamageType(1)) then
			local wep = dmginfo:GetAttacker():GetActiveWeapon()
			target:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
			target:EmitSound("pierce.mp3")
			if wep.Strength==1 then
				dmginfo:ScaleDamage(0.15)
			elseif wep.Strength==2 then
				dmginfo:ScaleDamage(0.2)
			elseif wep.Strength==3 then
				dmginfo:ScaleDamage(0.25)
			elseif wep.Strength==4 then
				dmginfo:ScaleDamage(0.3)
			elseif wep.Strength==5 then
				dmginfo:ScaleDamage(0.45)
			elseif wep.Strength==6 then
				dmginfo:ScaleDamage(0.5)
			end
		end
	end
end
hook.Add("EntityTakeDamage", "GuardeningMA",  Guarding )

function MADMGMultiplier( target, dmginfo )
	if IsValid(dmginfo:GetAttacker()) then
		if dmginfo:GetAttacker():IsPlayer() then
			local attacker = dmginfo:GetAttacker()
			local wep = attacker:GetActiveWeapon()
			if IsValid(wep) then
				wepCheck = string.find( wep:GetClass(), "meleearts" )
				if wepCheck then
					dmginfo:ScaleDamage(GetConVarNumber("ma2_damagemultiplier"))
				end
			end
		end
	end
end
hook.Add("EntityTakeDamage", "MultiplierMA",  MADMGMultiplier )

function Parry( target, dmginfo )
	if (  target:IsPlayer() and target:GetNWBool("MAParryFrame") == true and target:Alive()  ) then
		if ( dmginfo:IsDamageType(4) or dmginfo:IsDamageType(128) or dmginfo:IsDamageType(1) ) then
			local wep = target:GetActiveWeapon()
			--target:SetNWInt( 'MeleeArts2Stamina', math.floor(target:GetNWInt( 'MeleeArts2Stamina' )-wep.BlockStamina) )
			target:EmitSound("physics/metal/metal_grate_impact_hard3.wav")
			wep.Charge=wep.DmgMax

			dmginfo:ScaleDamage(0)
		end
	end
end
hook.Add("EntityTakeDamage", "ParryingMA",  Parry )

function Shoving( target, dmginfo )
	if (  target:IsPlayer() and target:GetNWBool("MeleeArtShoving") == true and target:Alive()  ) then
		if ( dmginfo:IsDamageType(4) or dmginfo:IsDamageType(128) or dmginfo:IsDamageType(1) ) then
			local wep = target:GetActiveWeapon()
			dmginfo:ScaleDamage(1.5)
		end
	end
end
hook.Add("EntityTakeDamage", "ShovingMA",  Shoving )

function DeathArts( ply )
	ply:SetNWBool("MAExpose",false)
	ply:SetNWInt( 'exposelevel', 0 )
	timer.Stop("bleedTime"..ply:GetNWInt("bleedTime"))
end
hook.Add("PlayerDeath", "DeathArtsMA",  DeathArts )

function Stunned( target, dmginfo )
	if (  target:IsPlayer() and target:GetNWBool("MeleeArtStunned") == true and target:Alive()  ) then
		if not dmginfo:IsDamageType(65536) then
			local wep = target:GetActiveWeapon()
			wep.NextStun = 0
		end
	end
end
hook.Add("EntityTakeDamage", "StunnedMA",  Stunned )

function GiveFists(ply)
	if ply:IsPlayer() and GetConVarNumber( "ma2_startwithfists" ) == 1 then
		ply:Give("meleearts_bludgeon_fists")
	end
end
hook.Add("PlayerSpawn", "GiveFistsMA", GiveFists)

function MASetSpawnInt(ply)
	ply:SetNWInt( 'exposelevel', 0 )
	ply:SetNWBool("ImperialArtsCanSwitch", true);
end
hook.Add("PlayerSpawn", "SetSpawnIntMA", MASetSpawnInt)

hook.Add("PlayerSwitchWeapon", "ImperialArtsCanSwitch",function(ply, old, new)
	if not ply:GetNWBool("ImperialArtsCanSwitch", true) then
		return true
	end
end)


print("Imperial Arts is workin maybe idk!?")
