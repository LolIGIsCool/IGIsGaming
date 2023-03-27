player_manager.AddValidModel( "Interrogation Droid", "models/interrogationdroid/interrogationdroid.mdl" );
list.Set( "PlayerOptionsModel", "Interrogation Droid", "models/interrogationdroid/interrogationdroid.mdl" );

AddCSLuaFile()

-- Add models to this table with their corrosponding sound.
local soundTable = {

  ["doors/door_metal_large_chamber_close1.wav"] = {
    "models/interrogationdroid/interrogationdroid.mdl"
  }
}

-- Change MyCustomFootstep to whatever UNIQUE name you like
hook.Add("PlayerFootstep", "MyCustomFootstep", function(ply)
  local footstep = nil
  for snd, tbl in pairs(soundTable) do
    if table.HasValue(tbl, ply:GetModel()) then
      footstep = snd
    end
  end

  if !footstep then return end -- If we don't have a custom sound, return

  -- ply:EmitSound(footstep) -- Emit the sound 

  return true -- Stop the default sound
end)
