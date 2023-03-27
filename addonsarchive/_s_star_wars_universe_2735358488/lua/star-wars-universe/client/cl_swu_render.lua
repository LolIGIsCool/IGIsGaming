function SWU:SetupRenderers()
    self:SetupSkyboxRotation()
end

function SWU:SetupSkyboxRotation()
    hook.Add("PreDrawSkyBox", "SWU_RotateSkybox", function ()
        if (IsValid(SWU.Controller)) then
            local matrix = Matrix()
            matrix:Rotate(Angle(0, SWU.Controller:GetInternalShipAngles().y, 0))

            cam.PushModelMatrix(matrix)
        end
    end)

    hook.Add("PostDrawSkyBox", "SWU_ResetSkyboxRotation", function ()
        if (IsValid(SWU.Controller)) then
            cam.PopModelMatrix()
        end
    end)
end