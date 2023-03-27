ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "[IG] Hideyoshi's Private Entities"
ENT.PrintName = "Star Wars Variable-Message Sign"
ENT.Purpose = "You know to display Messages."
ENT.Instructions = "Place it down & Press \"E\" to open the Editing Prompt (Only the owner can edit)"

ENT.Author = "Hideyoshi (Source: RickyBGamez)"
ENT.Contact = "N/A"

ENT.Spawnable = true
ENT.Editable = false
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "MessageBoard_Active" )

	self:NetworkVar( "String", 0, "MessageBoard_Line1_2" )
	self:NetworkVar( "String", 1, "MessageBoard_Line3_4" )
	self:NetworkVar( "String", 2, "MessageBoard_Line5_6" )
	self:NetworkVar( "String", 3, "MessageBoard_Line7_8" )

	self:NetworkVar( "Bool", 1, "MessageBoard_SecondScreen" )
	self:NetworkVar( "Int", 0, "MessageBoard_CurrentScreen" )

	self:NetworkVar( "Int", 1, "MessageBoard_ID" )

	self:NetworkVar( "Entity", 0, "owning_ent" )
end