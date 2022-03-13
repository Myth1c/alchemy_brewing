--init.lua
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

function ENT:Initialize()
	
	
	self:SetModel("models/props/de_inferno/tablecoffee.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self:SetUseType(SIMPLE_USE)
	self:Activate()

	self:SetPos(self:GetPos() + Vector(0, 0, 50))
	self:DropToFloor()

	self:DecorateSelf()

	timer.Simple(3, function() 
		self:MoveFlaskToBurner() 
		timer.Simple(3, function() 
			self:MoveFlaskFromBurner() 
		end)
	end)

end

function ENT:Use( ent, ply )

	
	self:TableNetworkMessage("brewUI", ply, self)


end

function ENT:DecorateSelf()

	--Test Tubes
	local tubes = ents.Create( "prop_dynamic" )
	tubes:SetModel( "models/equestrianhorizon/mlp_props/vailholder.mdl" )
	tubes:SetPos( self:GetPos() - self:GetAngles():Forward() * 3.5 + self:GetAngles():Up() * 20 - self:GetAngles():Right() * 18 )
	tubes:SetAngles( Angle(self:GetAngles().p + 0, self:GetAngles().y + 136, self:GetAngles().r) )
	tubes:SetParent( self )
	tubes:SetColor(Color(225, 225, 225))
	self:DeleteOnRemove( tubes )
	tubes:Spawn()
	-- Flask
	local flask = ents.Create( "prop_dynamic" )
	flask:SetModel( "models/equestrianhorizon/mlp_props/florenceflask.mdl" )
	flask:SetPos( self:GetPos() - self:GetAngles():Forward() * 8.6 + self:GetAngles():Up() * 20 + self:GetAngles():Right() * 4.5 )
	flask:SetAngles( Angle(self:GetAngles().p + 0, self:GetAngles().y + 162, self:GetAngles().r) )
	flask:SetParent( self )
	flask:SetColor(Color(109, 109, 109))
	flask:SetModelScale(flask:GetModelScale() * .75, 0)
	self:DeleteOnRemove( flask )
	-- Flask1
	local flask1 = ents.Create( "prop_dynamic" )
	flask1:SetModel( "models/props_halloween/flask_erlenmeyer.mdl" )
	flask1:SetPos( self:GetPos() - self:GetAngles():Forward() * 3.85 + self:GetAngles():Up() * 26 + self:GetAngles():Right() * 18 )
	flask1:SetAngles( Angle(self:GetAngles().p + 0, self:GetAngles().y + 162, self:GetAngles().r) )
	flask1:SetParent( self )
	flask1:SetColor(Color(88, 121, 219))
	flask1:SetModelScale(flask1:GetModelScale() * 1, 0)
	self:DeleteOnRemove( flask1 )
	-- Flask2
	local flask2 = ents.Create( "prop_dynamic" )
	flask2:SetModel( "models/props_halloween/flask_tub.mdl" )
	flask2:SetPos( self:GetPos() - self:GetAngles():Forward() * 6 + self:GetAngles():Up() * 27 - self:GetAngles():Right() * 8 )
	flask2:SetAngles( Angle(self:GetAngles().p + 0, self:GetAngles().y + 162, self:GetAngles().r) )
	flask2:SetParent( self )
	flask2:SetColor(Color(153, 196, 163))
	flask2:SetModelScale(flask2:GetModelScale() * 1.15, 0)
	self:DeleteOnRemove( flask2 )
	-- burner
	local burn1 = ents.Create( "prop_dynamic" )
	burn1:SetModel("models/maxofs2d/hover_plate.mdl")
	burn1:SetPos( self:GetPos() + self:GetAngles():Forward() * 4.5 + self:GetAngles():Up() * 20 + self:GetAngles():Right() * 9.25 )
	burn1:SetModelScale(burn1:GetModelScale() * .6, 0)
	burn1:SetParent(self)
	burn1:SetAngles( Angle(self:GetAngles().p - 0, self:GetAngles().y + 45, self:GetAngles().r + 0) )
	self:DeleteOnRemove( burn1 )
	-- burner flask
	self.flask3 = ents.Create( "prop_dynamic" )
	self.flask3:SetModel( "models/props_halloween/hwn_flask_vial.mdl" )
	self.flask3:SetPos( self:GetPos() - self:GetAngles():Forward() * 0 + self:GetAngles():Up() * 21 - self:GetAngles():Right() * 2 )
	self.flask3:SetAngles( Angle(self:GetAngles().p - 15, self:GetAngles().y + 98, self:GetAngles().r + 25) )
	self.flask3:SetParent( self )
	self.flask3:SetColor(Color(109, 109, 109))
	self.flask3:SetModelScale(self.flask3:GetModelScale() * .3, 0)


end

function ENT:MoveFlaskToBurner(time)

	
	local flaskEff = EffectData()
	flaskEff:SetOrigin( self.flask3:GetPos() )
	flaskEff:SetEntity( self.flask3 )
	util.Effect("propspawn", flaskEff, true, true)

	timer.Simple(0.3, function() 

		self.flask3:SetPos( self:GetPos() + self:GetAngles():Forward() * 3.75 + self:GetAngles():Up() * 21 + self:GetAngles():Right() * 10.25 )
		self.flask3:SetAngles( Angle(self:GetAngles().p - 15, self:GetAngles().y + 176, self:GetAngles().r + 25) )
		self.flask3:SetColor(Color(75, 75, 75, 255))

	end)

end

function ENT:MoveFlaskFromBurner(time)
	
	local flaskEff = EffectData()
	flaskEff:SetOrigin( self.flask3:GetPos() )
	flaskEff:SetEntity( self.flask3 )
	util.Effect("propspawn", flaskEff, true, true)

	timer.Simple(0.3, function() 
		self.flask3:SetPos( self:GetPos() - self:GetAngles():Forward() * 0 + self:GetAngles():Up() * 21 - self:GetAngles():Right() * 2 )
		self.flask3:SetAngles( Angle(self:GetAngles().p - 15, self:GetAngles().y + 98, self:GetAngles().r + 25) )
		self.flask3:SetColor(Color(109, 109, 109))
	end)

end
