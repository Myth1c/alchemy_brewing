ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Empty Grave"
ENT.Author = "Mythic"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "Alchemy Lab"

function ENT:SetupDataTables()

	self:NetworkVar("Entity", 0, "Owner")
	self:NetworkVar("Bool", 1, "Pickup")

	if SERVER then
		self:SetOwner(nil)
		self:SetPickup(false)
	end


end