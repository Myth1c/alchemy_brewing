local table_gui = {

    inventorySlots = {},

}

local stored_ents = {

}

--[[
    This chunk of code initializes settings and in case the config file doesn't load, it will set to defaults seen after the "or" statements
]]--
local FontType = Brew_Config.GUI_Font or "Brew_UIFont"
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

    storageFrame.OnClose = function() 
        if IsValid(hoverInfo) then hoverInfo:Close() end
        if !IsValid(brewFrame) then LocalPlayer():EmitSound("ui/item_bag_drop.wav") end
    end

    -- Setting up adjustments for different resolutions
    local boxW = ScrW() * box/1920
    local boxH = ScrH() * box/1080
    
    padding = ((ScrW() * padding/1920) + (ScrH() * padding/1080)) / 2



    for i = 1, max do

        table_gui.inventorySlots[i] = CreateInventorySlot(boxW, boxH, 30, 30, max, i-1, padding, columns)

    end

    DrawIngredients()

    if !IsValid(brewFrame) then
        local closeButton = vgui.Create( "DButton", storageFrame )
        closeButton:SetPos( ScrW() * (354 - frameWidth/2)/1920, ScrH() * 0/1080 )
        closeButton:SetSize( ScrW() * 65/1920, ScrH() * 25/1080 )
        closeButton:SetText( "X" )
        closeButton:SetFont("HudSelectionText")
        closeButton:SetTextColor( Color(255, 255, 255, 255) )
        closeButton.Paint = function(s, w, h)

            draw.RoundedBox(FrameCurve-4,0,0,w,h,BorderColour)
            draw.RoundedBox(FrameCurve-4,2,2,w-4,h-4,SlotBackground)

        end
        closeButton.DoClick = function()
            storageFrame:Close()
        end
    end

    LocalPlayer():EmitSound("ui/item_bag_pickup.wav")
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

--[[
    Function that adds entities to the inventory. It will draw any new entities it gets while the inventory is open, mainly to work with transfering
]]--
function AddToStorage(ent)

    if #stored_ents >= Brew_Config.Inventory_Size then return false end

    for i = 1, #stored_ents + 1 do
        if stored_ents[i] == nil then
            stored_ents[i] = ent
            if IsValid(storageFrame) then DrawIngredient(ent) end
            break
        end
    end
    return true
end

--[[
    This just take a class, model, and table abilities (not used for now) and will create a clientside entity with it
    It will automatically place it in the inventory after created
]]--
function CreateEntForStorage(class, model, abilities )

    local ent = ents.CreateClientside(class)
    ent:SetModel(model)
    ent:SetNoDraw(true)

    ent.Reagents = abilities

    DebugPrint("Entity added to storage with reagents: ")
    DebugPrintTable(ent.Reagents)

    AddToStorage(ent)


end

--[[
    This function is responsible for going through every inventory slot and checking for the first open slot to place items in.
    Once it finds one, it calls CreateIngredient with the entity we're trying to draw and the slot it should draw in
]]--
function DrawIngredient(ent)

    for k, v in ipairs(table_gui.inventorySlots) do
        local childCount = 0
        local didDraw = false
        local hasChild = false
        
        for h, j in ipairs(v:GetChildren()) do
            childCount = childCount + 1
            
            if j:GetClassName() == "Label" then break
            elseif j:GetClassName() == "Panel" and childCount == #v:GetChildren() then

                CreateIngredient(v, ent)
                didDraw = true
                break

            end
        end

        if didDraw == true then break end
    end
end

--[[
    This essentially just goes through all our stored ingredients and makes sure they all get drawn.
    It's done this way so I don't need to place a for loop for drawing every ingredient in the main function, although it can be done that way.
    I just think it looks cleaner this way.
]]--
function DrawIngredients()

    if table.IsEmpty(stored_ents) then return end

    for i = 1, #stored_ents do
        
        DrawIngredient(stored_ents[i])

    end
end

--[[
    This handles creating the images for items stored inside the inventory.
    It creates a DModelPanel at the supplied position of the given ent and makes sure it has left/right click functionality as well
]]--
function CreateIngredient(slot, ent) 

    local ingredModel = vgui.Create("DModelPanel", slot)
    ingredModel:SetPos(0, 0)
    ingredModel:SetSize(slot:GetSize())
    ingredModel:SetModel(ent:GetModel())

    local mn, mx = ingredModel.Entity:GetRenderBounds()
    local size = 0
    size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
    size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
    size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )

    ingredModel:SetFOV( 45 )
    ingredModel:SetCamPos( Vector( size, size, size ) )
    ingredModel:SetLookAt( (mn + mx) * 0.5 )

    function ingredModel:DoDoubleClick()
        if Inv_TransferEnt(ent) then
            ingredModel:Remove()
            if IsValid(hoverInfo) then hoverInfo:Close() end
        end
    end

    function ingredModel:DoClick()
        if IsValid(ingredModel) then
            if !IsValid(hoverInfo) then DrawHoverInfo(ent, ingredModel, slot)
            elseif IsValid(hoverInfo) then UpdateHoverInfo(ent, ingredModel, slot) end
        end
    end

    function ingredModel:DoRightClick()
        if IsValid(contextFrame) then contextFrame:Close() end
        if IsValid(hoverInfo) then hoverInfo:Close() end
        Brew_DrawContextMenu(ent, ingredModel, Inv_TransferEnt, Inv_DestroyItem, Inv_DropItem)
    end

end

--[[
    Transfer Function for the inventory. Mainly handles transfering between the brewing UI and the inventory.
]]--
function Inv_TransferEnt(ent)
    if !IsValid(brewFrame) then return false end
    if GrabIngredient(ent) then 
        table.RemoveByValue(stored_ents, ent)
        return true
    end

    return false

end

--[[
    Destroy function for the inventory. Just removes the ent from its storage table
]]--
function Inv_DestroyItem(ent)

    table.RemoveByValue(stored_ents, ent)

end

--[[
    Drop function for the inventory. 
    This is the function that handles dropping entities from the brewing menu so that you can use the context menu inside the brewing UI.
    Tells the server to create a serverside entity with the given class and model
]]
function Inv_DropItem(ent)

    net.Start("brew_drop_item")
        net.WriteString(ent:GetClass())
        net.WriteString(ent:GetModel())
        net.WriteTable(ent.Reagents)
    net.SendToServer()

    Inv_DestroyItem(ent)

    ent:Remove()
end

function Inv_RequestStorage()

    local temp = {}

    table.CopyFromTo(stored_ents, temp)

    table.Empty(stored_ents)

    return temp

end