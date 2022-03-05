BREWING_DEBUG = Brew_Config.BREWING_DEBUG or { Enabled = 1 }

function DebugPrint(message)
    if BREWING_DEBUG.Enabled ~= 1 then return end
    
    print(message)

end

function DebugPrintTable(table)
    if BREWING_DEBUG.Enabled ~= 1 then return end

    PrintTable(table)
end