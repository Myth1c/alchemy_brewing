local debug = CONFIG.DEBUG or true

function DebugPrint(message)
    if not debug then return end
    
    print(message)

end