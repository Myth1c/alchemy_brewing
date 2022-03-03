local status_gui = {}
local status_active_effects = {
    ["active"] = 0,
}

local FontType = Brew_Config.GUI_Status_Font or "Brew_StatusFont"
local FontColour = Brew_Config.GUI_Font_mainColour or Color(255, 255, 255, 255)
local FontColourShadow = Brew_Config.GUI_Font_shadowColour or Color(0, 0, 0, 255)
local FrameCurve = Brew_Config.GUI_Status_Curve or 2

local PrimaryColour = Brew_Config.GUI_Status_Foreground or Color(120,120,120, 125)
local BorderColour = Brew_Config.GUI_Status_Border or Color(0,0,0, 125)

local function CreatePlayerTimer()
    DebugPrint("Status Timer was created for: " .. tostring(LocalPlayer()))
    timer.Create("Brew_UpdateStatuses", 1, 0, function()
        if status_active_effects["active"] < 1 then timer.Pause("Brew_UpdateStatuses") return end
        UpdateTimers()
    end)


end

function Brew_DrawStatus(effect, tier, timelimit)

    status_active_effects["active"] = status_active_effects["active"] + 1
    local height = 80 * (status_active_effects["active"])
    
    if !timer.Exists("Brew_UpdatedStatuses") then CreatePlayerTimer()
    elseif timer.TimeLeft("Brew_UpdateStatuses") < 0 then timer.Start("Brew_UpdateStatuses") end

    local statusFrame = vgui.Create("DFrame")
    statusFrame:SetDraggable(false)
    statusFrame:SetTitle("")
    statusFrame:SetSize(180, 80)
    statusFrame:ShowCloseButton(false)
    statusFrame:SetPos(ScrW() * 1740/1920, ScrH() * height/1080)
    statusFrame.Paint = function(s, w, h)
        draw.RoundedBox(FrameCurve, 0, 0, w, h, BorderColour)
        draw.RoundedBox(FrameCurve, 2, 2, w-4, h-4, PrimaryColour)
    end   

    statusFrame.OnClose = function () 
        DebugPrint("Status expired!")

        if status_active_effects["active"] < 1 then timer.Pause("Brew_UpdateStatuses") end
        
        
    end
    
    if status_active_effects[effect] ~= nil or status_active_effects[effect] then
        
        if !CheckIfHigherTier(effect, tier) then
            statusFrame:Close() 
            status_active_effects["active"] = status_active_effects["active"] - 1 
            return
        end
        
    end
    status_active_effects[effect] = statusFrame

    local timeLabel = vgui.Create("DLabel", statusFrame)
    timeLabel:SetFont(FontType)
    timeLabel:SetText(timelimit)
    timeLabel:SetPos(15, 45)
    timeLabel:SetSize(100 - string.len(timeLabel:GetText()), 20)
    timeLabel:SetTextColor(FontColour)
    timeLabel.Paint = function(s, w, h)
        
        struc = {}
        struc["pos"] = {0, 0}
        struc["color"] = FontColourShadow
        struc["text"] = timeLabel:GetText()
        struc["font"] = FontType
        struc["xalign"] = TEXT_ALIGN_LEFT
        struc["yalign"] = TEXT_ALIGN_TOP
        

        draw.TextShadow(struc, 1, 200)

    end

    local effectLabel = vgui.Create("DLabel", statusFrame)
    effectLabel:SetFont(FontType)
    effectLabel:SetText(CapitalizeFirstLetter(effect) .. " " .. NumberToNumeral(tier))
    effectLabel:SetPos(15, 15)
    effectLabel:SetSize(100 - string.len(effectLabel:GetText()), 20)
    effectLabel:SetTextColor(FontColour)
    effectLabel.Paint = function(s, w, h)
        
        struc = {}
        struc["pos"] = {0, 0}
        struc["color"] = FontColourShadow
        struc["text"] = effectLabel:GetText()
        struc["font"] = FontType
        struc["xalign"] = TEXT_ALIGN_LEFT
        struc["yalign"] = TEXT_ALIGN_TOP
        

        draw.TextShadow(struc, 1, 200)

    end

    local effectImage = vgui.Create("DImage", statusFrame)
    effectImage:SetPos( 111, 8)
    effectImage:SetSize(64, 64)
    effectImage:SetImage("gui/arrow")


end

function UpdatePositions()

    local count = 0

    for k, v in pairs(status_active_effects) do

        if k ~= "active" and v ~= nil then
            count = count + 1

            local height = 80 * count

            v:SetPos(ScrW() * 1740/1920, ScrH() * height/1080) 

            print(v:GetPos() .. " ".. height)
        end

    end


end

function UpdateTimers()

    for k, v in pairs(status_active_effects) do
        
        if k ~= "active" then
            for __, h in ipairs(v:GetChildren()) do

                if h:GetName() == "DLabel" and tonumber(h:GetText(), "10") then
                    if tonumber(h:GetText(), "10") <= 0 then Brew_RemoveStatus(k) return end
                    if k == "overheal" then
                        local hp = LocalPlayer():Health()

                        if tonumber(h:GetText(), "10") < ((hp - 100) * Brew_Config.Effect_Overheal_DecayRate) - 10 or tonumber(h:GetText(), "10") > ((hp - 100) * Brew_Config.Effect_Overheal_DecayRate) + 10 then
                            h:SetText(tonumber((hp - 100) * Brew_Config.Effect_Overheal_DecayRate) - Brew_Config.Effect_Overheal_DecayRate)
                        else h:SetText(tonumber(h:GetText(), "10") - 1) end
                        
                    else h:SetText(tonumber(h:GetText(), "10") - 1) end
                end

            end
        end


    end


end

function Brew_RemoveStatus(key, notiServer)

    if notiServer then
        net.Start("brew_clear_single_effect")
            net.WriteString(key)
        net.SendToServer()
    end

    local frame = status_active_effects[key]
    frame:Close()

    status_active_effects[key] = nil

    status_active_effects["active"] = status_active_effects["active"] - 1

    UpdatePositions()


end

function CapitalizeFirstLetter(text)

    return (text:gsub("^%l", string.upper))

end

--[[
    Script taken from https://gist.github.com/efrederickson/4080372
    These functions just converts a given number into roman numerals mainly for the tier of a potion and back. 
]]--

local map = { 
    I = 1,
    V = 5,
    X = 10,
    L = 50,
    C = 100, 
    D = 500, 
    M = 1000,
}
local numbers = { 1, 5, 10, 50, 100, 500, 1000 }
local chars = { "I", "V", "X", "L", "C", "D", "M" }

local RomanNumerals = { }

function NumberToNumeral(input)
        

    input = tonumber(input)
    if not input or input ~= input then error"Unable to convert to number" end
    if input == math.huge then error"Unable to convert infinity" end
    input = math.floor(input)
    if input <= 0 then return " " end
	local ret = ""
        for i = #numbers, 1, -1 do
        local num = numbers[i]
        while input - num >= 0 and input > 0 do
            ret = ret .. chars[i]
            input = input - num
        end
        --for j = i - 1, 1, -1 do
        for j = 1, i - 1 do
            local n2 = numbers[j]
            if input - (num - n2) >= 0 and input < num and input > 0 and num - n2 ~= n2 then
                ret = ret .. chars[j] .. chars[i]
                input = input - (num - n2)
                break
            end
        end
    end
    return ret
end
function NumeralToNumber(input)
    input = input:upper()
    local ret = 0
    local i = 1
    while i <= input:len() do
    --for i = 1, s:len() do
        local c = input:sub(i, i)
        if c ~= " " then -- allow spaces
            local m = map[c] or error("Unknown Roman Numeral '" .. c .. "'")
            
            local next = input:sub(i + 1, i + 1)
            local nextm = map[next]
            
            if next and nextm then
                if nextm > m then 
                -- if string[i] < string[i + 1] then result += string[i + 1] - string[i]
                -- This is used instead of programming in IV = 4, IX = 9, etc, because it is
                -- more flexible and possibly more efficient
                    ret = ret + (nextm - m)
                    i = i + 1
                else
                    ret = ret + m
                end
            else
                ret = ret + m
            end
        end
        i = i + 1
    end
    return ret
end

--[[ Old script. Left here in case I don't want to support going over 10. Its unecessary since the max tier should be 5 but I figured the above function looked fun
function NumberToNumeral(num)
    local text = ""

    if num < 4 and num > 0 then
        for i = 1, num do
            text = text .. "I"
        end
    elseif num == 4 then
        text = "IV"
    elseif num == 5 then
        text = "V"
    elseif num > 5 and num < 9 then
        text = "V"
        for i = 1, num - 5 do
            text = text .. "I"
        end
    elseif num == 9 then
        text = "IX"
    elseif num == 10 then
        text = "X"
    elseif num > 10 then
        return num
    end
    

    return text
end
]]--

function CheckIfHigherTier(effect, tier)
    if effect == "overheal" then return false end
    
    DebugPrint("Attempting to duplicate status effects")
    for k, v in pairs(status_active_effects[effect]:GetChildren()) do

        if v:GetName() == "DLabel" and string.find(v:GetText(), CapitalizeFirstLetter(effect)) then

            local oldTier = NumeralToNumber(string.sub(v:GetText(), string.len(effect) + 2))

            if oldTier <= tier then
                DebugPrint("Should replace old " .. effect .. " " .. NumberToNumeral(oldTier) .. " with " .. effect .. " " .. NumberToNumeral(tier))
                Brew_RemoveStatus(effect, false)
                return true
            end
            
        end

    end

    return false

end