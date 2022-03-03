if SERVER then
    
    local Players_NoFallDmg = {}

    local Players_Overhealed = {}

    --[[
        Default function for when a potion gives no effects. This is meant for failed brews.
    ]]--
    function Effects_NoEffect(ply, pot)

        DebugPrint("No effect to give to: " .. tostring(ply))

    end

    function Effects_TestEffect(ply, pot, tier)

        
	    pot:PotionNetworkMessage(ply, "Test 1", 0, 25)
        
	    pot:PotionNetworkMessage(ply, "Test 2", 0, 18)

	    pot:PotionNetworkMessage(ply, "Test 3", 0, 69)

	    pot:PotionNetworkMessage(ply, "Test 4", 0, 420)
	    pot:PotionNetworkMessage(ply, "Test 5", 0, 82)
	    pot:PotionNetworkMessage(ply, "Test 6", 0, 87)

    end
    
    --[[
        This function handles applying the speed effect to the player.
    ]]--
    function Effects_Speed(ply, pot, tier)

        local timeBase = Brew_Config.Effect_Speed_TimeLimit_Base or 10
        local timeMult = Brew_Config.Effect_Speed_TimeLimit_Multiplier or 1
        local boostBase = Brew_Config.Effect_Speed_SpeedBoost_Base or 1
        local boostMult = Brew_Config.Effect_Speed_SpeedBoost_Multiplier or 0.25
        local defaultSpeed = Brew_Config.Effect_DefaultRunSpeed or 400



        local time = timeBase * (timeMult * tier)

        local boost = boostBase + (boostMult * tier)

        DebugPrint("Applying speed to: " .. tostring(ply) .. "\nTier: " .. tier .. "\nTime Limit: " .. time .. "\nSpeed Multiplier: " .. boost)
        
	    pot:PotionNetworkMessage(ply, "speed", tier, time)

        ply:SetRunSpeed(defaultSpeed * boost)


    end

    --[[
        Applies a leaping/jump boost effect to the player.
    ]]--
    function Effects_Leaping(ply, pot, tier)
        
        local timeBase = Brew_Config.Effect_Leaping_TimeLimit_Base or 10
        local timeMult = Brew_Config.Effect_Leaping_TimeLimit_Multiplier or 1
        local boostBase = Brew_Config.Effect_Leaping_JumpBoost_Base or 1
        local boostMult = Brew_Config.Effect_Leaping_JumpBoost_Multiplier or 0.25
        local defaultJump = Brew_Config.Effect_DefaultJumpPower or 280



        local time = timeBase * (timeMult * tier)

        local boost = boostBase + (boostMult * tier)

        DebugPrint("Applying leaping to: " .. tostring(ply) .. "\nTier: " .. tier .. "\nTime Limit: " .. time .. "\nJump Multiplier: " .. boost)
        
	    pot:PotionNetworkMessage(ply, "leaping", tier, time)

        ply:SetJumpPower(defaultJump * boost)

        if !table.HasValue(Players_NoFallDmg, ply) then table.insert(Players_NoFallDmg, ply) end

        
    end

    --[[
        Heals the player and if enabled will apply/decay overheal.
    ]]--
    function Effects_Healing(ply, pot, tier)

        local shouldDecay = Brew_Config.Effect_Overheal_Decay or true
        local boostBase = Brew_Config.Effect_Healing_Amount or 25
        local decayMax = Brew_Config.Effect_Overheal_DecayMaxHP or 200
        local decayRate = Brew_Config.Effect_Overheal_DecayRate or 3
        local decayStart = Brew_Config.Effect_Overheal_DecayStart or 100
        local maxHP = Brew_Config.Effect_Healing_MaxHP or 125



        local time = 0

        local boost = boostBase * tier

        DebugPrint("Applying healing to: " .. tostring(ply) .. "\nTier: " .. tier .. "\nTime Limit: " .. time .. "\nHealth Given: " .. boost)

        
        if shouldDecay then

            local plyHP = ply:Health()

            ply:SetHealth( math.Clamp(plyHP + boost, 1, decayMax))

            if ply:Health() > decayStart then
                time = (ply:Health() - decayStart) * decayRate
                if !table.HasValue(Players_Overhealed, ply) then table.insert(Players_Overhealed, ply) end
                if timer.TimeLeft("Decay_Overheal") < 0 then timer.Start("Decay_Overheal") end

                pot:PotionNetworkMessage(ply, "overheal", 0, time)
            end
        else
            
            ply:SetHealth( math.Clamp(plyHP + boost, 1, maxHP))
        end

        

    end

    function Effects_Shield(ply, pot, tier)

        local shieldBase = Brew_Config.Effect_Shield_Base or 25
        local maxArmor = Brew_Config.Effect_Shield_Max or 100

        local time = 0
        local boost = 25 * tier
        
        DebugPrint("Applying Shields to: " .. tostring(ply) .. "\nTier: " .. tier .. "\nTime Limit: " .. time .. "\nShields Given: " .. boost)


        ply:SetArmor(math.Clamp(ply:Armor() + boost, 1, maxArmor))


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
    
        local defaultRunSpeed = Brew_Config.Effect_DefaultRunSpeed or 400
        local defaultJumpPow = Brew_Config.Effect_DefaultJumpPower or 280

        local effect = net.ReadString()

        if effect == "speed" then

            ply:SetRunSpeed(defaultRunSpeed)
        elseif effect == "leaping" then

            ply:SetJumpPower(defaultJumpPow)
            table.RemoveByValue(Players_NoFallDmg, ply)
        end
    
    end)






    --[[
        Meant for the "clear all" command mentioned above. This will just be used to clear every effect from the player.
        Making it a function allows for me to potentially make negative effects that people can clear using antidotes with this function.
    ]]--
    function ClearEffects(player)

        local defaultRunSpeed = Brew_Config.Effect_DefaultRunSpeed or 400
        local defaultJumpPow = Brew_Config.Effect_DefaultJumpPower or 280

        player:SetRunSpeed(defaultRunSpeed)

        player:SetJumpPower(defaultJumpPow)
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

    timer.Create("Decay_Overheal", (Brew_Config.Effect_Overheal_DecayRate or 3), 0, function() 
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