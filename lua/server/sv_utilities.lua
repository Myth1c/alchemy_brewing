hook.Add("PlayerDeath", "brewing_dead_player", function(victim, inflictor, attacker)

    if !(Brew_Config.Drop_Inventory_On_Death or false) then return end

    DebugPrint(tostring(victim) .. " has died and should drop their inventory.")

    local grave = ents.Create("grave_stone")
    grave:SetPos(victim:GetPos() + Vector(0, 0, 20))
    grave:SetOwner(victim)

    grave:Spawn()


end)