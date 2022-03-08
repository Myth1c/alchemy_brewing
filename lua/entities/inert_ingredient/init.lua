--init.lua

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

ENT.Reagents = {

	["speed"] = 0,
    ["leaping"] = 0,
    ["healing"] = 0,
    ["shield"] = 0,

}

ENT.ModelTable = {
	
	["speed"] = "models/noesis/donut.mdl",
	["leaping"] = "models/maxofs2d/balloon_classic.mdl",
    ["healing"] = "models/props_junk/watermelon01.mdl",
    ["shield"] = "models/props_moonbase/moon_rock_small001.mdl",

}


function ENT:Initialize()

	if self.Reagents["speed"] == 0 and self.Reagents["leaping"] == 0 and 
	self.Reagents["healing"] == 0 and self.Reagents["shield"] == 0 then
		
		local distribution = 8

		local index = {
			"healing",
			"leaping",
			"shield",
			"speed"
		}
		
		local randReagent = index[math.random(1, 4)]

		self.Reagents[randReagent] = math.random(2, distribution)

		distribution = math.Clamp(distribution - self.Reagents[randReagent], 0, distribution)


		-- for i = 1, 4, 1 do

		-- 	local randReagent = index[math.random(1, 4)]

		-- 	self.Reagents[randReagent] = self.Reagents[randReagent] + math.random(0, distribution)
	
		-- 	distribution = math.Clamp(distribution - self.Reagents[randReagent], 0, distribution)

		-- end

	end

	DebugPrint("Entity " .. tostring(self) .. " created with:")
	DebugPrintTable(self.Reagents)


	local greatest = self:DetermineGreatestReagent()

	DebugPrint("Greatest Reagent: " .. greatest)


	self:SetModel(self.ModelTable[greatest])
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self:SetUseType(SIMPLE_USE)
	
end

function ENT:Use( activator, caller )
	

	self:IngredNetworkMessage("brew_store_ent", caller, self, self.Reagents)

	self:Remove()

	
end

function ENT:DetermineGreatestReagent()

	local greatest = 0
	local key = nil

	for k, v in pairs(self.Reagents) do

		if v > greatest then 
			key = k 
			greatest = v
		end

	end

	return key

end