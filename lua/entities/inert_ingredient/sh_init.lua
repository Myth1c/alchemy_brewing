ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Inert Ingredient"
ENT.Author = "Mythic"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "Alchemy Lab"


function ENT:IngredNetworkMessage(type, player, ent)

	net.Start("brew_store_Entity")
		net.WriteString(type)
        net.WriteEntity(ent)
	net.Send(player)


end