--init.lua

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

ENT.Reagents = 
{
	["speed"] = 0,
    ["leaping"] = 0,
    ["healing"] = 0,
    ["shield"] = 0,
}

local EffectFunctions = 
{
    ["speed"] = Effects_Speed,
    ["leaping"] = Effects_Leaping,
    ["healing"] = Effects_Healing,
    ["shield"] = Effects_Shield,
}

local potionModels = {
	"models/sohald_spike/props/potion_1.mdl",
	"models/sohald_spike/props/potion_2.mdl",
	"models/sohald_spike/props/potion_3.mdl",
	"models/sohald_spike/props/potion_4.mdl",
	"models/sohald_spike/props/potion_5.mdl",
}

local modelIndexes = {
	
    ["speed"] = 5,
    ["leaping"] = 6,
    ["healing"] = 1,
    ["shield"] = 4,

}




function ENT:Initialize()


	local mainEffect = self:DetermineGreatestReagent()

	local model = table.Random(potionModels)

	self:SetModel(model)

	self:SetSkin(modelIndexes[mainEffect] or 7)

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
	
	if !caller:KeyDown(4) then
		
		self:RunEffect(caller)
	
		self:Remove()
	else
		DebugPrint("Storing potion: " .. tostring(self))
		self:StorePotNetworkMessage("brew_store_ent", caller, self, self.Reagents)
		
		self:Remove()
	end


	
end

function ENT:RunEffect(ply)

	DebugPrint("Running effects on: " .. tostring(ply) .. "\nReagents are: ")
	DebugPrintTable(self.Reagents)

	for k, v in pairs(self.Reagents) do

		if v > 0 then
			
			EffectFunctions[k](ply, self, self:ConvertToTiers(v))

		end

	end

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