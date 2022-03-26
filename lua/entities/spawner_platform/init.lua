--init.lua

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

ENT.SpawnedEntity = {}

ENT.MaxSpawns = Brew_Config.Spawner_Max_Spawns or 3

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

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self:SetUseType(SIMPLE_USE)

    if !self:GetCustomModel() then
        self:SetColor(Color(0, 255, 0, 255))
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS) 
        
        self:DrawShadow(false)
    end

    local ang = Angle(self:GetAngles().p + 0, self:GetAngles().y + 0, self:GetAngles().r + 90)
    self:SetAngles(ang)

    timer.Simple(1, function() if IsValid(phys) then phys:Sleep() end end)
	
end


function ENT:Think()

    if !self.ShouldSpawn then return end

    if self.NextSpawn < CurTime() then 

        if #self.SpawnedEntity < self.MaxSpawns then
            
            local ent = ents.Create("inert_ingredient")

            local offset = self:RandomPointInCircle(105, 125)


            ent:SetPos(offset )
            ent.Reagents = self.Reagents
            ent:Spawn()

            table.insert(self.SpawnedEntity, ent)
            self.NextSpawn = CurTime() + self.Cooldown

        elseif #self.SpawnedEntity <= self.MaxSpawns then
            for k, v in pairs(self.SpawnedEntity) do
                if !IsValid(v) then self.SpawnedEntity[k] = nil
                elseif self:GetPos():DistToSqr(v:GetPos()) >= self.SpawnDistance^2 then
                    self.SpawnedEntity[k] = nil
                end

            end
        end



    end
    self:NextThink(CurTime() + self.ThinkInterval)
    return true

end

function ENT:RandomPointInCircle(minRad, maxRad)

    local randomAngle = math.random(1000)
    local circleRadius = math.random(minRad, maxRad)

    local x = math.cos(randomAngle)*circleRadius
    local y = math.sin(randomAngle)*circleRadius
    local z = 15

    local pos = self:GetPos() + Vector(x, y, z)

    return pos
end