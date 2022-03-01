if SERVER then

    function Effects_NoEffect(ply, pot)

        DebugPrint("No effect to give to: " .. ply)

    end
    
    function Effects_Speed(ply, pot, tier, time)

        DebugPrint("Applying speed to: " .. tostring(ply) .. "\nTier: " .. tier .. "\nTime Limit: " .. time)
        
	    pot:PotionNetworkMessage(ply, "speed", tier, time)

        ply:SetRunSpeed(ply:GetRunSpeed() * 1.5)

        Timer.Simple(time, function() ply:SetRunSpeed(ply:GetRunSpeed() * 1.5) end)

    end

    net.Receive("brew_effect_cleared", function(len, ply)
    
        DebugPrint("Removing all effects from:" .. ply)

        ClearEffects(ply)
    
    end)






    function ClearEffects(player)

        ply:SetRunSpeed(ply:GetRunSpeed() / 1.5)

    end



else

end