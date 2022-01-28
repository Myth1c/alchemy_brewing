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

