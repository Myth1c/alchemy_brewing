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


function ENT:Initialize()
	self:SetModel("models/Gibs/HGIBS.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self:SetUseType(SIMPLE_USE)

	if self.Reagents["speed"] == 0 and self.Reagents["leaping"] == 0 and 
	self.Reagents["healing"] == 0 and self.Reagents["shield"] == 0 then
		
		local distribution = 25

		for k, v in pairs(self.Reagents) do

			self.Reagents[k] = math.random(0, distribution)

			distribution = distribution - self.Reagents[k]

		end
	end
	
end

function ENT:Use( activator, caller )
	

	self:IngredNetworkMessage("brew_store_ent", caller, self, self.Reagents)

	self:Remove()

	
end