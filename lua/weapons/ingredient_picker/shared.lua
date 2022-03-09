if SERVER then
 
	AddCSLuaFile ("shared.lua")
 
	SWEP.Weight = 1
 
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
 
elseif CLIENT then
 
	SWEP.PrintName = "Ingredient Analyzer"

	SWEP.Slot = 1
	SWEP.SlotPos = 6
 
	SWEP.DrawAmmo = false
 
	SWEP.DrawCrosshair = true
end

SWEP.Author = "Mythic"
SWEP.Contact = "no"
SWEP.Purpose = "Analyzes ingredients and displays what reagents it contains."
SWEP.Instructions = "Left click an ingredient while close to reveal it's contents.\nReload over an ingredient to pick it up.\nRight click to open your inventory"
SWEP.Category = "Brewing"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = Model( "models/weapons/c_arms.mdl" )
SWEP.WorldModel = Model("models/props_junk/garbage_coffeemug001a.mdl")


SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"


function SWEP:Reload()
    
	local ent = self.Owner:GetEyeTrace().Entity

	if self.Owner:GetPos():Distance(ent:GetPos()) < 100  then


		if SERVER then
			if ent:GetClass() == "inert_ingredient" then
				ent:IngredNetworkMessage("brew_store_ent", self.Owner, ent, ent.Reagents)
			elseif ent:GetClass() == "inert_potion" then
				ent:StorePotNetworkMessage("brew_store_ent", self.Owner, ent, ent.Reagents)
			else return end

			ent:Remove()
		end

	end
end

function SWEP:Think()

end


function SWEP:PrimaryAttack()

	local ent = self.Owner:GetEyeTrace().Entity

	if self.Owner:GetPos():Distance(ent:GetPos()) < 100 and ent:GetClass() == "inert_ingredient" then

		if SERVER then
			net.Start("brew_draw_ingredient_info")
				net.WriteEntity(ent)
				net.WriteTable(ent.Reagents)
			net.Send(self.Owner)
		end

	end

end

function SWEP:SecondaryAttack()
    DebugPrint("Open this player's inventory!")

	if CLIENT then
		DrawStorage()
	end
end