--init.lua
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

ENT.StoredInventory = {}

function ENT:Initialize()
	
	
	self:SetModel("models/props_c17/gravestone004a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self:SetUseType(SIMPLE_USE)
	self:Activate()
	self:SetColor(Color(212, 212, 212, 255))

end

function ENT:Use( ent, ply )

	DebugPrintTable(self.StoredInventory)

end