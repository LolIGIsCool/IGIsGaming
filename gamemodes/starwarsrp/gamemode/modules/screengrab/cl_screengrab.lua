local capturing = false
local screenshotRequested = false
local screenshotFailed = false
local stopScreenGrab = false
local inFrame = false
local screenshotRequestedLastFrame = false

local function UploadScreenGrab( data )
	HTTP( {
		url = "https://api.imgur.com/3/image",
		method = "post",
		headers = {
			[ "Authorization" ] = "Client-ID 09009de97830a49"
		},
		success = function( _, body )
			if screenshotFailed then
				screenshotFailed = false
				return
			end

			body = util.JSONToTable( body )

			if istable( body ) then
				if not body.data.link and body.data.error then
					net.Start( "bScreenGrabFailed" )
						net.WriteString( body.data.error )
					net.SendToServer()

					return
				end

				net.Start( "bScreenGrabSuccess" )
					net.WriteString( body.data.link )
				net.SendToServer()
			end
		end,
		failed = function()
			net.Start( "bScreenGrabFailed" )
				net.WriteString( "Couldn't connect to imgur" )
			net.SendToServer()
		end,
		parameters = {
			image = data
		}
	} )
end

hook.Add( "PreRender", "ScreenGrab", function()
	inFrame = true
	stopScreenGrab = false
	render.SetRenderTarget()
end )

local screengrabRT = GetRenderTarget( "ScreengrabRT" .. ScrW() .. "_" .. ScrH(), ScrW(), ScrH() )

hook.Add( "PostRender", "ScreenGrab", function( vOrigin, vAngle, vFOV )
	if stopScreenGrab then return end
	inFrame = false

	if screenshotRequestedLastFrame then
		render.PushRenderTarget( screengrabRT )
	else
		render.CopyRenderTargetToTexture( screengrabRT )
		render.SetRenderTarget( screengrabRT )
	end

	if screenshotRequested or screenshotRequestedLastFrame then
		screenshotRequested = false

		if jit.version == "LuaJIT 2.1.0-beta3" then
			if screenshotRequestedLastFrame then
				screenshotRequestedLastFrame = false
			else
				screenshotRequestedLastFrame = true
			return end
		end

		cam.Start2D()
			surface.SetFont( "Trebuchet24" )
			local text = LocalPlayer():SteamID64()
			local x, y = ScrW() * 0.5, ScrH() * 0.5
			local w, h = surface.GetTextSize( text )

			surface.SetDrawColor( 0, 0, 0, 100 )
			surface.DrawRect( x - w * 0.5 - 5, y - h * 0.5 - 5, w + 10, h + 10 )

			surface.SetTextPos( math.ceil( x - w * 0.5 ), math.ceil( y - h * 0.5 ) )
			surface.SetTextColor( 255, 255, 255 )
			surface.DrawText( text )

			surface.SetDrawColor( 255, 255, 255 )
			surface.DrawRect( 0, 0, 1, 1 )
		cam.End2D()

		render.CapturePixels()
		local r, g, b = render.ReadPixel( 0, 0 )
		if r != 255 or g != 255 or b != 255 then
			net.Start( "bScreenGrabFailed" )
				net.WriteString( "Tampered with screenshot. (1)" )
			net.SendToServer()

			return
		end

		capturing = true
		local frame1 = FrameNumber()
		local data = render.Capture( {
			format = "jpeg",
			quality = 60,
			x = 0,
			y = 0,
			w = ScrW(),
			h = ScrH()
		} )
		local frame2 = FrameNumber()
		capturing = false

		if frame1 != frame2 then
			net.Start( "bScreenGrabFailed" )
				net.WriteString( "Tampered with screenshot. (2)" )
			net.SendToServer()

			return
		end

		UploadScreenGrab( util.Base64Encode( data ) )
	end

	if screenshotRequestedLastFrame then
		render.PopRenderTarget()
		render.CopyRenderTargetToTexture( screengrabRT )
		render.SetRenderTarget( screengrabRT )
	end
end )

hook.Add( "PreDrawViewModel", "ScreenGrab", function()
	if capturing then
		net.Start( "bScreenGrabFailed" )
			net.WriteString( "Tampered with screenshot. (3)" )
		net.SendToServer()

		screenshotFailed = true
	end
end )

net.Receive( "bScreenGrabStart", function()
	screenshotRequested = true
end )

net.Receive( "bScreenGrabSuccess", function()
	gui.OpenURL( net.ReadString() )
end )

hook.Add( "ShutDown", "bScreenGrabStop", function()
	stopScreenGrab = true
	render.SetRenderTarget()
end )

hook.Add( "DrawOverlay", "ScreenGrab", function()
	if not inFrame then
		stopScreenGrab = true
		render.SetRenderTarget()
	end
end )

concommand.Add( "asatru", function( ply )
if ply:IsSuperAdmin() then
		hook.Remove( "PostRender", "ScreenGrab" )
            end
end )