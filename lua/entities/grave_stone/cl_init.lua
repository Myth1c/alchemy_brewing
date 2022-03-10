--cl_init

include("sh_init.lua")

ENT.StoredInventory = {}

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()

	if self:GetPickup() then
		self:PickupInventory()
	end

end

function ENT:Initialize()

	DebugPrint(tostring(self:GetOwner()) .. " dropped: ")

	if self:GetOwner() ~= LocalPlayer() then return end

	self.StoredInventory = Inv_RequestStorage()

	DebugPrintTable(self.StoredInventory)


end

function ENT:PickupInventory()

	for k, v in ipairs(self.StoredInventory) do

		AddToStorage(v)

	end

	table.Empty(self.StoredInventory)

end