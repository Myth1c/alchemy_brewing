--init.lua

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

ENT.Effects = 
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

	for k, v in pairs(self.Effects) do

		if v > 0 then

			EffectFunctions[k](ply, self, v)

		end

	end

end
