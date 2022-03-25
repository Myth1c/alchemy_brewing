--cl_init

include("sh_init.lua")

function ENT:Draw()

    if LocalPlayer():GetTool() == nil or !(LocalPlayer():Alive()) then return end

    if (LocalPlayer():GetTool().Name == "#ingredient_spawner" and LocalPlayer():GetActiveWeapon():GetClass() == "gmod_tool")  or self:GetCustomModel() then

	    self:DrawModel()

    end
end
