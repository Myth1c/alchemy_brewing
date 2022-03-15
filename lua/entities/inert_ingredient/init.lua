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
		
		self:RollReagents()

	else
		local greatest = self:DetermineGreatestReagent()
	end

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self:SetUseType(SIMPLE_USE)
	
	self:SetPos(self:GetPos() + Vector(0, 0, 50))
	self:DropToFloor()
	
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

	local mdl = self.ModelTable[key]

	self:SetModel(mdl)

	return key

end

function ENT:RollReagents()

	self.Reagents = { ["speed"] = 0, ["leaping"] = 0, ["healing"] = 0, ["shield"] = 0 }

	local distribution = 3

	local index = { "healing", "leaping", "shield", "speed" }
	
	local randReagent = index[math.random(1, 4)]

	self.Reagents[randReagent] = math.random(1, distribution)

	distribution = math.Clamp(distribution - self.Reagents[randReagent], 0, distribution)

	self:DetermineGreatestReagent()

end