local Material = Material
local net_ReadUInt = net.ReadUInt
local net_ReadEntity = net.ReadEntity
local ipairs = ipairs
local table_remove = table.remove
local table_insert = table.insert
local net_Receive = net.Receive
local hook_Add = hook.Add
local render_SetStencilWriteMask = CLIENT and render.SetStencilWriteMask
local render_SetStencilTestMask = CLIENT and render.SetStencilTestMask
local render_SetStencilReferenceValue = CLIENT and render.SetStencilReferenceValue
local render_SetStencilCompareFunction = CLIENT and render.SetStencilCompareFunction
local render_SetStencilPassOperation = CLIENT and render.SetStencilPassOperation
local render_SetStencilFailOperation = CLIENT and render.SetStencilFailOperation
local render_SetStencilZFailOperation = CLIENT and render.SetStencilZFailOperation
local render_ClearStencil = CLIENT and render.ClearStencil
local render_OverrideDepthEnable = CLIENT and render.OverrideDepthEnable
local render_SetStencilEnable = CLIENT and render.SetStencilEnable
local render_SuppressEngineLighting = CLIENT and render.SuppressEngineLighting
local DrawColorModify = DrawColorModify
local render_OverrideBlend = CLIENT and render.OverrideBlend
local render_SetColorMaterialIgnoreZ = CLIENT and render.SetColorMaterialIgnoreZ
local render_SetMaterial = CLIENT and render.SetMaterial
local render_DrawScreenQuad = CLIENT and render.DrawScreenQuad

local Clr_holo_Ents = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0.3,
    ["$pp_colour_addb"] = 1,
    ["$pp_colour_brightness"] = 0,
    ["$pp_colour_contrast"] = 1,
    ["$pp_colour_colour"] = 1,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0
}

local holomat = Material("ace/sw/hologram")
local holoEnts = {}

-- It's not the best way but I actually don't care
local function handleNetMessage()
    for i = 1, net_ReadUInt(32) do
        local ent = net_ReadEntity()
        local isExist = false

        for k, v in ipairs(holoEnts) do
            if v == ent then
                isExist = true
                table_remove(holoEnts, k)
            end
        end

        if not isExist then
            table_insert(holoEnts, ent)
        end
    end
end

net_Receive("Eclipse.ShittyHologram.DoThing", handleNetMessage)

hook_Add("PreDrawEffects", "HologramDraw", function(isDrawingDepth, isDrawingSkybox)
    if #holoEnts == 0 then return end
    --if isDrawingDepth then return true end
    -- Reset everything to known good
    render_SetStencilWriteMask(0xFF)
    render_SetStencilTestMask(0xFF)
    render_SetStencilReferenceValue(0)
    render_SetStencilCompareFunction(STENCIL_ALWAYS)
    render_SetStencilPassOperation(STENCIL_KEEP)
    render_SetStencilFailOperation(STENCIL_KEEP)
    render_SetStencilZFailOperation(STENCIL_KEEP)
    render_ClearStencil()
    --this whole bit draws models to the first stencil buffer, i think
    render_OverrideDepthEnable(false, true)
    render_SetStencilEnable(true)
    render_SetStencilFailOperation(STENCILOPERATION_KEEP)
    render_SetStencilZFailOperation(STENCILOPERATION_KEEP)
    render_SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render_SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
    render_SetStencilReferenceValue(1)

    --this is probably a really shit way to do this, but it's fine for now
    for _, ent in ipairs(holoEnts) do
        if not ent:IsValid() then
            table_remove(holoEnts, _)
            continue
        end

        if not ent:IsEffectActive(EF_NODRAW) then
            render_SuppressEngineLighting(true)
            ent:DrawModel() --draw model to stencil buffer
            render_SuppressEngineLighting(false)
        end
    end

    render_SuppressEngineLighting(true)
    --Setup stencil for drawing only shit that matches stencil reference value 1 or something
    render_SetStencilReferenceValue(2)
    render_SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render_SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render_SetStencilReferenceValue(1)
    DrawColorModify(Clr_holo_Ents)
    --cool shit that makes holograms look good
    render_OverrideBlend(true, BLEND_DST_COLOR, BLEND_SRC_COLOR, BLENDFUNC_ADD, BLEND_ONE, BLEND_ONE, BLENDFUNC_ADD)
    render_SetColorMaterialIgnoreZ()
    render_SetMaterial(holomat)
    render_DrawScreenQuad(true) --draws hologram material to whole screen but only the parts matching the stencil buffer
    --reset everything to how it should be i think
    render_OverrideBlend(false)
    render_SuppressEngineLighting(false)
    render_SetStencilEnable(false)
end)
--render.DepthRange(0.0,1.0)