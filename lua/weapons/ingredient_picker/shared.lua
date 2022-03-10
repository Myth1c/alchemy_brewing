if SERVER then
 
	AddCSLuaFile ("shared.lua")
 
	SWEP.Weight = 1
 
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
 
elseif CLIENT then
 
	SWEP.PrintName = "Ingredient Picker"

	SWEP.Slot = 0
	SWEP.SlotPos = 6
 
	SWEP.DrawAmmo = false
 
	SWEP.DrawCrosshair = true
end

SWEP.Author = "Mythic"
SWEP.Contact = ""
SWEP.Purpose = "Analyze or pick ingredients"
SWEP.Instructions = "Left click an ingredient/potion while close to reveal it's contents.\nReload over an ingredient/potion to pick it up.\nRight click to open your ingredient pouch."
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

local analyzeSound = {
	"ambient/computer_tape.wav",
	"ambient/computer_tape2.wav",
	"ambient/computer_tape3.wav"
}
local finishSounds = {
	"garrysmod/save_load1.wav",
	"garrysmod/save_load2.wav",
	"garrysmod/save_load3.wav",
	"garrysmod/save_load4.wav",
}
local pickupSounds = {
	"ui/item_bottle_pickup.wav",
	"ui/item_cardboard_pickup.wav",
	"ui/item_default_pickup.wav",
	"ui/item_gooey_pickup.wav",

}

SWEP.Analyzing = false

function SWEP:Reload()
    
	local ent = self.Owner:GetEyeTrace().Entity

	if self.Owner:GetPos():Distance(ent:GetPos()) < 100 and self.Analyzing == false then
		local sound = table.Random(pickupSounds)
		self:EmitSound(sound)

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

	if self.Owner:GetPos():Distance(ent:GetPos()) < 100 and (ent:GetClass() == "inert_ingredient" or ent:GetClass() == "inert_potion") and self.Analyzing == false then
		local sound = table.Random(analyzeSound)
		self:EmitSound(sound)
		self.Analyzing = true
		timer.Simple(5, function()
			if SERVER then
				if !IsValid(ent) then return end
				net.Start("brew_draw_ingredient_info")
					net.WriteEntity(ent)
					net.WriteTable(ent.Reagents)
				net.Send(self.Owner)

			end
			self:StopSound(sound)
			sound = table.Random(finishSounds)
			self:EmitSound(sound)

			self.Analyzing = false
		end)

	end

end

function SWEP:SecondaryAttack()
	
	if self.Analyzing ~= false then return end
	if CLIENT then
		DrawStorage()
	end
end