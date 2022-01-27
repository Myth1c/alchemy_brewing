--cl_init

include("sh_init.lua")

function ENT:Draw()
	self:DrawModel()
end


net.Receive("open_brewUI", function(ply, len)   

	if net.ReadString() ~= "brewUI" then return end

	if not IsValid(brewFrame) then DrawBrewing() end

end)