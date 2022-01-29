--cl_init

include("sh_init.lua")

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()

end


net.Receive("brew_draw_StatusUI", function(len, ply)



	Brew_DrawStatus(net.ReadString(), net.ReadInt(32), net.ReadInt(32))


end)