
--[[
    This chunk of code initializes settings and in case the config file doesn't load, it will set to defaults seen after the "or" statements
]]--
local FontType = Brew_Config.GUI_Font or "DermaLarge"
local FontColour = Brew_Config.GUI_Font_mainColour or Color(255, 255, 255, 255)
local FontColourShadow = Brew_Config.GUI_Font_shadowColour or Color(119, 135, 137, 255)
local FrameCurve = Brew_Config.FrameCurve or 10

local PrimaryColour = Brew_Config.GUI_Inventory_Foreground or Color(120,120,120, 0)
local BorderColour = Brew_Config.GUI_Inventory_Background or Color(0,0,0, 0)

function Brew_DrawContextMenu(ent, icon, transferFunc, destroyFunc, dropFunc)



    contextFrame = vgui.Create("DFrame")
    contextFrame:SetTitle("")
    contextFrame:ShowCloseButton(false)
    contextFrame:SetDraggable(false)
    contextFrame:SetVisible(true)
    contextFrame:SetSize(125, 62)
    contextFrame:MakePopup(true)
    contextFrame:DoModal()
    contextFrame:SetKeyboardInputEnabled(false)
    contextFrame:SetPos(gui.MouseX(), gui.MouseY())
    contextFrame.Paint = function(s, w, h)

        draw.RoundedBox(FrameCurve - 5, 0, 0, w, h, BorderColour)
        draw.RoundedBox(FrameCurve - 5, 2, 2, w-4, h-4, PrimaryColour)

    end

    local transferButton = vgui.Create("DButton", contextFrame)
    transferButton:SetText("Transfer Item")
    transferButton:SetPos(1, 1)
    transferButton:SetSize(123, 20)
    transferButton:SetTextColor(Color(255, 255, 255, 255))
    transferButton.Paint = function(s, w, h)

        draw.RoundedBox(0, 0, 0, w, h, BorderColour)
        draw.RoundedBox(0, 2, 2, w-4, h-4, PrimaryColour)

    end
    transferButton.DoClick = function() 

        contextFrame:Close()
        transferFunc(ent)
        icon:Remove()
    end

    local destroyButton = vgui.Create("DButton", contextFrame)
    destroyButton:SetText("Destroy Item")
    destroyButton:SetPos(1, 21)
    destroyButton:SetSize(123, 20)
    destroyButton:SetTextColor(Color(255, 255, 255, 255))
    destroyButton.Paint = function(s, w, h)

        draw.RoundedBox(0, 0, 0, w, h, BorderColour)
        draw.RoundedBox(0, 2, 2, w-4, h-4, PrimaryColour)

    end
    destroyButton.DoClick = function() 
        
        contextFrame:Close()
        destroyFunc(ent)
        icon:Remove()
    end

    local dropButton = vgui.Create("DButton", contextFrame)
    dropButton:SetText("Drop Item")
    dropButton:SetPos(1, 41)
    dropButton:SetSize(123, 20)
    dropButton:SetTextColor(Color(255, 255, 255, 255))
    dropButton.Paint = function(s, w, h)

        draw.RoundedBox(0, 0, 0, w, h, BorderColour)
        draw.RoundedBox(0, 2, 2, w-4, h-4, PrimaryColour)

    end
    dropButton.DoClick = function() 
        
        contextFrame:Close()
        dropFunc(ent)
        icon:Remove()
    end




end