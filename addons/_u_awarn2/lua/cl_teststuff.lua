hook.Add("PreDrawTranslucentRenderables", "GrassScanLine", function()

	render.DrawLine( Vector( 0, 0, 9000 ), Vector( 0, 0, 9000 * -1 ), Color(255, 0, 0, 255), true)

end )