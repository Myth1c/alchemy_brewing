if SERVER then

    function Effects_NoEffect(ply, pot)

        DebugPrint("No effect to give to: " .. ply)

    end
    
    function Effects_Speed(ply, pot)

        DebugPrint("Applying speed to: " .. ply)
        
	    pot:PotionNetworkMessage(ply, "speed", 1, 10)

    end



else

end