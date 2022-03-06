--init.lua

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

ENT.Reagents = 
{
	["speed"] = 0,
    ["leaping"] = 0,
    ["healing"] = 0,
    ["shield"] = 0,
}

local EffectFunctions = 
{
    ["speed"] = Effects_Speed,
    ["leaping"] = Effects_Leaping,
    ["healing"] = Effects_Healing,
    ["shield"] = Effects_Shield,
}




function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_plasticbottle001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self:SetUseType(SIMPLE_USE)
	
end

function ENT:Use( activator, caller )
	
	if !caller:KeyDown(4) then
		
		self:RunEffect(caller)
	
		self:Remove()
	else
		DebugPrint("Storing potion: " .. tostring(self))
		self:StorePotNetworkMessage("brew_store_ent", caller, self, self.Reagents)
		
		self:Remove()
	end


	
end

function ENT:RunEffect(ply)

	DebugPrint("Running effects on: " .. tostring(ply) .. "\nReagents are: ")
	DebugPrintTable(self.Reagents)

	for k, v in pairs(self.Reagents) do

		if v > 0 then
			
			EffectFunctions[k](ply, self, self:ConvertToTiers(v))

		end

	end

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