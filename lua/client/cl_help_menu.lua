helpFrame = {}
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
    helpFrame:SetSize( ScrW() * 560/1920, ScrH() * 210/1080 )
    helpFrame:SetVisible(true)
    helpFrame:SetTitle("")
    helpFrame:ShowCloseButton(false)
    helpFrame:MakePopup()
    helpFrame:SetKeyboardInputEnabled(false)
    helpFrame.Paint = function(s, w, h)
        draw.RoundedBox(FrameCurve, 0, 0, w, h, FrameBorderColour)
        draw.RoundedBox(FrameCurve, 2, 2, w-4, h-4, FramePrimaryColour)
    end

    local textBox = vgui.Create("DLabel", helpFrame)
    textBox:SetFont(BodyFont)
    textBox:SetText("")
    textBox:SetSize( ScrW() * 680/1920, ScrH() * 210/1080 )
    textBox:SetPos(ScrW() * 0/1920, ScrH() * 0/1080)
    textBox:SetTextColor(FontColour)
    textBox.Paint = function(s, w, h)
        
        HowToTitle = {}
        HowToTitle["pos"] = {265, 0}
        HowToTitle["color"] = FontColour
        HowToTitle["text"] = "How to use:"
        HowToTitle["font"] = TitleFont
        HowToTitle["xalign"] = TEXT_ALIGN_CENTER
        HowToTitle["yalign"] = TEXT_ALIGN_TOP

        HowTo1 = {}
        HowTo1["pos"] = {265, 40}
        HowTo1["color"] = FontColour
        HowTo1["text"] = "Gather ingredients from around the world. Once you have some, return to"
        HowTo1["font"] = BodyFont
        HowTo1["xalign"] = TEXT_ALIGN_CENTER
        HowTo1["yalign"] = TEXT_ALIGN_TOP

        HowTo2 = {}
        HowTo2["pos"] = {265, 55}
        HowTo2["color"] = FontColour
        HowTo2["text"] = "the table then left click to inspect the reagents inside the ingredient. Right-Click to open"
        HowTo2["font"] = BodyFont
        HowTo2["xalign"] = TEXT_ALIGN_CENTER
        HowTo2["yalign"] = TEXT_ALIGN_TOP

        HowTo3 = {}
        HowTo3["pos"] = {265, 70}
        HowTo3["color"] = FontColour
        HowTo3["text"] = "the context menu. From there, transfer it into the table to begin brewing a potion."
        HowTo3["font"] = BodyFont
        HowTo3["xalign"] = TEXT_ALIGN_CENTER
        HowTo3["yalign"] = TEXT_ALIGN_TOP


        TipsTitle = {}
        TipsTitle["pos"] = {265, 110}
        TipsTitle["color"] = FontColour
        TipsTitle["text"] = "Tips:"
        TipsTitle["font"] = TitleFont
        TipsTitle["xalign"] = TEXT_ALIGN_CENTER
        TipsTitle["yalign"] = TEXT_ALIGN_TOP

        Tips1 = {}
        Tips1["pos"] = {265, 145}
        Tips1["color"] = FontColour
        Tips1["text"] = "Potions require powers of 3 for the next tier! Tier 2 = 3 reagents, Tier 3 = 9, so on."
        Tips1["font"] = BodyFont
        Tips1["xalign"] = TEXT_ALIGN_CENTER
        Tips1["yalign"] = TEXT_ALIGN_TOP

        Tips2 = {}
        Tips2["pos"] = {265, 160}
        Tips2["color"] = FontColour
        Tips2["text"] = "Extra reagents in a potion are destroyed after brewing. Maximize tiers before brewing!"
        Tips2["font"] = BodyFont
        Tips2["xalign"] = TEXT_ALIGN_CENTER
        Tips2["yalign"] = TEXT_ALIGN_TOP

        Tips3 = {}
        Tips3["pos"] = {265, 175}
        Tips3["color"] = FontColour
        Tips3["text"] = "Potions can be re-brewed for higher tiers. After-brewing, right click it for extra options"
        Tips3["font"] = BodyFont
        Tips3["xalign"] = TEXT_ALIGN_CENTER
        Tips3["yalign"] = TEXT_ALIGN_TOP
        
        Tips4 = {}
        Tips4["pos"] = {265, 190}
        Tips4["color"] = FontColour
        Tips4["text"] = "In the inventory, holding Shift while clicking will drop the item. Alt will delete it."
        Tips4["font"] = BodyFont
        Tips4["xalign"] = TEXT_ALIGN_CENTER
        Tips4["yalign"] = TEXT_ALIGN_TOP
        

        
        draw.Text(HowToTitle)
        draw.Text(HowTo1)
        draw.Text(HowTo2)
        draw.Text(HowTo3)
        draw.Text(TipsTitle)
        draw.Text(Tips1)
        draw.Text(Tips2)
        draw.Text(Tips3)
        draw.Text(Tips4)
    end 
   
    local openAnimation = Derma_Anim("ExpandOpen", helpFrame, function(pnl, anim, delta, data)
        local maxHeight = 560
        local maxWidth = 210

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