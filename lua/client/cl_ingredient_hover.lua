
local displayed_ent = nil
local displayed_slot = nil

local infoLabels = {}

local FontType = "Brew_UIFont_Small"
local FontColour = Brew_Config.GUI_Font_mainColour or Color(255, 255, 255, 255)
local FontColourShadow = Brew_Config.GUI_Font_shadowColour or Color(119, 135, 137, 255)
local FrameCurve = Brew_Config.FrameCurve or 10

local BrewSlotBackground = Brew_Config.GUI_BrewSlot_Background or Color(60,60,60, 180)
local FramePrimaryColour = Brew_Config.GUI_Brew_Foreground or Color(120,120,120, 0)
local FrameBorderColour = Brew_Config.GUI_Brew_Background or Color(0,0,0, 0)
local HeaderColor = Brew_Config.GUI_Inventory_Header or Color(255, 255, 255, 255)
local BrewSlotImage = Brew_Config.GUI_BrewSlot_Image or "decals/light"


function DrawHoverInfo(ent, slot)

    local invX = storageFrame:GetX() - 160
    local invY = storageFrame:GetY()

    displayed_ent = ent
    displayed_slot = slot

    hoverInfo = vgui.Create("DFrame")
    hoverInfo:SetPos(ScrW() * invX/1920, ScrH() * invY/1080)
    hoverInfo:SetSize( ScrW() * 150/1920, ScrH() * 160/1080 )
    hoverInfo:SetVisible(true)
    hoverInfo:SetTitle("")
    hoverInfo:ShowCloseButton(false)
    hoverInfo.Paint = function(s, w, h)
        draw.RoundedBox(FrameCurve, 0, 0, w, h, FrameBorderColour)
        draw.RoundedBox(FrameCurve, 2, 2, w-4, h-4, FramePrimaryColour)
        
        draw.RoundedBox(FrameCurve, 0, 0, w, 32, Color(0, 0, 0, 255))
        draw.RoundedBox(FrameCurve, 2, 2, w-4, 28, BrewSlotBackground)
    end

    hoverInfo.Onclose = function()

        displayed_ent = nil
        displayed_slot = nil

    end


    local hoverTitle = vgui.Create("DLabel", hoverInfo)
    hoverTitle:SetFont(FontType)
    hoverTitle:SetText("Ingredient Information")
    hoverTitle:SetSize( ScrW() * 300/1920, ScrH() * 40/1080 )
    hoverTitle:SetPos(ScrW() * 11/1920, ScrH() * 0/1080)
    hoverTitle:SetTextColor(FontColour)
    hoverTitle:AlignTop(-5)

    local text = "Transfer Ingredient"

    if !IsValid(brewFrame) then text = "Drop Ingredient" end

    local transferButton = vgui.Create( "DButton", hoverInfo )
    transferButton:SetPos( ScrW() * 10/1920, ScrH() * 130/1080 )
    transferButton:SetSize( ScrW() * 130/1920, ScrH() * 25/1080 )
    transferButton:SetText( text )
    transferButton:SetFont(FontType)
    transferButton:SetTextColor( Color(255, 255, 255, 255) )
    transferButton.Paint = function(s, w, h)

		draw.RoundedBox(FrameCurve-4,0,0,w,h,FrameBorderColour)
		draw.RoundedBox(FrameCurve-4,2,2,w-4,h-4,BrewSlotBackground)

	end
	transferButton.DoClick = function()
        if IsValid(brewFrame) then
            if Inv_TransferEnt(displayed_ent) then
                displayed_slot:Remove()
                hoverInfo:Close()
            end
        else 
            Inv_DropItem(displayed_ent)
            displayed_slot:Remove()
            hoverInfo:Close()
        end
	end

    local height = 30

    for k, v in pairs(ent.Reagents) do

        local reagentLabel = vgui.Create("DLabel", hoverInfo)
        reagentLabel:SetFont(FontType)
        reagentLabel:SetText(CapitalizeFirstLetter(k) .. ": ")
        reagentLabel:SetSize( ScrW() * 300/1920, ScrH() * 40/1080 )
        reagentLabel:SetPos(ScrW() * 0/1920, ScrH() * height/1080)
        reagentLabel:SetTextColor(FontColour)
        reagentLabel:AlignLeft(15)

        local reagentPPM = vgui.Create("DLabel", hoverInfo)
        reagentPPM:SetFont(FontType)
        reagentPPM:SetText(v .. " ppm")
        reagentPPM:SetSize( ScrW() * 300/1920, ScrH() * 40/1080 )
        reagentPPM:SetPos(ScrW() * 100/1920, ScrH() * height/1080)
        reagentPPM:SetTextColor(FontColour)

        infoLabels[k] = reagentPPM

        height = height + 20

    end



end


function UpdateHoverInfo(ent, slot)

    if displayed_ent == ent then hoverInfo:Close() return end

    DebugPrintTable(ent.Reagents)

    for k, v in pairs(ent.Reagents) do

        infoLabels[k]:SetText(v .. " ppm")

    end
    
    displayed_ent = ent
    displayed_slot = slot
end