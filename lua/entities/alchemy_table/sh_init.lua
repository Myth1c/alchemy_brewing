ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Alchemy Lab"
ENT.Author = "Mythic"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "Alchemy Lab"


function ENT:TableNetworkMessage(type, player)

	net.Start("brew_draw_brewUI")
		net.WriteString(type)
	net.Send(player)


end
if SERVER then
	net.Receive("brew_drop_item", function(len, ply)

		local pos = ply:GetPos() + (ply:GetForward() * 60) + (ply:GetUp() * 30)


		local class = net.ReadString()
		local model = net.ReadString()
		local table = net.ReadTable()

		local newEnt = ents.Create(class)
		newEnt:SetPos(pos)

		newEnt.Reagents = table


		newEnt:Spawn()
		newEnt:SetModel(model)
		newEnt:PhysicsInit(SOLID_VPHYSICS)

		DebugPrint("User requested to drop entity " .. tostring(newEnt) .. "\nEntity model: " .. tostring(newEnt:GetModel()) .. "\nReagents included: ")
		DebugPrintTable(newEnt.Reagents)

	end)
end