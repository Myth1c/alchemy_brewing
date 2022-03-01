local status_gui = {}
local status_active_effects = {
}

local FontType = Brew_Config.GUI_Status_Font or "Brew_StatusFont"
local FontColour = Brew_Config.GUI_Font_mainColour or Color(255, 255, 255, 255)
local FontColourShadow = Brew_Config.GUI_Font_shadowColour or Color(0, 0, 0, 255)
local FrameCurve = Brew_Config.GUI_Status_Curve or 2

local PrimaryColour = Brew_Config.GUI_Status_Foreground or Color(120,120,120, 125)
local BorderColour = Brew_Config.GUI_Status_Border or Color(0,0,0, 125)

timer.Create("Brew_UpdateStatuses", 1, 0, function()
    if #status_active_effects < 1 then timer.Pause("Brew_UpdateStatuses") return end
    UpdateTimers()
end)

function Brew_DrawStatus(effect, tier, timelimit)

    local height = 80 * (#status_active_effects + 1)

    if timer.TimeLeft("Brew_UpdateStatuses") < 0 then timer.Start("Brew_UpdateStatuses") end

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
    table.insert(status_active_effects, statusFrame)

    statusFrame.OnClose = function () 
        print("Status expired!")

        if #status_active_effects < 1 then timer.Pause("Brew_UpdateStatuses") end
    end

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

    for k, v in ipairs(status_active_effects) do

        local height = 80 * k
        
        v:SetPos(ScrW() * 1740/1920, ScrH() * height/1080)

    end


end

function UpdateTimers()

    for _, v in ipairs(status_active_effects) do
        
        for __, k in ipairs(v:GetChildren()) do

            if k:GetName() == "DLabel" and tonumber(k:GetText(), "10") then
                if tonumber(k:GetText(), "10") == 0 then Brew_RemoveStatus(v) return end
                k:SetText(tonumber(k:GetText(), "10") - 1)
            end

        end


    end


end

function Brew_RemoveStatus(frame)

    net.Start("brew_clear_single_effect")
        net.WriteString("speed")
    net.SendToServer()

    table.RemoveByValue(status_active_effects, frame)
    frame:Close()
    UpdatePositions()


end

function CapitalizeFirstLetter(text)

    return (text:gsub("^%l", string.upper))

end

--[[
    Script taken from https://gist.github.com/efrederickson/4080372
    This function just converts a given number into roman numerals mainly for the tier of a potion. 
]]--

function NumberToNumeral(input)
        
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

    input = tonumber(input)
    if not input or input ~= input then error"Unable to convert to number" end
    if input == math.huge then error"Unable to convert infinity" end
    input = math.floor(input)
    if input <= 0 then return input end
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