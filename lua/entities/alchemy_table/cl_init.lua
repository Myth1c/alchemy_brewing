--cl_init

include("sh_init.lua")

function ENT:Draw()
	self:DrawModel()


	if IsValid(brewFrame) then

		if math.DistanceSqr(LocalPlayer():GetPos().x, LocalPlayer():GetPos().y, self:GetPos().x, self:GetPos().y) > 9000 then 
			brewFrame:Close()
		end
	end

end


net.Receive("brew_draw_brewUI", function(ply, len)   

	if net.ReadString() ~= "brewUI" then return end

	if not IsValid(brewFrame) then DrawBrewing()
	elseif IsValid(brewFrame) then brewFrame:Close() end

end)