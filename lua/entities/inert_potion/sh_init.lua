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

function ENT:StorePotNetworkMessage(type, player, ent, reagentTable)

	net.Start("brew_store_Entity")
		net.WriteString(type)
        net.WriteEntity(ent)
		net.WriteTable(reagentTable)
	net.Send(player)


end



function ENT:ConvertToTiers(input)

    if input == 0 then return 0 end
    if input < 3 then return 1 end
	for i = 1, Brew_Config.Global_Max_Tier, 1 do

        if input <= 3^i then
            return i
        end
    end
end