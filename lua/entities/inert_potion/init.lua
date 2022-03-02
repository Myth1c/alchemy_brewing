--init.lua

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

ENT.EffectFunction = 
{
	Effects_Speed,
	Effects_Leaping,
	Effects_Healing,
}


function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_plasticbottle001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self:SetUseType(SIMPLE_USE)
	
end

function ENT:Use( activator, caller )
	
	self:RunEffect(caller)

	self:Remove()

	
end

function ENT:RunEffect(ply)

	for i=1, #self.EffectFunction, 1 do

		local effect = self.EffectFunction[i]

		if effect ~= nil then effect(ply, self, 1) end

	end

end
