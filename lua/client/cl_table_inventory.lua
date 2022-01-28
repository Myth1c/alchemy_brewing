local table_gui = {

    inventorySlots = {},

}

local stored_ents = {

}

--[[
    This chunk of code initializes settings and in case the config file doesn't load, it will set to defaults seen after the "or" statements
]]--
local FontType = Brew_Config.GUI_Font or "DermaLarge"
local FontColour = Brew_Config.GUI_Font_mainColour or Color(255, 255, 255, 255)
local FontColourShadow = Brew_Config.GUI_Font_shadowColour or Color(119, 135, 137, 255)
local FrameCurve = Brew_Config.FrameCurve or 10

local SlotBackground = Brew_Config.GUI_BrewSlot_Background or Color(60,60,60, 180)

local PrimaryColour = Brew_Config.GUI_Inventory_Foreground or Color(120,120,120, 0)
local BorderColour = Brew_Config.GUI_Inventory_Background or Color(0,0,0, 0)
local HeaderColor = Brew_Config.GUI_Inventory_Header or Color(255, 255, 255, 255)

--[[

    The main function for the storage UI. This draws the main window and all it's children windows(such as the inventory slots)
    It will variably set the window size based on options set in the config file.

]]--

function DrawStorage()

    local max = Brew_Config.Inventory_Size or 25
    local box = Brew_Config.Inventory_BoxSize or 50
    local padding = Brew_Config.Inventory_Padding or 5
    
    local factor = GetBiggestFactor(max)

    local rows = factor.y
    local columns = factor.x


    local frameHeight = 25 + (rows * box) + (rows * padding) + padding
    local frameWidth = (columns * box) + (columns * padding) + padding

    DebugPrint("Max Boxes: " .. max .. "\nBox Size: " .. box .. "\nPadding: " .. padding .. "\nFrameHeight: " .. frameHeight .. "\nRows: " .. rows .. "\nColumns: " .. columns)

    storageFrame = vgui.Create("DFrame")
    storageFrame:SetPos(ScrW() * (960 - frameWidth/2)/1920, ScrH() * 600/1080)
    storageFrame:SetSize( ScrW() * frameWidth/1920, ScrH() * frameHeight/1080 )
    storageFrame:SetVisible(true)
    storageFrame:SetTitle("")
    storageFrame:ShowCloseButton(false)
    storageFrame:MakePopup()
    storageFrame:SetKeyboardInputEnabled(false)
    storageFrame.Paint = function(s, w, h)


        draw.RoundedBox(FrameCurve, 0, 0, w, h, BorderColour)
        draw.RoundedBox(FrameCurve, 2, 2, w-4, h-4, PrimaryColour)

        draw.RoundedBox(FrameCurve, 0, 0, w, 25, BorderColour)
        draw.RoundedBox(FrameCurve, 2, 2, w-4, 21, HeaderColor)

        draw.RoundedBox(FrameCurve, 2, 27, w-4, h-29, BorderColour)
    end


    for i = 1, max do

        table_gui.inventorySlots[i] = CreateInventorySlot(box, box, 30, 30, max, i-1, padding, columns)

    end


end

--[[

    The main function for creating inventory slots. Not designed to place singular slots but place an array of slots.
    Creates the background for the inventory slot as well as the ImageButton used for simplicity.

]]--

function CreateInventorySlot(sizeX, sizeY, posX, posY, max, current, padding, columns)

    local pos = Vector(GetNext(padding, current, max, posX, posY, sizeX, sizeY, columns))

    local borderPadding = padding + (padding/5)

    local slotPad = vgui.Create("DFrame", storageFrame)
    slotPad:SetVisible(true)
    slotPad:SetTitle("")
    slotPad:ShowCloseButton(false)
    slotPad:SetDraggable(false)
    slotPad:SetSize(sizeX +borderPadding, sizeY + borderPadding)
    slotPad:SetPos(pos.x - (borderPadding/2), (pos.y - (borderPadding/2)) + 25)

    slotPad.Paint = function(s, w, h)

        draw.RoundedBox(FrameCurve, 0, 0, w, h, BorderColour)
        draw.RoundedBox(FrameCurve, 2, 2, w-4, h-4, PrimaryColour)

    end

    local invSlot = vgui.Create("DImageButton", storageFrame)
    invSlot:SetPos(pos.x, pos.y + 25)
    invSlot:SetSize(sizeX, sizeY)
    invSlot:SetText("")
    invSlot:SetImage("decals/light")

    invSlot.Paint = function(s, w, h)
        draw.RoundedBox(FrameCurve, 0, 0, w, h, BorderColour)
        draw.RoundedBox(FrameCurve, 2, 2, w-4, h-4, SlotBackground)
    end

    return invSlot

end

--[[

    The main engine for the array feature of the inventory slots. Without this, the slots would have to be placed manually.

]]--

function GetNext(padding, current, max, posX, posY, sizeX, sizeY, maxColumns)

        
    local row = math.floor(current / maxColumns) + 1
    local column = current % maxColumns 

    DebugPrint("\nCreating slot:\nRow: " .. row .. " Column: ".. column .. " Current Slot: " .. current)


    local X = ((sizeX + padding) * column + (padding + sizeX)) - sizeX

    local Y = (((sizeY + padding) * row) - sizeY)

    DebugPrint("At: (".. X .. "," .. Y .. ")")
    
    


    return Vector(X, Y)
end

--[[

    Used to get the largest factors of whatever number the amount of inventory spaces is set to in the config.
    ie: 25 = 5*5, 30 = 6*5, 100 = 10*10

]]--

function GetBiggestFactor(val)
    val=math.floor(val)

    local factor = Vector(1, val)

    local lastX = 1
    local lastY = val

    for i = 1, val do
        
        if val % i == 0 then
            if lastX >= lastY then 
                factor.x = lastX
                factor.y = lastY
                break
            end
            lastX = i
            lastY = val / i
            
        end
    end


    return factor
end