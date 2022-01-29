
--[[
    This chunk of code initializes settings and in case the config file doesn't load, it will set to defaults seen after the "or" statements
]]--
local FontType = Brew_Config.GUI_Font or "DermaLarge"
local FontColour = Brew_Config.GUI_Font_mainColour or Color(255, 255, 255, 255)
local FontColourShadow = Brew_Config.GUI_Font_shadowColour or Color(119, 135, 137, 255)
local FrameCurve = Brew_Config.FrameCurve or 10

local ButtonPrimaryColour = Brew_Config.GUI_Context_Button_Foreground or Color(120,120,120, 255)
local ButtonBorderColour = Brew_Config.GUI_Context_Button_Border or Color(255,255,255, 255)
local MainBorderColour = Brew_Config.GUI_Context_Main_Border or Color(255,255,255, 255)

function Brew_DrawContextMenu(ent, icon, transferFunc, destroyFunc, dropFunc)



    contextFrame = vgui.Create("DFrame")
    contextFrame:SetTitle("")
    contextFrame:ShowCloseButton(false)
    contextFrame:SetDraggable(false)
    contextFrame:SetVisible(true)
    contextFrame:SetSize(125, 83)
    contextFrame:MakePopup(true)
    contextFrame:DoModal()
    contextFrame:SetKeyboardInputEnabled(false)
    contextFrame:SetPos(gui.MouseX(), gui.MouseY())
    contextFrame.Paint = function(s, w, h)

        draw.RoundedBox(FrameCurve - 5, 0, 0, w, h, MainBorderColour)
        draw.RoundedBox(FrameCurve - 5, 2, 2, w-4, h-4, ButtonPrimaryColour)

    end

    local transferButton = vgui.Create("DButton", contextFrame)
    transferButton:SetText("Transfer Item")
    transferButton:SetPos(1, 1)
    transferButton:SetSize(123, 20)
    transferButton:SetTextColor(Color(255, 255, 255, 255))
    transferButton.Paint = function(s, w, h)

        draw.RoundedBox(0, 0, 0, w, h, ButtonBorderColour)
        draw.RoundedBox(0, 2, 2, w-4, h-4, ButtonPrimaryColour)

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

        draw.RoundedBox(0, 0, 0, w, h, ButtonBorderColour)
        draw.RoundedBox(0, 2, 2, w-4, h-4, ButtonPrimaryColour)

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

        draw.RoundedBox(0, 0, 0, w, h, ButtonBorderColour)
        draw.RoundedBox(0, 2, 2, w-4, h-4, ButtonPrimaryColour)

    end
    dropButton.DoClick = function() 

        contextFrame:Close()
        dropFunc(ent)
        icon:Remove()
    end

    local cancelButton = vgui.Create("DButton", contextFrame)
    cancelButton:SetText("Cancel")
    cancelButton:SetPos(1, 61)
    cancelButton:SetSize(123, 20)
    cancelButton:SetTextColor(Color(255, 255, 255, 255))
    cancelButton.Paint = function(s, w, h)

        draw.RoundedBox(0, 0, 0, w, h, ButtonBorderColour)
        draw.RoundedBox(0, 2, 2, w-4, h-4, ButtonPrimaryColour)

    end
    cancelButton.DoClick = function() 

        contextFrame:Close()
    end




end