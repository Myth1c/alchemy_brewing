TOOL.Category = "Brewing Mod"
TOOL.Name = "#tool.ingredient_spawner.name"
TOOL.Command = "gmod_toolmode ingredient_spawner"
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
 
function TOOL:LeftClick( trace )
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
 
function TOOL:RightClick( trace )
	if SERVER then
		local ent = trace.Entity

		local Reagents = self:DetermineSpawnParameters(trace)

		if ent:GetClass() == "spawner_platform" then
			DebugPrint("Add to persistance file")
		elseif trace.HitWorld then

			local spawner = ents.Create("spawner_platform")
			spawner:SetPos(trace.HitPos)
			spawner.Reagents = Reagents
			spawner:Spawn()
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



--[[
	Language Adds
]]-- 
if CLIENT then
	language.Add("tool.ingredient_spawner.name", "Ingredient Modifier")
	language.Add("tool.ingredient_spawner.desc", "Spawn, Update, or make ingredients persistant!")
	language.Add("tool.ingredient_spawner.left", "Spawn/Update ingredient with selected settings")
	language.Add("tool.ingredient_spawner.right", "Create spawner platform. Right click a platform to make it persistant.")
	language.Add("tool.ingredient_spawner.reload", "Remove ingredient from map and remove persistance")

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