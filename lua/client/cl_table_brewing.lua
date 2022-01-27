local brew_gui = {

    ingredientSlots = {},
    brewArrow = {},
    ingredientCount = 0,

}


local FontType = Brew_Config.GUI_Font or "DermaLarge"
local FontColour = Brew_Config.GUI_Font_mainColour or Color(255, 255, 255, 255)
local FontColourShadow = Brew_Config.GUI_Font_shadowColour or Color(119, 135, 137, 255)
local FramePrimaryColour = Brew_Config.GUI_Frame_Foreground or Color(120,120,120, 0)
local FrameBorderColour = Brew_Config.GUI_Frame_Background or Color(0,0,0, 0)
local ProgressEmptyColour = Brew_Config.GUI_ProgressBar_Background or Color(60,60,60, 180)
local ProgressBorderColour = Brew_Config.GUI_ProgressBar_Border or Color(0,0,0, 180)
local ProgressBarColour = Brew_Config.GUI_ProgressBar_BarColor or Color(255,255,255, 180)
local FrameCurve = Brew_Config.FrameCurve or 10

function DrawBrewing(ent)
    
    brewFrame = vgui.Create("DFrame")
    brewFrame:SetPos(ScrW() * 660/1920, ScrH() * 300/1080)
    brewFrame:SetSize( ScrW() * 600/1920, ScrH() * 600/1080 )
    brewFrame:SetVisible(true)
    brewFrame:SetTitle("")
    brewFrame:ShowCloseButton(false)
    brewFrame:MakePopup()
    brewFrame:SetKeyboardInputEnabled(false)
    brewFrame.Paint = function(s, w, h)
        draw.RoundedBox(FrameCurve, 0, 0, w, h, FrameBorderColour)
        draw.RoundedBox(FrameCurve, 2, 2, w-4, h-4, FramePrimaryColour)
    end

    local max = Brew_Config.Max_Ingredients or 3
    
    for i = 1, max do
        brew_gui.ingredientSlots[i] = CreateIngredientSlot(i, max)

    end

    local brewArrow = vgui.Create("DSprite")
    brewArrow:SetMaterial(Material("gui/arrow"))
    brewArrow:SetSize(128, 128)
    brewArrow:SetParent(brewFrame)
    brewArrow:SetPos(300, 300)
    brewArrow:SetRotation(180)
    brewArrow:SetColor(Color(70, 70, 70, 255))

    brew_gui.brewArrow = brewArrow
    

    local brewTitle = vgui.Create("DLabel")
    brewTitle:SetFont(FontType)
    brewTitle:SetText("Potion Brewing Station")
    brewTitle:SetSize( 300, 40 )
    brewTitle:SetPos(190 - string.len(brewTitle:GetText()), 5)
    brewTitle:SetParent(brewFrame)
    brewTitle:SetTextColor(FontColour)
    brewTitle.Paint = function(s, w, h)
        
        struc = {}
        struc["pos"] = {0, 0}
        struc["color"] = FontColourShadow
        struc["text"] = brewTitle:GetText()
        struc["font"] = FontType
        struc["xalign"] = TEXT_ALIGN_LEFT
        struc["yalign"] = TEXT_ALIGN_TOP
        

        draw.TextShadow(struc, 1, 200)

    end

    local startBrew = vgui.Create("DButton")
    startBrew:SetPos(100 , 500)
    startBrew:SetSize(400, 50)
    startBrew:SetText("Start Brewing")
    startBrew:SetParent(brewFrame)
    startBrew:SetTextColor(Color(255, 255, 255, 255))

    startBrew.DoClick = function() StartBrewing() end

    startBrew.Paint = function(s, w, h)
        draw.RoundedBox(FrameCurve, 0, 0, w, h, FrameBorderColour)
        draw.RoundedBox(FrameCurve, 2, 2, w-4, h-4, ProgressEmptyColour)
    end

    local closeButton = vgui.Create( "DButton", brewFrame )
    closeButton:SetPos( 536, 0 )
    closeButton:SetText( "X" )
    closeButton:SetFont("HudSelectionText")
    closeButton:SetTextColor( Color(255, 255, 255, 255) )
    closeButton.Paint = function(s, w, h)

		draw.RoundedBox(FrameCurve-4,0,0,w,h,FrameBorderColour)
		draw.RoundedBox(FrameCurve-4,2,2,w-4,h-4,ProgressEmptyColour)

	end
	closeButton.DoClick = function()
		brewFrame:Close()
	end

    local outputBoxFrame = vgui.Create("DFrame", brewFrame)
    outputBoxFrame:SetPos(238, 363)
    outputBoxFrame:SetSize(125, 125)
    outputBoxFrame:SetDraggable(false)
    outputBoxFrame:ShowCloseButton(false)
    outputBoxFrame:SetTitle("")
    outputBoxFrame.Paint = function(s, w, h)
        draw.RoundedBox(FrameCurve, 0, 0, w, h, FrameBorderColour)
        draw.RoundedBox(FrameCurve, 2, 2, w-4, h-4, ProgressEmptyColour)
    end

    local outputBoxImage = vgui.Create("DImage", brewFrame)
    outputBoxImage:SetPos(238, 363)
    outputBoxImage:SetSize(125, 125)
    outputBoxImage:SetImage("decals/light")

end


function GetNextPos(spacing, current, max)

    local offset = spacing / 2

    if max == 3 then
        offset = 0
    else
        offset = offset * (max - 3)
    end

    return (spacing * current - offset)
end

function GrabIngredient(button)

    brew_gui.ingredientCount = brew_gui.ingredientCount + 1

    local ingredModel = vgui.Create("DModelPanel")
    ingredModel:SetPos(0, 0)
    ingredModel:SetSize(100, 100)
    ingredModel:SetModel("models/Gibs/HGIBS.mdl")
    ingredModel:SetParent(button)

    local mn, mx = ingredModel.Entity:GetRenderBounds()
    local size = 0
    size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
    size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
    size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )

    ingredModel:SetFOV( 45 )
    ingredModel:SetCamPos( Vector( size, size, size ) )
    ingredModel:SetLookAt( (mn + mx) * 0.5 )

    ingredModel.OnMousePressed = function(mcode)

        ingredModel:Remove()
        
        brew_gui.ingredientCount = brew_gui.ingredientCount - 1

    end

    




end

function CreateIngredientSlot(current, max)

    local ingredSlot = vgui.Create("DImageButton", brewFrame)
    ingredSlot:SetPos(GetNextPos(125, current, max ) , 125)
    ingredSlot:SetSize(100, 100)
    ingredSlot:SetText("")
    ingredSlot:SetImage("decals/light")

    ingredSlot.DoClick = function ()
        GrabIngredient(ingredSlot)
    end

    ingredSlot.Paint = function(s, w, h)
        draw.RoundedBox(FrameCurve, 0, 0, w, h, FrameBorderColour)
        draw.RoundedBox(FrameCurve, 2, 2, w-4, h-4, ProgressEmptyColour)
    end

    return ingredSlot

end

function StartBrewing()

    if brew_gui.ingredientCount > 0 then
        
        local potion = vgui.Create("DModelPanel")
        potion:SetPos(225, 350)
        potion:SetSize(150, 150)
        potion:SetModel("models/props_junk/garbage_plasticbottle001a.mdl")
        potion:SetParent(brewFrame)

        local mn, mx = potion.Entity:GetRenderBounds()
        local size = 0
        size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
        size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
        size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )

        potion:SetFOV( 45 )
        potion:SetCamPos( Vector( size, size, size ) )
        potion:SetLookAt( (mn + mx) * 0.5 )

        potion.OnMousePressed = function(mcode)

            potion:Remove()
            
            brew_gui.ingredientCount = brew_gui.ingredientCount - 1

        end

        brew_gui.brewArrow:SetColor(Color(255, 255, 255, 255))

        ClearIngredients()
    end

end

function ClearIngredients()

    for k, v in ipairs(brew_gui.ingredientSlots) do

        for h, j in ipairs(v:GetChildren()) do
            if j:GetClassName () == "Label" then
                j:Remove()
            end
        end

    end

    brew_gui.ingredientCount = 0

end