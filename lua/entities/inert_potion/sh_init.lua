ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Inert Potion"
ENT.Author = "Mythic"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "Alchemy Lab"


function ENT:PotionNetworkMessage(player, effect, tier, timeLimit)

	net.Start("brew_draw_StatusUI")
		net.WriteString(effect)
        net.WriteInt(tier, 32)
		net.WriteInt(timeLimit, 32)
	net.Send(player)


end