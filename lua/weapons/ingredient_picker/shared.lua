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
SWEP.Instructions = "Look at an ingredient and left click over it."
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
    DebugPrint("Reload pressed.")
end

function SWEP:Think()

end


function SWEP:PrimaryAttack()
    DebugPrint("Primary Attack Pressed.")
	local ent = self.Owner:GetEyeTrace().Entity

	DebugPrint(tostring(self.Owner) .. " used left click on " .. tostring(ent))

	if self.Owner:GetPos():Distance(ent:GetPos()) < 150 and ent:GetClass() == "inert_ingredient" then
		DebugPrint(tostring(self.Owner) .. " should see info about " .. tostring(ent))
	end

end

function SWEP:SecondaryAttack()
    DebugPrint("Open this player's inventory!")

	if CLIENT then
		DrawStorage()
	end
end