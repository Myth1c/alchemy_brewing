if SERVER then

    function Effects_NoEffect(ply, pot)

        DebugPrint("No effect to give to: " .. tostring(ply))

    end
    
    function Effects_Speed(ply, pot, tier, time)

        DebugPrint("Applying speed to: " .. tostring(ply) .. "\nTier: " .. tier .. "\nTime Limit: " .. time)
        
	    pot:PotionNetworkMessage(ply, "speed", tier, time)

        ply:SetRunSpeed(ply:GetRunSpeed() * 1.5)

        --timer.Simple(time, function() ply:SetRunSpeed(ply:GetRunSpeed() / 1.5) end)

    end

    net.Receive("brew_effect_cleared", function(len, ply)
    
        DebugPrint("Removing all effects from:" .. tostring(ply))

        ClearEffects(ply)
    
    end)

    net.Receive("brew_clear_single_effect", function(len, ply)
    
        print("Net message received to clear an effect.")

        local effect = net.ReadString()

        if effect == "speed" then
            ply:SetRunSpeed(ply:GetRunSpeed() / 1.5)
        end
    
    end)






    function ClearEffects(player)

        ply:SetRunSpeed(ply:GetRunSpeed() / 1.5)

    end



else

end