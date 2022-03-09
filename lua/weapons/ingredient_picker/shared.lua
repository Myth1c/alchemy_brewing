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
end

function SWEP:SecondaryAttack()
    DebugPrint("Secondary Attack Pressed.")
end