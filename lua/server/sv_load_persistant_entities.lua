
function LoadPersistance()
    local mapName = game.GetMap()
    local fileName = mapName .. ".json"
    local filePath = "brewingmod/" .. fileName


    if file.Exists(filePath, "DATA") then

        DebugPrint("File " .. filePath .. " Loaded")

        local json = file.Read(filePath, "DATA")
        local table = util.JSONToTable(json)

        

        for k, v in pairs(table) do

            local class = nil
            local pos = nil
            local reagents = nil

            if k ~= "count" then

                for h, j in pairs(v) do

                    if h == "class" then class = j
                    elseif h == "pos" then pos = j
                    elseif h == "reagents" then reagents = j 
                    end

                end

                DebugPrint("Spawning: " .. k .. "\nPosition: " .. tostring(pos) .. "\nReagents are:")
                DebugPrintTable(reagents or {})

                local ent = ents.Create(tostring(class))
                ent:SetPos(pos)
                ent.Reagents = reagents
                ent:Spawn()

            end



        end


    end
end


hook.Add("PostCleanupMap", "RespawnSpawners", function() LoadPersistance() end)
hook.Add("InitPostEntity", "SpawnSpawners", function() LoadPersistance() end)
