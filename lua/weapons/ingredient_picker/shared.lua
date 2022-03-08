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

SWEP.Spawnable = true -- Whether regular players can see it
SWEP.AdminSpawnable = true -- Whether Admins/Super Admins can see it

SWEP.ViewModel = "models/weapons/v_RPG.mdl" -- This is the model used for clients to see in first person.
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl" -- This is the model shown to all other clients and in third-person.


SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

local ShootSound = Sound("Metal.SawbladeStick")

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