local brew_gui = {

    ingredientSlots = {},
    brewArrow = {},
    reagentInfo = {},
    ingredientCount = 0,

}
local brew_ents = {}

local reagents_Tracker = {
    
    ["speed"] = 0,
    ["leaping"] = 0,
    ["healing"] = 0,
    ["shield"] = 0,
}

local reagents_Tracker_Labels = {

    speedTier = {},
    leapingTier = {},
    healingTier = {},
    shieldTier = {}
}

--[[
    This chunk of code initializes settings and in case the config file doesn't load, it will set to defaults seen after the "or" statements
]]--
local FontType = Brew_Config.GUI_Font or "Brew_UIFont"
local FontColour = Brew_Config.GUI_Font_mainColour or Color(255, 255, 255, 255)
local FontColourShadow = Brew_Config.GUI_Font_shadowColour or Color(119, 135, 137, 255)
local FrameCurve = Brew_Config.FrameCurve or 10

local BrewSlotBackground = Brew_Config.GUI_BrewSlot_Background or Color(60,60,60, 180)
local FramePrimaryColour = Brew_Config.GUI_Brew_Foreground or Color(120,120,120, 0)
local FrameBorderColour = Brew_Config.GUI_Brew_Background or Color(0,0,0, 0)
local BrewSlotImage = Brew_Config.GUI_BrewSlot_Image or "decals/light"

--[[
    Main function that makes the brewing UI work.
    Calls and opens the inventory UI at the same time since both should always be opened when interacting with a table, but allows for me to open
    the inventory separately if needed. 
    Not much variability inside this as it was not designed to be infinitely expandable like the Inventory UI. 

]]--
function DrawBrewing()

    DrawStorage()
    
    brewFrame = vgui.Create("DFrame")
    brewFrame:SetPos(ScrW() * 660/1920, ScrH() * 75/1080)
    brewFrame:SetSize( ScrW() * 600/1920, ScrH() * 500/1080 )
    brewFrame:SetVisible(true)
    brewFrame:SetTitle("")
    brewFrame:ShowCloseButton(false)
    brewFrame:MakePopup()
    brewFrame:SetKeyboardInputEnabled(false)
    brewFrame.Paint = function(s, w, h)
        draw.RoundedBox(FrameCurve, 0, 0, w, h, FrameBorderColour)
        draw.RoundedBox(FrameCurve, 2, 2, w-4, h-4, FramePrimaryColour)
    end
    brewFrame.OnClose = function() 
        StoreIngredients()

        if IsValid(storageFrame) then storageFrame:Close() end
        if IsValid(contextFrame) then contextFrame:Close() end
        if IsValid(reagentInfo) then reagentInfo:Close() end
    end

    local max = Brew_Config.Max_Ingredients or 3
    if max > 5 then max = 5 end
    
    for i = 1, max do
        brew_gui.ingredientSlots[i] = CreateIngredientSlot(i, max)

    end

    local brewArrow = vgui.Create("DSprite")
    brewArrow:SetMaterial(Material("gui/arrow"))
    brewArrow:SetSize(ScrW() * 96/1920, ScrH() * 96/1080)
    brewArrow:SetParent(brewFrame)
    brewArrow:SetPos(ScrW() * 300/1920, ScrH() * 210/1080)
    brewArrow:SetRotation(180)
    brewArrow:SetColor(BrewSlotBackground)

    brew_gui.brewArrow = brewArrow
    

    local brewTitle = vgui.Create("DLabel")
    brewTitle:SetFont(FontType)
    brewTitle:SetText("Potion Brewing Station")
    brewTitle:SetSize( ScrW() * 300/1920, ScrH() * 40/1080 )
    brewTitle:SetPos(ScrW() * (190 - string.len(brewTitle:GetText()))/1920, ScrH() * 5/1080)
    brewTitle:SetParent(brewFrame)
    brewTitle:SetTextColor(FontColour)
    -- brewTitle.Paint = function(s, w, h)
        
    --     struc = {}
    --     struc["pos"] = {0, 2}
    --     struc["color"] = FontColourShadow
    --     struc["text"] = brewTitle:GetText()
    --     struc["font"] = FontType
    --     struc["xalign"] = TEXT_ALIGN_LEFT
    --     struc["yalign"] = TEXT_ALIGN_TOP
        

    --     draw.TextShadow(struc, 1, 200)

    -- end

    local startBrew = vgui.Create("DButton")
    startBrew:SetPos( ScrW() * 100/1920 , ScrH() * 400/1080)
    startBrew:SetSize(ScrW() * 400/1920, ScrH() * 50/1080)
    startBrew:SetText("Start Brewing")
    startBrew:SetFont("Brew_UIFont")
    startBrew:SetParent(brewFrame)
    startBrew:SetTextColor(Color(255, 255, 255, 255))

    startBrew.DoClick = function() StartBrewing() end

    startBrew.Paint = function(s, w, h)
        draw.RoundedBox(FrameCurve, 0, 0, w, h, FrameBorderColour)
        draw.RoundedBox(FrameCurve, 2, 2, w-4, h-4, BrewSlotBackground)
    end

    local closeButton = vgui.Create( "DButton", brewFrame )
    closeButton:SetPos( ScrW() * 536/1920, ScrH() * 0/1080 )
    closeButton:SetSize( ScrW() * 65/1920, ScrH() * 25/1080 )
    closeButton:SetText( "X" )
    closeButton:SetFont("HudSelectionText")
    closeButton:SetTextColor( Color(255, 255, 255, 255) )
    closeButton.Paint = function(s, w, h)

		draw.RoundedBox(FrameCurve-4,0,0,w,h,FrameBorderColour)
		draw.RoundedBox(FrameCurve-4,2,2,w-4,h-4,BrewSlotBackground)

	end
	closeButton.DoClick = function()
		brewFrame:Close()
	end

    local outputBoxFrame = vgui.Create("DFrame", brewFrame)
    outputBoxFrame:SetPos(ScrW() * 238/1920, ScrH() * 263/1080)
    outputBoxFrame:SetSize(ScrW() * 125/1920, ScrH() * 125/1080)
    outputBoxFrame:SetDraggable(false)
    outputBoxFrame:ShowCloseButton(false)
    outputBoxFrame:SetTitle("")
    outputBoxFrame.Paint = function(s, w, h)
        draw.RoundedBox(FrameCurve, 0, 0, w, h, FrameBorderColour)
        draw.RoundedBox(FrameCurve, 2, 2, w-4, h-4, BrewSlotBackground)
    end

    local outputBoxImage = vgui.Create("DImage", brewFrame)
    outputBoxImage:SetPos(ScrW() * 238/1920, ScrH() * 263/1080)
    outputBoxImage:SetSize(ScrW() * 125/1920, ScrH() * 125/1080)
    outputBoxImage:SetImage(BrewSlotImage)

end

--[[
    The function in charge of handling where the input slots should draw on the x axis. The y axis is always the same.
    Its setup to always center the boxes. Odd number of boxes = middle one centered, even = centered between the "middle" boxes
]]--
function GetNextPos(spacing, current, max)

    local offset = spacing / 2

    if max == 3 then
        offset = 0
    else
        offset = offset * (max - 3)
    end

    return (spacing * current - offset)
end

--[[
    This was a temporary function to get things setup and will be repurposed later. 
    For now it just draws a fake ingredient over the supplied button.
]]--
function GrabIngredient(ent)

    if brew_gui.ingredientCount == Brew_Config.Max_Ingredients then return false end
    brew_gui.ingredientCount = brew_gui.ingredientCount + 1

    DebugPrint("Ingredient should be added: " .. tostring(ent) .. "\nReagents included: ")
    DebugPrintTable(ent.Reagents)
    

    if !IsValid(reagentInfo) then DrawReagentInfo(ent) end

    AddReagents(ent)

    for k, v in ipairs(brew_gui.ingredientSlots) do
        local childCount = 0
        local didDraw = false
        
        for h, j in ipairs(v:GetChildren()) do
            childCount = childCount + 1
            
            if j:GetClassName() == "Label" then break
            elseif j:GetClassName() == "Panel" and childCount == #v:GetChildren() then

                Brew_CreateIngredient(ent, v)
                didDraw = true
                table.insert(brew_ents, ent)
                break

            end
        end

        if didDraw == true then break end
    end
    
    return true



end

function Brew_CreateIngredient(ent, button)

    local ingredModel = vgui.Create("DModelPanel", button)
    ingredModel:SetPos(0, 0)
    ingredModel:SetSize(button:GetSize())
    ingredModel:SetModel(ent:GetModel())

    local mn, mx = ingredModel.Entity:GetRenderBounds()
    local size = 0
    size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
    size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
    size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )

    ingredModel:SetFOV( 45 )
    ingredModel:SetCamPos( Vector( size, size, size ) )
    ingredModel:SetLookAt( (mn + mx) * 0.5 )

    ingredModel.OnMousePressed = function(obj, mcode)

        if mcode == 107 and Brew_TransferEnt(ent) then

            ingredModel:Remove()

        elseif mcode == 108 then 

            if IsValid(contextFrame) then contextFrame:Close() end
            Brew_DrawContextMenu(ent, ingredModel, Brew_TransferEnt, Brew_DestroyItem, Brew_DropItem)
        end
        

    end
end

--[[
    This function creates the ingredient slots with some variability so they always fit on the brewing UI.
    It'll return each slot created so it can be stored inside a table for access later.
]]--
function CreateIngredientSlot(current, max)

    local ingredSlot = vgui.Create("DImageButton", brewFrame)
    ingredSlot:SetPos(ScrW() * GetNextPos(125, current, max )/1920 , ScrH() * 50/1080)
    ingredSlot:SetSize(ScrW() * 100/1920, ScrH() * 100/1080)
    ingredSlot:SetText("")
    ingredSlot:SetImage(BrewSlotImage)

    -- ingredSlot.DoClick = function ()
    --     GrabIngredient(ingredSlot)
    -- end

    ingredSlot.Paint = function(s, w, h)
        draw.RoundedBox(FrameCurve, 0, 0, w, h, FrameBorderColour)
        draw.RoundedBox(FrameCurve, 2, 2, w-4, h-4, BrewSlotBackground)
    end

    return ingredSlot

end

--[[
    Another temporary function to get things setup. This will also be repurposed/rewritten later.
    For now it just draws a fake potion that can be removed by clicking on it.
]]--
function StartBrewing()

    if brew_gui.ingredientCount > 0 then

        local pot = ents.CreateClientside("inert_potion")
        pot:SetModel("models/props_junk/garbage_plasticbottle001a.mdl")
        pot:SetNoDraw(true)
        pot.Effects = {}

        --table.insert(brew_ents, pot)
        
        local potion = vgui.Create("DModelPanel", brewFrame)
        potion:SetPos(ScrW() * 225/1920, ScrH() * 250/1080)
        potion:SetSize(ScrW() * 150/1920, ScrH() * 150/1080)
        potion:SetModel(pot:GetModel())

        local mn, mx = potion.Entity:GetRenderBounds()
        local size = 0
        size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
        size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
        size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )

        potion:SetFOV( 45 )
        potion:SetCamPos( Vector( size, size, size ) )
        potion:SetLookAt( (mn + mx) * 0.5 )

        potion.OnMousePressed = function(obj, mcode)

            if mcode == 107 then

                brew_gui.brewArrow:SetColor(BrewSlotBackground)
                brewFrame:Close()
            -- elseif mcode == 108 then 
            --     Brew_DrawContextMenu(pot, potion, Brew_TransferEnt, Brew_DestroyItem, Brew_DropItem)
            end


        end

        SetupEffects(pot)

        
        Brew_DropItem(pot)

        brew_gui.brewArrow:SetColor(Color(255, 255, 255, 255))

        ClearIngredients()

        for _, v in ipairs(brew_ents) do
            RemoveReagents(v)
        end

        if IsValid(reagentInfo) then reagentInfo:Close() end
    end

end


--[[
    Function for clearing all ingredients from slots. Purpose is to be ran when brewing a potion so the ingredients are "used up" and cannot be rused.
    Another function that will be rewritten when actual logic is introduced. :(
]]--
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

--[[
    Called when the UI is closed so ingredients inside of it aren't destroyed or dropped physically.
    If theres anything to store, it will go through the brewing UIs stored entities and send them to the inventory instead.

    TODO: Update this function to use the transfer function, and anything that won't fit will be dropped on the ground.
]]--
function StoreIngredients()

    if brew_gui.ingredientCount > 0 then

        for _, v in ipairs(brew_ents) do
            AddToStorage(v)
            RemoveReagents(v)
        end


    end
    brew_ents = {}
    brew_gui.ingredientCount = 0
end

--[[
    This is the function that handles sending ingredients between the brewing UI and the player inventory.
    It checks if the inventory is full first before sending anything and will return true or false depending on if it could send anything.
]]--
function Brew_TransferEnt(ent)

    if not AddToStorage(ent) then return false end

    Brew_DestroyItem(ent)

    return true

end

--[[
    This function only handles destroying entities generally done through the context menu.
]]--
function Brew_DestroyItem(ent)
    if table.HasValue(brew_ents, ent) then
        table.RemoveByValue(brew_ents, ent)
        brew_gui.ingredientCount = brew_gui.ingredientCount - 1

        if IsValid(reagentInfo) and #brew_ents < 1 then reagentInfo:Close() end

        RemoveReagents(ent)
    end

end

--[[
    This is the function that handles dropping entities from the brewing menu so that you can use the context menu inside the brewing UI
    Tells the server to create a serverside entity with the given class and model
]]--
function Brew_DropItem(ent)

    net.Start("brew_drop_item")
        net.WriteString(ent:GetClass())
        net.WriteString(ent:GetModel())
        net.WriteTable(ent.Reagents or ent.Effects)
    net.SendToServer()

    Brew_DestroyItem(ent)

end

--[[
    This draws a UI popup on the left of the main brewing frame.
    It just displays what tiers of what effects your current potion will give you with the supplied ingredients.
]]--
function DrawReagentInfo(ent)

    reagentInfo = vgui.Create("DFrame")
    reagentInfo:SetPos(ScrW() * 330/1920, ScrH() * 75/1080)
    reagentInfo:SetSize( ScrW() * 300/1920, ScrH() * 250/1080 )
    reagentInfo:SetVisible(true)
    reagentInfo:SetTitle("")
    reagentInfo:ShowCloseButton(false)
    reagentInfo.Paint = function(s, w, h)
        draw.RoundedBox(FrameCurve, 0, 0, w, h, FrameBorderColour)
        draw.RoundedBox(FrameCurve, 2, 2, w-4, h-4, FramePrimaryColour)
        
        draw.RoundedBox(FrameCurve, 0, 0, w, 30, Color(0, 0, 0, 255))
        draw.RoundedBox(FrameCurve, 2, 2, w-4, 28, Color(255, 255, 255, 255))
    end

    local reagentTitle = vgui.Create("DLabel", reagentInfo)
    reagentTitle:SetFont(FontType)
    reagentTitle:SetText("Ingredient Information")
    reagentTitle:SetSize( ScrW() * 300/1920, ScrH() * 40/1080 )
    reagentTitle:SetPos(ScrW() * 15/1920, ScrH() * -3/1080)
    reagentTitle:SetTextColor(FontColour)



    local speedLabel = vgui.Create("DLabel", reagentInfo)
    speedLabel:SetFont(FontType)
    speedLabel:SetText("Speed: ")
    speedLabel:SetSize( ScrW() * 300/1920, ScrH() * 40/1080 )
    speedLabel:SetPos(ScrW() * (25 - string.len(speedLabel:GetText()))/1920, ScrH() * 30/1080)
    speedLabel:SetTextColor(FontColour)

    speedTier = vgui.Create("DLabel", reagentInfo)
    speedTier:SetFont(FontType)
    speedTier:SetText("0")
    speedTier:SetSize( ScrW() * 300/1920, ScrH() * 40/1080 )
    speedTier:SetPos(ScrW() * (270 - string.len(speedTier:GetText()))/1920, ScrH() * 30/1080)
    speedTier:SetTextColor(FontColour)



    local leapingLabel = vgui.Create("DLabel", reagentInfo)
    leapingLabel:SetFont(FontType)
    leapingLabel:SetText("Leaping: ")
    leapingLabel:SetSize( ScrW() * 300/1920, ScrH() * 40/1080 )
    leapingLabel:SetPos(ScrW() * (25 - string.len(leapingLabel:GetText()))/1920, ScrH() * 90/1080)
    leapingLabel:SetTextColor(FontColour)

    leapingTier = vgui.Create("DLabel", reagentInfo)
    leapingTier:SetFont(FontType)
    leapingTier:SetText("0")
    leapingTier:SetSize( ScrW() * 300/1920, ScrH() * 40/1080 )
    leapingTier:SetPos(ScrW() * (270 - string.len(leapingTier:GetText()))/1920, ScrH() * 90/1080)
    leapingTier:SetTextColor(FontColour)



    local healingLabel = vgui.Create("DLabel", reagentInfo)
    healingLabel:SetFont(FontType)
    healingLabel:SetText("Healing: ")
    healingLabel:SetSize( ScrW() * 300/1920, ScrH() * 40/1080 )
    healingLabel:SetPos(ScrW() * (25 - string.len(healingLabel:GetText()))/1920, ScrH() * 150/1080)
    healingLabel:SetTextColor(FontColour)
    
    healingTier = vgui.Create("DLabel", reagentInfo)
    healingTier:SetFont(FontType)
    healingTier:SetText("0")
    healingTier:SetSize( ScrW() * 300/1920, ScrH() * 40/1080 )
    healingTier:SetPos(ScrW() * (270 - string.len(healingTier:GetText()))/1920, ScrH() * 150/1080)
    healingTier:SetTextColor(FontColour)



    local shieldLabel = vgui.Create("DLabel", reagentInfo)
    shieldLabel:SetFont(FontType)
    shieldLabel:SetText("Shield: ")
    shieldLabel:SetSize( ScrW() * 300/1920, ScrH() * 40/1080 )
    shieldLabel:SetPos(ScrW() * (25 - string.len(shieldLabel:GetText()))/1920, ScrH() * 210/1080)
    shieldLabel:SetTextColor(FontColour)
    
    shieldTier = vgui.Create("DLabel", reagentInfo)
    shieldTier:SetFont(FontType)
    shieldTier:SetText("0")
    shieldTier:SetSize( ScrW() * 300/1920, ScrH() * 40/1080 )
    shieldTier:SetPos(ScrW() * (270 - string.len(shieldTier:GetText()))/1920, ScrH() * 210/1080)
    shieldTier:SetTextColor(FontColour)






end

--[[
    This function will add reagents to the table based on the supplied entity.
]]--
function AddReagents(ent)

    DebugPrint("Adding reagents: ")
    DebugPrintTable(ent.Reagents)

    for k, v in pairs(ent.Reagents) do

        reagents_Tracker[k] = reagents_Tracker[k] + v

    end

    DebugPrint("Reagents addedd. Table now has:\n")
    DebugPrintTable(reagents_Tracker)

    UpdateTierLabels()

end

--[[
    This function will remove reagents to the table based on the supplied entity.
]]--
function RemoveReagents(ent)

    DebugPrint("Removing reagents: ")
    DebugPrintTable(ent.Reagents)

    for k, v in pairs(ent.Reagents) do

        reagents_Tracker[k] = reagents_Tracker[k] - v

    end

    DebugPrint("Reagents removed. Table now has:\n")
    DebugPrintTable(reagents_Tracker)

    UpdateTierLabels()

end

--[[
    This function is ONLY for the tracking UI.
    It goes through all the labels we need that display what tier the effects are, and updates them each to what the table has stored internally.
]]--
function UpdateTierLabels()

    speedTier:SetText(reagents_Tracker["speed"])
    leapingTier:SetText(reagents_Tracker["leaping"])
    healingTier:SetText(reagents_Tracker["healing"])
    shieldTier:SetText(reagents_Tracker["shield"])


end

--[[
    This function does the heavy lifting of the brewing portion. It takes in everything from the internal reagents table and gives it to the created potion
    This potion will then use the numbers given and supply them to the potion. Which will then use those numbers to give effects to the user.
]]--
function SetupEffects(ent)

    for k, v in pairs(reagents_Tracker) do

        if v > 0 then 
            DebugPrint("Inserting " .. k .. " into potion.")
            
            ent.Effects[k] = v

            DebugPrintTable(ent.Effects)

        end

    end




end