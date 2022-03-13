--cl_init

include("sh_init.lua")

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()
	
	if LocalPlayer():Alive() and LocalPlayer():GetPos():Distance(self:GetPos()) < 100 and self.Reagents ~= nil
	and LocalPlayer():GetEyeTrace().Entity == self and (LocalPlayer():GetActiveWeapon():GetClass() == "ingredient_picker" or false) then

		local Pos = self:GetPos()
		local Ang = self:GetAngles()
		

		local font = "HudSelectionText"
		local scrHeight = 18
		local count = 0
		local nextHeight = -10
		
		Ang.y = LocalPlayer():EyeAngles().y - 90
		Ang.z = LocalPlayer():EyeAngles().z + 90
		Ang.x = 0
		
		for k, v in pairs(self.Reagents) do
			if v > 0 then
				count = count + 1
			end
		end

		scrHeight = (18 * count)

		cam.Start3D2D(Pos + Vector(0, 0, 20), Ang, .1)

			draw.RoundedBoxEx( 2, -75, -30, 150, 20, Color(120, 120, 120, 125), true, true, false, false)
			draw.SimpleTextOutlined("Potion details", font, 0, -28, Color(255, 255, 255, 255), 1, 3, 1.25, Color( 0, 0, 0, 255 ) )
			draw.RoundedBoxEx( 0, -75, -10, 150, scrHeight, Color(72, 72, 72, 125), false, false, true, true)

			for k, v in pairs(self.Reagents) do
				
				if v > 0 then
					draw.SimpleTextOutlined(k .. " " ..  NumberToNumeral(self:ConvertToTiers(v)), font, 0, nextHeight, Color(255, 255, 255, 255), 1, 0, 1.25, Color( 0, 0, 0, 255 ) )
					

					nextHeight = nextHeight + 18
				end

			end

		cam.End3D2D()


	end

end

