hook.Add("PostPlayerDeath", "brewing_dead_player", function(victim, inflictor, attacker)

    if !(Brew_Config.Drop_Inventory_On_Death or false) then return end

    DebugPrint(tostring(victim) .. " has died and should drop their inventory.")

    local grave = ents.Create("grave_stone")
    grave:SetPos(victim:GetPos() + Vector(0, 0, 20))
    grave:SetOwner(victim)

    grave:Spawn()


end)

net.Receive("brew_Play_Sound", function(len, ply)

    local ent = net.ReadEntity()
    local sound = net.ReadString()
    local time = net.ReadInt(32)


    ent:EmitSound(sound)
    if ent:GetClass() == "alchemy_table" then
        ent:MoveFlaskToBurner()
    end

    timer.Simple(time, function() 
        
        if IsValid(ent) then
            ent:StopSound(sound)
            if ent:GetClass() == "alchemy_table" then
                ent:MoveFlaskFromBurner()
            end
        end
    end)


end)