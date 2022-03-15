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
 
function TOOL:LeftClick( trace )
	if SERVER then
		local ent = trace.Entity
	
		local Reagents = {
			["healing"] = tonumber(self:GetClientInfo("healing")),
			["leaping"] = tonumber(self:GetClientInfo("leaping")),
			["shield"] = tonumber(self:GetClientInfo("shield")),
			["speed"] = tonumber(self:GetClientInfo("speed"))
		}
		
		if self:GetClientInfo("randomize") == "1" then
			DebugPrint("Randomizing ingredients...")
			for k, v in pairs(Reagents) do
				
				Reagents[k] = math.random(tonumber(self:GetClientInfo("randomize_min")), tonumber(self:GetClientInfo("randomize_max")))

			end
		end

		if ent:GetClass() == "inert_ingredient" then 
			ent.Reagents = Reagents
			
		elseif trace.HitWorld then
			local newEnt = ents.Create("inert_ingredient")
			newEnt:SetPos(trace.HitPos)
			newEnt.Reagents = Reagents
			newEnt:Spawn()
			undo.Create("#tool.ingredient_spawner.undo_message")
				undo.AddEntity(newEnt)
				undo.SetPlayer(self:GetOwner())
			undo.Finish()
		end
	end	

end
 
function TOOL:RightClick( trace )

	local ent = trace.Entity

	if ent:GetClass() == "inert_ingredient" then
		DebugPrint("Add to persistance file")
	else
		DebugPrint("Spawn AND add to persistance file")
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
	panel:AddControl("Header", { Text = "header", Description = "#tool.ingredient_spawner.headerDescription" })

	panel:AddControl("Header", { Text = "randomizeHeader", Description = "#tool.ingredient_spawner.randomizeHeader" })
	panel:AddControl("Checkbox", {Label = "#tool.ingredient_spawner.randomize", Command = "ingredient_spawner_randomize"})
	panel:AddControl("Slider", { Label = "#tool.ingredient_spawner.randomize_min", Min = "0", Max = "99", Command = "ingredient_spawner_randomize_min" })
	panel:AddControl("Slider", { Label = "#tool.ingredient_spawner.randomize_max", Min = "1", Max = "100", Command = "ingredient_spawner_randomize_max" })

	panel:AddControl("Checkbox", {Label = "#tool.ingredient_spawner.reroll", Command = "ingredient_spawner_reroll"})
 
	panel:AddControl("Header", { Text = "reagentHeader", Description = "#tool.ingredient_spawner.reagentHeader" })
	panel:AddControl("Slider", { Label = "#tool.ingredient_spawner.healing", Min = "0", Max = "100", Command = "ingredient_spawner_healing" })
	panel:AddControl("Slider", { Label = "#tool.ingredient_spawner.leaping", Min = "0", Max = "100", Command = "ingredient_spawner_leaping" })
	panel:AddControl("Slider", { Label = "#tool.ingredient_spawner.shield", Min = "0", Max = "100", Command = "ingredient_spawner_shield" })
	panel:AddControl("Slider", { Label = "#tool.ingredient_spawner.speed", Min = "0", Max = "100", Command = "ingredient_spawner_speed" })
end




--[[
	Language Adds
]]-- 
if CLIENT then
	language.Add("tool.ingredient_spawner.name", "Ingredient Modifier")
	language.Add("tool.ingredient_spawner.desc", "Spawn, Update, or make ingredients persistant!")
	language.Add("tool.ingredient_spawner.left", "Spawn/Update ingredient with selected settings")
	language.Add("tool.ingredient_spawner.right", "Spawn/Make targeted ingredient persistant")
	language.Add("tool.ingredient_spawner.reload", "Remove ingredient from map and remove persistance")
	
	language.Add("tool.ingredient_spawner.headerDescription", "Ingredient Modifier")

	language.Add("tool.ingredient_spawner.randomizeHeader", "Reagent Randomizer Options")
	language.Add("tool.ingredient_spawner.randomize", "Randomize ingredients?")
	language.Add("tool.ingredient_spawner.randomize_min", "Minimum value for randomizer")
	language.Add("tool.ingredient_spawner.randomize_max", "Max value for randomizer")

	language.Add("tool.ingredient_spawner.reroll", "Re-roll ingredients?")

	language.Add("tool.ingredient_spawner.reagentHeader", "Manual Options")
	language.Add("tool.ingredient_spawner.healing", "Healing Reagent")
	language.Add("tool.ingredient_spawner.leaping", "Leaping Reagent")
	language.Add("tool.ingredient_spawner.shield", "Shield Reagent")
	language.Add("tool.ingredient_spawner.speed", "Speed Reagent")

	
	language.Add("tool.ingredient_spawner.undo_message", "spawned ingredient")
end