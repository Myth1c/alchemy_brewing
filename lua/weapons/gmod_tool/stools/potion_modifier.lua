TOOL.Category = "Brewing Mod"
TOOL.Name = "#potion_modifier"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.Information = {
	{name = "left"},
	{name = "right"}
}


TOOL.ClientConVar[ "manual" ] = 0
TOOL.ClientConVar[ "healing" ] = 0
TOOL.ClientConVar[ "leaping" ] = 0
TOOL.ClientConVar[ "shield" ] = 0
TOOL.ClientConVar[ "speed" ] = 0

TOOL.ClientConVar[ "randomize" ] = 0
TOOL.ClientConVar[ "randomize_min" ] = 0
TOOL.ClientConVar[ "randomize_max" ] = 0
 
function TOOL:LeftClick( trace )
	if SERVER then
		local ent = trace.Entity

		local Reagents = self:DetermineSpawnParameters(trace)

		if ent:GetClass() == "inert_ingredient" then 
			if self:GetClientInfo("manual") == "1" or self:GetClientInfo("randomize") == "1" then
				self:SpawnNewIngredient(trace, Reagents, ent)
			end
			
		elseif trace.HitWorld then
			local tbl = nil
			if self:GetClientInfo("manual") == "1" or self:GetClientInfo("randomize") == "1" then tbl = Reagents end

			local newEnt = self:SpawnNewIngredient(trace, tbl, nil)
			undo.Create("#tool.potion_modifier.undo_message")
				undo.AddEntity(newEnt)
				undo.SetPlayer(self:GetOwner())
			undo.Finish()
		end
	end	

end
 
function TOOL:RightClick( trace )
	if SERVER then
		local ent = trace.Entity

		if ent:GetClass() == "inert_potion" then 
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

	panel:AddControl("Header", { Text = "randomizeHeader", Description = "#tool.potion_modifier.randomizeHeader" })
	panel:AddControl("Checkbox", {Label = "#tool.potion_modifier.randomize", Command = "potion_modifier_randomize", help = true})
	panel:AddControl("Slider", { Label = "#tool.potion_modifier.randomize_min", Min = "0", Max = "99", Command = "potion_modifier_randomize_min" })
	panel:AddControl("Slider", { Label = "#tool.potion_modifier.randomize_max", Min = "1", Max = "100", Command = "potion_modifier_randomize_max" })
 
	panel:AddControl("Header", { Text = "reagentHeader", Description = "#tool.potion_modifier.reagentHeader" })
	panel:AddControl("Checkbox", {Label = "#tool.potion_modifier.manual", Command = "potion_modifier_manual", help = true})
	panel:AddControl("Slider", { Label = "#tool.potion_modifier.healing", Min = "0", Max = "100", Command = "potion_modifier_healing" })
	panel:AddControl("Slider", { Label = "#tool.potion_modifier.leaping", Min = "0", Max = "100", Command = "potion_modifier_leaping" })
	panel:AddControl("Slider", { Label = "#tool.potion_modifier.shield", Min = "0", Max = "100", Command = "potion_modifier_shield" })
	panel:AddControl("Slider", { Label = "#tool.potion_modifier.speed", Min = "0", Max = "100", Command = "potion_modifier_speed" })
end


function TOOL:SpawnNewIngredient(trace, tbl, oldEnt)

	local pos = trace.HitPos
	if oldEnt ~= nil then
		pos = oldEnt:GetPos()
		oldEnt:Remove()
	end

	local newEnt = ents.Create("inert_potion")
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
		DebugPrint("Randomizing reagents...")
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
	language.Add("potion_modifier", "Potion Modifier")
	language.Add("tool.potion_modifier.name", "Potion Modifier")
	language.Add("tool.potion_modifier.desc", "Spawn or Update targeted potions")
	language.Add("tool.potion_modifier.left", "Spawn/Update potion with selected settings")
	language.Add("tool.potion_modifier.right", "Remove targeted potion")
	
	language.Add("tool.potion_modifier.randomizeHeader", "The randomizer will randomly set all values between the min and max values set below")
	language.Add("tool.potion_modifier.randomize", "Enable Randomize Options")
	language.Add("tool.potion_modifier.randomize_min", "Minimum value for randomizer")
	language.Add("tool.potion_modifier.randomize_max", "Max value for randomizer")
	language.Add("tool.potion_modifier.randomize.help", "Takes priority over manual options")

	language.Add("tool.potion_modifier.reagentHeader", "Manual settings will spawn or update a potion with the reagents set below")
	language.Add("tool.potion_modifier.healing", "Healing Reagent")
	language.Add("tool.potion_modifier.leaping", "Leaping Reagent")
	language.Add("tool.potion_modifier.shield", "Shield Reagent")
	language.Add("tool.potion_modifier.speed", "Speed Reagent")
	language.Add("tool.potion_modifier.manual.help", "Randomizing has priority over manual settings")
	language.Add("tool.potion_modifier.manual", "Enable manual Options")

	language.Add("tool.potion_modifier.undo_message", "spawned potion")
end