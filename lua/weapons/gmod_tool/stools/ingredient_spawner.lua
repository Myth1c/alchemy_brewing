TOOL.Category = "Brewing Mod"
TOOL.Name = "#ingredient_spawner"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.Information = {
	{name = "left"},
	{name = "right"},
	{name = "reload"}
}


TOOL.ClientConVar[ "healing" ] = 0
TOOL.ClientConVar[ "leaping" ] = 0
TOOL.ClientConVar[ "shield" ] = 0
TOOL.ClientConVar[ "speed" ] = 0
TOOL.ClientConVar[ "randomize" ] = 0
TOOL.ClientConVar[ "randomize_min" ] = 0
TOOL.ClientConVar[ "randomize_max" ] = 0
TOOL.ClientConVar[ "reroll" ] = 0
TOOL.ClientConVar[ "manual" ] = 0
 
function TOOL:RightClick( trace )
	if SERVER then
		local ent = trace.Entity

		local Reagents = self:DetermineSpawnParameters(trace)

		if ent:GetClass() == "inert_ingredient" then 
			if self:GetClientInfo("reroll") == "1" then
				self:SpawnNewIngredient(trace, nil, ent)
			elseif self:GetClientInfo("manual") == "1" or self:GetClientInfo("randomize") == "1" then
				self:SpawnNewIngredient(trace, Reagents, ent)
			end
			
		elseif trace.HitWorld then
			local tbl = nil
			if self:GetClientInfo("manual") == "1" or self:GetClientInfo("randomize") == "1" then tbl = Reagents end

			local newEnt = self:SpawnNewIngredient(trace, tbl, nil)
			undo.Create("#tool.ingredient_spawner.undo_message")
				undo.AddEntity(newEnt)
				undo.SetPlayer(self:GetOwner())
			undo.Finish()
		end
	end	

end
 
function TOOL:LeftClick( trace )
	if SERVER then
		local ent = trace.Entity

		local Reagents = self:DetermineSpawnParameters(trace)

		if ent:GetClass() == "spawner_platform" then
			DebugPrint("Add to persistance file")
			self:SaveToFile(ent)
		elseif trace.HitWorld then

			local spawner = ents.Create("spawner_platform")
			spawner:SetPos(trace.HitPos)
			spawner.Reagents = Reagents
			spawner:Spawn()
			undo.Create("#tool.ingredient_spawner.undo_message_platform")
				undo.AddEntity(spawner)
				undo.SetPlayer(self:GetOwner())
			undo.Finish()

		elseif ent:GetClass() == "prop_physics" then
			local spawner = ents.Create("spawner_platform")
			spawner:SetPos(ent:GetPos())
			spawner.Reagents = Reagents
			spawner:SetCustomModel(true)
			spawner:Spawn()
			spawner:SetModel(ent:GetModel())
			spawner:SetAngles(ent:GetAngles())
			ent:Remove()
			undo.Create("#tool.ingredient_spawner.undo_message_platform")
				undo.AddEntity(spawner)
				undo.SetPlayer(self:GetOwner())
			undo.Finish()
		end
	end
end

function TOOL:Reload( trace )

	if SERVER then
		local ent = trace.Entity

		if ent:GetClass() == "inert_ingredient" then 
			ent:Remove()
		elseif ent:GetClass() == "spawner_platform" then
			ent:Remove()
			self:RemovePersistance(ent)
		elseif trace.HitWorld then
			DebugPrint("Printing Debug info for client settings")
			DebugPrint("Randomize is set to: " .. self:GetClientInfo("randomize"))
			DebugPrint("Healing slider is set to: " .. self:GetClientInfo("healing"))
			DebugPrint("Leaping slider is set to: " .. self:GetClientInfo("leaping"))
			DebugPrint("Shield slider is set to: " .. self:GetClientInfo("shield"))
			DebugPrint("Speed slider is set to: " .. self:GetClientInfo("speed"))
		end




	end

end
 
function TOOL.BuildCPanel( panel )

	panel:AddControl("Header", { Text = "rerollHeader", Description = "#tool.ingredient_spawner.rerollHeader" })
	panel:AddControl("Checkbox", {Label = "#tool.ingredient_spawner.reroll", Command = "ingredient_spawner_reroll", help = true})

	panel:AddControl("Header", { Text = "randomizeHeader", Description = "#tool.ingredient_spawner.randomizeHeader" })
	panel:AddControl("Checkbox", {Label = "#tool.ingredient_spawner.randomize", Command = "ingredient_spawner_randomize", help = true})
	panel:AddControl("Slider", { Label = "#tool.ingredient_spawner.randomize_min", Min = "0", Max = "99", Command = "ingredient_spawner_randomize_min" })
	panel:AddControl("Slider", { Label = "#tool.ingredient_spawner.randomize_max", Min = "1", Max = "100", Command = "ingredient_spawner_randomize_max" })
 
	panel:AddControl("Header", { Text = "reagentHeader", Description = "#tool.ingredient_spawner.reagentHeader" })
	panel:AddControl("Checkbox", {Label = "#tool.ingredient_spawner.manual", Command = "ingredient_spawner_manual", help = true})
	panel:AddControl("Slider", { Label = "#tool.ingredient_spawner.healing", Min = "0", Max = "100", Command = "ingredient_spawner_healing" })
	panel:AddControl("Slider", { Label = "#tool.ingredient_spawner.leaping", Min = "0", Max = "100", Command = "ingredient_spawner_leaping" })
	panel:AddControl("Slider", { Label = "#tool.ingredient_spawner.shield", Min = "0", Max = "100", Command = "ingredient_spawner_shield" })
	panel:AddControl("Slider", { Label = "#tool.ingredient_spawner.speed", Min = "0", Max = "100", Command = "ingredient_spawner_speed" })
end


function TOOL:SpawnNewIngredient(trace, tbl, oldEnt)

	local pos = trace.HitPos
	if oldEnt ~= nil then
		pos = oldEnt:GetPos()
		oldEnt:Remove()
	end

	local newEnt = ents.Create("inert_ingredient")
	newEnt:SetPos(pos)
	if tbl ~= nil then newEnt.Reagents = tbl end
	newEnt:Spawn()
	
	DebugPrint("Entity " .. tostring(newEnt) .. "\nModel: " .. tostring(newEnt:GetModel()) .. "\nReagents: ")
	DebugPrintTable(newEnt.Reagents)

	return newEnt

end

function TOOL:DetermineSpawnParameters(trace)
	
	local Reagents = {
		["healing"] = 0,
		["leaping"] = 0,
		["shield"] = 0,
		["speed"] = 0
	}

	if self:GetClientInfo("manual") == "1" then
		for k, v in pairs(Reagents) do
			Reagents[k] = tonumber(self:GetClientInfo(k))
		end
	end

	
	if self:GetClientInfo("randomize") == "1" then
		DebugPrint("Randomizing ingredients...")
		for k, v in pairs(Reagents) do
			
			Reagents[k] = math.random(tonumber(self:GetClientInfo("randomize_min")), tonumber(self:GetClientInfo("randomize_max")))

		end

		DebugPrint("New reagents are: ")
		DebugPrintTable(Reagents)
	end

	return Reagents
end

function TOOL:SaveToFile(ent)
	if SERVER then
		local mapName = game.GetMap()
		local fileName = mapName .. ".json"
		local filePath = "brewingmod/" .. fileName
		if !file.Exists(filePath, "DATA") then
			DebugPrint("No persistance file found. Creating one.")
			local StoredEnts = {["count"] = 0}

			file.CreateDir("BrewingMod")
			file.Write(filePath, util.TableToJSON(StoredEnts, true))
		end

		local json = file.Read(filePath, "DATA")
		local tab = util.JSONToTable(json)

		for k, v in pairs(tab) do
			DebugPrint(k)
			if k ~= "count" then
				for h, j in pairs(v) do
					if h == "pos" then

						if j:DistToSqr(ent:GetPos()) < 2500 then DebugPrint("Entity is already in table!") return end
					end
				end
			end

		end


		local entTable = {
			["class"] = ent:GetClass(),
			["pos"] = ent:GetPos(),
			["reagents"] = ent.Reagents,
			["model"] = ent:GetModel(),
			["angles"] = ent:GetAngles(),
		}

		local index = tab["count"] + 1
		tab[ent:GetClass() .. " " .. index] = entTable

		tab["count"] = tab["count"] + 1

		json = util.TableToJSON(tab, true)

		file.Write(filePath, json)

	end
end

function TOOL:RemovePersistance(ent)

	DebugPrint("Removing " .. tostring(ent) .. " from persistance." )

	local mapName = game.GetMap()
    local fileName = mapName .. ".json"
    local filePath = "brewingmod/" .. fileName

	local entTable = {
		["class"] = ent:GetClass(),
		["pos"] = ent:GetPos(),
		["reagents"] = ent.Reagents,
		["model"] = ent:GetModel(),
		["angles"] = ent:GetAngles(),
	}

    if file.Exists(filePath, "DATA") then

        local json = file.Read(filePath, "DATA")
        local tab = util.JSONToTable(json)

        for k, v in pairs(tab) do

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


				if entTable["class"] == class and entTable["pos"] == pos then


					local equal = true
					for x, y in pairs(reagents) do

						if y ~= entTable["reagents"][x] then
							equal = false
						end

					end
					if equal then

						tab[k] = nil

						tab["count"] = tab["count"] - 1
					end
					break

				end

            end


        end

		json = util.TableToJSON(tab, true)

		file.Write(filePath, json)


    end

end



--[[
	Language Adds
]]-- 
if CLIENT then
	language.Add("ingredient_spawner", "Ingredient Spawner")
	language.Add("tool.ingredient_spawner.name", "Ingredient Spawner")
	language.Add("tool.ingredient_spawner.desc", "Spawn, Update, or make ingredients persistant!")
	language.Add("tool.ingredient_spawner.right", "Spawn/Update ingredient with selected settings")
	language.Add("tool.ingredient_spawner.left", "Create spawner platform. Left click a platform to make it persistant. Left click a prop to convert it into a spawner.")
	language.Add("tool.ingredient_spawner.reload", "Remove Ingredient/Spawner from map and remove from persistance from targeted spawenr")

	language.Add("tool.ingredient_spawner.rerollHeader", "Re-rolls all the reagents in the targeted ingredient with their default parameters")
	language.Add("tool.ingredient_spawner.reroll", "Enable re-roll")
	language.Add("tool.ingredient_spawner.reroll.help", "Does nothing while spawning a new entity.\nTakes priority over all options")
	
	language.Add("tool.ingredient_spawner.randomizeHeader", "The randomizer will randomly set all values between the min and max values set below")
	language.Add("tool.ingredient_spawner.randomize", "Enable Randomize Options")
	language.Add("tool.ingredient_spawner.randomize_min", "Minimum value for randomizer")
	language.Add("tool.ingredient_spawner.randomize_max", "Max value for randomizer")
	language.Add("tool.ingredient_spawner.randomize.help", "Takes priority over manual options")

	language.Add("tool.ingredient_spawner.reagentHeader", "Manual settings will spawn or update an ingredient with the reagents set below")
	language.Add("tool.ingredient_spawner.healing", "Healing Reagent")
	language.Add("tool.ingredient_spawner.leaping", "Leaping Reagent")
	language.Add("tool.ingredient_spawner.shield", "Shield Reagent")
	language.Add("tool.ingredient_spawner.speed", "Speed Reagent")
	language.Add("tool.ingredient_spawner.manual.help", "Both above settings have priority over this")
	language.Add("tool.ingredient_spawner.manual", "Enable manual Options")

	language.Add("tool.ingredient_spawner.undo_message", "spawned ingredient")
	language.Add("tool.ingredient_spawner.undo_message_platform", "spawner platform")
end