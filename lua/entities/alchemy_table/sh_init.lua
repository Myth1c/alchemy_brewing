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

		local newEnt = ents.Create(class)
		newEnt:SetModel(model)
		newEnt:SetPos(pos)


		newEnt:Spawn()

	end)
end