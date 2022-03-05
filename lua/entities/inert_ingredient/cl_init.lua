--cl_init

include("sh_init.lua")

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()

end


net.Receive("brew_store_Entity", function(len, ply) 

	if net.ReadString() ~= "brew_store_ent" then return end
	local ent = net.ReadEntity()
	local tbl = net.ReadTable()

	DebugPrint("Sending " .. tostring(ent:GetClass()) .. " to client.\nEntity Model: " .. tostring(ent:GetModel()) .. "\nReagents in the ingredient: ")
	DebugPrintTable(tbl)

	CreateEntForStorage(ent:GetClass(), ent:GetModel(), tbl)





end)