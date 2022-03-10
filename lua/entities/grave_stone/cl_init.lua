--cl_init

include("sh_init.lua")

ENT.StoredInventory = {}

function ENT:Draw()
	self:DrawModel()
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 100 and IsValid(self:GetOwner()) then

		local Pos = self:GetPos()
		local Ang = self:GetAngles()
		
		local font = "HudSelectionText"
		
		Ang.y = LocalPlayer():EyeAngles().y - 90
		Ang.z = LocalPlayer():EyeAngles().z + 90
		Ang.x = 0


		cam.Start3D2D(Pos + Vector(0, 0, 20), Ang, .1)

			draw.RoundedBoxEx( 2, -75, -30, 150, 20, Color(120, 120, 120, 125), true, true, false, false)
			draw.SimpleTextOutlined("Bag Owner", font, 0, -28, Color(255, 255, 255, 255), 1, 3, 1.25, Color( 0, 0, 0, 255 ) )
			draw.RoundedBoxEx( 0, -75, -10, 150, 18, Color(72, 72, 72, 125), false, false, true, true)

			draw.SimpleTextOutlined((self:GetOwner():Nick() or "nil"), font, 0, -10, Color(255, 255, 255, 255), 1, 0, 1.25, Color( 0, 0, 0, 255 ) )


		cam.End3D2D()


	end
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