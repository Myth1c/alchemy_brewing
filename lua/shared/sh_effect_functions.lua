if SERVER then

    function Effects_NoEffect(ply, pot)

        DebugPrint("No effect to give to: " .. tostring(ply))

    end
    
    function Effects_Speed(ply, pot, tier)

        local time = Brew_Config.Effect_Speed_TimeLimit_Base * (Brew_Config.Effect_Speed_TimeLimit_Multiplier * tier)

        local boost = Brew_Config.Effect_Speed_SpeedBoost_Base + (Brew_Config.Effect_Speed_SpeedBoost_Multiplier * tier)

        DebugPrint("Applying speed to: " .. tostring(ply) .. "\nTier: " .. tier .. "\nTime Limit: " .. time .. "\nSpeed Multiplier: " .. boost)
        
	    pot:PotionNetworkMessage(ply, "speed", tier, time)

        ply:SetRunSpeed(ply:GetRunSpeed() * boost)


    end

    net.Receive("brew_effect_cleared", function(len, ply)
    
        DebugPrint("Removing all effects from:" .. tostring(ply))

        ClearEffects(ply)
    
    end)

    net.Receive("brew_clear_single_effect", function(len, ply)
    
        local effect = net.ReadString()

        if effect == "speed" then
            ply:SetRunSpeed(Brew_Config.Effect_DefaultRunSpeed)
        end
    
    end)






    function ClearEffects(player)

        ply:SetRunSpeed(Brew_Config.Effect_DefaultRunSpeed)

    end



else

end