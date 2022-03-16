--init.lua

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

ENT.SpawnedEntity = nil

ENT.ShouldSpawn = true

ENT.LastSpawn = nil
ENT.Cooldown = Brew_Config.Spawner_Spawn_Cooldown or 30
ENT.NextSpawn = CurTime()
ENT.SpawnDistance = Brew_Config.Spawner_Spawn_Distance or 500

ENT.ThinkInterval = Brew_Config.Spawner_Think_Interval or 5

ENT.Reagents = 
{
	["speed"] = 0,
    ["leaping"] = 0,
    ["healing"] = 0,
    ["shield"] = 0,
}

function ENT:Initialize()

    self:SetModel("models/props_c17/streetsign004e.mdl")

	self:PhysicsInit( SOLID_VPHYSICS )     
	self:SetMoveType( MOVETYPE_NONE )   
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS) 

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self:SetUseType(SIMPLE_USE)

    self:SetColor(Color(0, 255, 0, 255))
    
    self:DrawShadow(false)

    local ang = Angle(self:GetAngles().p + 0, self:GetAngles().y + 0, self:GetAngles().r + 90)
    self:SetAngles(ang)

    timer.Simple(1, function() if IsValid(phys) then phys:Sleep() end end)
	
end


function ENT:Think()

    if !self.ShouldSpawn then return end

    if self.NextSpawn < CurTime() then

        if self.SpawnedEntity == nil then
            
            local ent = ents.Create("inert_ingredient")
            ent:SetPos(self:GetPos() + Vector(0, 0, 15))
            ent.Reagents = self.Reagents
            ent:Spawn()

            self.SpawnedEntity = ent
            self.NextSpawn = CurTime() + self.Cooldown

        elseif !IsValid(self.SpawnedEntity) or self:GetPos():DistToSqr(self.SpawnedEntity:GetPos()) >= self.SpawnDistance^2 then
            self.SpawnedEntity = nil
        end



    end
    self:NextThink(CurTime() + self.ThinkInterval)
    return true

end