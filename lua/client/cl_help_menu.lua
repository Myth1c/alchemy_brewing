helpFrame = {}
local openAnimation = nil
local closeAnimation = nil
--[[
    This chunk of code initializes settings and in case the config file doesn't load, it will set to defaults seen after the "or" statements
]]--
local TitleFont = Brew_Config.GUI_Font or "Brew_UIFont"
local BodyFont = "Brew_UIFont_Small"
local FontColour = Brew_Config.GUI_Font_mainColour or Color(255, 255, 255, 255)
local FontColourShadow = Brew_Config.GUI_Font_shadowColour or Color(119, 135, 137, 255)
local FrameCurve = Brew_Config.FrameCurve or 10

local BrewSlotBackground = Brew_Config.GUI_BrewSlot_Background or Color(60,60,60, 180)
local FramePrimaryColour = Brew_Config.GUI_Brew_Foreground or Color(120,120,120, 0)
local FrameBorderColour = Brew_Config.GUI_Brew_Background or Color(0,0,0, 0)

function DrawHelpMenu()

    if IsValid(helpFrame) then if IsValid(helpFrame) then helpFrame:Close() end return end

    local opened = true

    helpFrame = vgui.Create("DFrame")
    helpFrame:SetPos(ScrW() * 680/1920, ScrH() * 95/1080)
    helpFrame:SetSize( ScrW() * 560/1920, ScrH() * 110/1080 )
    helpFrame:SetVisible(true)
    helpFrame:SetTitle("")
    helpFrame:ShowCloseButton(false)
    helpFrame:MakePopup()
    helpFrame:SetKeyboardInputEnabled(false)
    helpFrame.Paint = function(s, w, h)
        draw.RoundedBox(FrameCurve, 0, 0, w, h, FrameBorderColour)
        draw.RoundedBox(FrameCurve, 2, 2, w-4, h-4, FramePrimaryColour)
    end

    local htuTitle = vgui.Create("DLabel", helpFrame)
    htuTitle:SetFont(TitleFont)
    htuTitle:SetText("How to use:")
    htuTitle:SetSize( ScrW() * 300/1920, ScrH() * 40/1080 )
    htuTitle:SetPos(ScrW() * (210 - string.len(htuTitle:GetText()))/1920, ScrH() * 0/1080)
    htuTitle:SetTextColor(FontColour)
    htuTitle:AlignTop(0)
    

    local htuLine1 = vgui.Create("DLabel", helpFrame)
    htuLine1:SetFont(BodyFont)
    htuLine1:SetText("")
    htuLine1:SetSize( ScrW() * 600/1920, ScrH() * 125/1080 )
    htuLine1:SetPos(ScrW() * 0/1920, ScrH() * 0/1080)
    htuLine1:SetTextColor(FontColour)
    htuLine1.Paint = function(s, w, h)
        
        struc = {}
        struc["pos"] = {265, 40}
        struc["color"] = FontColour
        struc["text"] = "Gather ingredients from around the world. Once you have some, return to"
        struc["font"] = BodyFont
        struc["xalign"] = TEXT_ALIGN_CENTER
        struc["yalign"] = TEXT_ALIGN_TOP
        

        draw.Text(struc, 1, 200)
    end
    local htuLine2 = vgui.Create("DLabel", helpFrame)
    htuLine2:SetFont(BodyFont)
    htuLine2:SetText("")
    htuLine2:SetSize( ScrW() * 600/1920, ScrH() * 125/1080 )
    htuLine2:SetPos(ScrW() * 0/1920, ScrH() * 0/1080)
    htuLine2:SetTextColor(FontColour)
    htuLine2.Paint = function(s, w, h)
        
        struc = {}
        struc["pos"] = {265, 55}
        struc["color"] = FontColour
        struc["text"] = "the table then left click to inspect the reagents inside the ingredient. Right-Click to open"
        struc["font"] = BodyFont
        struc["xalign"] = TEXT_ALIGN_CENTER
        struc["yalign"] = TEXT_ALIGN_TOP
        

        draw.Text(struc, 1, 200)
    end
    local htuLine3 = vgui.Create("DLabel", helpFrame)
    htuLine3:SetFont(BodyFont)
    htuLine3:SetText("")
    htuLine3:SetSize( ScrW() * 600/1920, ScrH() * 125/1080 )
    htuLine3:SetPos(ScrW() * 0/1920, ScrH() * 0/1080)
    htuLine3:SetTextColor(FontColour)
    htuLine3.Paint = function(s, w, h)
        
        struc = {}
        struc["pos"] = {265, 70}
        struc["color"] = FontColour
        struc["text"] = "the context menu. From there, transfer it into the table to begin brewing a potion."
        struc["font"] = BodyFont
        struc["xalign"] = TEXT_ALIGN_CENTER
        struc["yalign"] = TEXT_ALIGN_TOP
        

        draw.Text(struc, 1, 200)
    end

    openAnimation = Derma_Anim("ExpandOpen", helpFrame, function(pnl, anim, delta, data)
    
        local maxHeight = 560
        local maxWidth = 110

        local curHeight = math.floor(delta * maxHeight)
        local curWidth = math.floor(delta * maxWidth)

        pnl:SetSize(curHeight, curWidth)
    
    end)
    

    helpFrame.Think = function(self)

        if openAnimation:Active() then
            openAnimation:Run()
        end


    end


    
    openAnimation:Start(0.15)


end