--init.lua
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")


function ENT:Initialize()
	
	
	self:SetModel("models/props_survival/cash/dufflebag.mdl")
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


function ENT:Use(activator)

	if activator ~= self:GetOwner() then return end

	self:SetPickup(true)

    self:EmitSound("ui/item_bag_pickup.wav")

	self:Remove()


end