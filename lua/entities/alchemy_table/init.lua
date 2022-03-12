--init.lua
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

function ENT:Initialize()
	
	
	self:SetModel("models/props_c17/FurnitureTable003a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self:SetUseType(SIMPLE_USE)
	self:Activate()

	self:SetPos(self:GetPos() + Vector(0, 0, 50))
	self:DropToFloor()

end

function ENT:Use( ent, ply )

	
	self:TableNetworkMessage("brewUI", ply, self)


end