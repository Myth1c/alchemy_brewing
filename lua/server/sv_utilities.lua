
net.Receive("brew_player_died", function(len, ply) 

    DebugPrint(tostring(ply) .. " has died and should drop their inventory.")

end)