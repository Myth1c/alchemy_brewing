--cl_init

include("sh_init.lua")

function ENT:Draw()

    self:DrawShadow(false)

    if LocalPlayer():GetTool().Command == "gmod_toolmode ingredient_spawner" and LocalPlayer():GetActiveWeapon():GetClass() == "gmod_tool" then

	    self:DrawModel()

    end
end
