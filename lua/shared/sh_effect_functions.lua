if SERVER then
    
    local Players_NoFallDmg = {}

    local Players_Overhealed = {}

    --[[
        Default function for when a potion gives no effects. This is meant for failed brews.
    ]]--
    function Effects_NoEffect(ply, pot)

        DebugPrint("No effect to give to: " .. tostring(ply))

    end
    
    --[[
        This function handles applying the speed effect to the player.
    ]]--
    function Effects_Speed(ply, pot, tier)

        local time = Brew_Config.Effect_Speed_TimeLimit_Base * (Brew_Config.Effect_Speed_TimeLimit_Multiplier * tier)

        local boost = Brew_Config.Effect_Speed_SpeedBoost_Base + (Brew_Config.Effect_Speed_SpeedBoost_Multiplier * tier)

        DebugPrint("Applying speed to: " .. tostring(ply) .. "\nTier: " .. tier .. "\nTime Limit: " .. time .. "\nSpeed Multiplier: " .. boost)
        
	    pot:PotionNetworkMessage(ply, "speed", tier, time)

        ply:SetRunSpeed(ply:GetRunSpeed() * boost)


    end

    --[[
        Applies a leaping/jump boost effect to the player.
    ]]--
    function Effects_Leaping(ply, pot, tier)

        local time = Brew_Config.Effect_Leaping_TimeLimit_Base * (Brew_Config.Effect_Leaping_TimeLimit_Multiplier * tier)

        local boost = Brew_Config.Effect_Leaping_JumpBoost_Base + (Brew_Config.Effect_Leaping_JumpBoost_Multiplier * tier)

        DebugPrint("Applying leaping to: " .. tostring(ply) .. "\nTier: " .. tier .. "\nTime Limit: " .. time .. "\nJump Multiplier: " .. boost)
        
	    pot:PotionNetworkMessage(ply, "leaping", tier, time)

        ply:SetJumpPower(ply:GetJumpPower() * boost)

        if !table.HasValue(Players_NoFallDmg, ply) then table.insert(Players_NoFallDmg, ply) end

        
    end

    function Effects_Healing(ply, pot, tier)

        local time = 0

        local boost = 25

        DebugPrint("Applying healing to: " .. tostring(ply) .. "\nTier: " .. tier .. "\nTime Limit: " .. time .. "\nHealth Given: " .. boost)

        -- Whether to allow overheal will go here.
        if true then

            local plyHP = ply:Health()

            ply:SetHealth( math.Clamp(plyHP + boost, 1, 150))

            if ply:Health() > 100 then
                time = (ply:Health() - 100) * 3
                if !table.HasValue(Players_Overhealed, ply) then table.insert(Players_Overhealed, ply) end
                if timer.TimeLeft("Decay_Overheal") < 0 then timer.Start("Decay_Overheal") end

                pot:PotionNetworkMessage(ply, "overheal", 0, time)
            end
        else
            
            ply:SetHealth( math.Clamp(plyHP + boost, 1, 100))
        end

        

    end

    --[[
        Currently unused. I plan to implement a command for clearing effects from a given player.
    ]]--
    net.Receive("brew_effect_cleared", function(len, ply)
    
        DebugPrint("Removing all effects from:" .. tostring(ply))

        ClearEffects(ply)
    
    end)

    --[[
        Receives word from the client that an effect should be removed. 
        It will remove whatever effect the client is telling the server to remove.
    ]]--
    net.Receive("brew_clear_single_effect", function(len, ply)
    
        local effect = net.ReadString()

        if effect == "speed" then
            ply:SetRunSpeed(Brew_Config.Effect_DefaultRunSpeed)
        elseif effect == "leaping" then
            ply:SetJumpPower(280)
            table.RemoveByValue(Players_NoFallDmg, ply)
        end
    
    end)






    --[[
        Meant for the "clear all" command mentioned above. This will just be used to clear every effect from the player.
        Making it a function allows for me to potentially make negative effects that people can clear using antidotes with this function.
    ]]--
    function ClearEffects(player)

        player:SetRunSpeed(Brew_Config.Effect_DefaultRunSpeed)

        player:SetJumpPower(280)
        table.RemoveByValue(Players_NoFallDmg, ply)

    end

    --[[
        This hook listens for when a player should take fall damage. It will ONLY override fall damage if the player is under the effect of a leaping potion
        This is so you don't take fall damage when you have a leaping 2 or higher potion applied to you.
    ]]--
    hook.Add("GetFallDamage", "FeatherFalling", function(fallingPlayer, speed)
        for _, v in ipairs(Players_NoFallDmg) do
            if fallingPlayer == v then
                return 0
            end
        end

    end)

    timer.Create("Decay_Overheal", 3, 0, function() 
        if #Players_Overhealed < 1 then timer.Pause("Decay_Overheal") end
        
        for _, v in ipairs(Players_Overhealed) do

            if v:Health() > 100 then
                v:SetHealth(v:Health() - 1)
            else
                table.RemoveByValue(Players_Overhealed, v)
            end

        end
    
    end)

else

end