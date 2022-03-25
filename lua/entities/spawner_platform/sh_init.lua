ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Spawn Platform"
ENT.Author = "Mythic"
ENT.Spawnable = false
ENT.AdminSpawnable = true
ENT.Category = "Alchemy Lab"

function ENT:SetupDataTables()

	self:NetworkVar("Bool", 0, "CustomModel")

	if SERVER then
		self:SetCustomModel(false)
	end


end