--init.lua

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

ENT.Reagents = {

	["speed"] = 1,
    ["leaping"] = 2,
    ["healing"] = 3,
    ["shield"] = 4,

}


function ENT:Initialize()
	self:SetModel("models/Gibs/HGIBS.mdl")
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