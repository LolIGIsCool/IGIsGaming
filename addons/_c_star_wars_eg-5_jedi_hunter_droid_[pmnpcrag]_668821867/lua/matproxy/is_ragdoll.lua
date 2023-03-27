
--===========================================================
--Simple check to ask if the material is attached to a ragdoll (Basically a check for deadness.)
--
--===========================================================


matproxy.Add( {
	name = "IsRagdoll",

	init = function( self, mat, values )
		-- Store the name of the variable we want to set
		self.ResultTo = values.resultvar
	end,

	bind = function( self, mat, ent )
		if not IsValid( ent ) then return end
		
		if  ent:IsRagdoll() then
			mat:SetInt( self.ResultTo, 1 )	
		else
			mat:SetInt( self.ResultTo, 0 )	
		end

	end
} )
